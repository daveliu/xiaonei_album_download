class AddCountToPhotos < ActiveRecord::Migration
  def self.up  
    add_column :photos, :count, :integer, :default => 0
  end

  def self.down
  end
end
