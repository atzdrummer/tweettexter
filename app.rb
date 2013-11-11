require 'twilio-ruby'
require 'tweetstream'


keywords = Hash.new

ARGV.each do|keyword|
	keywords[keyword] = 1
	puts "Keyword " + keyword + " registered"
end


# put your own credentials here
account_sid = 'twilio account id'
auth_token = 'twilio account token'

TweetStream.configure do |config|
	config.consumer_key       = 'twitter consumer key'
	config.consumer_secret    = 'twitter consumer secret'
	config.oauth_token        = 'twitter access token'
	config.oauth_token_secret = 'twitter access token secret'
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
