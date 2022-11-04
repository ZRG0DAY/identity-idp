require 'rails_helper'

# Simulates a user (in this case, a VA inherited proofing-authorized user)
# coming over to login.gov from a service provider, and hitting the
# OpenidConnect::AuthorizationController#index action.
def send_user_from_service_provider_to_login_gov_openid_connect(user)
  expect(user).to_not be_nil
  # NOTE: VA user.
  visit_idp_from_oidc_va_with_ial2
end

def complete_idv_steps_up_to_inherited_proofing_get_started_step(user, expect_accessible: false)
  unless current_path == idv_inherited_proofing_step_path(step: :get_started)
    complete_idv_steps_before_phone_step(user)
    click_link t('links.cancel')
    click_button t('idv.cancel.actions.start_over')
    expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :get_started))
  end
  expect(page).to be_axe_clean.according_to :section508, :"best-practice" if expect_accessible
end

def complete_idv_steps_up_to_inherited_proofing_how_verifying_step(user, expect_accessible: false)
  complete_idv_steps_up_to_inherited_proofing_get_started_step user,
                                                               expect_accessible: expect_accessible
  unless current_path == idv_inherited_proofing_step_path(step: :agreement)
    click_on t('inherited_proofing.buttons.continue')
  end
end

def complete_idv_steps_up_to_inherited_proofing_we_are_retrieving_step(user,
                                                                       expect_accessible: false)
  complete_idv_steps_up_to_inherited_proofing_how_verifying_step(
    user,
    expect_accessible: expect_accessible,
  )
  unless current_path == idv_inherited_proofing_step_path(step: :verify_wait)
    check t('inherited_proofing.instructions.consent', app_name: APP_NAME), allow_label_click: true
    click_on t('inherited_proofing.buttons.continue')
  end
end

def complete_idv_steps_up_to_inherited_proofing_verify_your_info_step(user,
                                                                      expect_accessible: false)
  complete_idv_steps_up_to_inherited_proofing_we_are_retrieving_step(
    user,
    expect_accessible: expect_accessible,
  )
end

feature 'inherited proofing cancel process', :js do
  include InheritedProofingHelper
  include_context 'va_user_context'

  before do
    allow(IdentityConfig.store).to receive(:va_inherited_proofing_mock_enabled).and_return true
    send_user_from_service_provider_to_login_gov_openid_connect user
  end

  let!(:user) { user_with_2fa }

  context 'from the "Get started verifying your identity" view, and clicking the "Cancel" link' do
    before do
      complete_idv_steps_up_to_inherited_proofing_get_started_step user
    end

    it 'should have current path equal to the Getting Started page' do
      expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :get_started))
    end

    context 'when clicking the "Start Over" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :get_started))
      end

      it 'redirects the user back to the start of the Inherited Proofing process' do
        click_button t('inherited_proofing.cancel.actions.start_over')
        expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :get_started))
      end
    end

    context 'when clicking the "No, keep going" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :get_started))
      end

      it 'redirects the user back to where the user left off in the Inherited Proofing process' do
        click_button t('inherited_proofing.cancel.actions.keep_going')
        expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :get_started))
      end
    end

    context 'when clicking the "Exit Login.gov" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :get_started))
      end

      it 'redirects the user back to the service provider website' do
        click_button t('idv.cancel.actions.exit', app_name: APP_NAME)
        expect(page).to have_current_path(/\/auth\/result\?/)
      end
    end
  end

  context 'from the "How verifying your identify works" view, and clicking the "Cancel" link' do
    before do
      complete_idv_steps_up_to_inherited_proofing_how_verifying_step user
    end

    it 'should have current path equal to the How Verifying (agreement step) page' do
      expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :agreement))
    end

    context 'when clicking the "Start Over" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :agreement))
      end

      it 'redirects the user back to the start of the Inherited Proofing process' do
        click_button t('inherited_proofing.cancel.actions.start_over')
        expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :get_started))
      end
    end

    context 'when clicking the "No, keep going" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :agreement))
      end

      it 'redirects the user back to where the user left off in the Inherited Proofing process' do
        click_button t('inherited_proofing.cancel.actions.keep_going')
        expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :agreement))
      end
    end

    context 'when clicking the "Exit Login.gov" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :agreement))
      end

      it 'redirects the user back to the service provider website' do
        click_button t('idv.cancel.actions.exit', app_name: APP_NAME)
        expect(page).to have_current_path(/\/auth\/result\?/)
      end
    end
  end

  context 'from the "Verify your information..." view, and clicking the "Cancel" link' do
    before do
      complete_idv_steps_up_to_inherited_proofing_verify_your_info_step user
    end

    it 'should have current path equal to the Verify your information (verify_info step) page' do
      expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :verify_info))
    end

    context 'when clicking the "Start Over" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :verify_info))
      end

      it 'redirects the user back to the start of the Inherited Proofing process' do
        click_button t('inherited_proofing.cancel.actions.start_over')
        expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :get_started))
      end
    end

    context 'when clicking the "No, keep going" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :verify_info))
      end

      it 'redirects the user back to where the user left off in the Inherited Proofing process' do
        click_button t('inherited_proofing.cancel.actions.keep_going')
        expect(page).to have_current_path(idv_inherited_proofing_step_path(step: :verify_info))
      end
    end

    context 'when clicking the "Exit Login.gov" button from the "Cancel" view' do
      before do
        click_link t('links.cancel')
        expect(page).to have_current_path(idv_inherited_proofing_cancel_path(step: :verify_info))
      end

      it 'redirects the user back to the service provider website' do
        click_button t('idv.cancel.actions.exit', app_name: APP_NAME)
        expect(page).to have_current_path(/\/auth\/result\?/)
      end
    end
  end
end
