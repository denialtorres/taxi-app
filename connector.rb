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
  # 2. Read RABBIT_URI from ENV
  connection = Bunny.new ENV["RABBIT_URI"]

  # 3, Start a communication session with RabbitMQ
  connection.start
  # 3.1 Declare a channel
  channel = connection.create_channel

  # allow reconnection recovery
  sleep 10
rescue Bunny::TCPConectionFailed => e
  puts "conection to server failed #{e}"
end

def on_start(channel)
  # 4. Declare a queue for a given taxi
  queue = channel.queue("taxi.1", durable: true)

  # 5. Declare a "direct exchange" => "taxi-direct"
  exchange = channel.direct("taxi-direct", durable: true, auto_delete: true)

  # 6. bind/join the queue to the exchange
  queue.bind(exchange, routing_key: "taxi.1")

  # 7. Return the exchange
  exchange
end

binding.pry

exchange = on_start(channel) 
