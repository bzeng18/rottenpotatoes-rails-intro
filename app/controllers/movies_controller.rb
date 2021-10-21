class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if !params[:sort].nil?
      @sort = params[:sort]
    end
    @all_ratings = Movie.all_ratings
    if params[:ratings].nil? && params[:ratings_show].nil?
      @ratings_show= []
      @ratings_to_show = []
      if @sort.nil?
        @movies = Movie.all
      else
        @movies = Movie.all.order(params[:sort])
      end
    else
      if params[:ratings_show].nil?
        @ratings_show= params[:ratings]
        @ratings_to_show = @ratings_show.keys
        if @sort.nil?
          @movies = Movie.with_ratings(@ratings_to_show)
        else
          @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort])
        end
      else
        @ratings_to_show = @ratings_show.keys
        if @sort.nil?
          @movies = Movie.with_ratings(@ratings_to_show)
        else
          @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort])
        end
      end
    end
    if @sort=="title"
          @title_class = 'hilite bg-warning'
          @release_class = ''
        elsif @sort=="release_date"
          @title_class = ''
          @release_class = 'hilite bg-warning'
        else
          @title_class = ''
          @release_class = ''
        end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
