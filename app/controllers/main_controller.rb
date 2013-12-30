class MainController < ApplicationController
  def home
  end
  def about
  end
  def contact
  end
  def search
    @results = Search.new(params[:summoner], params[:region])
    if @results.summoner == nil
      flash[:danger] = "We couldn't find a summoner by that name! Check yo regions, dawg."
      redirect_to root_path
    end
  end
end
