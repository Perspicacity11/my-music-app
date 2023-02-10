require 'album'
require 'album_repository'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe AlbumRepository do
  before(:each) do 
    reset_albums_table
  end

  it 'finds all albums' do
    repo = AlbumRepository.new

    albums = repo.all
    
    expect(albums.length).to eq(12)
    expect(albums.first.title).to eq('Doolittle')
    expect(albums.first.artist_id).to eq(1)
  end

  it 'finds one album' do
    repo = AlbumRepository.new

    album = repo.find(3)
    
    expect(album.id).to eq(3)
    expect(album.title).to eq('Waterloo')
    expect(album.artist_id).to eq(2)
  end

  it 'creates an album' do
    repo = AlbumRepository.new

    new_album = Album.new
    new_album.title = 'Pablo Honey'
    new_album.release_year = 1993
    new_album.artist_id = 1
    repo.create(new_album)

    albums = repo.all

    expect(albums.length).to eq(13)
    expect(albums.last.title).to eq('Pablo Honey')
    expect(albums.last.artist_id).to eq(1)
  end

  it 'deletes an album' do
    repo = AlbumRepository.new

    repo.delete(1)
    albums = repo.all

    expect(albums.length).to eq(11)
    expect(albums.first.id).to eq(2)
  end
end