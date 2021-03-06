class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort]
    @ratings_show = params[:ratings_show]
    @all_ratings = Movie.all_ratings
    if params[:home].nil?
      @ratings_show = session[:ratings_show]
      @sort = session[:sort]
    end
    if params[:ratings].nil? && @ratings_show.nil?
      @ratings_show= {"G"=>1, "PG"=>1, "PG-13"=>1, "R"=>1}
      @ratings_to_show = @all_ratings
      if @sort.nil?
        @movies = Movie.all
      else
        @movies = Movie.all.order(@sort)
      end
    else
      if @ratings_show.nil?
        @ratings_show= params[:ratings]
        @ratings_to_show = @ratings_show.keys
        if @sort.nil?
          @movies = Movie.with_ratings(@ratings_to_show)
        else
          @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
        end
      else
        @ratings_to_show = @ratings_show.keys
        if @sort.nil?
          @movies = Movie.with_ratings(@ratings_to_show)
        else
          @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
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
    session[:sort] = @sort
    session[:ratings_show] = @ratings_show
    if params[:ratings].nil? && params[:sort].nil?
      redirect_to movies_path(:ratings=>@ratings_show,:sort=>@sort)
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
