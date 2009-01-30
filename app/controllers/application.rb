# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a988443081447099355cae80d988cbaa'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def error_messages_for(object_name)
    object = instance_variable_get("@#{object_name}") 
    if object
      msg = ""     
      puts  "================"
      puts object.errors.inspect
      object.errors.each do | attr, msg| 
        msg = content_tag(:p, Column[attr]+msg) 
        break
      end   
    end  
    content_tag(:div, msg, :id => "errorExplanation")  unless msg.blank?
  end
end
