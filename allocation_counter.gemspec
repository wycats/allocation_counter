# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'allocation_counter/version'

Gem::Specification.new do |spec|
  spec.name          = "allocation_counter"
  spec.version       = AllocationCounter::VERSION
  spec.authors       = ["Yehuda Katz"]
  spec.email         = ["wycats@gmail.com"]
  spec.description   = %q{Allocation Counter lets you run a block of code N times and tells you how many objects were allocated (based on Ruby 1.9's allocation profiling)}
  spec.summary       = %q{Count how many objects were allocated}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
