require 'top_secret'

chevy_url = 'http://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/page1/?filter=ALL_REVIEWS#link'
puts TopSecret::Scrape.positive(chevy_url, 5, 3)
