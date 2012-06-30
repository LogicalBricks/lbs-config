# encoding: UTF-8

module Lbs
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    class_option :template_engine, 
      :type => :string, 
      :default => 'erb', 
      :desc => 'Indica qué debe usarse para generar la vista [erb, haml]'
    class_option :cancan, 
      :type => :boolean, 
      :default => false, 
      :desc => 'Indica si se debe validar por cancan (se agrega la validación de cancan a las ligas en las vistas y se adapta el controller)'
    class_option :bootstrap, 
      :type => :boolean, 
      :default => false, 
      :desc => 'Indica si la vista se generará enfocada en bootstrap'
    class_option :form_builder, 
      :type => :string, 
      :default => 'default', 
      :desc => 'Indica que estructura se debe utilizar para el formulario [default, formtastic, simple_form]'

    no_tasks { attr_accessor :show_link, :edit_link, :destroy_link, :new_link }

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
        suffix = options.bootstrap? ? '_b' : ''
        template(
          "#{engine_extension}/_form#{suffix}.html.#{engine_extension}", 
          "lib/templates/#{engine_extension}/scaffold/_form.html.#{engine_extension}"
        )
        copy_file(
          "#{engine_extension}/_error_messages#{suffix}.html.#{engine_extension}", 
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
      complete_syntax :show, v do
        "= link_to t('.show', default: t('helpers.links.show')), #{v}"
      end
    end

    def edit_link variable = :local
      v = '<%= singular_table_name %>'
      v = '@' + v if variable == :instance
      complete_syntax :edit, v do
        "= link_to t('.edit', default: t('helpers.links.edit')), edit_<%= singular_table_name %>_path(#{v})"
      end
    end

    def destroy_link variable = :local
      v = '<%= singular_table_name %>'
      v = '@' + v if variable == :instance
      complete_syntax :destroy, v do
        "= link_to t('.destroy', default: t('helpers.links.destroy')), #{v}, <%= key_value :confirm, \"t('helpers.links.confirm')\" %>, <%= key_value :method, ':delete' %>"
      end
    end

    def back_link
      v = '<%= singular_table_name.camelize %>'
      complete_syntax(v) do
        "= link_to t('.back', default: t('helpers.links.back')), <%= index_helper %>_path"
      end
    end

    def new_link
      v = '<%= singular_table_name.camelize %>'
      if defined? Rieles
        r = "<% if singular_table_name.split('_').first =~ /[ad]$/ -%>\n"
        r += female_new_link v
        r += "\n<% else %>\n"
        r += male_new_link v
        r += "\n<% end %>"
      else
        complete_syntax(v) { %(= link_to "New <%= human_name %>", new_<%= singular_table_name %>_path) }
      end 
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

    def erb?
      engine_extension == 'erb'
    end

    def complete_syntax type = :show, v
      erb_syntax do
        cancan_syntax type, v do
          bootstrap_syntax type do
            yield
          end
        end
      end # erb_syntax
    end

    def erb_syntax
      if erb?
        "<%%" + yield + "%>"
      else
        yield
      end
    end

    def cancan_syntax type = :show, v
      options.cancan? ? yield + " if can? :read, #{v}" : yield
      if options.cancan?
        str = case type
              when :show
                'read'
              when :destroy
                'destroy'
              when :new
                'create'
              when :edit
                'update'
              end
        yield + " if can? :#{str}, #{v}"
      else
        yield
      end
    end

    def bootstrap_syntax type = :show
      if options.bootstrap?
        str = 'btn btn-mini'
        str += ' btn-mini-danger' if type == :destroy
        yield + ", <%= key_value :class, \"'#{str}'\" %>"
      else
        yield
      end
    end

    def female_new_link v
      erb_syntax do
        cancan_syntax :new, v do
          bootstrap_syntax :new do
            %(= link_to t('.new', <%= key_value :default, "t('helpers.links.f_new')" %>, <%= key_value(:model, "'\#{human_name}'") %>), new_<%= singular_table_name %>_path)
          end
        end
      end # erb_syntax
    end

    def male_new_link v
      erb_syntax do
        cancan_syntax :new, v do
          bootstrap_syntax :new do
            %(= link_to t('.new', <%= key_value :default, "t('helpers.links.new')" %>, <%= key_value(:model, "'\#{human_name}'") %>), new_<%= singular_table_name %>_path)
          end
        end
      end # erb_syntax
    end
  end
end
