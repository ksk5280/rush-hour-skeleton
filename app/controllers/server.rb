module RushHour

  class Server < Sinatra::Base
    not_found do
      erb :error
    end

    get '/' do
      erb :home
    end

    post '/sources' do
      @client = Client.new(:root_url => params["rootUrl"], :identifier => params["identifier"])
      status PathParser.sources_parser(@client, params)["status"]
      body PathParser.sources_parser(@client, params)["body"]
    end

    post '/sources/:identifier/data' do |identifier|
      code, message = RequestParser.parse_request(params["payload"], identifier)
      status(code)
      body(message)
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, relative_path|
      @client = Client.find_by(identifier: identifier)
      url = @client.root_url + '/' + relative_path

      unless Url.pluck(:address).include?(url)
        redirect '/missing-url'
      else
        @url_obj = Url.find_by(address: url)
        erb :url_stats
      end
    end

    get '/missing-url' do
      erb :unrequested_url
    end

    get '/sources/:identifier' do |identifier|
      @client = Client.find_by(identifier: identifier)

      if !@client.nil?
        @payloads = PayloadRequest.where(client_id: @client.id)
        @user_systems = UserSystem.where(id: @payloads.pluck(:user_system_id))
        @resolutions = Resolution.where(id: @payloads.pluck(:resolution_id))
      end

      erb PathParser.sources_identifier_parse(@payloads, @client)
    end

    get '/sources/:identifier/events' do |identifier|
      @client = Client.find_by(identifier: identifier)
      @all_events = @client.event_names.uniq if !@client.nil?
      @identifier = identifier
      erb :events_list
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      @client = Client.find_by(identifier: identifier)
      @event = EventName.find_by(event_name: event_name)
      erb :event_breakdown
    end
  end
end
