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

      def build_and_poll(query)
        post_response = create_build(query)
        tries = 0

        while(true)
          last_response = build(post_response.id)  
          break if last_response.status.find { |format| format.status == "queued" || format.status == "working" }.nil?
          tries += 1
          if tries > 100
            raise "The build is taking too long. Exiting"
          end
          sleep(5)
        end

        last_response
      end

      def builds(options = {})
        get("builds", options)
      end

      def build(id, options = {})
        get("builds/#{id}", options)
      end

      def create_build(options)
        post("builds", options)
      end

      def update_build(id, formats = {})
        put("builds/#{id}", :formats => formats)
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
        @last_response = response = agent.send(method, path, options)
        Hashie::Mash.new(JSON.parse(response.body))
      end

    end
  end
end
