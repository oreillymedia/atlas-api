require 'faraday'
require 'json'
require 'hashie'

module Atlas
  module Api
    class Client

      def initialize(options = {})
        @api_endpoint = options[:api_endpoint]
        @access_token = options[:access_token]
      end

      # Builds
      # ------------------------------------------------------------------------


      # Build Formats
      # ------------------------------------------------------------------------


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
        @agent ||= Faraday.new(@api_endpoint, { params: { access_token: @access_token }})
      end

      private

      def request(method, path, options)
        @last_response = response = agent.send(method, URI.encode(path), options)
        Hashie::Mash.new(JSON.parse(response.body))
      end

    end
  end
end
