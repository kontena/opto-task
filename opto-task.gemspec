# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opto/task/version'

Gem::Specification.new do |spec|
  spec.name          = "opto-task"
  spec.version       = Opto::Task::VERSION
  spec.authors       = ["Kimmo Lehto"]
  spec.email         = ["info@kontena.io"]

  spec.summary       = %q{Create tasks or service objects from Opto::Models}
  spec.homepage      = "https://github.com/kontena/opto-task"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "opto-model", "~> 0.1"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
