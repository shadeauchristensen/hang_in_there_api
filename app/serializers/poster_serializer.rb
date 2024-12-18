class PosterSerializer
    def self.format_posters(posters)
        posters.map do |poster|
            format_single_poster(poster)
        end
    end

    def self.format_single_poster(poster)
        {
            name: poster.name,
            description: poster.description,
            pirce: poster.price,
            year: poster.year,
            vintage: poster.vintage,
            img_url: poster.img_url
        }
    end
end