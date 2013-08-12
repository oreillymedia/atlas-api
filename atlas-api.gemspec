# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atlas-api/version'

Gem::Specification.new do |gem|
  gem.name          = "atlas-api"
  gem.version       = Atlas::Api::VERSION
  gem.authors       = ["Rune Skjoldborg Madsen"]
  gem.email         = ["rune@runemadsen.com"]
  gem.description   = "Gem to interact with the O'Reilly Media Atlas API"
  gem.summary       = "Gem to interact with the O'Reilly Media Atlas API"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "faraday", "~> 0.5.3"
  gem.add_dependency "hashie", "~> 0.4.0"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"
end
