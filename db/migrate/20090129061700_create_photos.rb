class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table "photos" do |t|
      t.string :email, :password, :album_url
    end  
  end

  def self.down
    drop_table "photos"
  end
end
