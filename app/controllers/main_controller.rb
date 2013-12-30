class MainController < ApplicationController
  def home
  end
  def about
  end
  def contact
  end
  def search
    @results = Search.new(params[:summoner], params[:region])
    if @results.status != nil
      flash[:danger] = "The rate limit for my API key has been reached! Darn. Try again in a bit."
      redirect_to root_path
      return
    end
    if @results.summoner == nil
      flash[:danger] = "We couldn't find a summoner by that name! Check yo regions, dawg."
      redirect_to root_path
    end
  end
end
