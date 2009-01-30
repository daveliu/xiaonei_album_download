require 'mechanize'
require 'hpricot'  
require 'zip/zip'
require 'zip/zipfilesystem'
      
class Photo < ActiveRecord::Base 
  extend ActiveSupport::Memoizable 
  validates_presence_of :email, :password, :album_url
  
  attr_reader :agent                              
  
  LOGIN_PATH = "http://www.xiaonei.com/Login.do"
  
  def agent
    agent = WWW::Mechanize.new
    agent.user_agent_alias = 'Windows IE 7'      
    params = {:email => email, :password => password}
    agent.post(LOGIN_PATH, params)
    agent
  end  
  memoize :agent 
  
  def validate
    errors.add(:base, "邮箱或密码有错误") if agent.page.uri.to_s == LOGIN_PATH
  end
  
  def photos_ary
    album_page = agent.get(album_url)  
    album_page.root.search("td.photoPan a").inject([]) do |ary, img|
      href = img.attributes['href']
      photo_page = agent.get(href)
      src = photo_page.root.search("img#photo").first.attributes['src']
      ary << src
    end
  end  
  
  def self.bundle(photo)
     timestamp = photo.created_at.strftime("%Y-%m-%d-%s")
     bundle_filename = "#{RAILS_ROOT}/public/uploads/#{timestamp}.zip"

     # check to see if the file exists already, and if it does, delete it.
     if File.file?(bundle_filename)
       File.delete(bundle_filename)
     end 

     # open or create the zip file
     Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) do |zipfile|
       # collect the album's tracks
       photo.photos_ary.each_with_index do |src, i|                           
         system("curl -o #{RAILS_ROOT}/public/uploads/#{timestamp}_#{i}.png #{src}")
         zipfile.add( "#{i}.png", "#{RAILS_ROOT}/public/uploads/#{timestamp}_#{i}.png")
       end
     end

     # set read permissions on the file
     File.chmod(0644, bundle_filename)   
     system("rm #{RAILS_ROOT}/public/uploads/*.png")
     photo.update_attribute(:finish, true)
  end
  
end  