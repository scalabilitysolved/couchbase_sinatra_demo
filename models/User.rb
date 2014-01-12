class User < JsonSerializer

def initialize(user_name, join_date,last_active,session_id)
    @user_name = user_name
    @join_date = join_date
    @last_active = last_active
    @session_id = session_id
  end

end