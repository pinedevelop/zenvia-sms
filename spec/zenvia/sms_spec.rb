require 'spec_helper'

RSpec.describe Zenvia::SMS do
  before :each do
    allow(Zenvia).to receive(:config)
      .and_return(instance_double(Zenvia::Configuration, authorization: 'AUTH'))
  end

  it 'has a version number' do
    expect(Zenvia::SMS::VERSION).not_to be nil
  end

  context 'sending sms' do
    let(:sms) do
      described_class.new from: 'Gem',
                          to: '5511999999999',
                          message: 'Hello World!',
                          callback: true,
                          id: '12345',
                          aggregate_id: '98765'
    end

    let(:json_request) do
      {
        sendSmsRequest: {
          from: 'Gem',
          to: '5511999999999',
          schedule: nil,
          msg: 'Hello World!',
          callbackOption: true,
          id: '12345',
          aggregateId: '98765'
        }
      }.to_json
    end

    let(:json_response) do
      {
        sendSmsResponse: {
          statusCode: '00',
          statusDescription: 'Ok',
          detailCode: '000',
          detailDescription: 'Message Sent'
        }
      }.to_json
    end

    let(:json_error_response) do
      {
        sendSmsResponse: {
          statusCode: '10',
          statusDescription: 'SomeError',
          detailCode: '999',
          detailDescription: 'Detailed error reason'
        }
      }.to_json
    end

    describe '.to_zenvia' do
      subject { described_class.to_zenvia('endpoint', json_request) }

      it 'posts the request to Zenvia endpoint' do
        expect(RestClient).to receive(:post)
          .with('https://api-rest.zenvia360.com.br/services/endpoint',
                json_request, Zenvia::SMS.default_headers).and_return(json_response)
        subject
      end

      it 'raises error when response statusCode != ok' do
        expect(RestClient).to receive(:post)
          .with('https://api-rest.zenvia360.com.br/services/endpoint',
                json_request, Zenvia::SMS.default_headers).and_return(json_error_response)
        expect(Zenvia::SMS::Error).to receive(:new).with(:error, :unknown_error, 'Detailed error reason')
          .and_call_original
        expect { subject }.to raise_error Zenvia::SMS::Error, 'Detailed error reason'
      end
    end

    describe '.default_headers' do
      subject { described_class.default_headers }
      let(:headers) do
        {
          content_type: 'application/json',
          authorization: 'Basic AUTH',
          accept: 'application/json'
        }
      end

      it { is_expected.to eq headers }
    end

    describe '#deliver' do
      subject { sms.deliver }

      it 'does call .to_zenvia with the right args' do
        expect(Zenvia::SMS).to receive(:to_zenvia)
          .with('send-sms', json_request).and_return(json_response)
        subject
      end
    end

    describe '#schedule' do
      subject { sms.schedule(schedule_time) }
      let(:schedule_time) { Time.now }
      let(:json_request) do
        {
          sendSmsRequest: {
            from: 'Gem',
            to: '5511999999999',
            schedule: schedule_time.iso8601[0, 19],
            msg: 'Hello World!',
            callbackOption: true,
            id: '12345',
            aggregateId: '98765'
          }
        }.to_json
      end

      it 'does call .to_zenvia with the right args' do
        expect(Zenvia::SMS).to receive(:to_zenvia)
          .with('send-sms', json_request).and_return(json_response)
        subject
      end
    end
  end
end
