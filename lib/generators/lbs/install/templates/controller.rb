<%% module_namespacing do -%>
class <%%= controller_class_name %>Controller < ApplicationController
  <%= 'load_and_authorize_resource' if options.cancan? -%>

  # GET <%%= route_url %>
  # GET <%%= route_url %>.json
  def index
  <%- unless options.cancan? -%>
    @<%%= plural_table_name %> = <%%= orm_class.all(class_name) %>

  <%- end -%>
    respond_to do |format|
      format.html # index.html.erb
      format.json { render <%%= key_value :json, "@#{plural_table_name}" %> }
    end
  end

  # GET <%%= route_url %>/1
  # GET <%%= route_url %>/1.json
  def show
  <%- unless options.cancan? -%>
    @<%%= singular_table_name %> = <%%= orm_class.find(class_name, "params[:id]") %>

  <%- end -%>
    respond_to do |format|
      format.html # show.html.erb
      format.json { render <%%= key_value :json, "@#{singular_table_name}" %> }
    end
  end

  # GET <%%= route_url %>/new
  # GET <%%= route_url %>/new.json
  def new
  <%- unless options.cancan? -%>
    @<%%= singular_table_name %> = <%%= orm_class.build(class_name) %>

  <%- end -%>
    respond_to do |format|
      format.html # new.html.erb
      format.json { render <%%= key_value :json, "@#{singular_table_name}" %> }
    end
  end

  # GET <%%= route_url %>/1/edit
  def edit
  <%- unless options.cancan? -%>
    @<%%= singular_table_name %> = <%%= orm_class.find(class_name, "params[:id]") %>
  <%- end -%>
  end

  # POST <%%= route_url %>
  # POST <%%= route_url %>.json
  def create
  <%- unless options.cancan? -%>
    @<%%= singular_table_name %> = <%%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

  <%- end -%>
    respond_to do |format|
      if @<%%= orm_instance.save %>
        <%- if defined? Rieles -%>
        <%% created = singular_table_name.match(/[ad]$/) ? 'creada' : 'creado' %>
        <%- else -%>
        <%% created = 'created' %>
        <%- end -%>
        format.html { redirect_to @<%%= singular_table_name %>, <%%= key_value :notice, "t('flash.messages', :resource => '#{human_name}', :action => '#{created}')" %> }
        format.json { render <%%= key_value :json, "@#{singular_table_name}" %>, <%%= key_value :status, ':created' %>, <%%= key_value :location, "@#{singular_table_name}" %> }
      else
        format.html { render <%%= key_value :action, '"new"' %> }
        format.json { render <%%= key_value :json, "@#{orm_instance.errors}" %>, <%%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # PATCH/PUT <%%= route_url %>/1
  # PATCH/PUT <%%= route_url %>/1.json
  def update
  <%- unless options.cancan? -%>
    @<%%= singular_table_name %> = <%%= orm_class.find(class_name, "params[:id]") %>

  <%- end -%>
    respond_to do |format|
      if @<%%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        <%- if defined? Rieles -%>
        <%% updated = singular_table_name.match(/[ad]$/) ? 'modificada' : 'modificado' %>
        <%- else -%>
        <%% updated = 'updated' %>
        <%- end -%>
        format.html { redirect_to @<%%= singular_table_name %>, <%%= key_value :notice, "t('flash.messages', :resource => '#{human_name}', :action => '#{updated}')" %> }
        format.json { head :no_content }
      else
        format.html { render <%%= key_value :action, '"edit"' %> }
        format.json { render <%%= key_value :json, "@#{orm_instance.errors}" %>, <%%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # DELETE <%%= route_url %>/1
  # DELETE <%%= route_url %>/1.json
  def destroy
  <%- unless options.cancan? -%>
    @<%%= singular_table_name %> = <%%= orm_class.find(class_name, "params[:id]") %>
  <%- end -%>
    @<%%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%%= index_helper %>_url }
      format.json { head :no_content }
    end
  end
end
<%% end -%>
