require 'bundler'
require 'sinatra'
require 'omniauth-mendeley_oauth2'
require 'dotenv/load'

use Rack::Session::Cookie

# to register a Mendeley app sign up at http://mendeley.com/,
# then login with given credentials at http://dev.mendeley.com
use OmniAuth::Builder do
  provider :mendeley, ENV['MENDELEY_CONSUMER_KEY'], ENV['MENDELEY_CONSUMER_SECRET'], client_options: { redirect_uri: "http://127.0.0.1:9292/auth/mendeley/callback" }
end

class App < Sinatra::Base
  get '/' do
    "<a href='/auth/mendeley'>Sign in via Mendeley</a>"
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    info = request.env['omniauth.auth'].to_hash
    MultiJson.dump(info).to_s
  end
end

run App.new

# shotgun --server=thin --port=9292 config.ru
