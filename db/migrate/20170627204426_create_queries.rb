class CreateQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :queries do |t|
      t.belongs_to :meta_query, foreign_key: true

      t.timestamps
    end
  end
end
