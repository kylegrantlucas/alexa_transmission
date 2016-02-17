Bundler.require
require "alexa_transmission/version"
require 'transmission_api'
require 'to_name'
require 'active_support/core_ext/array'
require 'sinatra/extension'

module Transmission
  register Sinatra::Extension

  post '/alexa_transmission' do
    halt 400, "" if settings.config.application_id && @application_id != settings.config.application_id

    if @echo_request.launch_request?
      response = AlexaObjects::Response.new
      response.spoken_response = "I'm ready to check your downloads."
      response.end_session = false
      response.without_card.to_json
    elsif @echo_request.intent_name == "EndSession"
      
    elsif @echo_request.session_ended_request?
        response = AlexaObjects::Response.new
        response.end_session = true
        response.without_card.to_json
    else
        self.send(@echo_request.intent_name.underscore.to_sym)
    end
  end

  def self.check_transmission
    response = AlexaObjects::Response.new
    transmission_api_client = ::TransmissionApi::Client.new(
                                  :username => settings.config.transmission.username,
                                  :password => settings.config.transmission.password,
                                  :url      => settings.config.transmission.rpc_url
                                )

    parsed_files = transmission_api_client.all.map{|x| {percent_completed: x["percentDone"], name: ToName.to_name(x["name"].gsub(/\+/, '.').gsub(' ', '.'))} if x["percentDone"] != 1}.compact
    parsed_strings = parsed_files.map {|x| "#{x[:name].name}#{" Episode #{x[:name].episode}" if x[:name].episode} is at #{x[:percent_completed]*100} percent" }.to_sentence

    response.end_session = true
    response.spoken_response = parsed_strings            
    response.without_card.to_json
  end

  def self.end_session
    response = AlexaObjects::Response.new
    response.end_session = true
    response.spoken_response = "exiting couchpoato"
    response.without_card.to_json
  end
end
