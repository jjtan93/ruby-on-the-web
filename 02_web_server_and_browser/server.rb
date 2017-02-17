require 'socket'               # Get sockets from stdlib
require 'json'

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  
  client_request = ""
  
  begin
   client_request = client.read_nonblock(256)
  rescue IO::WaitReadable, IO::EAGAINWaitReadable
     IO.select([client])
     retry
  end
  
  request_parts = client_request.to_s.split(" ")
  
  case request_parts[0]
    when "GET"
      begin
      # Open and read all lines from index.html
      file_lines = File.readlines request_parts[1][1..-1]
      file_lines = file_lines.join("")

      client.print "HTTP/1.0 200 OK\r\n" +
                   "Content-length: #{file_lines.length}\r\n\r\n" +
                   "#{file_lines}"
      rescue
        client.print "HTTP/1.0 404 FILE NOT FOUND\n"
      end
    when "POST"
      # Split response at first blank line into headers and body
      headers,body = client_request.split("\r\n\r\n", 2)

      params = JSON.parse(body)
      puts "#{params}, #{params.class}"
    
      # Open and read all lines from index.html
      file_lines = File.read "thanks.html"
      user_data = "<li>name: #{params['viking']['name']}</li><li>e-mail: #{params['viking']['email']}</li>"
      file_lines.gsub!('<%= yield %>', user_data)
  
      #puts "#{file_lines}"
      client.print "HTTP/1.0 200 OK\r\n" +
                   "Content-length: #{file_lines.length}\r\n\r\n" + # TODO get content length!!!!!!!!!!!!!
                   "#{file_lines}"
  end
  
  #client.puts "\r\n\r\nClosing the connection. Bye!"
  client.close                 # Disconnect from the client
}