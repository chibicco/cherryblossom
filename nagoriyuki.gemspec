# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nagoriyuki/version"

Gem::Specification.new do |spec|
  spec.name          = "nagoriyuki"
  spec.version       = Nagoriyuki::VERSION
  spec.authors       = ["chibicco"]
  spec.email         = ["chibiccoes@gmail.com"]
  spec.summary       = %q{Distributed id generator}
  spec.description   = %q{Distributed id generator}
  spec.homepage      = "http://github.com/chibicco/nagoriyuki"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 2.0.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "delorean"
  spec.add_development_dependency "coveralls"
end
