class Create<%= class_name.pluralize.delete('::') %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name || plural_name.split('/').last %> do |t|
    <%- for attribute in model_attributes -%>
      t.<%= attribute.type %> :<%= attribute.name %>
    <%- end -%>
    t.timestamps
    end
  end
end
