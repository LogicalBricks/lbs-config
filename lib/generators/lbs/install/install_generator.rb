# encoding: UTF-8

module Lbs
  class InstallGenerator < Rails::Generators::Base
    if defined? Rieles
      source_root File.expand_path('../templates/es', __FILE__)
    else
      source_root File.expand_path('../templates/en', __FILE__)
    end

    argument :model_attributes, :type => :array, :default => []

    class_option :template_engine, 
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
    class_option :form_builder, 
      :type => :string, 
      :default => 'default', 
      :desc => 'Indica que estructura se debe utilizar para el formulario [default, formtastic, simple_form]'

    no_tasks { attr_accessor :show_link, :edit_link, :destroy_link }

    def copy_views
      # Se copian las vistas de index, edit, new y show
      template(
        "#{engine_extension}/index.html.#{engine_extension}", 
        "lib/templates/#{engine_extension}/scaffold/index.html.#{engine_extension}"
      )
      template(
        "#{engine_extension}/edit.html.#{engine_extension}", 
        "lib/templates/#{engine_extension}/scaffold/edit.html.#{engine_extension}"
      )
      template(
        "#{engine_extension}/new.html.#{engine_extension}", 
        "lib/templates/#{engine_extension}/scaffold/new.html.#{engine_extension}"
      )
      template(
        "#{engine_extension}/show.html.#{engine_extension}", 
        "lib/templates/#{engine_extension}/scaffold/show.html.#{engine_extension}"
      )

      # Se copia el _form dependiendo de qué form builder se vaya a utilizar
      if options.form_builder == 'default'       
        template(
          "#{engine_extension}/_form.html.#{engine_extension}", 
          "lib/templates/#{engine_extension}/scaffold/_form.html.#{engine_extension}"
        )
        copy_file(
          "#{engine_extension}/_error_messages.html.#{engine_extension}", 
          "app/views/application/_error_messages.html.#{engine_extension}"
        )
      elsif options.form_builder == 'formtastic' 
        template(
          "_#{engine_extension}/_form_f.html.#{engine_extension}", 
          "lib/templates/#{engine_extension}/scaffold/_form.html.#{engine_extension}"
        )
      elsif options.form_builder == 'simple_form'
        template(
          "#{engine_extension}/__form_s.html.#{engine_extension}", 
          "lib/templates/#{engine_extension}/scaffold/_form.html.#{engine_extension}"
        )
      end
    end

    def copy_controller          
      template("controller.rb", "lib/templates/rails/scaffold_controller/controller.rb")
    end

    def copy_model
      #template 'model.rb', "app/models/#{singular_table_name}.rb"
    end     

    def show_link variable = :local
      v = '<%= singular_table_name %>'
      v = '@' + v if variable == :instance
      show_link = ""
      show_link += "<%%" if engine_extension == 'erb'
      show_link = "= link_to t('.show', default: t('helpers.links.show')), #{v}"
      show_link += ", <%= key_value 'class', \"'btn btn-mini'\" %>" if options.bootstrap?
      show_link += " if can? :read, #{v}" if options.cancan?
      show_link += "%>" if engine_extension == 'erb'
      show_link
    end

    def edit_link variable = :local
      v = '<%= singular_table_name %>'
      v = '@' + v if variable == :instance
      show_link = ""
      show_link += "<%%" if engine_extension == 'erb'
      show_link = "= link_to t('.edit', default: t('helpers.links.edit')), edit_<%= singular_table_name %>_path(#{v})"
      show_link += ", <%= key_value 'class', \"'btn btn-mini'\" %>" if options.bootstrap?
      show_link += " if can? :update, #{v}" if options.cancan?
      show_link += "%>" if engine_extension == 'erb'
      show_link
    end

    def destroy_link variable = :local
      v = '<%= singular_table_name %>'
      v = '@' + v if variable == :instance
      show_link = ""
      show_link += "<%%" if engine_extension == 'erb'
      show_link += "= link_to t('.destroy', default: t('helpers.links.destroy')), #{v}, <%= key_value :confirm, \"'¿Está usted seguro?'\" %>, <%= key_value :method, ':delete' %>"
      show_link += ", <%= key_value 'class', \"'btn btn-mini btn-danger'\" %>" if options.bootstrap?
      show_link += " if can? :read, #{v}" if options.cancan?
      show_link += "%>" if engine_extension == 'erb'
      show_link
    end

    def back_link
      v = '<%= singular_table_name.camelize %>'
      show_link = ""
      show_link += "<%%" if engine_extension == 'erb'
      show_link = "= link_to t('.back', default: t('helpers.links.back')), <%= index_helper %>_path"
      show_link += ", <%= key_value 'class', \"'btn btn-mini btn-danger'\" %>" if options.bootstrap?
      show_link += " if can? :read, #{v}" if options.cancan?
      show_link += "%>" if engine_extension == 'erb'
      show_link
    end

    def form_html_bootstrap
      ", <%= key_value(:html, { :class => 'form-horizontal' }) %>" if options.bootstrap?
    end

    #####################
    private
    #####################

    def engine_extension
      @engine_extension ||= (::Rails.application.config.generators.options[:rails][:template_engine] || filter_engine_user_param)
    end

    def filter_engine_user_param
      %w(erb haml).member?(options.template_engine) ? options.template_engine : 'erb'
    end
  end
end
