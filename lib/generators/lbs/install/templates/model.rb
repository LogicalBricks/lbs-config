class <%= class_name %> < ActiveRecord::Base
  attr_accessible <%= model_attributes.map { |a| ":#{a.name}" if accessible_attribute?(a.name) }.compact.join(", ") %>
  
  # Associations
<% model_belongs_to_attributes.each do |bt| %>
  <%= "belongs_to :" + bt %>
<% end %>

  # Validations
<% if model_uniq_attributes.any? %>
  <%= "validates #{model_uniq_attributes.map { |a| a.name.to_sym}.join(', ') }, :presence => true, uniqueness => true " %>
<% end %>

  # Scopes

  # Methods


  #####################
  private
  #####################

end
