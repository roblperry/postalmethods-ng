# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'postalmethods/version'

Gem::Specification.new do |spec|
  spec.name          = "postalmethods-ng"
  spec.version       = PostalMethods::VERSION
  spec.authors       = ["Paul Philippov"]
  spec.email         = ["themactep@gmail.com"]
  spec.description   = %q{PostalMethods SOAP API library}
  spec.summary       = %q{PostalMethods SOAP API library based on Savon SOAP Client v2.}
  spec.homepage      = "http://themactep.com/ruby/postalmethods-ng"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.4"
  spec.add_development_dependency "rake"
  spec.add_dependency "savon", "~> 2.0"
end
