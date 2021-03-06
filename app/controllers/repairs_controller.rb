# frozen_string_literal: true

# rails controller for repairs
class RepairsController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.admin?
      @repairs = Repair.all
    elsif current_user.owner.nil?
      redirect_to new_owner_path
    else
      @repairs = Repair.where(owner_id: current_user.owner.id)
    end
  end

  def new
    @repair = Repair.new
  end

  def create
    @repair = Repair.new(repair_params)
    if current_user.owner.nil?
      redirect_to new_owner_path
    else
      @repair.owner_id = current_user.owner.id
      @repair.save
      redirect_to repairs_path
    end
  end

  def edit
    @repair = Repair.find(params[:id])
  end

  def update
    @repair = Repair.find(params[:id])
    @repair.update_attributes(repair_params)
    @repair.save
    redirect_to repairs_path
  end

  def destroy
    @repair = Repair.find(params[:id])
    @repair.destroy
    redirect_to repairs_path
  end
end

private

def repair_params
  params.require(:repair).permit(:repair_type, :repair_notes)
end
