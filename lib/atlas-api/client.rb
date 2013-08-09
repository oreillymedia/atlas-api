require 'faraday'
require 'json'
require 'hashie'

module Atlas
  module Api
    class Client

      def initialize(options = {})
        @api_endpoint = options[:api_endpoint]
        @auth_token = options[:auth_token]
      end

      # Builds
      # ------------------------------------------------------------------------

      def builds(options = {})
        get("builds", options)
      end

      def build(id, options = {})
        get("builds/#{id}", options)
      end

      def create_build(options)
        post("builds", options)
      end

      # Build Formats
      # ------------------------------------------------------------------------

      def update_build_format(uuid, options = {})
        put("build_formats/#{uuid}", options)
      end

      # HTTP methods
      # ------------------------------------------------------------------------

      def get(path, options = {})
        request :get, path, options
      end

      def post(path, options = {})
        request :post, path, options
      end

      def put(path, options = {})
        request :put, path, options
      end

      def delete(path, options = {})
        request :delete, path, options
      end

      def agent
        @agent ||= Faraday.new(url: @api_endpoint, params: { auth_token: @auth_token })
        @agent
      end

      private

      def request(method, path, options)
        @last_response = response = agent.send(method, URI.encode(path), options)
        Hashie::Mash.new(JSON.parse(response.body))
      end

    end
  end
end
