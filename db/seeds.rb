# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Poster.create(name: "DOUBT",
description: "Success is for other people, not you.",
price: 140.00,
year: 2020,
vintage: false,
img_url: "https://www.pluggedin.com/wp-content/uploads/2019/12/doubt-1200x720.jpg")

Poster.create(name: "FAILURE",
description: "Why bother trying? It's probably not worth it.",
price: 68.00,
year: 2019,
vintage: true,
img_url: "https://www.tutordoctor.co.uk/wp-content/uploads/2023/11/iStock-827879520.jpg")

Poster.create(name: "REGRET",
description: "Hard work rarely pays off.",
price: 89.00,
year: 2018,
vintage: true,
img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

