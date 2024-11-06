# frozen_string_literal: true

module IdentityConfig
  GIT_SHA = `git rev-parse --short=8 HEAD`.chomp.freeze
  GIT_TAG = `git tag --points-at HEAD`.chomp.split("\n").first.freeze
  GIT_BRANCH = `git rev-parse --abbrev-ref HEAD`.chomp.freeze

  VENDOR_STATUS_OPTIONS = %i[operational partial_outage full_outage].freeze

  # Shorthand to allow using old syntax to access configs, minimizes merge conflicts
  # while migrating to newer syntax
  def self.store
    Identity::Hostdata.config
  end

  # identity-hostdata transforms these configs to the described type
  # rubocop:disable Metrics/BlockLength
  # rubocop:disable Metrics/LineLength
  BUILDER = proc do |config|
    #  ______________________________________
    # / Adding something new in here? Please \
    # \ keep methods sorted alphabetically.  /
    #  --------------------------------------
    #                                   /
    #           _.---._    /\\         /
    #        ./'       "--`\//        /
    #      ./              o \       /
    #     /./\  )______   \__ \
    #    ./  / /\ \   | \ \  \ \
    #       / /  \ \  | |\ \  \7
    #        "     "    "  "
    config.add(:aamva_auth_request_timeout, type: :float)
    config.add(:aamva_auth_url, type: :string)
    config.add(:aamva_cert_enabled, type: :boolean)
    config.add(:aamva_private_key, type: :string)
    config.add(:aamva_public_key, type: :string)
    config.add(:aamva_send_id_type, type: :boolean)
    config.add(:aamva_supported_jurisdictions, type: :json)
    config.add(:aamva_verification_request_timeout, type: :float)
    config.add(:aamva_verification_url)
    config.add(
      :account_creation_device_profiling,
      type: :symbol,
      enum: [:disabled, :collect_only, :enabled],
    )
    config.add(:account_reset_token_valid_for_days, type: :integer)
    config.add(:account_reset_wait_period_days, type: :integer)
    config.add(:account_reset_fraud_user_wait_period_days, type: :integer, allow_nil: true)
    config.add(:account_suspended_support_code, type: :string)
    config.add(:acuant_sdk_initialization_creds)
    config.add(:acuant_sdk_initialization_endpoint)
    config.add(:add_email_link_valid_for_hours, type: :integer)
    config.add(:address_identity_proofing_supported_country_codes, type: :json)
    config.add(:all_redirect_uris_cache_duration_minutes, type: :integer)
    config.add(:allowed_biometric_ial_providers, type: :json)
    config.add(:allowed_ialmax_providers, type: :json)
    config.add(:allowed_valid_authn_contexts_semantic_providers, type: :json)
    config.add(:allowed_verified_within_providers, type: :json)
    config.add(:asset_host, type: :string)
    config.add(:async_stale_job_timeout_seconds, type: :integer)
    config.add(:async_wait_timeout_seconds, type: :integer)
    config.add(:attribute_encryption_key, type: :string)
    config.add(:attribute_encryption_key_queue, type: :json)
    config.add(:available_locales, type: :comma_separated_string_list)
    config.add(:aws_http_retry_limit, type: :integer)
    config.add(:aws_http_retry_max_delay, type: :integer)
    config.add(:aws_http_timeout, type: :integer)
    config.add(:aws_kms_client_contextless_pool_size, type: :integer)
    config.add(:aws_kms_client_multi_pool_size, type: :integer)
    config.add(:aws_kms_key_id, type: :string)
    config.add(:aws_kms_multi_region_key_id, type: :string)
    config.add(:aws_kms_session_key_id, type: :string)
    config.add(:aws_logo_bucket, type: :string)
    config.add(:aws_region, type: :string)
    config.add(:backup_code_cost, type: :string)
    config.add(:backup_code_user_id_per_ip_attempt_window_exponential_factor, type: :float)
    config.add(:backup_code_user_id_per_ip_attempt_window_in_minutes, type: :integer)
    config.add(:backup_code_user_id_per_ip_attempt_window_max_minutes, type: :integer)
    config.add(:backup_code_user_id_per_ip_max_attempts, type: :integer)
    config.add(:biometric_ial_enabled, type: :boolean)
    config.add(:broken_personal_key_window_finish, type: :timestamp)
    config.add(:broken_personal_key_window_start, type: :timestamp)
    config.add(:check_user_password_compromised_enabled, type: :boolean)
    config.add(:component_previews_embed_frame_ancestors, type: :json)
    config.add(:component_previews_enabled, type: :boolean)
    config.add(:compromised_password_randomizer_value, type: :integer)
    config.add(:compromised_password_randomizer_threshold, type: :integer)
    config.add(:country_phone_number_overrides, type: :json)
    config.add(:dashboard_api_token, type: :string)
    config.add(:dashboard_url, type: :string)
    config.add(:database_advisory_locks_enabled, type: :boolean)
    config.add(:database_host, type: :string)
    config.add(:database_name, type: :string)
    config.add(:database_password, type: :string)
    config.add(:database_pool_idp, type: :integer)
    config.add(:database_prepared_statements_enabled, type: :boolean)
    config.add(:database_read_replica_host, type: :string)
    config.add(:database_readonly_password, type: :string)
    config.add(:database_readonly_username, type: :string)
    config.add(:database_socket, type: :string)
    config.add(:database_sslmode, type: :string)
    config.add(:database_statement_timeout, type: :integer)
    config.add(:database_timeout, type: :integer)
    config.add(:database_username, type: :string)
    config.add(:database_worker_jobs_host, type: :string)
    config.add(:database_worker_jobs_name, type: :string)
    config.add(:database_worker_jobs_password, type: :string)
    config.add(:database_worker_jobs_sslmode, type: :string)
    config.add(:database_worker_jobs_username, type: :string)
    config.add(:deleted_user_accounts_report_configs, type: :json)
    config.add(:deliver_mail_async, type: :boolean)
    config.add(:development_mailer_deliver_method, type: :symbol, enum: [:file, :letter_opener])
    config.add(:disable_email_sending, type: :boolean)
    config.add(:disable_logout_get_request, type: :boolean)
    config.add(:disposable_email_services, type: :json)
    config.add(:doc_auth_attempt_window_in_minutes, type: :integer)
    config.add(:doc_auth_check_failed_image_resubmission_enabled, type: :boolean)
    config.add(:doc_auth_client_glare_threshold, type: :integer)
    config.add(:doc_auth_client_sharpness_threshold, type: :integer)
    config.add(:doc_auth_error_dpi_threshold, type: :integer)
    config.add(:doc_auth_error_glare_threshold, type: :integer)
    config.add(:doc_auth_error_sharpness_threshold, type: :integer)
    config.add(:doc_auth_max_attempts, type: :integer)
    config.add(:doc_auth_max_capture_attempts_before_native_camera, type: :integer)
    config.add(:doc_auth_max_submission_attempts_before_native_camera, type: :integer)
    config.add(:doc_auth_selfie_desktop_test_mode, type: :boolean)
    config.add(:doc_auth_supported_country_codes, type: :json)
    config.add(:doc_auth_vendor, type: :string)
    config.add(:doc_auth_vendor_default, type: :string)
    config.add(:doc_auth_vendor_lexis_nexis_percent, type: :integer)
    config.add(:doc_auth_vendor_socure_percent, type: :integer)
    config.add(:doc_auth_vendor_switching_enabled, type: :boolean)
    config.add(:doc_capture_polling_enabled, type: :boolean)
    config.add(:doc_capture_request_valid_for_minutes, type: :integer)
    config.add(:drop_off_report_config, type: :json)
    config.add(:domain_name, type: :string)
    config.add(:email_from, type: :string)
    config.add(:email_from_display_name, type: :string)
    config.add(:email_registrations_per_ip_limit, type: :integer)
    config.add(:email_registrations_per_ip_period, type: :integer)
    config.add(:email_registrations_per_ip_track_only_mode, type: :boolean)
    config.add(:enable_add_mfa_redirect_for_personal_key, type: :boolean)
    config.add(:enable_load_testing_mode, type: :boolean)
    config.add(:enable_rate_limiting, type: :boolean)
    config.add(:enable_test_routes, type: :boolean)
    config.add(:enable_usps_verification, type: :boolean)
    config.add(:event_disavowal_expiration_hours, type: :integer)
    config.add(:facial_match_general_availability_enabled, type: :boolean)
    config.add(:feature_idv_force_gpo_verification_enabled, type: :boolean)
    config.add(:feature_idv_hybrid_flow_enabled, type: :boolean)
    config.add(:feature_select_email_to_share_enabled, type: :boolean)
    config.add(:feature_valid_authn_contexts_semantic_enabled, type: :boolean)
    config.add(:geo_data_file_path, type: :string)
    config.add(:get_usps_proofing_results_job_cron, type: :string)
    config.add(:get_usps_proofing_results_job_reprocess_delay_minutes, type: :integer)
    config.add(:get_usps_proofing_results_job_request_delay_milliseconds, type: :integer)
    config.add(:get_usps_ready_proofing_results_job_cron, type: :string)
    config.add(:get_usps_waiting_proofing_results_job_cron, type: :string)
    config.add(:good_job_max_threads, type: :integer)
    config.add(:good_job_queue_select_limit, type: :integer)
    config.add(:good_job_queues, type: :string)
    config.add(:gpo_designated_receiver_pii, type: :json, options: { symbolize_names: true })
    config.add(:gpo_max_profile_age_to_send_letter_in_days, type: :integer)
    config.add(:hide_phone_mfa_signup, type: :boolean)
    config.add(:hmac_fingerprinter_key, type: :string)
    config.add(:hmac_fingerprinter_key_queue, type: :json)
    config.add(:identity_pki_disabled, type: :boolean)
    config.add(:identity_pki_local_dev, type: :boolean)
    config.add(:idv_account_verified_email_campaign_id, type: :string)
    config.add(:idv_acuant_sdk_upgrade_a_b_testing_enabled, type: :boolean)
    config.add(:idv_acuant_sdk_upgrade_a_b_testing_percent, type: :integer)
    config.add(:idv_acuant_sdk_version_alternate, type: :string)
    config.add(:idv_acuant_sdk_version_default, type: :string)
    config.add(:idv_attempt_window_in_hours, type: :integer)
    config.add(:idv_available, type: :boolean)
    config.add(:idv_contact_phone_number, type: :string)
    config.add(:idv_max_attempts, type: :integer)
    config.add(:idv_min_age_years, type: :integer)
    config.add(:idv_send_link_attempt_window_in_minutes, type: :integer)
    config.add(:idv_send_link_max_attempts, type: :integer)
    config.add(:idv_socure_reason_code_download_enabled, type: :boolean)
    config.add(:idv_socure_shadow_mode_enabled, type: :boolean)
    config.add(:idv_sp_required, type: :boolean)
    config.add(:in_person_completion_survey_url, type: :string)
    config.add(:in_person_doc_auth_button_enabled, type: :boolean)
    config.add(:in_person_eipp_enrollment_validity_in_days, type: :integer)
    config.add(:in_person_email_reminder_early_benchmark_in_days, type: :integer)
    config.add(:in_person_email_reminder_final_benchmark_in_days, type: :integer)
    config.add(:in_person_email_reminder_late_benchmark_in_days, type: :integer)
    config.add(:in_person_enrollment_validity_in_days, type: :integer)
    config.add(:in_person_enrollments_ready_job_cron, type: :string)
    config.add(:in_person_enrollments_ready_job_email_body_pattern, type: :string)
    config.add(:in_person_enrollments_ready_job_enabled, type: :boolean)
    config.add(:in_person_enrollments_ready_job_max_number_of_messages, type: :integer)
    config.add(:in_person_enrollments_ready_job_queue_url, type: :string)
    config.add(:in_person_enrollments_ready_job_visibility_timeout_seconds, type: :integer)
    config.add(:in_person_enrollments_ready_job_wait_time_seconds, type: :integer)
    config.add(:in_person_full_address_entry_enabled, type: :boolean)
    config.add(:in_person_opt_in_available_completion_survey_url, type: :string)
    config.add(:in_person_outage_emailed_by_date, type: :string)
    config.add(:in_person_outage_expected_update_date, type: :string)
    config.add(:in_person_outage_message_enabled, type: :boolean)
    config.add(:in_person_proofing_enabled, type: :boolean)
    config.add(:in_person_proofing_enforce_tmx, type: :boolean)
    config.add(:in_person_proofing_opt_in_enabled, type: :boolean)
    config.add(:in_person_results_delay_in_hours, type: :integer)
    config.add(:in_person_send_proofing_notifications_enabled, type: :boolean)
    config.add(:in_person_stop_expiring_enrollments, type: :boolean)
    config.add(:invalid_gpo_confirmation_zipcode, type: :string)
    config.add(:lexisnexis_account_id, type: :string)
    config.add(:lexisnexis_base_url, type: :string)
    config.add(:lexisnexis_hmac_auth_enabled, type: :boolean)
    config.add(:lexisnexis_hmac_key_id, type: :string)
    config.add(:lexisnexis_hmac_secret_key, type: :string)
    config.add(:lexisnexis_instant_verify_timeout, type: :float)
    config.add(:lexisnexis_instant_verify_workflow, type: :string)
    config.add(:lexisnexis_password, type: :string)
    config.add(:lexisnexis_phone_finder_timeout, type: :float)
    config.add(:lexisnexis_phone_finder_workflow, type: :string)
    config.add(:lexisnexis_request_mode, type: :string)
    config.add(:lexisnexis_threatmetrix_api_key, type: :string, allow_nil: true)
    config.add(:lexisnexis_threatmetrix_base_url, type: :string, allow_nil: true)
    config.add(:lexisnexis_threatmetrix_js_signing_cert, type: :string)
    config.add(:lexisnexis_threatmetrix_mock_enabled, type: :boolean)
    config.add(:lexisnexis_threatmetrix_org_id, type: :string, allow_nil: true)
    config.add(:lexisnexis_threatmetrix_policy, type: :string, allow_nil: true)
    config.add(:lexisnexis_threatmetrix_support_code, type: :string)
    config.add(:lexisnexis_threatmetrix_timeout, type: :float)
    config.add(:lexisnexis_trueid_account_id, type: :string)
    config.add(:lexisnexis_trueid_hmac_key_id, type: :string)
    config.add(:lexisnexis_trueid_hmac_secret_key, type: :string)
    config.add(:lexisnexis_trueid_liveness_cropping_workflow, type: :string)
    config.add(:lexisnexis_trueid_liveness_nocropping_workflow, type: :string)
    config.add(:lexisnexis_trueid_noliveness_cropping_workflow, type: :string)
    config.add(:lexisnexis_trueid_noliveness_nocropping_workflow, type: :string)
    config.add(:lexisnexis_trueid_password, type: :string)
    config.add(:lexisnexis_trueid_timeout, type: :float)
    config.add(:lexisnexis_trueid_username, type: :string)
    config.add(:lexisnexis_username, type: :string)
    config.add(:lockout_period_in_minutes, type: :integer)
    config.add(:log_password_reset_matches_existing_ab_test_percent, type: :integer)
    config.add(:log_to_stdout, type: :boolean)
    config.add(:login_otp_confirmation_max_attempts, type: :integer)
    config.add(:logins_per_email_and_ip_bantime, type: :integer)
    config.add(:logins_per_email_and_ip_limit, type: :integer)
    config.add(:logins_per_email_and_ip_period, type: :integer)
    config.add(:logins_per_ip_limit, type: :integer)
    config.add(:logins_per_ip_period, type: :integer)
    config.add(:logins_per_ip_track_only_mode, type: :boolean)
    config.add(:logo_upload_enabled, type: :boolean)
    config.add(:mailer_domain_name)
    config.add(:max_auth_apps_per_account, type: :integer)
    config.add(:max_bad_passwords, type: :integer)
    config.add(:max_bad_passwords_window_in_seconds, type: :integer)
    config.add(:max_emails_per_account, type: :integer)
    config.add(:max_mail_events, type: :integer)
    config.add(:max_mail_events_window_in_days, type: :integer)
    config.add(:max_phone_numbers_per_account, type: :integer)
    config.add(:max_piv_cac_per_account, type: :integer)
    config.add(:mfa_report_config, type: :json)
    config.add(:min_password_score, type: :integer)
    config.add(:minimum_wait_before_another_usps_letter_in_hours, type: :integer)
    config.add(:mx_timeout, type: :integer)
    config.add(:new_device_alert_delay_in_minutes, type: :integer)
    config.add(:newrelic_license_key, type: :string)
    config.add(
      :openid_connect_redirect,
      type: :string,
      enum: ['server_side', 'client_side', 'client_side_js'],
    )
    config.add(
      :openid_connect_redirect_uuid_override_map,
      type: :json,
    )
    config.add(
      :openid_connect_redirect_issuer_override_map,
      type: :json,
    )
    config.add(:openid_connect_content_security_form_action_enabled, type: :boolean)
    config.add(:otp_delivery_blocklist_findtime, type: :integer)
    config.add(:otp_delivery_blocklist_maxretry, type: :integer)
    config.add(:otp_expiration_warning_seconds, type: :integer)
    config.add(:otp_min_attempts_remaining_warning_count, type: :integer)
    config.add(:otp_valid_for, type: :integer)
    config.add(:otps_per_ip_limit, type: :integer)
    config.add(:otps_per_ip_period, type: :integer)
    config.add(:otps_per_ip_track_only_mode, type: :boolean)
    config.add(:outbound_connection_check_retry_count, type: :integer)
    config.add(:outbound_connection_check_timeout, type: :integer)
    config.add(:outbound_connection_check_url)
    config.add(:participate_in_dap, type: :boolean)
    config.add(:password_max_attempts, type: :integer)
    config.add(:password_pepper, type: :string)
    config.add(:personal_key_retired, type: :boolean)
    config.add(:phone_carrier_registration_blocklist_array, type: :json)
    config.add(:phone_confirmation_max_attempt_window_in_minutes, type: :integer)
    config.add(:phone_confirmation_max_attempts, type: :integer)
    config.add(
      :phone_recaptcha_country_score_overrides,
      type: :json,
      options: { symbolize_names: true },
    )
    config.add(:phone_recaptcha_score_threshold, type: :float)
    config.add(:phone_service_check, type: :boolean)
    config.add(:phone_setups_per_ip_limit, type: :integer)
    config.add(:phone_setups_per_ip_period, type: :integer)
    config.add(:phone_setups_per_ip_track_only_mode, type: :boolean)
    config.add(:pii_lock_timeout_in_minutes, type: :integer)
    config.add(:pinpoint_sms_configs, type: :json)
    config.add(:pinpoint_sms_sender_id, type: :string, allow_nil: true)
    config.add(:pinpoint_voice_configs, type: :json)
    config.add(:pinpoint_voice_pool_size, type: :integer)
    config.add(:piv_cac_service_timeout, type: :float)
    config.add(:piv_cac_service_url, type: :string)
    config.add(:piv_cac_verify_token_secret)
    config.add(:piv_cac_verify_token_url, type: :string)
    config.add(:poll_rate_for_verify_in_seconds, type: :integer)
    config.add(:prometheus_exporter, type: :boolean)
    config.add(:proof_address_max_attempt_window_in_minutes, type: :integer)
    config.add(:proof_address_max_attempts, type: :integer)
    config.add(:proof_ssn_max_attempt_window_in_minutes, type: :integer)
    config.add(:proof_ssn_max_attempts, type: :integer)
    config.add(:proofer_mock_fallback, type: :boolean)
    config.add(
      :proofing_device_profiling,
      type: :symbol,
      enum: [:disabled, :collect_only, :enabled],
    )
    config.add(:protocols_report_config, type: :json)
    config.add(:push_notifications_enabled, type: :boolean)
    config.add(:pwned_passwords_file_path, type: :string)
    config.add(:rack_mini_profiler, type: :boolean)
    config.add(:rack_timeout_service_timeout_seconds, type: :integer)
    config.add(:rails_mailer_previews_enabled, type: :boolean)
    config.add(:raise_on_component_validation_error, type: :boolean)
    config.add(:raise_on_missing_title, type: :boolean)
    config.add(:reauthn_window, type: :integer)
    config.add(:recaptcha_enterprise_api_key, type: :string)
    config.add(:recaptcha_enterprise_project_id, type: :string)
    config.add(:recaptcha_mock_validator, type: :boolean)
    config.add(:recaptcha_secret_key, type: :string)
    config.add(:recaptcha_site_key, type: :string)
    config.add(:recovery_code_length, type: :integer)
    config.add(:redis_pool_size, type: :integer)
    config.add(:redis_throttle_pool_size, type: :integer)
    config.add(:redis_throttle_url, type: :string)
    config.add(:redis_url, type: :string)
    config.add(:reg_confirmed_email_max_attempts, type: :integer)
    config.add(:reg_confirmed_email_window_in_minutes, type: :integer)
    config.add(:reg_unconfirmed_email_max_attempts, type: :integer)
    config.add(:reg_unconfirmed_email_window_in_minutes, type: :integer)
    config.add(:reject_id_token_hint_in_logout, type: :boolean)
    config.add(:remember_device_expiration_hours_aal_1, type: :integer)
    config.add(:remember_device_expiration_minutes_aal_2, type: :integer)
    config.add(:report_timeout, type: :integer)
    config.add(:requests_per_ip_cidr_allowlist, type: :comma_separated_string_list)
    config.add(:requests_per_ip_limit, type: :integer)
    config.add(:requests_per_ip_path_prefixes_allowlist, type: :comma_separated_string_list)
    config.add(:requests_per_ip_period, type: :integer)
    config.add(:requests_per_ip_track_only_mode, type: :boolean)
    config.add(:reset_password_email_max_attempts, type: :integer)
    config.add(:reset_password_email_window_in_minutes, type: :integer)
    config.add(:reset_password_on_auth_fraud_event, type: :boolean)
    config.add(:risc_notifications_local_enabled, type: :boolean)
    config.add(:risc_notifications_rate_limit_interval, type: :integer)
    config.add(:risc_notifications_rate_limit_max_requests, type: :integer)
    config.add(:risc_notifications_rate_limit_overrides, type: :json)
    config.add(:risc_notifications_request_timeout, type: :integer)
    config.add(:ruby_workers_idv_enabled, type: :boolean)
    config.add(:rules_of_use_horizon_years, type: :integer)
    config.add(:rules_of_use_updated_at, type: :timestamp)
    config.add(:s3_public_reports_enabled, type: :boolean)
    config.add(:s3_report_bucket_prefix, type: :string)
    config.add(:s3_report_public_bucket_prefix, type: :string)
    config.add(:s3_data_warehouse_bucket_prefix, type: :string)
    config.add(:s3_idp_dw_tasks, type: :string)
    config.add(:s3_reports_enabled, type: :boolean)
    config.add(:saml_endpoint_configs, type: :json, options: { symbolize_names: true })
    config.add(:saml_secret_rotation_enabled, type: :boolean)
    config.add(:scrypt_cost, type: :string)
    config.add(:second_mfa_reminder_account_age_in_days, type: :integer)
    config.add(:second_mfa_reminder_sign_in_count, type: :integer)
    config.add(:secret_key_base, type: :string)
    config.add(:seed_agreements_data, type: :boolean)
    config.add(:service_provider_request_ttl_hours, type: :integer)
    config.add(:ses_configuration_set_name, type: :string)
    config.add(:session_check_delay, type: :integer)
    config.add(:session_check_frequency, type: :integer)
    config.add(:session_encryption_key, type: :string)
    config.add(:session_encryptor_alert_enabled, type: :boolean)
    config.add(:session_timeout_in_minutes, type: :integer)
    config.add(:session_timeout_warning_seconds, type: :integer)
    config.add(:session_total_duration_timeout_in_minutes, type: :integer)
    config.add(:show_unsupported_passkey_platform_authentication_setup, type: :boolean)
    config.add(:show_user_attribute_deprecation_warnings, type: :boolean)
    config.add(:short_term_phone_otp_max_attempts, type: :integer)
    config.add(:short_term_phone_otp_max_attempt_window_in_seconds, type: :integer)
    config.add(:sign_in_user_id_per_ip_attempt_window_exponential_factor, type: :float)
    config.add(:sign_in_user_id_per_ip_attempt_window_in_minutes, type: :integer)
    config.add(:sign_in_user_id_per_ip_attempt_window_max_minutes, type: :integer)
    config.add(:sign_in_user_id_per_ip_max_attempts, type: :integer)
    config.add(:sign_in_recaptcha_log_failures_only, type: :boolean)
    config.add(:sign_in_recaptcha_percent_tested, type: :integer)
    config.add(:sign_in_recaptcha_score_threshold, type: :float)
    config.add(:skip_encryption_allowed_list, type: :json)
    config.add(:recommend_webauthn_platform_for_sms_ab_test_account_creation_percent, type: :integer)
    config.add(:recommend_webauthn_platform_for_sms_ab_test_authentication_percent, type: :integer)
    config.add(:socure_document_request_endpoint, type: :string)
    config.add(:socure_enabled, type: :boolean)
    config.add(:socure_idplus_api_key, type: :string)
    config.add(:socure_idplus_base_url, type: :string)
    config.add(:socure_idplus_timeout_in_seconds, type: :integer)
    config.add(:socure_reason_code_api_key, type: :string)
    config.add(:socure_reason_code_base_url, type: :string)
    config.add(:socure_reason_code_timeout_in_seconds, type: :integer)
    config.add(:socure_standard_capture_desktop_enabled, type: :boolean)
    config.add(:socure_webhook_enabled, type: :boolean)
    config.add(:socure_webhook_secret_key, type: :string)
    config.add(:socure_webhook_secret_key_queue, type: :json)
    config.add(:sp_handoff_bounce_max_seconds, type: :integer)
    config.add(:sp_issuer_user_counts_report_configs, type: :json)
    config.add(:state_tracking_enabled, type: :boolean)
    config.add(:team_ada_email, type: :string)
    config.add(:team_all_login_emails, type: :json)
    config.add(:team_daily_fraud_metrics_emails, type: :json)
    config.add(:team_daily_reports_emails, type: :json)
    config.add(:team_monthly_fraud_metrics_emails, type: :json)
    config.add(:team_ursula_email, type: :string)
    config.add(:telephony_adapter, type: :string)
    config.add(:test_ssn_allowed_list, type: :comma_separated_string_list)
    config.add(:totp_code_interval, type: :integer)
    config.add(:unauthorized_scope_enabled, type: :boolean)
    config.add(:use_dashboard_service_providers, type: :boolean)
    config.add(:use_kms, type: :boolean)
    config.add(:use_vot_in_sp_requests, type: :boolean)
    config.add(:usps_auth_token_refresh_job_enabled, type: :boolean)
    config.add(:usps_confirmation_max_days, type: :integer)
    config.add(:usps_eipp_sponsor_id, type: :string)
    config.add(:usps_ipp_client_id, type: :string)
    config.add(:usps_ipp_password, type: :string)
    config.add(:usps_ipp_request_timeout, type: :integer)
    config.add(:usps_ipp_root_url, type: :string)
    config.add(:usps_ipp_sponsor_id, type: :string)
    config.add(:usps_ipp_transliteration_enabled, type: :boolean)
    config.add(:usps_ipp_username, type: :string)
    config.add(:usps_ipp_enrollment_status_update_email_address, type: :string)
    config.add(:usps_mock_fallback, type: :boolean)
    config.add(:usps_upload_enabled, type: :boolean)
    config.add(:usps_upload_sftp_directory, type: :string)
    config.add(:usps_upload_sftp_host, type: :string)
    config.add(:usps_upload_sftp_password, type: :string)
    config.add(:usps_upload_sftp_timeout, type: :integer)
    config.add(:usps_upload_sftp_username, type: :string)
    config.add(:valid_authn_contexts, type: :json)
    config.add(:valid_authn_contexts_semantic, type: :json)
    config.add(:vendor_status_lexisnexis_instant_verify, type: :symbol, enum: VENDOR_STATUS_OPTIONS)
    config.add(:vendor_status_lexisnexis_phone_finder, type: :symbol, enum: VENDOR_STATUS_OPTIONS)
    config.add(:vendor_status_lexisnexis_trueid, type: :symbol, enum: VENDOR_STATUS_OPTIONS)
    config.add(:vendor_status_sms, type: :symbol, enum: VENDOR_STATUS_OPTIONS)
    config.add(:vendor_status_voice, type: :symbol, enum: VENDOR_STATUS_OPTIONS)
    config.add(:vendor_status_idv_scheduled_maintenance_start, type: :string)
    config.add(:vendor_status_idv_scheduled_maintenance_finish, type: :string)
    config.add(:verification_errors_report_configs, type: :json)
    config.add(:verify_gpo_key_attempt_window_in_minutes, type: :integer)
    config.add(:verify_gpo_key_max_attempts, type: :integer)
    config.add(:verify_personal_key_attempt_window_in_minutes, type: :integer)
    config.add(:verify_personal_key_max_attempts, type: :integer)
    config.add(:version_headers_enabled, type: :boolean)
    config.add(:voice_otp_pause_time)
    config.add(:voice_otp_speech_rate)
    config.add(:vtm_url)
    config.add(:weekly_auth_funnel_report_config, type: :json)
  end.freeze
  # rubocop:enable Metrics/LineLength
  # rubocop:enable Metrics/BlockLength
end
