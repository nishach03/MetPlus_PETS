require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :controller do
  describe 'get confirmation_token' do
    let!(:agency) { FactoryGirl.create(:agency) }
    let!(:aa_person) { FactoryGirl.create(:agency_admin, agency: agency) }
    let!(:cm_person) { FactoryGirl.create(:case_manager, agency: agency) }
    let!(:jd_person) { FactoryGirl.create(:job_developer, agency: agency) }
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end
    it 'rejects invalid tag' do
      get :show, confirmation_token: 'HzDZWwMxswSAs_aQSYwd'
      expect(response).to render_template('users/confirmations/new')
    end
    it 'confirms user email address' do
      @js = FactoryGirl.create(:job_seeker_applicant)
      get :show, confirmation_token: @js.confirmation_token
      expect(response).to render_template('/')
      expect(flash[:notice]).to eq 'Your email address has been successfully confirmed.'
    end
    it 'allows re-confirmation of user email address' do
      @js = FactoryGirl.create(:job_seeker_applicant)
      @user_token = @js.confirmation_token
      get :show, confirmation_token: @js.confirmation_token
      get :show, confirmation_token: @user_token
      expect(flash[:notice]).to eq 'Your email address has been successfully confirmed.'
    end
  end
end
