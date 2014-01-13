couchbase_sinatra_demo
======================

Small example of sinatra working with multiple couchbase buckets and running on unicorn.

First install couchbase. http://scalabilitysolved.com/installing-couchbase-on-aws/

To run the app you will need to install nginx

https://www.digitalocean.com/community/articles/how-to-install-nginx-on-ubuntu-12-04-lts-precise-pangolin

You'll need to change the following line in the nginx.conf to point to your app directory

'server unix:/home/scalabilitysolved/work/ruby/couchbase_sinatra_demo/unicorn/sockets/unicorn.sock'

1. Change '@dir = "/YOUR_PATH_TO_REPO/couchbase_sinatra_demo/"' in unicorn/unicorn.rb
2. Backup nginx.conf file at /etc/nginx/ with 'sudo cp nginx.conf nginx.conf.backup'
3. Create a symbolic link to our new nginx.conf file from the repo (remember to replace file path with where your repo is located)' sudo ln -s /YOUR_PATH_TO_REPO/couchbase_sinatra_demo/nginx/nginx.conf'
4. Restart nginx 'sudo service nginx restart' and check status with 'sudo service nginx status'
5. Go to the root of the cloned repo and run the following command 'unicorn -c unicorn/unicorn.rb -E development'

You can create a user in the demo app with:
```
curl -XPOST -d 'user_id=user_id' http://localhost/user
```
Retreive a specific user with:
```
curl http://localhost/user/user_id
```
Create a session for a user:
```
curl -XPOST -d 'user_id=user_id' http://localhost/session
```
Retreive current session
```
curl http://localhost/session/user_id
```