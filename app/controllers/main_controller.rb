class MainController < ApplicationController
  def home
  end
  def about
  end
  def contact
  end
  def search
    @search = Search.analyze(params[:summoner])
  end
end
