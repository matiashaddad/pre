class PartiesController < ApplicationController
  before_action :set_party, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @parties = Party.all
    @carousel = Party.top_three
  end

  def show
    @user = @party.user
    @review = Review.new
    @request = Request.new
    @this_request = @party.requests.where(user: current_user).first
    @chatroom = Chatroom.new
    if @party.requests.where(user: current_user).exists?
      @request = @party.requests.find_by(user: current_user)
    else
      @request = Request.new
    end
  end

  def new
    @party = Party.new
  end

  def create
    require 'date'
    @party = Party.new(
      status: party_params[:status].to_i,
      name: party_params[:name],
      # date: Date.parse("#{party_params['date(3i)']}/#{party_params['date(2i)']}/#{party_params['date(1i)']}"),
      date: party_params[:date],
      description: party_params[:description],
      address: party_params[:address],
      photo: party_params[:photo]
    )
    # @party = Party.new(party_params)
    @party.user = current_user
    @party.save!

    redirect_to party_path(@party)
  end

  def edit
  end

  def update
    @party.update(party_params)

    redirect_to party_path(@party)
  end

  def destroy
    @party.destroy

    redirect_to parties_path, status: :see_other
  end


  private

  def set_party
    @party = Party.find(params[:id])
  end

  def party_params
    params.require(:party).permit(:name, :date, :status, :description, :address)
  end
end
