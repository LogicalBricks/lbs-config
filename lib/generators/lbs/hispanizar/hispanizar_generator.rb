# encoding: UTF-8
require 'rails/generators'

module Lbs
  module Generators
    class HispanizarGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      class_option :keep_current, :type => :boolean, :default => false, :desc => 'Indica si en lugar de tratar de sobreescribir el archivo de inflections, se debe crear un archivo adicional (inflections_es)'

      def generate_inflections
        copy_file 'inflections.rb', "config/initializers/#{file_name}.rb"
        copy_file 'es.yml', 'config/locales/es.yml'
      end

      private

      def file_name
        file_name = options.keep_current? ? 'inflections_es' : 'inflections'
      end
    end
  end
end
