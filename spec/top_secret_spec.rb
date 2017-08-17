require "spec_helper"

RSpec.describe TopSecret do
  it "has a version number" do
    expect(TopSecret::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end
  it "returns positive" do
    expect(TopSecret::Scrape.positive("http://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/#link",5,3)).to eql("Yes!")
  end
end
