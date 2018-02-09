require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) do
    request.headers['Accept'] = "application/vnd.marketplace.v1, application/json"
    request.headers['']
    request.headers['Content-Type'] = Mime[:json].to_s
  end
  describe "Get #create" do 
    context "when user is created" do 
      before(:each) do 
        @user_attributes = attributes_for(:user)
        post :create, params: {user: @user_attributes}
      end
      it "renders the json response for user record" do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(@user_attributes[:email])
      end
    end
    context "with user is not created" do 
      before(:each) do 
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, params: {user: @invalid_user_attributes}
      end
      it "renders an error json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
      it "renders the json errors on why user is not created" do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
      it {should respond_with 422}
    end
  end
  # Show action specs
  describe "Get #show" do 
    before(:each) do 
      @user = create(:user)
      get :show, params: {id: @user.id }, format: :json
    end

    it "returns the information about a reporter on a hash" do 
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql(@user.email)
    end
    it { should respond_with 200 }
  end

  # Put action specs
  describe "PUT/PATCH #update" do
    context "when is successfully updated" do
      before(:each) do
        @user = create :user
        patch :update, params:{ id: @user.id,
                         user: { email: "newmail@example.com" } }
      end

      it "renders the json representation for the updated user" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql "newmail@example.com"
      end

      it { should respond_with 200 }
    end

    context "when is not created" do
      before(:each) do
        @user = create :user
        patch :update, params: { id: @user.id,
                         user: { email: "bademail.com" } }
      end

      it "renders an errors json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end
  # Destroy action specs
  describe "Delete #Destroy" do 
    before(:each) do 
      @user = create(:user)
      delete :destroy, params: {id: @user.id}
    end
    it {should respond_with 204 }
  end
end
