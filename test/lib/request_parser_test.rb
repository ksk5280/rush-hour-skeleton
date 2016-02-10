require_relative '../test_helper'
require_relative '../../app/lib/request_parser'

class RequestParserTest < Minitest::Test
  include TestHelpers

  def test_parser_correctly_renames_keys
    payload = {
      "url": "http://jumpstartlab.com/blog",
      "requestedAt": "2013-02-16 21:38:28 -0700",
      "respondedIn": 37,
      "referredBy": "http://jumpstartlab.com",
      "requestType": "GET",
      "parameters": [],
      "eventName": "socialLogin",
      "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth": "1920",
      "resolutionHeight": "1280",
      "ip": "63.29.38.211"
    }

    binding.pry
    pr = RequestParser.parse_request(payload)
    parsed_request = PayloadRequest.create(payload)

    assert_equal 37, parsed_request.responded_in
    assert_equal "socialLogin", parse_request.event_name
    refute_equal "http://google.com", parsed_request.referred_by
  end
end

# payload = {
#   "url": "http://jumpstartlab.com/blog",
#   "requestedAt": "2013-02-16 21:38:28 -0700",
#   "respondedIn": 37,
#   "referredBy": "http://jumpstartlab.com",
#   "requestType": "GET",
#   "parameters": [],
#   "eventName": "socialLogin",
#   "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
#   "resolutionWidth": "1920",
#   "resolutionHeight": "1280",
#   "ip": "63.29.38.211"
# }
# pr = PayloadRequest.create(payload)
#
# assert_equal "2013-02-16 21:38:28 -0700", pr.requestedAt
# end


# parsed_request = {
#   :url => payload[:url],
#   :requested_at => payload[:requestedAt],
#   :responded_in => payload[:respondedIn],
#   :referred_by => payload[:referredBy],
#   :request_type => payload[:requestType],
#   :parameters => payload[:parameters],
#   :event_name => payload[:eventName],
#   :resolution_width => payload[:resolutionWidth],
#   :resolution_height => payload[:resolutionHeight],
#   :ip => payload[:ip]
# }
