class Api::V1::PostersController < ApplicationController
    def index
        posters = Poster.all
        render json: {
            "data": posters,
            "meta": { count: posters.count }
        }
    end

    def show
        poster = Poster.find(params[:id])
        render json: poster
    end

    def create
        render json: Poster.create(poster_params)
    end

    def update
        render json: Poster.update(params[:id], poster_params)
    end
    
    def destroy
        render json: Poster.delete(params[:id])
    end

    private

    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end