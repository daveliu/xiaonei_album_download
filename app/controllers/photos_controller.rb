class PhotosController < ApplicationController
  skip_before_filter :verify_authenticity_token    
  def new
  end
  
  def create    
    @photo = Photo.new params[:photo]
    if @photo.save    
      #Photo.send_later(:bundle, @photo)  
      Photo.bundle(@photo)
      render :update do |page|         
        page.replace_html  "error", "<div id='error'></div>"
        page.replace_html  "progress", :partial => "jobs"
      end  
    else                       
      render :update do |page|
        page.replace_html "error", "<div id='error'>#{error_messages_for(:photo)}</div>"
      end  
    end  
  end  
  
  def show
     @photo = Photo.find params[:id]                                        
     send_file "#{RAILS_ROOT}/public/uploads/#{@photo.created_at.strftime("%Y-%m-%d-%s")}.zip"    
  end  
  
  def update            
    @photo = Photo.find params[:id]                                        
    @size = Dir.glob(File.join(RAILS_ROOT, "public", "uploads", "#{@photo.created_at.strftime("%Y-%m-%d-%s")}_*.png")).size
    render :partial => 'job', :layout => false
  end
end
