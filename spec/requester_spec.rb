require File.dirname(__FILE__) + '/spec_helper'

describe RTurk::Requester do

  before(:all) do
    FakeWeb.clean_registry
    aws = YAML.load(File.open(File.join(SPEC_ROOT, 'mturk.yml')))
    RTurk.setup(aws['AWSAccessKeyId'], aws['AWSAccessKey'], :sandbox => true)
  end

  it "should send the request to Amazon" do
    RestClient.should_receive(:get).with(/amazonaws.*Operation=GetHIT.*$/)
    RTurk::Requester.request(:Operation => 'GetHIT', 'HITId' => 'test')
  end

  it "should build a correct querystring with one value per key" do
    params = {
      :Operation => 'GetHIT',
      'Param1' => 'test1',
      'Param2' => 'test2'
    }
    RestClient.should_receive(:get).with(
      /(?=.*Operation=GetHIT)(?=.*Param1=test1)(?=.*Param2=test2)/)
    RTurk::Requester.request(params)
  end

  it "Should build a correct querystring with two values per key" do
    params = {
      :Operation => 'GetHIT',
      'Param1' => 'test1',
      'Param2' => %w(test2a test2b)
    }
    RestClient.should_receive(:get).with(
      /(?=.*Operation=GetHIT)(?=.*Param1=test1)(?=.*Param2=test2a)(?=.*Param2=test2b)/)
    RTurk::Requester.request(params)
  end
end