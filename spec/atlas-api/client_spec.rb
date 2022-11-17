require 'spec_helper'

describe Atlas::Api::Client do

  def stub_request_with_token(method, path, body, query = {})
    stub_request(method, "#{@endpoint}/#{path}?auth_token=#{@token}").with(:body => query).to_return(:body => body)
  end

  before(:each) do
    @token = "abcdefg"
    @endpoint = "http://atlas.oreilly.com"
    @body = { message: "Success!" }
    @client = Atlas::Api::Client.new(
      auth_token: @token,
      api_endpoint: @endpoint
    )
  end

  describe "Configuration" do

    it "should set options as instance vars" do
      @client.instance_variable_get("@auth_token").should == @token
      @client.instance_variable_get("@api_endpoint").should == @endpoint
    end

    it "should use auth_token and api_endpoint in calls and return hashie" do
      stub = stub_request_with_token(:get, "fake", @body.to_json)
      res = @client.get("fake")
      stub.should have_been_requested
      res.should be_instance_of(Hashie::Mash)
      res.message.should == @body[:message]
    end

    it "should combine paths from endpoint and path" do
      @endpoint = "http://atlas.oreilly.com/api"
      client = Atlas::Api::Client.new(
        auth_token: @token,
        api_endpoint: @endpoint
      )
      stub = stub_request_with_token(:get, "fake", @body.to_json)
      res = client.get("fake")
      stub.should have_been_requested
    end

  end

  describe "Builds" do

    describe "#build_and_poll" do
      
      it "polls the api until all builds are done" do
        @client.stub(:sleep).and_return(true)

        query = {
          :project => "atlasservers/basic-sample",
          :formats => "pdf,html",
          :branch => "main",
          :pingback_url => "http://www.someurl.com"
        }

        first = {
          "id" => 1,
          "status" => [
            {
              "format" => "pdf",
              "status" => "queued"
            },
            {
              "format" => "html",
              "status" => "queued"
            }
          ]
        }

        second = {
          "id" => 1,
          "status" => [
            {
              "format" => "pdf",
              "status" => "completed",
              "download_url" => "pdfurl"
            },
            {
              "format" => "html",
              "status" => "queued"
            }
          ]
        }

        third = {
          "id" => 1,
          "status" => [
            {
              "format" => "pdf",
              "status" => "completed",
              "download_url" => "pdfurl"
            },
            {
              "format" => "html",
              "status" => "failed",
              "message" => "wrong"
            }
          ]
        }

        stub_request_with_token(:post, "builds", first.to_json, query)
        stub_request_with_token(:get, "builds/1", second.to_json).then.to_return(:body => third.to_json)
        res = @client.build_and_poll(query)
        res["status"].first["status"].should == "completed"
        res["status"].last["status"].should == "failed"
      end
    end

    it "#create_build" do
      query = {
        :project => "atlasservers/basic-sample",
        :formats => "pdf,html",
        :branch => "main",
        :pingback_url => "http://www.someurl.com"
      }
      stub = stub_request_with_token(:post, "builds", @body.to_json, query)
      @client.create_build(query)
      stub.should have_been_requested
    end

    it "#build" do
      stub = stub_request_with_token(:get, "builds/1", @body.to_json)
      @client.build(1)
      stub.should have_been_requested
    end

    it "#builds" do
      stub = stub_request_with_token(:get, "builds", @body.to_json)
      @client.builds
      stub.should have_been_requested
    end

    it "#update_build" do
      query = {
        :pdf => {
          :message => "hello", 
          :download_url => "http://www.someurl.com",
          :status => "success"
        }
      }
      stub = stub_request_with_token(:put, "builds/1", {:formats => query}.to_json)
      @client.update_build(1, query)
      stub.should have_been_requested
    end

  end

end