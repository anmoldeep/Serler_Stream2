module SearchQueriesHelper
  def link_to_add_search_line(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("search_queries/search_line", f: builder)
    end
    link_to(name, '#', class: "btn btn-success fa fa-plus-circle add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
