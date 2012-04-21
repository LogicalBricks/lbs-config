# encoding: UTF-8

module Lbs
  class InstallGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    argument :model_attributes, :type => :array, :default => []

    class_option :engine, 
      :type => :string, 
      :default => 'erb', 
      :desc => 'Indica qué debe usarse para generar la vista [erb, haml]'
    class_option :cancan, 
      :type => :boolean, 
      :default => false, 
      :desc => 'Indica si se debe validar por cancan (genera vistas con ligas validadas y adapta el controller)'
    class_option :bootstrap, 
      :type => :boolean, 
      :default => false, 
      :desc => 'Indica si la vista se generará enfocada en boostrap'
    class_option :form, 
      :type => :string, 
      :default => 'default', 
      :desc => 'Indica que estructura se debe utilizar para el formulario [default, formtastic, simple_form]'

    no_tasks { attr_accessor :model_name, :table_name, :attributes}

    def copy_views
      template("index.html.#{engine_extension}", "lib/templates/#{engine_extension}/scaffold/index.html.#{engine_extension}")
      template("edit.html.#{engine_extension}", "lib/templates/#{engine_extension}/scaffold/edit.html.#{engine_extension}")
      template("new.html.#{engine_extension}", "lib/templates/#{engine_extension}/scaffold/new.html.#{engine_extension}")
      template("show.html.#{engine_extension}", "lib/templates/#{engine_extension}/scaffold/show.html.#{engine_extension}")
      template("_form.html.#{engine_extension}", "lib/templates/#{engine_extension}/scaffold/_form.html.#{engine_extension}")
      copy_file("_error_messages.html.#{engine_extension}", "app/views/application/_error_messages.html.#{engine_extension}")
    end

    def copy_controller          
      template("controller.rb", "lib/templates/rails/scaffold_controller/controller.rb")
    end

    def copy_model
      #template 'model.rb', "app/models/#{singular_table_name}.rb"
    end     

    #####################
    private
    #####################

    def engine_extension
      ::Rails.application.config.generators.options[:rails][:template_engine] || filter_engine_user_param
    end

    def filter_engine_user_param
      %w(erb haml).member?(options.engine) ? options.engine : 'erb'
    end
  end
