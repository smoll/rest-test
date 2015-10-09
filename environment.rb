require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-migrations'
require 'ostruct'

require 'sinatra' unless defined?(Sinatra)

unless Sinatra::Base.production?
  # See https://github.com/deivid-rodriguez/byebug/blob/master/GUIDE.md#debugging-remote-programs
  # or try http://stackoverflow.com/a/13138381
  require 'byebug'
  Byebug.wait_connection = false
  port = ENV['REMOTE_BYEBUG_PORT'] || '5050'
  puts "Remote debugger on port #{port}. Run 'rake byebug' in a new shell to connect to it!"
  Byebug.start_server('localhost', port.to_i)
end

Dotenv.load

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'Your Application Name',
                 :author => 'Your Name',
                 :url_base => 'http://localhost:4567/'
               )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db"))
  DataMapper.finalize
  DataMapper.auto_upgrade!
end
