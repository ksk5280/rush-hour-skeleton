module RushHour

  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    post '/sources' do
      @client = Client.new(:root_url => params["rootUrl"], :identifier => params["identifier"]) # data from curl request
      #built in active record errors
      if @client.save
        status 200
        body "{\"identifier\":\"#{@client.identifier}\"}"
      elsif params["rootUrl"].nil? || params["identifier"].nil?
        status 400
        body "Missing Parameters"
      else
        status 403
        body @client.errors.full_messages.join(", ")
      end#conditional for errors
    end

    post '/sources/:identifier/data' do |identifier|
      code, message = RequestParser.parse_request(params["payload"], identifier)
      status(code)
      body(message)
      # @client = Client.new(:root_url => params["rootUrl"], :identifier => params["identifier"])
      # @client_payload = RequestParser.new
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @client = Client.where(identifier: identifier).first
      url = @client.root_url + '/' + relative_path
      url_obj = Url.where(address: url).first
      @max = url_obj.payload_requests.max_response_time
      @min = url_obj.payload_requests.min_response_time
      # require "pry"
      # binding.pry
      #
      # @payload = PayloadRequest.where(url_id: ???)
      erb :url_stats
    end
  end

end



# create a parser to do something like this to parse params when registering?

# identifier, rootUrl = Parser.new(params[:register])

# do something like this to parse parameters (taken from class example)

# data = JSON.parse(params[:genre]) # this has to be parsed because it's a string

# genre = Genre.new(data)
