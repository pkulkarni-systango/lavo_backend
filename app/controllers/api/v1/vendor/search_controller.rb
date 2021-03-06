class API::V1::Vendor::SearchController < API::V1::VersionController

  def index
    vendor_index = ::Index::VendorSearchIndex.new(self)
    vendors = vendor_index.vendors(Vendor.activated.search(params[:query]))
    render json: vendors, meta: pagination(vendors)
  end
end