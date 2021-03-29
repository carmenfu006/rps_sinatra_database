require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/user'

get '/' do
  "Hello, World!"
  erb :index
end

post '/submit' do
	@user = User.new(params[:user])
	if @user.save
		redirect '/users'
	else
		"Sorry, there was an error!"
	end
end

get '/users' do
	@users = User.all
	erb :users
end