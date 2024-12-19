class Api::V1::PostersController < ApplicationController
    def index
        posters = Poster.all
        options = {}
        options[:meta] = {count: posters.count}

        if  params[:sort] == 'asc'
            posters = posters.order(:created_at)
        elsif
            params[:sort] == 'desc'
            posters = posters.order(created_at: :desc)
        end

        if params[:name] == "#{params[:name]}"
            posters = Poster.where("name ILIKE ?", "%#{params[:name]}%").order(:name)
        end

        if params[:min_price] == "#{params[:min_price]}"
            posters = posters.where("price >= ?", params[:min_price]).order(:price)
        end

        if params[:max_price] == "#{params[:max_price]}"
            posters = posters.where("price <= ?", params[:max_price]).order(:price)
        end

        render json: PosterSerializer.new(posters, options)
    end

    def show
        render json: PosterSerializer.new(Poster.find(params[:id]))
    end

    def create
        poster = Poster.create(poster_params)
        render json: PosterSerializer.new(poster)
    end

    def update
        poster = Poster.find(params[:id])
        poster.update(poster_params)
        render json: PosterSerializer.new(poster)
    end
    
    def destroy
        poster = Poster.find(params[:id])
        poster.destroy
        render json: PosterSerializer.new(poster)
    end

    private

    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end