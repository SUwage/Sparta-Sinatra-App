class ProductsController < Sinatra::Base
  # sets root as the parent-directory of the current file
  set :root, File.join(File.dirname(__FILE__), '..')

  # sets the view directory correctly
  set :views, Proc.new { File.join(root, "views") }

  configure :development do
    register Sinatra::Reloader
  end

  helpers Sinatra::Cookies

  enable :sessions

  # INDEX
    get "/" do
      unless cookies[:visited]
        @show_message = true
        response.set_cookie(:visited, :value => 1, :expires => Time.now + (60 * 60 * 2))
      end

      @title = "FTG"
      @products = Product.all
      erb :"products/index"
    end

    # NEW
      get "/new" do
        product = Product.new

        @product = product
        product.id = ""
        product.name = ""
        product.description = ""
        product.price = ""

        erb :"products/new"
      end

      # SHOW
        get "/:id" do
          id = params[:id].to_i

          if(!session[:products])
            session[:products] = []
          end

          if(!session[:products].include?(id))
            session[:products].push(id)
          end

          puts "The user has visited #{session[:products]}"

          @product = Product.find(id)
              erb :"products/show"
            end

      # CREATE
        post "/" do
          product = Product.new

          product.name = params[:name]
          product.description = params[:description]
          product.price = params[:price]

          product.save


          redirect "/"
        end

        # EDIT
        get "/:id/edit" do
          id = params[:id].to_i
          @product = Product.find(id)

          erb :"products/edit"
        end

        # UPDATE
        put "/:id" do
          id = params[:id].to_i
          product = Product.find(id)
          product.name = params[:name]
          product.description = params[:description]
          product.price = params[:price]

          product.save

          redirect "/"
        end

        # DESTROY
        delete "/:id" do
          id = params[:id].to_i
          Product.destroy(id)
          redirect "/"
        end



  end
