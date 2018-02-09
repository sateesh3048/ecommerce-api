require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = build(:user) }
  subject{@user}
  it { expect(subject).to respond_to(:email) }
  it { expect(subject).to respond_to(:password) }
  it { expect(subject).to respond_to(:password_confirmation)}
  it { expect(subject).to validate_presence_of(:email)}
  it { expect(subject).to validate_uniqueness_of(:email).case_insensitive}
  it { expect(subject).to validate_confirmation_of(:password)}
  it { expect(subject).to validate_uniqueness_of(:auth_token) }

  describe "#generate_auth_token" do 
    it "should generate auth token" do 
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      user1 = create(:user)
      expect(user1.auth_token).to eq("auniquetoken123")
    end

    it "should generate another token when one already has been taken" do 
      user1 = create(:user)
      user2 = create(:user)
      user2.generate_auth_token!
      expect(user1.auth_token).not_to eql user2
    end
  end
end
