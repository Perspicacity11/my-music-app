require "spec_helper"
require "rack/test"
require_relative '../../app'
 
def reset_artist_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do 
    reset_artists_table
    reset_albums_table
  end

  context "POST /albums" do
    it 'returns a success page when Dancing Queen is added using the GET albums/new route' do
      response = post('/albums', 
      title: 'Dancing Queen', 
      release_year: '1976',
      artist_id: '2'
      )
    expect(response.status).to eq(200)
    expect(response.body).to include('<p>Your album has been added.</p>')
    end

    it 'fails due to invalid input' do
      response = post('/albums',
      title: 'Dancing Queen',
      release_year: nil,
      artist_id: '2'
      )

      expect(response.status).to eq(400)
      expect(response.body).to include("Invalid input")
    end
  end

  context "GET /albums" do
    it 'returns a document containing info on all albums formatted in HTML' do
      response = get('/albums')
    
      expect(response.body).to include('Baltimore')
      expect(response.body).to include('Folklore')
      expect(response.status).to eq(200)
    end
  end

  context "GET /albums/new" do
    it 'returns a form page to input a new album' do
      response = get('albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Enter an album</h1>')
      expect(response.body).to include('<form action="/albums" method="POST">')
    end
  end

  context "GET /albums/:id" do
    it 'returns a document containing information on the album Surfer Rosa' do
      response = get('/albums/2')
  
      expect(response.status).to eq(200)
      expect(response.body).to include('Surfer Rosa')
      expect(response.body).to include('Pixies')
    end
  end

  context "POST /artists" do
    it 'returns a success page when The Last Shadow Puppets are added to artists using the GET artists/new route' do
      response = post('/artists', 
        name: 'The Last Shadow Puppets', 
        genre: 'Indie'
        )
      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Your artist has been added.</p>')
      end

      it 'fails due to invalid input' do
        response = post('/artists',
        name: 'The Last Shadow Puppets',
        genre: ''
        )
  
        expect(response.status).to eq(400)
        expect(response.body).to include("Invalid input")
      end
  end

  context "GET /artists" do
    it 'tests ability to return names of all artists' do
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('Pixies')
      expect(response.body).to include('ABBA')
      expect(response.body).to include('Taylor Swift')
      expect(response.body).to include('Nina Simone')
    end
  end

  context "GET /artists/:id" do
    it 'returns information on the artist at ID1, Pixies' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('Pixies')
      expect(response.body).to include('Rock')
    end
  end

  context "GET /artists/new" do
    it 'returns a form page to input a new album' do
      response = get('artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Enter an artist</h1>')
      expect(response.body).to include('<form action="/artists" method="POST">')
    end
  end
end