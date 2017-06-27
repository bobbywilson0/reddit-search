class Query < ApplicationRecord
  belongs_to :meta_query, counter_cache: true
end
