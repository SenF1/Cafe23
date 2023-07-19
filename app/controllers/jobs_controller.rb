class JobsController < ApplicationController
  before_action :set_job, only: [:edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    @jobs = Job.all
  end

  def new
    @job = Job.new
  end

  def edit
  end

  def create
    @job = Job.new(job_params)
    if @job.save 
      redirect_to jobs_path, notice: "Job was successfully created."
    else
      render :new
    end
  end

  def update
    if @job.update(job_params)
      redirect_to jobs_path, notice: "Job was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if @job.shift_jobs.empty?
      @job.destroy
      redirect_to jobs_path, notice: "Job was successfully destroyed."
    else
      render :index
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :description, :active)
  end
end