require 'sinatra'
require 'gmail'
#require 'mandrill' # this is an alternative to gmail

# Basic functions
# -------------------------------------------------------------

get '/' do
  @title = "A Poplite sample website"
  erb :home
end

get '/about' do
  @title = "More innovation from Vizica Consulting"
  erb :about, :layout => :layout_poplite, :locals => {:active=>["","pure-menu-selected",""]}
end  
  
get '/contact' do
  @title = "Online information request form"
  @name = ""
  @email = ""
  @comments = ""
  erb :contact, :layout => :layout_poplite, :locals => {:active=>["","","pure-menu-selected"]}
end

not_found do
  erb :not_found
end

# Sample application to show mailout capabilities with Gmail
# This Google account has been adjusted for less security 
# -------------------------------------------------------------------------

post '/mailout' do
  @user = ENV["GMAIL_USER"]   # access info stored in environment variables
  @pwd = ENV["GMAIL_PWD"]
  
  gmail = Gmail.connect(@user, @pwd)
  
  email = gmail.compose do	
  end
  
  email['to'] = "admin@xxx.net"  # enter your administrators email here
  email['subject'] = "Request for information from - " + params[:name] + " - " + params[:email]
  email['body'] = params[:comments]
  
  email.deliver! 
  
  gmail.logout
  
  redirect to('/')
end


# Sample application to show mailout capabilities with Mandrill
# -------------------------------------------------------------------------

post '/mailout_option' do

  m = Mandrill::API.new ENV["MANDRILL_API_KEY"] # accesses environment variable
	
  message = {  
   :subject=> "Request for information from - " + params[:name],
   :from_name=> params[:name],  
   :text=>params[:comments],  
   :to=>[  
     { 
       :email=> ENV["ADMIN_EMAIL"]  # accesses environment variable
     }  
   ],  
   :html=>params[:comments],  
   :from_email=> ENV["ADMIN_EMAIL"]  # this needs to match Mandrill setup
  }  
  sending = m.messages.send message

  redirect to('/')
end