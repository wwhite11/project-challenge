class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit,  :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :create, :update]

  # GET /dogs
  # GET /dogs.json
  def index
    @dogs = Dog.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
    if current_user.id != @dog.user_id
      redirect_to root_path, :alert => "Not your cute dog"
    end
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    current_user.dogs << @dog
    respond_to do |format|
      if @dog.save
        if params[:dog][:images].present?
          params[:dog][:images].each do |image|
            @dog.images.attach(image)
          end
        end

        format.html { redirect_to @dog, notice: 'The cute Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'The cute Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'The cute Dog was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, images: [])
    end
end
