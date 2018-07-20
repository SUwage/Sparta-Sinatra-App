require "sinatra"
require "sinatra/contrib"
require "sinatra/reloader" if development?
require "sinatra/cookies"
require "pg"
require_relative "controllers/products_controller.rb"
require_relative "models/product.rb"

use Rack::MethodOverride
run ProductsController
