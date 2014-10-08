require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = route_params
      @params.merge!(parse_www_encoded_form(req.query_string || ""))
      @params.merge!(parse_www_encoded_form(req.body || ""))
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params = {}
      raw_params = URI::decode_www_form(www_encoded_form).to_h
      raw_params.each do |key, value|
        parsed = parse_key(key).reverse
        nested = parsed.reduce(value) { |a, n| {n => a} }
        params.my_deep_merge!(nested)
      end

      params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end



  end
end

class Hash
  def my_deep_merge!(hash)
    self.merge!(hash) do |key, oldval, newval|
      if newval.class == Hash && oldval.class == Hash
        #recursive case
        oldval.my_deep_merge!(newval)
      else
        #base case
        newval
      end
    end

    self
  end
end