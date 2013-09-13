# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dragonfly/mongo_data_store/version'

Gem::Specification.new do |spec|
  spec.name          = "dragonfly-mongo_data_store"
  spec.version       = Dragonfly::MongoDataStore::VERSION
  spec.authors       = ["Mark Evans"]
  spec.email         = ["mark@new-bamboo.co.uk"]
  spec.description   = %q{Mongo data store for Dragonfly}
  spec.summary       = %q{Data store for storing content (e.g. images) handled with the Dragonfly gem in a mongo database.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dragonfly", "~> 1.0"
  spec.add_runtime_dependency "mongo", "~> 1.7"
  spec.add_development_dependency "rspec", "~> 2.0"
end

