require_relative "rspec_helper"
require_relative "../lib/okyakusan"

RSpec.describe Okyakusan do
  describe ".start" do
    it "should create a Client object" do
      Okyakusan.start do |client|
        expect(client).to be_an_instance_of(Okyakusan::Client)
      end
    end
  end
end
