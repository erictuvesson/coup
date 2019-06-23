# frozen_string_literal: true

require "json"
require_relative "coup/game"

# The collection of games and players
GAMES = Hash.new { |h, k| h[k] = Game.new }

# config
set :content_type, :json
set :public_folder, 'public'

get '/' do
  redirect '/index.html'
end

# Reset the game
post '/games/:game_id/players/:player_id/reset' do
  game    = GAMES[params[:game_id]]
  player  = game.players[params[:player_id]]

  game.reset!
  game.to_json(player)
end

# Draw a card
post '/games/:game_id/players/:player_id/draw' do
  game    = GAMES[params[:game_id]]
  player  = game.players[params[:player_id]]
  count   = params[:cards].to_i
  
  game.draw_for(player, count)
  game.to_json(player)
end

# Return a card
post '/games/:game_id/players/:player_id/return/:card_token' do
  game    = GAMES[params[:game_id]]
  player  = game.players[params[:player_id]]

  game.return_from(player, params[:card_token])
  game.to_json(player)
end

# Refresh game
get '/games/:game_id/players/:player_id' do
  game    = GAMES[params[:game_id]]
  player  = game.players[params[:player_id]]

  game.to_json(player)
end

# Adjust money
post '/games/:game_id/players/:player_id/adjust_money/:amount' do
  game    = GAMES[params[:game_id]]
  player  = game.players[params[:player_id]]
  amount  = params[:amount].to_i

  player.adjust_money(amount)
  game.to_json(player)
end

# Lose influence
post '/games/:game_id/players/:player_id/lose/:card_token' do
  game    = GAMES[params[:game_id]]
  player  = game.players[params[:player_id]]
  card    = params[:card_token]
  
  player.lose_influence(card)
  game.to_json(player)
end
