require 'rails_helper'

RSpec.describe RedditSearch do
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

  it 'returns results' do
    stub_request(:get, "https://www.reddit.com/search.json?q=programming")
      .to_return(status: 200, body: programming_response, headers: {})

    reddit_search_service = Search.new("programming")

    expect(reddit_search_service.results).to eq([{
      title: "A post about Programming",
      num_comments: 376,
      score: 966
    }])
  end
end
