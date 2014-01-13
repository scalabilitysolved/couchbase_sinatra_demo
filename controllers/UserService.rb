require 'rubygems'
require 'couchbase'
require 'sinatra/base'
require 'securerandom'
require 'json'
require_relative '../models/JsonSerializer'
require_relative '../models/User'
require_relative '../database/CouchbaseConnection'

class UserService < Sinatra::Base
 
def initialize
 super
 @couchbase ||= CouchbaseConnection.new()
end

post "/user" do 
  user_id = params[:user_id]
  client = @couchbase.connection("users")
  user = client.get(user_id, :quiet => true) 
  
  if user.nil?
   current_utc = Time.now.utc
   user = User.new(user_id,current_utc,current_utc)
   client.set(user_id,user.to_json)
   response.body = client.get(user_id, :quiet => true)
   response.status = 201
  else
    response.body = "#{user_id} as a username is not available"
    response.status = 400
  end
end

get "/user/:id" do |user_id|
  client = @couchbase.connection("users")
  user = client.get(user_id, :quiet => true)

  if user.nil?
    response.body = "#{user_id} is not a valid user"
    response.status = 404
  else
    response.body = user
    response.status = 200
  end
end

post "/sessions" do
    user_id = params[:user_id] 
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
end

run! if __FILE__ == $0
end