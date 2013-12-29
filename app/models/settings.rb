require 'settingslogic'

class Settings < Settingslogic
  source "#{Rails.root}/config/settings/application.yml"
  namespace Rails.env
  suppress_errors Rails.env.production?
end