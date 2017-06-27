class CreateMetaQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :meta_queries do |t|
      t.string :keywords
      t.integer :queries_count

      t.timestamps
    end
  end
end
