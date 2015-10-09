require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
require File.join(File.dirname(__FILE__), "environment")

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  set :show_exceptions, :after_handler
end

configure :production, :development do
  enable :logging
end

helpers do
  # add your helpers here
end

# root page
get "/" do
  @profiles = Profile.all
  erb :root
end

post "/profiles" do
  content_type :json

  profile = Profile.new
  profile.name = params[:name]

  return {
    saved: true,
    data: profile.attributes
  }.to_json if profile.save

  { saved: false, errors: profile.errors.to_a }.to_json
end
