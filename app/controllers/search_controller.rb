class SearchController < ApplicationController
  def index
    @meta_queries = MetaQuery.order(params[:sort])
    if params['q'].present?
      @results = Search.new(params['q']).results
    end
  end
end
