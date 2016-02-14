# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alexa_transmission/version'

Gem::Specification.new do |spec|
  spec.name          = "alexa_transmission"
  spec.version       = AlexaTransmission::VERSION
  spec.authors       = ["kylegrantlucas"]
  spec.email         = ["kglucas93@gmail.com"]

  spec.summary       = %q{A sinatra middleware for using alexa commands with transmission.}
  spec.description   = %q{A sinatra middleware for using alexa commands with transmission.}
  spec.homepage      = "http://github.com/kylegrantlucas/alexa_transmission"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "skills_config"]

  spec.add_runtime_dependency 'alexa_objects'
  spec.add_runtime_dependency 'toname'
  spec.add_runtime_dependency 'transmission_api'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'sinatra'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
