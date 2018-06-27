require 'rails_helper'

RSpec.describe ODataRequestHelper do
  let!(:test_uri) { URI("https://api.parliament.uk/Staging/odata/endpoint") }
  let(:stub_get) {
    stub_request(:get, "https://api.parliament.uk/Staging/odata/endpoint")
    .with(
      headers: {
     	  'Accept'=>'*/*',
     	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     	  'Host'=>'api.parliament.uk',
     	  'User-Agent'=>'Ruby'
      }
    ).to_return(status: 200, body: "{\"value\":[{\"LocalId\":\"e9G2vHbc\",\"ProcedureStepName\":\"Test step\"}]}", headers: {})
  }

  describe '#request' do
    context 'base url' do
      it 'makes a request using base url' do
        # require 'irb'; binding.irb
        ODataRequestHelper.request('endpoint')
        expect(stub_get).to have_been_requested
      end
    end
  end
end
