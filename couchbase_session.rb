require 'rubygems'
require 'couchbase'
require 'sinatra'
require 'securerandom'
require "json"

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

get "/user/:id" do |user_id|
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

class JsonSerializer
    def to_json
        hash = {}
        self.instance_variables.each do |var|
            hash[var.to_s.delete "@"] = self.instance_variable_get var
        end
        hash.to_json
    end
    def from_json! string
        JSON.load(string).each do |var, val|
            self.instance_variable_set var, val
        end
    end
end

class User < JsonSerializer

def initialize(user_name, join_date,last_active,session_id)
    @user_name = user_name
    @join_date = join_date
    @last_active = last_active
    @session_id = session_id
  end

end



