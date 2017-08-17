## Installation

Clone the top_secret gem:

```$ git clone https://github.com/jblack332017/top-secret.git```

And then execute:

    $ gem install bundler
    $ bundle install
    $ gem build top_secret.gemspec
    $ gem install top_secret-0.1.0.gem

Then to run the application:

    $ ruby challenge.rb
    
    
Then to run tests:

    $ rake spec
    
## Usage

The TopSecret gem has one module with one functional method. The method TopSecret::Scrape.positive method accepts three arguments: 
    1. DealerRater url in "http://www.dealerrater.com/dealer/<dealer>/page1/?filter=ALL_REVIEWS
    2. Number of pages to scrape
    3. Number of most postive reviews to return
    
The challenge.rb script will run the TopSecret gem under the conditions required for the podium challenge.

## Sorting

The reviews are sorted based first on overall score and then by date.

