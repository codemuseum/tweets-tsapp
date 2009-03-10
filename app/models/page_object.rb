require 'json'
require 'open-uri'

class PageObject < ActiveRecord::Base
  BASE_URL = "http://twitter.com/statuses/user_timeline" 
  DEFAULT_NUMBER_OF_UPDATES = 50 
  include ThriveSmartObjectMethods

  # Updates every hour
  self.caching_default = 'interval[60]' 
  #[in :forever, :page_object_update, :any_page_object_update, 'data_update[datetimes]', :never, 'interval[5]']

  def tweetless?
    username.blank? || tweets.nil? || tweets.empty?
  end

  # Calls twitter for tweets correctly, and returns a JSON object, which is simply a hash of strings
  def tweets
    return @tweets unless @tweets.nil?
    url = "#{BASE_URL}/#{user}?count=#{number_of_updates || DEFAULT_NUMBER_OF_UPDATES}"
    @tweets = JSON.parse(open(url).read)
  end
end
