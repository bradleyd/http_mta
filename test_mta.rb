require 'rubygems'
require 'eventmachine'
require 'ostruct'
require './parse_config'

class SMTP < EventMachine::Protocols::SmtpServer
  attr_accessor :current
  #include ParseConfig
  def initialize
    @config=ParseConfig.read_config
    super
  end

  def current
    @current ||= OpenStruct.new
  end


  def receive_data_chunk data
    #mail = TMail::Mail.parse(data.join("\n"))
    #body = mail.multipart? ? mail.parts.first.body : mail.body
    current.data << data.join("\n")
    # your_custom_method(mail.from, mail.to, mail.subject, body)
    true
  end

  def build_message
    msgstr = "From: Your Name <your@mail.address>
To: Destination Address <someone@example.com>
Subject: test message
Date: Sat, 23 Jun 2001 16:26:43 +0900
Message-Id: <unique.message.id.string@example.com>

#{current.data}.
"
  end

  def send_email
    smtp = Net::SMTP.start("localhost",25)
    smtp.send_message build_message, 'brad.smith@fullspectrum.net', 'fake@fullspectrum.net'
    smtp.finish    
  end

  def receive_sender(sender)
    current.sender = sender
    true
  end

  def receive_data_command
    current.data = ""
    true
  end

  def receive_recipient rcpt
    user=@config['domain']['user']
    current.recipient = recipient
    p :user => user
    p :rcpt => rcpt
    true
  end

  def receive_transaction
    if @ehlo_domain
      current.ehlo_domain = @ehlo_domain
      @ehlo_domain = nil
    end
    true
  end

  def receive_message
    current.received = true
    current.completed_at = Time.now
    #p [:received_email, current]
    p "hello you!"
    @current = OpenStruct.new
    true
  end
end

EM::run do
  EM::start_server "0.0.0.0", 10025, SMTP
end
