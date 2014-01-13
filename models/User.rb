require 'securerandom'
class User < JsonSerializer

def initialize(user_name, join_date,last_active)
    @user_name = user_name
    @join_date = join_date
    @last_active = last_active
    @session_id = generate_session_id
  end

def generate_session_id
    SecureRandom.urlsafe_base64(16) + @user_name	
end

end