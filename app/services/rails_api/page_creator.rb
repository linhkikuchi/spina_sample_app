module RailsApi
  class PageCreator

    VIEW_TEMPLATE = "show"
    THEME = 'default'

    attr_reader :content

    def initialize(url, content)
      @url, @content = url, content
      paths = url.split('/').map(&method(:sanitize))
      page_name = paths.pop
      
      last_page = Spina::Page.find_or_create_by(name: paths.shift, ancestry: nil, view_template: VIEW_TEMPLATE)
      paths.each do |path|
        last_page = last_page.children.find_or_create_by(name: path, view_template: VIEW_TEMPLATE)
        last_page.save if last_page.new_record?
      end
      
      page = last_page.children.find_or_create_by(name: page_name, view_template: VIEW_TEMPLATE)
      
      page.parts.clear
      page.parts << page.page_part(text_part)
      page.page_parts.last.partable.update content: content
      page.save
    end

    def text_part
      theme.page_parts.first
    end

    def theme
      Spina::Theme.find_by_name(THEME)
    end

    def sanitize(path)
      path.downcase.sub(/\.html$/, '')
    end
  end
end
