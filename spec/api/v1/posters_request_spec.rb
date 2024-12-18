require 'rails_helper'

describe Api::V1::PostersController, type: :request do
    describe "Posters API" do
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

        it "creates a new poster" do
            poster_params = {
                name: "FAILURE",
                description: "Why bother trying? It's probably not worth it.",
                price: 68.00,
                year: 2019,
                vintage: true,
                img_url: "https://www.tutordoctor.co.uk/wp-content/uploads/2023/11/iStock-827879520.jpg"
            }

            headers = { "CONTENT_TYPE" => "application/json" }
        
            post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)

            expect(response).to be_successful
        
            get "/api/v1/posters"

            posters = JSON.parse(response.body, symbolize_names: true)

            expect(posters.count).to eq(1)

            poster_params2 = {
                name: "DOUBT",
                description: "Success is for other people, not you.",
                price: 140.00,
                year: 2020,
                vintage: false,
                img_url: "https://www.pluggedin.com/wp-content/uploads/2019/12/doubt-1200x720.jpg"
            }

            headers = { "CONTENT_TYPE" => "application/json" }
        

            post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)

            expect(response).to be_successful
        
            get "/api/v1/posters"
        
            posters = JSON.parse(response.body, symbolize_names: true)

            expect(posters.count).to eq(2)
        
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
        
        it "update the corresponding Poster (if found) with whichever details are provided by the user" do
            id = Poster.create(name: "DOUBT",
            description: "Success is for other people, not you.",
            price: 140.00,
            year: 2020,
            vintage: false,
            img_url: "https://www.pluggedin.com/wp-content/uploads/2019/12/doubt-1200x720.jpg").id

            previous_name = Poster.last.name
            poster_params = {name: "NO FAITH"}
            headers = {"CONTENT_TYPE" => "application/json"}

            patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: poster_params})
            poster = Poster.find_by(id: id)

            expect(response).to be_successful
            expect(poster.name).to_not eq(previous_name)
            expect(poster.name).to eq("NO FAITH")
        end

        it "can destroy a poster" do
            id = Poster.create(name: "DOUBT",
            description: "Success is for other people, not you.",
            price: 140.00,
            year: 2020,
            vintage: false,
            img_url: "https://www.pluggedin.com/wp-content/uploads/2019/12/doubt-1200x720.jpg").id
        
            expect(Poster.count).to eq(1)
        
            delete "/api/v1/posters/#{id}"
        
            expect(response).to be_successful
            expect(Poster.count).to eq(0)
            expect{Poster.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
        end  
    end
end