class Api::V1::PostersController < ApplicationController
    def index
        render json: Poster.all
    end

    def show
        poster = Poster.find(params[:id])
        render json: poster
    end

    def create
        render json: poster Poster.create(poster_params)
    end
end