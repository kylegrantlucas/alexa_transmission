require "alexa_transmission/version"
require 'transmission_api'
require 'to_name'
require 'active_support/core_ext/array'
require 'sinatra/extension'

module Transmission
  extend Sinatra::Extension

  helpers do
    def check_transmission
      transmission_api_client = ::TransmissionApi::Client.new(
                                  :username => settings.config.transmission.username,
                                  :password => settings.config.transmission.password,
                                  :url      => settings.config.transmission.rpc_url
                                )

      parsed_files = transmission_api_client.all.map! {|x| {percent_completed: x["percentDone"], name: ToName.to_name(x["name"].gsub(/\+/, '.').gsub(' ', '.'))} if x["percentDone"] != 1}.compact!
      parsed_strings = if parsed_files && !parsed_files.empty?
                         parsed_files.map! { |x| "#{x[:name].name}#{" Episode #{x[:name].episode}" if x[:name].episode} is at #{(x[:percent_completed]*100).round} percent" }
                         parsed_files.to_sentence
                       else
                         "No downloads are currently in progress"
                       end
                       
      AlexaObjects::Response.new(spoken_response: parsed_strings).to_json            
    end
  end
end
