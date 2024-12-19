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
            expect(posters[:data].length).to eq(3)
            expect(posters[:meta][:count]).to eq(3)
            
            posters[:data].each do |poster|
                expect(poster).to have_key(:id)
                expect(poster[:id]).to be_an(String)

                expect(poster[:attributes]).to have_key(:name)
                expect(poster[:attributes][:name]).to be_a(String)

                expect(poster[:attributes]).to have_key(:description)
                expect(poster[:attributes][:description]).to be_a(String)

                expect(poster[:attributes]).to have_key(:price)
                expect(poster[:attributes][:price]).to be_a(Float)

                expect(poster[:attributes]).to have_key(:year)
                expect(poster[:attributes][:year]).to be_an(Integer)

                expect(poster[:attributes]).to have_key(:vintage)
                expect(poster[:attributes][:vintage]).to be_in([true, false])

                expect(poster[:attributes]).to have_key(:img_url)
                expect(poster[:attributes][:img_url]).to be_a(String)
            end
        end

        it "sorts posters ascending or descending based on the query param" do
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

            get "/api/v1/posters?sort=asc"

            expect(response).to be_successful

            posters = JSON.parse(response.body, symbolize_names: true)
            
            expect(posters[:data].first[:attributes][:name]).to eq("DOUBT")
            expect(posters[:data].last[:attributes][:name]).to eq("REGRET")

            get "/api/v1/posters?sort=desc"

            expect(response).to be_successful

            posters = JSON.parse(response.body, symbolize_names: true)

            expect(posters[:data].first[:attributes][:name]).to eq("REGRET")
            expect(posters[:data].last[:attributes][:name]).to eq("DOUBT")
        end

        it "filters out posters who name matches the query param value" do
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

            get "/api/v1/posters?name=re"

            posters = JSON.parse(response.body, symbolize_names: true)

            expect(response).to be_successful
            expect(posters[:data].length).to eq(2)
            expect(posters[:data].first[:attributes][:name]).to eq("FAILURE")
            expect(posters[:data].last[:attributes][:name]).to eq("REGRET")
        end

        it "filters out posters that are above/below min/max price" do
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

            get "/api/v1/posters?min_price=80"

            posters = JSON.parse(response.body, symbolize_names: true)

            expect(response).to be_successful
            expect(posters[:data].length).to eq(2)
            expect(posters[:data].first[:attributes][:price]).to eq(89.00)
            expect(posters[:data].last[:attributes][:price]).to eq(140.00)

            get "/api/v1/posters?max_price=100"

            posters = JSON.parse(response.body, symbolize_names: true)

            expect(response).to be_successful
            expect(posters[:data].length).to eq(2)
            expect(posters[:data].first[:attributes][:price]).to eq(68.00)
            expect(posters[:data].last[:attributes][:price]).to eq(89.00)
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
            
            expect(poster[:data]).to have_key(:id)
            expect(poster[:data][:id]).to be_an(String)

            expect(poster[:data][:attributes]).to have_key(:name)
            expect(poster[:data][:attributes][:name]).to be_a(String)

            expect(poster[:data][:attributes]).to have_key(:description)
            expect(poster[:data][:attributes][:description]).to be_a(String)

            expect(poster[:data][:attributes]).to have_key(:price)
            expect(poster[:data][:attributes][:price]).to be_a(Float)

            expect(poster[:data][:attributes]).to have_key(:year)
            expect(poster[:data][:attributes][:year]).to be_an(Integer)

            expect(poster[:data][:attributes]).to have_key(:vintage)
            expect(poster[:data][:attributes][:vintage]).to be_in([true, false])

            expect(poster[:data][:attributes]).to have_key(:img_url)
            expect(poster[:data][:attributes][:img_url]).to be_a(String)
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

            expect(posters[:data].count).to eq(1)

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
        
            posters[:data].each do |poster|
                expect(poster).to have_key(:id)
                expect(poster[:id]).to be_an(String)

                expect(poster[:attributes]).to have_key(:name)
                expect(poster[:attributes][:name]).to be_a(String)

                expect(poster[:attributes]).to have_key(:description)
                expect(poster[:attributes][:description]).to be_a(String)

                expect(poster[:attributes]).to have_key(:price)
                expect(poster[:attributes][:price]).to be_a(Float)

                expect(poster[:attributes]).to have_key(:year)
                expect(poster[:attributes][:year]).to be_an(Integer)

                expect(poster[:attributes]).to have_key(:vintage)
                expect(poster[:attributes][:vintage]).to be_in([true, false])

                expect(poster[:attributes]).to have_key(:img_url)
                expect(poster[:attributes][:img_url]).to be_a(String)
            end
        end
        
        it "update the corresponding Poster (if found) with the details are provided by the user" do
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