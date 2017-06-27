class Search
  attr_reader :meta_query

  def initialize(keywords)
    @keywords = keywords.strip
    @meta_query = MetaQuery.find_or_create_by(keywords: @keywords)
    @meta_query.queries.create

    @connection = Faraday.new('https://www.reddit.com') do |conn|
      conn.adapter Faraday.default_adapter
    end
  end

  def results
    api_response = @connection.get('/search.json', q: @keywords)
    posts = JSON.parse(api_response.body)['data']['children']
    posts.map do |post|
      {
        title: post['data']['title'],
        num_comments: post['data']['num_comments'],
        score: post['data']['score']
      }
    end
  end

end
