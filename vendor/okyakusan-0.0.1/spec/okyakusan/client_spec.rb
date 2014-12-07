require_relative "../rspec_helper"
require_relative "../artifice/heroku_api"
require_relative "../../lib/okyakusan/client"
require "artifice"

RSpec.describe Okyakusan::Client do
  let(:http)     { Net::HTTP.start("example.com", "80") }
  let(:client)   { Okyakusan::Client.new(http) }
  let(:app)      { "dodging-samurai-42" }

  before do
    Artifice.activate_with(HerokuAPI)
  end

  after do
    Artifice.deactivate
  end

  describe "#get" do
    it "should make a get request" do
      response = client.get("/apps/#{app}/env-vars")
      expect(response.code).to eq("200")
    end

    it "should work on edge versions" do
      response = client.get("/apps/#{app}/env-vars", version: "edge")
      expect(response.code).to eq("200")
    end

    it "should break on v2 api" do
      response = client.get("/apps/#{app}/env-vars", version: "2")
      expect(response.code).to eq("500")
    end
  end

  describe "#delete" do
    let(:addon) { "heroku-postgresql" }

    it "should make a delete request" do
      response = client.delete("/apps/#{app}/addons/#{addon}")
      expect(response.code).to eq("200")
    end
  end

  describe "#post" do
    let(:addon) { "heroku-postgresql:dev" }

    it "should make a post request" do
      data = {
        config: { "db-version" => "1.2.3" },
        plan: addon
      }
      response = client.post("/apps/#{app}/addons", data: data)
      expect(response.code).to eq("200")
    end

    it "doesn't always need a data argmuent" do
      response = client.post("/apps/#{app}/sources")
      expect(response.code).to eq("200")
    end
  end

  describe "#patch" do
    let(:addon) { "heroku-postgresql" }
    let(:plan)  { "01234567-89ab-cdef-0123-456789abcdef" }

    it "should make a patch request" do
      data = {
        plan: plan
      }

      response = client.patch("/apps/#{app}/addons/#{addon}", data: data)
      expect(response.code).to eq("200")
    end
  end
end
