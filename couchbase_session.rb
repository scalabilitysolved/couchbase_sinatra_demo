require 'rubygems'
require 'couchbase'
require 'sinatra'
require 'securerandom'
require 'json'
require_relative 'JsonSerializer'
require_relative 'User'

  CONFIG = {
    :node_list => ["localhost:8091"],
    :pool_size => 3
  }

def connection(bucket)
  @servers ||= {} 
  @servers[bucket] ||= begin
    size = CONFIG[:pool_size]
    params = CONFIG.merge(:bucket => bucket)
    Couchbase::ConnectionPool.new(size, params)
  end
end

post "/user" do 
  user_id = params[:user_id]
  couchbase = connection("users")
  user = couchbase.get(user_id, :quiet => true) 
  
  if user.nil?
   current_utc = Time.now.utc
   user = User.new(user_id,current_utc,current_utc,nil)
   couchbase.set(user_id,user.to_json)
   response.body = couchbase.get(user_id, :quiet => true)
   response.status = 201
  else
    response.body = "#{user_id} as a username is not available"
    response.status = 400
  end
end

get "/user/:id" do |user_id|
  client = connection("users")
  user = client.get(user_id, :quiet => true)

  if user.nil?
    response.body = "#{user_id} is not a valid user"
    response.status = 404
  else
    response.body = user
    response.status = 200
  end

end

post "/user/:id" do |user_id|
    client = connection("sessions")
    session_id = client.get(user_id, :quiet => true)

    if session_id.nil?
      session_id = SecureRandom.urlsafe_base64(16) + user_id
      thirty_minute_sessions = 60 * 30
      client.set(user_id,session_id, :ttl => thirty_minute_sessions)
    end

    response = client.get(user_id, :quiet => true)
    response.body = client.get(user_id,:quiet => true)
    response.status = 200
    body = response
end'