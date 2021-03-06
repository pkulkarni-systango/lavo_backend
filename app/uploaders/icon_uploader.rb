class IconUploader < CarrierWave::Uploader::Base
  include ::UploaderConcern

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    ActionController::Base.helpers.asset_path "fallback/item/default_icon.svg"
  end

  process :strip # strip image of all profiles and comments
  process :resize_to_fit => [50, 50]
  process :quality => 100 # Set JPEG/MIFF/PNG compression level (0-100)
  process :convert => 'jpg'
  process :colorspace => :rgb # Set colorspace to rgb or cmyk
  process :auto_orient # Rotate the image if it has orientation data

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end
end
