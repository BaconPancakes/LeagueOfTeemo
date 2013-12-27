class MainController < ApplicationController
  def home
  end
  def about
  end
  def contact
  end
  def search
    @results = Search.new params[:summoner]

  end
end
