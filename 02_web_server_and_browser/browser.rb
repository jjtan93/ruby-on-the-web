require 'socket'
require 'json'
 
#host = 'www.tutorialspoint.com'     # The web server
#port = 80                           # Default HTTP port
host = 'localhost'
port = 2000
path = "/index.html"                 # The file we want 

puts "Choose: \n(a) GET \n(b) POST"
choice = gets.chomp
case choice
  when "a" 
    request = "GET #{path} HTTP/1.0\r\n\r\n"

    socket = TCPSocket.open(host,port)  # Connect to server
    socket.print(request)               # Send request
  puts "SENT!!!"
    response = socket.read              # Read complete response
    # Split response at first blank line into headers and body
  
    # This part onwards can be made into a method to remove repetition <<<<<<
    headers,body = response.split("\r\n\r\n", 2)

    headers_split = headers.split("\r\n")
    status_parts = headers_split[0].split(" ")
    puts "#{headers}\n\n"                 # And display it
    puts "#{body}"                        # And display it
    socket.close
  
  when "b"
    puts "What is the name of your viking:"
    name = gets.chomp
    puts "What is the e-mail of your viking:"
    email = gets.chomp
    
    details = Hash.new
    details["name"] = name
    details["email"] = email
  
    viking = Hash.new
    viking["viking"] = details
  
    # This is the HTTP request we send to fetch a file
    request = "POST #{path} HTTP/1.0\r\n" +
              "Content-Length: #{viking.to_s.length}\r\n\r\n" +
              "#{viking.to_json}"
  
    #puts "#{request}"

    socket = TCPSocket.open(host,port)  # Connect to server
    socket.print(request)               # Send request
    # TODO REMOVE!!!!!!!!!!!!
    response = socket.read              # Read complete response
    # Split response at first blank line into headers and body
    headers,body = response.split("\r\n\r\n", 2)

    headers_split = headers.split("\r\n")
    status_parts = headers_split[0].split(" ")
    #puts "#{headers}\n\n"                 # And display it
    puts "#{body}"                        # And display it
    socket.close
  else
  
end