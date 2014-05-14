require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'typhoeus'
require 'json'

configure do
  root = File.expand_path(File.dirname(__FILE__))
  set :views, File.join(root, 'views')
end


get '/' do
  erb :form
end

get '/movies/new' do
  erb :new
end

get '/movies/create' do
  response = Typhoeus.post("localhost:3000/movies.json", params: {movie: params[:movie]})
  redirect '/movies'
end

get '/movies' do
  response = Typhoeus.get("localhost:3000/movies.json?query=#{params[:query]}")
  @movies = JSON.parse(response.body)
  erb :index
end

get "/movie/:id" do
  # show a particular movie

  response = Typhoeus.get(
    "localhost:3000/movies/#{params[:id]}.json"
    )

  @movie = JSON.parse(response.body)
  #raise @movie_info.inspect

  erb :show
end
