# frozen_string_literal: true

# Datadog api and app keys
module Keys
  def self.help
    <<~HELP
      api key <"value"|field_name> <string>: Fetch api keys by field
      api keys: Fetch all api key names
    HELP
  end

  def all_api_keys
    DatadogAPIClient::V1::KeyManagementAPI.new.list_api_keys.api_keys
  end

  def api_key(args)
    type = args[0].to_sym
    target = args[1]
    if type == :value
      all_api_keys.select { |k| k.key =~ /#{target}$/ }
    else
      all_api_keys.select { |k| k.send(type).eql? target }
    end.each { |k| puts "#{k.name}: #{k.key}" }
  end

  def api_keys
    keys = all_api_keys
    keys.map { |k| k.name.to_s }
  end
end
