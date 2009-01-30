class AddFinishToPhotos < ActiveRecord::Migration
  def self.up  
    add_column :photos, :finish, :boolean, :default => false
  end

  def self.down
  end
end
