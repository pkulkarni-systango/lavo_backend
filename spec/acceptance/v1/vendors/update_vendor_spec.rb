require 'acceptance_helper'

resource 'vendors/update', document: :v1 do
  include_context :content_headers
  header 'Authorization', :token

  parameter :id, 'Vendor id', required: true
  parameter :type, 'vendors', scope: :data, required: true
  with_options scope: [:data, :attributes], required: true do |o|
    o.parameter :name, 'Vendor name'
    o.parameter :phone, 'Vendor phone number'
    o.parameter :avatar, 'Base64 encoded avatar: https://developer.mozilla.org/ru/docs/Web/API/FileReader/readAsDataURL'
  end

  let(:vendor) { create(:signed_in_vendor) }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  let(:id) { vendor.id }
  let(:type) { 'vendors' }
  let(:name) { 'New name' }
  let(:phone) { '+1234567890' }
  let(:avatar) { "data:image/png;base64,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" }

  patch "/vendors/:id" do

    context 'Successfully update vendor profile' do
      example_request 'Successfully update vendor profile' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:avatar]).to be_present
      end
    end
  end
end
