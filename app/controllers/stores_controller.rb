class StoresController < ApplicationController
    before_action :set_store, only: [:show, :edit, :update]
    before_action :check_login
    authorize_resource

    def index
        @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
        @inactive_stores = Store.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    end

    def show
        @current_employees = @store.employees.where(active: true)
    end

    def new
        @store = Store.new
    end

    def create
        @store = Store.new(store_params)

        if @store.save
        redirect_to @store, notice: "Store was successfully created."
        else
        render :new
        end
    end

    def edit
    end

    def update
        if @store.update(store_params)
        redirect_to @store, notice: "Updated store information for #{@store.name}."
        else
        render :edit
        end
    end

    private

    def set_store
        @store = Store.find(params[:id])
    end

    def store_params
        params.require(:store).permit(:name, :street, :city, :state, :zip, :phone, :active)
    end
end
