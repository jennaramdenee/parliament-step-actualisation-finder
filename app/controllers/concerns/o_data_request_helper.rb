module ODataRequestHelper
  require 'json'

  ODATA_BASE_URL = 'https://api.parliament.uk/Staging/odata/'

  def self.request(endpoint)
    uri = URI(ODATA_BASE_URL + endpoint)
    JSON.parse(Net::HTTP.get(uri))
    # ["value"]
  end

end
