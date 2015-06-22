require 'bundler'
Bundler.require
require 'carrierwave/orm/activerecord'

configure do
    ActiveRecord::Base.configurations = YAML.load_file('db/database.yml')
    ActiveRecord::Base.establish_connection(Sinatra::Application.environment)
    enable :sessions
end

class PhotoUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    permissions 0666
    directory_permissions 0777
    storage :file

    #サムネイル画像の生成
    version :thumb do
        process :resize_to_fill => [200, 200]
    end

    #縮小画像の生成
    version :small do
        process :resize_to_limit => [900, 900]
    end
    
    #ファイル名を一意に ex.
    def filename
         "#{secure_token(10)}.#{file.extension}" if original_filename.present?
    end

    protected
    def secure_token(length=16)
        var = :"@#{mounted_as}_secure_token"
        model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
    end
end

class Photo < ActiveRecord::Base
    mount_uploader :file, PhotoUploader
    validates :comment, :file, presence: true
end

post "/new" do
    photo = Photo.new(file: params[:photo], comment: params[:comment])
    if photo.save
        session[:responce] = {code: 200, messages: "成功しました"}
    else
        session[:responce] = {code: 400, messages: photo.errors.full_messages}
    end
    redirect back
end

get "/new" do
	@title = "画像投稿"
	slim :new
end

get "/" do
	@title = "Gazo"
	@photos = Photo.all.reverse_order
	slim :index
end

get "/image/:id" do
	@photo = Photo.find_by(id: params[:id])
	if @photo.nil?
		"Not found...."
	else
		@title = "画像"
		slim :show
	end
end
