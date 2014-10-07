require 'json'
require 'webrick'

module Phase4
  class Session

    COOKIE_NAME = "_rails_lite_app"

    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)

      cookie_index = req.cookies.find_index do |cookie|
        cookie.name == COOKIE_NAME
      end

      our_cookie = cookie_index.nil? ? nil : req.cookies[cookie_index]

      @cookie = our_cookie.nil? ? {} : JSON.parse(our_cookie.value)
    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new(COOKIE_NAME, @cookie.to_json)
    end
  end
end
