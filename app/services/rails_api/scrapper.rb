module RailsApi
  class Scrapper
    attr_reader :pages

    def run(offset, limit)
      root_pages[offset..limit].each_with_index do |page, index|
        puts "*"*20,index,"*"*20
        fetch_content(page)
      end
    end

    def fetch_content(page)
      parser = PageParser.new(page)
      PageCreator.new(page, parser.content)
    end

    def root_pages
      raise NotImplementedError
    end

  end
end