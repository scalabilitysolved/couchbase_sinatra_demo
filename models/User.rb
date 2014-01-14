require 'securerandom'
class User < JsonSerializer

def initialize(user_name)
    @user_name = user_name
    current_utc = Time.now.utc
    @join_date = current_utc
    @last_active = current_utc
end

def update_last_active
    @last_active = Time.now.utc
end

end