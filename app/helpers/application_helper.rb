# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper   
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
