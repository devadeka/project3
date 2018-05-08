class SearchesController < ApplicationController


  def new
  
    #HTTPARTY
    @song_response = HTTParty.get("https://api.spotify.com/v1/me/player/currently-playing",
      :query => { 
          :access_token => session[:access_token]
          })
    if @song_response.code == 200
      @song_id = @song_response['item']['id']
      @song_name = @song_response['item']['name']
      @song_artist = @song_response['item']['artists'].count>1 ? "#{@song_response['item']['artists'][0]['name']} and others" :  "#{@song_response['item']['artists'][0]['name']}" 
      @album_image_url = @song_response['item']['album']['images'][2]['url']
      @album_name = @song_response['item']['album']['name']

      @match_url = "/match?song_id=#{@song_id}&song_name=#{@song_name}&artist=#{@song_artist}&img_url=#{@album_image_url}&album=#{@album_name}"
    
      
    end

  end


  def find_match

    
    user = User.find_by(spotify_id: session[:spotify_id])
    Search.where(:user_id == user.id).destroy_all
    search = Search.new
    search.song_id = params['song_id']
    search.song_name = params['song_name']
    search.artist = params['artist']
    search.img_url = params['img_url']
    search.album = params['album']
    search.user_id = user.id
    search.save

    #DB QUERY


    raise ""

    #REDIRECT MATCH SHOW


  end
end
