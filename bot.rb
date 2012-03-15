require "twitter"
require "tweetstream"
require "iron_worker"

class Bot

  CONSUMER_KEY = "iqlMxXcI5LWbtQWYxeBUOg"
  CONSUMER_SECRET = "njSfi1HDTV6PV59NNPJX7mnhSnr72p2gmreEoAa7Xc"
  ACCESS_TOKEN = "524858064-jnaamOdfHwmYJXgrC4M1cupOy3W1GA79vjSC1UIv"
  ACCESS_SECRET = "1KUGJXZ2pVvm2FCIVPwl7g34bZRttB8JwdXqAdqc"

  TERMS = {
    #"sad" => "",
    #"depressed" => "",
    #"bored" => "",
    #"condom" => "Do it!",
    #"happy" => ""
    "uncommon phrase" => "guess it's not that obscure"
  }

  def initialize
    authenticate_twitter
    configure_worker
    track_the_twits
  end

  def authenticate_twitter
    TweetStream.configure do |config|
      config.consumer_key = CONSUMER_KEY
      config.consumer_secret = CONSUMER_SECRET
      config.oauth_token = ACCESS_TOKEN
      config.oauth_token_secret = ACCESS_SECRET
      config.auth_method = :oauth
    end
  end

  def configure_worker
    IronWorker.configure do |config|
      config.token = "EoYFffqqvlz-_Hthww96eOt-dY0"
      config.project_id = "4f61454fa859d05c2000194e"
    end
  end

  def track_the_twits
    TweetStream::Client.new.track(*TERMS) do |status|
      regexp = TERMS.keys.join("|")
      matched_term = status.text.match(regexp)
      worker = HappyWorker.new
      worker.message = "#poopin"
      worker.queue
    end
  end

end

class HappyWorker < IronWorker::Base

  CONSUMER_KEY = "iqlMxXcI5LWbtQWYxeBUOg"
  CONSUMER_SECRET = "njSfi1HDTV6PV59NNPJX7mnhSnr72p2gmreEoAa7Xc"
  ACCESS_TOKEN = "524858064-jnaamOdfHwmYJXgrC4M1cupOy3W1GA79vjSC1UIv"
  ACCESS_SECRET = "1KUGJXZ2pVvm2FCIVPwl7g34bZRttB8JwdXqAdqc"

  attr_accessor :message

  #def initialize(message)
    #message = message
  #end

  def run
    Twitter.configure do |config|
      config.consumer_key = CONSUMER_KEY
      config.consumer_secret = CONSUMER_SECRET
      config.oauth_token = ACCESS_TOKEN
      config.oauth_token_secret = ACCESS_SECRET
    end
    Twitter.update(message)
  end

end
