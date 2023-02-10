# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

ENV['ENV'] = 'test'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

post '/albums' do
  title = params[:title]
  release_year = params[:release_year]
  artist_id = params[:artist_id] #ideally this would be artist name and it would grab the foreign key if it exists, and serialise a new one if not

  def invalid_request_parameters?
    return true if params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil
    return true if params[:title] == "" || params[:release_year] == "" || params[:artist_id] == ""
  end

  if invalid_request_parameters?
    status 400
    return 'Invalid input'
  end

  new_album = Album.new
  new_album.title = title
  new_album.release_year = release_year
  new_album.artist_id = artist_id

  AlbumRepository.new.create(new_album)

  return erb(:new_album_created)
end

get '/albums' do
  repo1 = AlbumRepository.new
  @allalbums = repo1.all
  # repo2 = ArtistRepository.new
  # @allartists = repo2.all #LEFTOVER FROM AN ATTEMPT TO INCLUDE ARTIST NAME IN HTML READOUT
  return erb(:allalbums)
end

get '/albums/new' do
  return erb(:newalbum)
end

get '/albums/:id' do
  albumrepo = AlbumRepository.new
  artistrepo = ArtistRepository.new
  @selected_album = albumrepo.find(params[:id])
  @selected_artist = artistrepo.find(@selected_album.artist_id)

  return erb(:singlealbum)
end

post '/artists' do
  name = params[:name]
  genre = params[:genre]

  def invalid_request_parameters?
    return true if params[:name] == nil || params[:genre] == nil
    return true if params[:name] == "" || params[:genre] == ""
  end

  if invalid_request_parameters?
    status 400
    return 'Invalid input'
  end

  new_artist = Artist.new
  new_artist.name = name
  new_artist.genre = genre

  ArtistRepository.new.create(new_artist)

  return erb(:new_artist_created)
end

get '/artists' do
  artistrepo = ArtistRepository.new
  @allartists = artistrepo.all

  return erb(:allartists)
end

get '/artists/new' do
  return erb(:newartist)
end

get '/artists/:id' do
  artistrepo = ArtistRepository.new
  @selected_artist = artistrepo.find(params[:id])

  return erb(:singleartist)
end

end
