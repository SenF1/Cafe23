class ShiftJobsController < ApplicationController
  before_action :set_shift_job, only: [:destroy]
  before_action :check_login
  authorize_resource

  def new
    @shift_job = ShiftJob.new
    @shift = Shift.find(params[:shift_id])
  end

  def create
    @shift_job = ShiftJob.new(shift_job_params)
    @shift = Shift.find(shift_job_params[:shift_id])
    if @shift_job.save
      redirect_to shift_path(@shift_job.shift), notice: "Shift job was successfully created."
    else
      render :new
    end
  end

  def destroy
    @shift_job.destroy
    redirect_to shift_path(@shift_job.shift), notice: "Shift job was successfully destroyed."
  end

  private

  def set_shift_job
    @shift_job = ShiftJob.find(params[:id])
  end

  def shift_job_params
    params.require(:shift_job).permit(:shift_id, :job_id)
  end
end