class AddTimestampToPhotos < ActiveRecord::Migration
  def self.up    
    add_column :photos, :created_at, :datetime
  end

  def self.down
  end
end
