# Be sure to restart your server when you modify this file.

ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural(/([rndl])([A-Z]|_|$)/, '\1es\2')
  inflect.plural(/([aeiou])([A-Z]|_|$)/, '\1s\2')
  inflect.plural(/([aeiou])([A-Z]|_)([a-z]+)([rndl])([A-Z]|_|$)/, '\1s\2\3\4es\5')
  inflect.plural(/([rndl])([A-Z]|_)([a-z]+)([aeiou])([A-Z]|_|$)/, '\1es\2\3\4s\5')
  inflect.plural(/(z)$/i, 'ces')

  inflect.singular(/(ia)$/i, '\1')
  inflect.singular(/([aeiou])s([A-Z]|_|$)/, '\1\2')
  inflect.singular(/([rndl])es([A-Z]|_|$)/, '\1\2')
  inflect.singular(/([aeiou])s([A-Z]|_)([a-z]+)([rndl])es([A-Z]|_|$)/, '\1\2\3\4\5')
  inflect.singular(/([rndl])es([A-Z]|_)([a-z]+)([aeiou])s([A-Z]|_|$)/, '\1\2\3\4\5')
  inflect.singular(/ces$/, 'z')
  
  inflect.singular 'pais', 'pais'
  inflect.irregular 'pais', 'paises'

  inflect.uncountable %w( campus lunes martes miercoles jueves viernes )
end
