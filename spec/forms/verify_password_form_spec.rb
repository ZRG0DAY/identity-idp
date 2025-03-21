require 'rails_helper'

RSpec.describe VerifyPasswordForm, type: :model do
  describe '#submit' do
    context 'when the form is valid' do
      it 'is successful' do
        password = 'cab123DZN456'
        user = create(:user, password: password)
        pii = { ssn: '111111111' }
        profile = create(:profile, :verified, :password_reset, user: user, pii: pii)

        form = VerifyPasswordForm.new(
          user: user, password: password,
          decrypted_pii: Pii::Attributes.new_from_hash(pii)
        )

        expect(profile.reload.active?).to eq false

        result = form.submit

        expect(profile.reload.active?).to eq true
        expect(result.to_h).to eq(success: true)
      end
    end

    context 'when the password is invalid' do
      it 'returns errors' do
        password = 'cab123DZN456'
        user = create(:user, password: password)
        pii = { ssn: '111111111' }
        profile = create(:profile, :verified, :password_reset, user: user, pii: pii)

        form = VerifyPasswordForm.new(
          user: user, password: "#{password}a",
          decrypted_pii: Pii::Attributes.new_from_hash(pii)
        )

        expect(profile.reload.active?).to eq false

        result = form.submit

        expect(profile.reload.active?).to eq false
        expect(result.to_h).to eq(
          success: false,
          error_details: { password: { password_incorrect: true } },
        )
      end
    end
  end
end
