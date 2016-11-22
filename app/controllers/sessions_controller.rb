class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:email, :password)
    @user = User.confirm(user_params)
    if @user
      session[:user_id] = @user.id
      @current_user = @user
      flash[:success] = "Successfully logged in."
      redirect_to aws_login_path
    else
      flash[:error] = "Incorrect email or password."
      redirect_to login_path
    end
  end

  def update
    auth_hash = request.env['omniauth.auth']

  # render :text => auth_hash["uid"]

    client = MWS.orders(
      primary_marketplace_id: "",
      merchant_id: auth_hash["uid"][14..-1],
      aws_access_key_id: "",
      aws_secret_access_key: "",
      auth_token: auth_hash["credentials"]["token"]
    )

    #     response = client.list_orders created_after: '2016-10-25'
    #     clean_orders_hash = response.parse
    #     @clean_orders = clean_orders_hash["Orders"]["Order"]

    #     render :json => @clean_orders
        render :json => auth_hash
  end

end
