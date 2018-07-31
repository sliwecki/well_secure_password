# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'well_secure_password/version'

Gem::Specification.new do |spec|
  spec.name          = 'well_secure_password'
  spec.version       = WellSecurePassword::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Damian Śliwecki']
  spec.email         = ['sliwecki@gmail.com']

  spec.summary       = %q{Next generation plugin to secure your clients password}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/sliwecki/well_secure_password'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'rails', '~> 4.2.0'
  spec.add_dependency 'dry-configurable', '~> 0.7.0'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
