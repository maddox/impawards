require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'pathname'
require 'cgi'

module IMPAwards
  class IMPAwards

    def self.search_posters(query)
      movie_urls = get_movie_results(query)

      if movie_urls.size > 0
        posters_for_url(movie_urls.first['href'])
      else
        []
      end
    end

    def self.get_posters(query)
      movie_urls = get_movie_results(query)
      movie_urls.delete_if{|movie_url| movie_url.inner_text !~ /#{query}/i}
      if movie_urls.size > 0
        posters_for_url(movie_urls.first['href'])
      else
        []
      end
    end

    def self.posters_for_url(url)
      posters = []
      url_path = Pathname.new(url)

      doc = Hpricot markup_for_movie_url(url)

      (doc/"#altdesigns img").each do |element|
        posters << get_poster_hash(url_path.dirname.to_s + '/' + element['src'])
      end

      # if no posters were found at the bottom use the one on the page
      posters << get_poster_hash(url_path.dirname.to_s + '/' + doc.at("#left_half img")['src']) if posters.size == 0
      posters
    end

    private
    
    def self.get_movie_results(query)
      results_url = "http://www.google.com/cse?cx=partner-pub-6811780361519631%3A48v46vdqqnk&cof=FORID%3A9&ie=ISO-8859-1&q=#{CGI.escape(query)}&sa=Search&ad=w9&num=10&rurl=http%3A%2F%2Fwww.impawards.com%2Fgooglesearch.html%3Fcx%3Dpartner-pub-6811780361519631%253A48v46vdqqnk%26cof%3DFORID%253A9%26ie%3DISO-8859-1%26q%3Doverboard%2B1987%26sa%3DSearch"
      doc = Hpricot open(results_url)
      movie_urls = (doc/"div.g h2.r a")
      movie_urls.delete_if{|movie_url| movie_url.inner_text !~ /Poster - Internet/i}
    end
    
    def self.markup_for_movie_url(url)
      markup = open(url).read
      if markup.match(/URL=\.\.(\/.*\/.*.html)/)
        markup_for_movie_url("http://impawards.com#{$1}")
      else
        markup
      end
    end

    def self.get_poster_hash(poster_path)
      tiny_path = poster_path
      thumb_path = poster_path.gsub('thumbs', 'posters').gsub('imp_', '')
      xlg_path = poster_path.gsub('thumbs', 'posters').gsub('imp_', '').gsub('.jpg', '_xlg.jpg')

      poster_hash = { :tiny => tiny_path, 
                      :thumb => thumb_path, 
                      :xlg => xlg_path}
    end
  end
end

