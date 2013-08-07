require 'spec_helper'

describe Atlas::Api::Client do

  before(:each) do
    @token = "abcdefg"
    @endpoint = "http://www.runemadsen.com"
    @body = { message: "Success!" }
    @client = Atlas::Api::Client.new(
      access_token: @token,
      api_endpoint: @endpoint
    )
  end

  describe "Configuration" do

    it "should set options as instance vars" do
      @client.instance_variable_get("@access_token").should == @token
      @client.instance_variable_get("@api_endpoint").should == @endpoint
    end

    it "should use access_token and api_endpoint in calls and return hashie" do
      stub_request(:get, "#{@endpoint}/fake?access_token=#{@token}").to_return(:status => 200, :body => @body.to_json, :headers => {})
      res = @client.get("/fake")
      res.message.should == @body[:message]
    end

  end

end