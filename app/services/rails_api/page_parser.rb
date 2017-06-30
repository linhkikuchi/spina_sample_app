module RailsApi
  class PageParser
    BASE_PATH = "http://api.rubyonrails.org/"
    
    attr_accessor :page
    attr_reader :path
    

    def initialize(path)
      @path = path
      @page = Nokogiri::HTML(open(url))
      parse_links
    end

    def url
      File.join(BASE_PATH, path)
    end

    def parse_links
      page.search("a").each do |link|
        href = link.attributes['href']
        href.value = href.value.downcase.sub(/\.html$/, '')
      end
    end

    def content
      page.search("body").to_s
    end
  end
end