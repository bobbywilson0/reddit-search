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
    fill_in "q", with: "programming"

    within "div.col-md-3" do
      expect(page).to have_content "2"
    end
  end

end
