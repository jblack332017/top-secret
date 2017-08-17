require "top_secret/version"
require 'rest-client'
require 'nokogiri'
require 'pry'

module TopSecret

    class Scrape

    def self.positive(url,pages,limit_to_return)
      reviews = []
      counter = 1

      while counter <= pages
        url = url.sub("page" + (counter-1).to_s, "page" + counter.to_s )
        reviews.concat extract(url)
        counter = counter + 1
      end
      return reviews
    end

    def self.extract(url)
      reviews = []

      #use rest-client to get the page object
      page = RestClient.get(url)

      #convert the page object into a nokogiri object to be parsed. The review-wrapper css class is used to identify reviews.
      noko_page = Nokogiri::HTML(page).css('.review-entry')

      #map through each user_review
      noko_page.map do |user_review|
        review_to_add = Hash.new

        date_and_overall = user_review.css('.review-date').css('div')
        review_to_add["date"] = date_and_overall.css('.italic').text.strip
        review_to_add["overall"] = rating(date_and_overall.css('.dealership-rating').css('div')[1])

        review_wrapper = user_review.css('.review-wrapper').css('div')

        review_title = review_wrapper[1]
        review_to_add["title"] = review_title.css('h3').text.strip
        review_to_add["name"] = review_title.css('span').text.strip

        review_body = review_wrapper[2]
        review_to_add["body"] = review_body.css('p').text.strip

        review_ratings = review_wrapper.css('.review-ratings-all').css('.table').css('.tr')


        review_ratings.map do |specific_rating|
          specific_score = rating(specific_rating.css('div')[1])
          review_to_add[specific_rating.css('.bold').text] = specific_score
        end

        review_employees = review_wrapper.css('.employees-wrapper')

        employees = []

        review_employees.css('a').map do |employee|
          employees.push(employee.text.strip)
        end
        review_to_add['employees'] = employees

        if other_employees = review_employees.css('span').css('.italic').text.strip and other_employees.length > 0
          review_to_add['other_employees'] = other_employees
        end

        reviews.push(review_to_add)
      end

      reviews
    end

    def self.rating(element)
      return element.text.strip unless element.text.length == 0

      rating_re = /\d+/
      return rating_re.match(element.attr('class'))[0]
    end

  end
end
