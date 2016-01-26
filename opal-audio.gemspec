# coding: utf-8
$LOAD_PATH << File.expand_path('../opal', __FILE__)
require 'audio/version'

Gem::Specification.new do |spec|
  spec.name          = "opal-audio"
  spec.version       = Audio::VERSION
  spec.authors       = ["Jose Añasco"]
  spec.email         = ["joseanasco1@gmail.com"]

  spec.summary       = %q{wrapper around web audio api}
  spec.description   = %q{Web Audio api in Ruby}
  spec.homepage      = "http://github.com/merongivian/opal-audio"

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency "opal", ">= 0.7.0", "< 0.9.0"
end
