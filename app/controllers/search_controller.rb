class SearchController < ApplicationController
  def index
    @meta_queries = MetaQuery.order(params[:sort])
    if params['q'].present?
      search = Search.new(params['q'])
      @results = search.results
      @meta_query = search.meta_query
    end
  end
end
