# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lbs-config/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Azarel Doroteo Pacheco"]
  gem.email         = ["azarel.doroteo@logicalbricks.com"]
  gem.description = %q{Instala templates para el scaffold, incluye opciones para generarlos con erb, haml, simple_form, formtastic, bootstrap y cancan. Incluye la posibilidad de generarlos en Inglés y Español, con su respectivo inflection.}
  gem.summary     = %q{Instala archivos de templates usuales en LogicalBricks Solutions para el scaffold}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lbs-config"
  gem.require_paths = ["lib"]
  gem.version       = Lbs::Config::VERSION

  gem.add_dependency 'rieles'
end
