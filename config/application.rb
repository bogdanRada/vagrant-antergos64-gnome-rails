# frozen_string_literal: false
require File.expand_path('../boot', __FILE__)

require 'rails/all'
# Pick the frameworks you want:
# require "rails/test_unit/railtie"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  # base class used for configuring the app
  class Application < Rails::Application

    I18n.enforce_available_locales = false

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Eastern Time (US & Canada)'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    config.action_dispatch.default_headers = {
      'X-UA-Compatible' => 'IE=edge,chrome=1'
    }

    # Temporary set as rails did not work on one of servers
    config.middleware.delete Rack::Lock

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
