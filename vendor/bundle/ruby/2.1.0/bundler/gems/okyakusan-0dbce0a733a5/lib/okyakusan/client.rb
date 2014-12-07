require "netrc"
require "net/http"
require "json"

module Okyakusan
  class Client
    def initialize(http)
      @http     = http
      netrc     = Netrc.read
      @username = netrc["api.heroku.com"].first
      @password = netrc["api.heroku.com"].last
    end

    %w(get delete).each do |method_name|
      define_method(method_name) do |path, version: false|
        klass   = Net::HTTP.const_get(method_name.capitalize)
        request = klass.new(path)

        setup_request(request, version: version)
        @http.request(request)
      end
    end

    %w(post patch).each do |method_name|
      define_method(method_name) do |path, data: nil, version: nil|
        klass   = Net::HTTP.const_get(method_name.capitalize)
        request = klass.new(path)

        setup_request(request, version: version)
        request.body = data.to_json if data
        @http.request(request)
      end
    end

    private
    def setup_request(request, version:)
      version ||= "3"

      request.basic_auth(@username, @password)
      request.content_type = "application/json"
      request["Accept"]    = "application/vnd.heroku+json; version=#{version}"
      request
    end
  end
end
