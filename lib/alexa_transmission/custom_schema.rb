module Sinatra
  module Transmission
    def self.custom_schema
      File.read(File.expand_path('../../../skills_config/custom_schema.txt', __FILE__))
    end
  end
end