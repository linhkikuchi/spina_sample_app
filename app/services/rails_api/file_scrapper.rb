module RailsApi
  class FileScrapper < Scrapper
    
    INDEX_PATH = File.join(Rails.root, 'lib/fixtures', 'links')

    def initialize
      @pages = File.readlines(INDEX_PATH).map(&:strip)
    end

    def root_pages
      pages
    end
  end
end