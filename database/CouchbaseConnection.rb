require 'rubygems'
require 'couchbase'

class CouchbaseConnection

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

end