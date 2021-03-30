class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

  # set public folder for static files
  set :public_folder, File.expand_path('../../public', __FILE__)

  # set folder for templates to ../views, but make the path absolute
  set :views, File.expand_path('../../views', __FILE__)

  enable :sessions

  get '/' do
    erb :index
  end

  get '/new-player' do
    erb :new
  end

  get '/all-players' do
    @players = Player.all
    erb :players
  end

  get '/game' do
    @player = Player.find_by(id: session[:player_id])
    erb :stage
  end

  post '/game' do
    @player = Player.new(params[:player])
    if @player.save
      session[:player_id] = @player.id
      erb :stage
    else
      "Sorry, there was an error!"
    end
  end

  post '/game/throw' do
    session['results'] = []
    @player = Player.find_by(id: session[:player_id])
    result = @player.results.build(params[:result])
    if result.save
      set_number_of_rounds(result.round)
      erb :game
    else
      "Sorry, there was an error!"
    end
  end

  get '/game/throw/:gamer_choices' do
    @player = Player.find_by(id: session[:player_id])
    calculate_rounds
    choices = ['rock', 'paper', 'scissors']
    computer_choices = rand(choices.length)
    session['gamer_choices'] = params[:gamer_choices]
    session['computer_choices'] = choices[computer_choices]

    if session['player_rounds'] >= 0
      session['results_ready'] = false
      session['results_ready'] = true if session['player_rounds'] == 0
      if params[:gamer_choices] == 'rock' && choices[computer_choices] == 'paper'
        store_results('lose')
        erb :lose
      elsif params[:gamer_choices] == 'paper' && choices[computer_choices] == 'scissors'
        store_results('lose')
        erb :lose
      elsif params[:gamer_choices] == 'scissors' && choices[computer_choices] == 'rock'
        store_results('lose')
        erb :lose
      elsif params[:gamer_choices] == 'scissors' && choices[computer_choices] == 'paper'
        store_results('win')
        erb :win
      elsif params[:gamer_choices] == 'rock' && choices[computer_choices] == 'scissors'
        store_results('win')
        erb :win
      elsif params[:gamer_choices] == 'paper' && choices[computer_choices] == 'rock'
        store_results('win')
        erb :win
      else
        store_results('tied')
        erb :tied
      end
    end
  end

  get '/game/:player_name/result' do
    player = Player.find_by(id: session[:player_id])
    player.results.last.update(win_record: session['results'].count('win'),
                              lose_record: session['results'].count('lose'),
                              tied_record: session['results'].count('tied')
                              )
    erb :result
  end

  private
    def set_number_of_rounds(rounds)
      rounds ? session['player_rounds'] = rounds : session['player_rounds'] = session['player_rounds']
    end

    def calculate_rounds
      rounds = session['player_rounds'].to_i
      rounds -= 1
      session['player_rounds'] = rounds
    end

    def store_results(result)
      case result
        when 'win'
          session['results'].push('win')
        when 'lose'
          session['results'].push('lose')
        when 'tied'
          session['results'].push('tied')
      end 
    end
end