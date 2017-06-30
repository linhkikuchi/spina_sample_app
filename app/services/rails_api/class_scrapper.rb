module RailsApi
  class ClassScrapper < Scrapper
    
    INDEX_PATH = File.join(Rails.root, 'lib/fixtures', 'pages.json')
    URL_COLUMN = 2

    def initialize
      @pages = JSON.parse(File.read(INDEX_PATH))
              .fetch('info', [])
              .map{ |row| row[URL_COLUMN] }
    end

    def root_pages
      pages.reject{ |page| page['#'] }
    end
  end
end