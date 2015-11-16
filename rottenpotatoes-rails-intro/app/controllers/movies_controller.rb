class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sorting = params[:sorting] || session[:sorting]
    if params[:ratings]
      @filter_string = []
      params[:ratings].each_key do |key|
        @filter_string << key
      end
      session[:ratings] = @filter_string
    elsif session[:ratings]
      @filter_string = session[:ratings]
    else
      @filter_string = ['G','PG','PG-13','R']
    end
    @all_ratings = Movie.all_ratings

    if params[:sorting] != session[:sorting]
      session[:sorting] = sorting
      redirect_to :sorting => sorting, :ratings => @selected_ratings and return
    end

    if params[:sorting] == 'Title'
      @title_class = 'hilite'
      @movies = Movie.rating_filtered(@filter_string).order("title")
    elsif params[:sorting] == 'Release'
      @release_class = 'hilite'
      @movies = Movie.rating_filtered(@filter_string).order("release_date")
    else
      @title_class = ''
      @release_class = ''
      @movies = Movie.rating_filtered(@filter_string)
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

end
