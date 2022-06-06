# frozen_string_literal: true

# Datadog users
module Users
  def self.help
    <<~HELP
      Users:
        get user <>: fetch the user
    HELP
  end

  def get_user(name)
    DatadogAPIClient::V1::UsersAPI.new.get_user(name.first)
  end
end
