require 'spec_helper'

describe Atlas::Api::Client do

  def stub_request_with_token(method, path, body, query = {})
    stub_request(method, "#{@endpoint}#{path}?auth_token=#{@token}").with(:body => query).to_return(:body => body)
  end

  before(:each) do
    @token = "abcdefg"
    @endpoint = "http://www.runemadsen.com"
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
      stub = stub_request_with_token(:get, "/fake", @body.to_json)
      res = @client.get("/fake")
      stub.should have_been_requested
      res.should be_instance_of(Hashie::Mash)
      res.message.should == @body[:message]
    end

  end

  describe "Builds" do

    it "#create_build" do
      query = {
        :project => "atlasservers/basic-sample",
        :formats => "pdf,html",
        :branch => "master",
        :pingback_url => "http://www.someurl.com"
      }
      stub = stub_request_with_token(:post, "/builds", @body.to_json, query)
      @client.create_build(query)
      stub.should have_been_requested
    end

    it "#build" do

    end

    it "#builds" do

    end

  end

end