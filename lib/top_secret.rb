require "top_secret/version"
require 'rest-client'
require 'nokogiri'
require 'date'
require 'pry'

module TopSecret

    class Scrape

    def self.positive(url,pages,limit_to_return)
      reviews = []
      counter = 1
      # replaces url and calls extract on correct number of pages starting with the first page.
      while counter <= pages
        url = url.sub("page" + (counter-1).to_s, "page" + counter.to_s )
        reviews.concat extract(url)
        counter = counter + 1
      end
      # sorts reviews based on teh overall score and then the date.
      reviews.sort { |a, b| [a['overall'], Date.parse(a['date'])] <=> [b['overall'], Date.parse(b['date'])] }
      return reviews.first(limit_to_return)
    end

    def self.extract(url)
      reviews = []

      # use rest-client to get the page object
      page = RestClient.get(url)

      # convert the page object into a nokogiri object to be parsed. The review-wrapper css class is used to identify reviews.
      noko_page = Nokogiri::HTML(page).css('.review-entry')

      # map through each user_review
      noko_page.map do |user_review|
        review_to_add = Hash.new

        # the date and overall are located in an earlier div than the rest of the info locates in the review-wrapper container
        date_and_overall = user_review.css('.review-date').css('div')
        review_to_add["date"] = date_and_overall.css('.italic').text.strip
        review_to_add["overall"] = rating(date_and_overall.css('.dealership-rating').css('div')[1])

        # the rest of the review
        review_wrapper = user_review.css('.review-wrapper').css('div')

        # title and name
        review_title = review_wrapper[1]
        review_to_add["title"] = review_title.css('h3').text.strip
        review_to_add["name"] = review_title.css('span').text.strip

        # the main text of the review
        review_body = review_wrapper[2]
        review_to_add["body"] = review_body.css('p').text.strip

        # the specific ratings
        review_ratings = review_wrapper.css('.review-ratings-all').css('.table').css('.tr')

        # map through specific review score and call rating to fetch correct score.
        review_ratings.map do |specific_rating|
          specific_score = rating(specific_rating.css('div')[1])
          review_to_add[specific_rating.css('.bold').text] = specific_score
        end

        # component containing employees
        review_employees = review_wrapper.css('.employees-wrapper')

        employees = []

        # loops through and stores each employee name
        review_employees.css('a').map do |employee|
          employees.push(employee.text.strip)
        end

        review_to_add['employees'] = employees

        # adds other employees if they exist
        if other_employees = review_employees.css('span').css('.italic').text.strip and other_employees.length > 0
          review_to_add['other_employees'] = other_employees
        end

        reviews.push(review_to_add)
      end

      # return reviews
      reviews
    end

    # returns correct rating based on class and text of elemnt passed in.
    def self.rating(element)
      return element.text.strip unless element.text.length == 0
      rating_re = /\d+/
      return rating_re.match(element.attr('class'))[0]
    end

  end
end
