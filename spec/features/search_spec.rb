require "rails_helper"

describe "search", type: :feature do
  let (:programming_response) {
    %({
      "data": {
        "children": [
          {
            "data": {
              "score": 966,
              "title": "A post about Programming",
              "num_comments": 376
            }
          }
        ]
      }
    }).gsub(/\s+/, " ").gsub("\n", "").strip
  }

  it "shows search results" do
    stub_request(:get, "https://www.reddit.com/search.json?q=programming")
      .to_return(status: 200, body: programming_response, headers: {})

    visit root_path
    fill_in "q", with: "programming"
    click_button "Search"
    expect(page).to have_content "Programming"
  end

  it "only shows unique searches" do
    MetaQuery.create(keywords: 'programming')

    visit root_path

    within "div.col-md-3" do
      expect(page).to have_content "2"
    end
  end

  it "can sort past searches" do
    MetaQuery.create(keywords: 'programming')
    MetaQuery.create(keywords: 'ducks', queries_count: 2)

    visit root_path

    within "tr:nth-child(3) > td:nth-child(1)" do
      expect(page).to have_content "ducks"
    end

    click_on "Count"

    within "tr:nth-child(3) > td:nth-child(1)" do
      expect(page).to have_content "programming"
    end
  end

  it "shows previously searched keyword timestamps" do
    stub_request(:get, "https://www.reddit.com/search.json?q=programming")
      .to_return(status: 200, body: programming_response, headers: {})

    meta_query = MetaQuery.create(keywords: 'programming')
    meta_query.queries.create
    meta_query.queries.create

    visit root_path
    fill_in "q", with: "programming"
    click_button "Search"

    expect(page).to have_content Query.last.created_at
  end
end
