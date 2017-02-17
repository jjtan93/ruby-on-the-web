require 'jumpstart_auth'
require 'bitly'

Bitly.use_api_version_3

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
  end
  
  def tweet(message)
    if(message.length <= 140)
      puts "Tweet successful!"
      @client.update(message)
    else
      puts "Tweet is over 140 characters long!"
    end
  end
  
  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ""
    while command != "q"
      printf "Enter command: "
      input = gets.chomp
      parts = input.split(" ")
      
      case parts[0]
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'spam' then spam_my_followers(parts[1..-1].join(" "))
        when 'elt' then everyones_last_tweet
        when 's' then shorten(parts[1])
        when 'turl' then tweet_with_url(parts)
        else
        puts "Sorry, I don't know how to #{command}"
      end
    end
  end
      
  def dm(target, message)
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }

    if(screen_names.include? target)
      puts "Trying to send #{target} this direct message:"
      puts message
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "Error! You can only DM people who are following you!"
    end
  end
        
  def followers_list
    screen_names = []
    
    @client.followers.each do |follower|
      screen_names << @client.user(follower).screen_name
    end
    
    screen_names
  end
        
  def spam_my_followers(message)
    followers_list.each do |follower|
      dm(follower, message)
    end
  end
  
  def everyones_last_tweet
    screen_names = @client.friends.collect {|f| @client.user(f).screen_name }
    screen_names.sort_by!{|screen_name| screen_name.downcase}
    
    screen_names.each do |friend|
      last_tweet = @client.user(friend).status
      timestamp = last_tweet.created_at
      puts "#{last_tweet.user.screen_name} said this on #{timestamp.strftime("%A, %b %d")}..."
      puts "#{last_tweet.text}"
    end
  end
          
  def shorten(original_url)
    # Shortening Code
    puts "Shortening this URL: #{original_url}"
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    return bitly.shorten(original_url).short_url
  end
          
  def tweet_with_url(parts)
    tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
  end
  
end

blogger = MicroBlogger.new
blogger.run
