require 'rails_helper'

describe "Posters API", type: :request do
    it "sends a list of posters" do
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

        get "/api/v1/posters"

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)

        expect(posters.count).to eq(3)

        posters.each do |poster|
            expect(poster).to have_key(:id)
            expect(poster[:id]).to be_an(Integer)

            expect(poster).to have_key(:name)
            expect(poster[:name]).to be_a(String)

            expect(poster).to have_key(:description)
            expect(poster[:description]).to be_a(String)

            expect(poster).to have_key(:price)
            expect(poster[:price]).to be_a(Float)

            expect(poster).to have_key(:year)
            expect(poster[:year]).to be_an(Integer)

            expect(poster).to have_key(:vintage)
            expect(poster[:vintage]).to be_in([true, false])

            expect(poster).to have_key(:img_url)
            expect(poster[:img_url]).to be_a(String)
        end
    end

    it "can get one sony by its id" do
        id = Poster.create(name: "DOUBT",
        description: "Success is for other people, not you.",
        price: 140.00,
        year: 2020,
        vintage: false,
        img_url: "https://www.pluggedin.com/wp-content/uploads/2019/12/doubt-1200x720.jpg").id

        get "/api/v1/posters/#{id}"

        poster = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(poster).to have_key(:id)
        expect(poster[:id]).to be_an(Integer)

        expect(poster).to have_key(:name)
        expect(poster[:name]).to be_a(String)

        expect(poster).to have_key(:description)
        expect(poster[:description]).to be_a(String)

        expect(poster).to have_key(:price)
        expect(poster[:price]).to be_a(Float)

        expect(poster).to have_key(:year)
        expect(poster[:year]).to be_an(Integer)

        expect(poster).to have_key(:vintage)
        expect(poster[:vintage]).to be_in([true, false])

        expect(poster).to have_key(:img_url)
        expect(poster[:img_url]).to be_a(String)
    end
end