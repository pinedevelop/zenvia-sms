# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zenvia/sms/version'

Gem::Specification.new do |spec|
  spec.name          = 'zenvia-sms'
  spec.version       = Zenvia::SMS::VERSION
  spec.authors       = ['Diego Silva']
  spec.email         = ['diego.silva@live.com']

  spec.summary       = 'A wrapper for Zenvia SMS API'
  spec.homepage      = 'https://github.com/pinedevelop/zenvia-sms'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.1'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.11.0'

  spec.add_runtime_dependency 'rest-client', '~> 1.8'
end
