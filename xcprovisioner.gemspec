# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcprovisioner/version'

Gem::Specification.new do |spec|
  spec.name          = 'xcprovisioner'
  spec.version       = XCProvisioner::VERSION
  spec.authors       = ['Andrei Raifura']
  spec.email         = ['thelvis4@gmail.com']
  spec.summary       = 'Set provisioning profile specifier after switching to Manual signing (if needed).'
  spec.homepage      = 'https://github.com/thelvis4/XCProvisioner'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']

  spec.add_dependency 'xcodeproj', '~> 1.4'

  spec.add_runtime_dependency 'activesupport',  '>= 3', '< 5.0'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  ## Make sure you can build the gem on older versions of RubyGems too:
  spec.rubygems_version = '1.6.2'
  if spec.respond_to? :required_rubygems_version=
    spec.required_rubygems_version = Gem::Requirement.new('>= 0')
  end
  spec.required_ruby_version = '>= 2.0.0'
end
