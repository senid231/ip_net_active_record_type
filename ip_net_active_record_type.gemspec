
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ip_net_active_record_type/version'

Gem::Specification.new do |spec|
  spec.name          = 'ip_net_active_record_type'
  spec.version       = IpNetActiveRecordType::VERSION
  spec.authors       = ['Denis Talakevich']
  spec.email         = ['senid231@gmail.com']

  spec.summary       = 'Fixed behaviour for inet type in ActiveRecord'
  spec.description   = 'Fixed behaviour for inet type in ActiveRecord'
  spec.homepage      = 'https://github.com/senid231/ip_net_active_record_type'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'

  spec.add_dependency 'activemodel', '~> 5.0'
end
