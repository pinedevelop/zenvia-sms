require 'spec_helper'

RSpec.describe Zenvia::Configuration do
  before :all do
    Zenvia.configure do |config|
      config.account = 'conta'
      config.code = 'senha'
    end
  end

  describe '#authorization' do
    subject { Zenvia.config.authorization }

    it { is_expected.to eq 'Y29udGE6c2VuaGE=' }
  end
end
