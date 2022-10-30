# Create dev user
# docker exec some-rabbit rabbitmqctl add_user cc-dev taxi123
# Create a vhost
# docker exec some-rabbit rabbitmqctl add_vhost cc-dev-vhost
# Configure dev user for vhost
# docker exec some-rabbit rabbitmqctl set_permissions -p cc-dev-vhost cc-dev ".*" ".*" ".*"
# Add an admin user
# docker exec some-rabbit rabbitmqctl add_user cc-admin taxi123
# Configure admin user for vhost
# docker exec some-rabbit rabbitmqctl set_permissions -p cc-dev-vhost cc-admin ".*" ".*" ".*"

require 'pry'
# Require client library
require 'bunny'
require 'dotenv'
Dotenv.load

begin
  connection = Bunny.new ENV["RABBIT_URI"]
  connection.start

  # allow reconnection recovery
  sleep 10
rescue Bunny::TCPConectionFailed => e
  puts "conection to server failed #{e}"
end
