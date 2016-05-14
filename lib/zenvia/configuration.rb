require 'base64'

module Zenvia
  class << self
    attr_reader :config

    def configure
      yield @config ||= Configuration.new
    end
  end

  class Configuration
    attr_accessor :account, :code

    def authorization
      Base64.strict_encode64 "#{@account}:#{@code}"
    end
  end
end
