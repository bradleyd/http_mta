require 'em-proxy'
require 'mail'
Proxy.start(:host => "0.0.0.0", :port => 2524) do |conn|
  conn.server :srv, :host => "127.0.0.1", :port => 25

  # RCPT TO:<name@address.com>\r\n
  RCPT_CMD = /RCPT TO:<(.*)?>\r\n/

  conn.on_data do |data|
   #m = Mail.new(data)
   p data 
    #if rcpt = data.match(RCPT_CMD)
      #if rcpt[1] != "ilya@igvita.com"
       #conn.send_data "550 No such user here\n"
       #data = nil
      #end
    #end

    data
  end
 
  conn.on_response do |backend, resp|
     p [:on_response, backend, resp]
    resp
  end
end
