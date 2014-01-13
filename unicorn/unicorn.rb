@dir = "/home/scalabilitysolved/work/ruby/couchbase_sinatra_demo/"

worker_processes 2
working_directory @dir

timeout 30

 
# Socket for unicorn to listen to, also needs to be referenced in nginx.conf
listen "#{@dir}unicorn/sockets/unicorn.sock", :backlog => 64

# Set process id path
pid "#{@dir}unicorn/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"