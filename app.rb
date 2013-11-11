require 'twilio-ruby'
require 'tweetstream'


keywords = Hash.new

ARGV.each do|keyword|
	keywords[keyword] = 1
	puts "Keyword " + keyword + " registered"
end


# put your own credentials here
account_sid = 'AC235bb85f6223d8e29d83a6547f1eb65b'
auth_token = 'c59e3fbd96e33519e30173e8aeef8a79'

TweetStream.configure do |config|
	config.consumer_key       = 'DsvgaONFVB1X3ZyA7WOmVg'
	config.consumer_secret    = 'P6jqjV92yMrRfmULadWQvuzfaz61S3mEvZ33d7kBBTU'
	config.oauth_token        = '19437640-jvDXV0NM1lY2WIr44zm7soRew0nHjqQydoaM5vVr2'
	config.oauth_token_secret = 'WErlDQuNfuVKfSpQhSK89l7JTVS98d0gfJmjX0QDjik'
	config.auth_method        = :oauth
end

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token



TweetStream::Client.new.follow(2187636229) do |status|
	keywordFound = 0;
	text = "A tweet has been posted with keywords: " + "\n"

	keywords.each { |key, value| 
		if status.text.downcase.match(key.downcase)
			text = text + key + "\n"
			keywordFound = 1
		end
	}
	
	text = text + "Status: " + status.text + "\n"

	if keywordFound == 1
		puts text
		message = @client.account.messages.create(
			:from => '+14437983200',
			:to => '+14438342310',
			:body => text
			)
	end
end
