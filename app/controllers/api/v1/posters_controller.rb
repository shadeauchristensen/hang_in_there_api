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
        elsif 
            params[:name] == "#{params[:name]}"
            posters = Poster.where("name ILIKE ?", "%#{params[:name]}%").order(:name)
        elsif 
            params[:min_price] == "#{params[:min_price]}"
            posters = posters.where("price >= #{params[:min_price]}").order(:price)
        elsif 
            params[:max_price] == "#{params[:max_price]}"
            posters = posters.where("price <= #{params[:max_price]}").order(:price)
        end

        render json: PosterSerializer.new(Poster.all, options)
    end

    def show
        render json: PosterSerializer.new(Poster.find(params[:id]))
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