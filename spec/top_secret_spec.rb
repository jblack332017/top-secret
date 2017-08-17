require "spec_helper"
require 'nokogiri'

chevy_url = "http://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/page1/?filter=ALL_REVIEWS#link"
small_url = "http://www.dealerrater.com/dealer/Jody-Wilkinson-Acura-review-19262/page1/?filter=ALL_REVIEWS"
large_url = "http://www.dealerrater.com/dealer/Brent-Brown-Toyota-dealer-reviews-11535/page1/?filter=ALL_REVIEWS#link"
invalid_url = "http://www.dealerrater.com/dealer/Brent-Brown-Toyota-dealer-reviews-11535/#link"

normal_test = TopSecret::Scrape.positive(chevy_url,5,3)
normal_review = normal_test[0]

RSpec.describe TopSecret do

  it "has a version number" do
    expect(TopSecret::VERSION).not_to be nil
  end

  it "has title" do
    expect(normal_review['title'].length).to be > 0
  end

  it "has name" do
    expect(normal_review['name'].length).to be > 0
  end

  it "has date" do
    expect(normal_review['date'].length).to be > 0
  end

  it "has overall" do
    expect(normal_review['overall'].length).to be > 0
  end

  it "has body" do
    expect(normal_review['body'].length).to be > 0 
  end

  it "returns normal size" do
    expect(normal_test.length).to eql(3)
  end

  it "returns small size" do
    expect(TopSecret::Scrape.positive(chevy_url,1,1).length).to eql(1)
  end

  it "returns large size" do
    expect(TopSecret::Scrape.positive(chevy_url,10,100).length).to eql(100)
  end

  it "handles large page number" do
    expect{TopSecret::Scrape.positive(small_url,10,100)}.to_not raise_error
  end

  it "handles zero page number" do
    expect{TopSecret::Scrape.positive(small_url,0,100)}.to_not raise_error
  end

  it "handles zero limit number" do
    expect{TopSecret::Scrape.positive(small_url,10,0)}.to_not raise_error
  end

  it "returns yes rating" do
    xml = <<EOT
<mainnode>
  yes
</mainnode>
EOT
    element = Nokogiri::XML(xml)
    expect(TopSecret::Scrape.rating(element)).to eql('yes')
  end

  it "returns no rating" do
    xml = <<EOT
<mainnode>
  no
</mainnode>
EOT
    element = Nokogiri::XML(xml)
    expect(TopSecret::Scrape.rating(element)).to eql('no')
  end

#   it "returns 49 rating" do
#     xml = <<EOT
# <div>
# </div>
# EOT
#     element = Nokogiri::XML(xml)
#     element.set_attribute("class","rating-49")
#     expect(TopSecret::Scrape.rating(element)).to eql('49')
#   end
#
#   it "returns 00 rating" do
#     xml = <<EOT
# <div>
# </div>
# EOT
#     element = Nokogiri::XML(xml)
#     element['class']="rating-static rating-00 margin-top-none pull-right margin-right-none"
#     expect{TopSecret::Scrape.rating(element)}.to_not raise_error
#   end

end
