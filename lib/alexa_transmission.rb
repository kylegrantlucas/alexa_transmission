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

      parsed_files = transmission_api_client.all.map! do |x| 
        size_in_gb = x["totalSize"].to_f/(1000**3)
        rate_download_in_gb_sec = x["rateDownload"].to_f/(1000**3)

        hash = {
          percent_completed: x["percentDone"], 
          name: ToName.to_name(x["name"].gsub(/\+/, '.').gsub(' ', '.')),
          eta: (size_in_gb-(size_in_gb*x["percentDone"]))/rate_download_in_gb_sec/(60**2)
        } 

        hash if x["isFinished"] != true
      end 

      parsed_files.compact!
      
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
