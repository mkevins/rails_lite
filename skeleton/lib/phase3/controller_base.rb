require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      template = ERB.new(
        File.read(
          view_file_name(template_name)
        )
      )
      render_content(template.result(binding), "text/html")
    end

    private

    def view_file_name(template_name)
      view_file_name = "views/" +
      #self.class.name.underscore.pluralize + "/" +
      self.class.name.underscore + "/" +
      template_name.to_s + ".html.erb"
    end
  end
end
