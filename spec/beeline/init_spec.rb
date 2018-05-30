require 'honeycomb/client'

RSpec.describe 'Honeycomb.init' do
  after { Honeycomb.reset }

  context 'with missing parameters' do
    it 'complains if writekey is unspecified' do
      expect { Honeycomb.init dataset: 'dummy_service' }.to raise_error(/writekey/i)
    end

    it 'complains if dataset is unspecified' do
      expect { Honeycomb.init writekey: 'dummy' }.to raise_error(/dataset/i)
    end
  end

  context 'with parameters specified explicitly' do
    it 'persists the writekey, service name and dataset' do
      Honeycomb.init writekey: 'dummy', service_name: 'test_service', dataset: 'my-test-service'

      expect(Honeycomb.service_name).to eq 'test_service'

      expect(Honeycomb.client).to_not be_nil
      expect(Honeycomb.client.writekey).to eq 'dummy'
      expect(Honeycomb.client.dataset).to eq 'my-test-service'
    end
  end

  context 'configured via environment' do
    after do
      ENV.delete 'HONEYCOMB_WRITEKEY'
      ENV.delete 'HONEYCOMB_SERVICE'
      ENV.delete 'HONEYCOMB_DATASET'
    end

    it 'picks up writekey, service name and dataset from the environment' do
      ENV['HONEYCOMB_WRITEKEY'] = 'fake'
      ENV['HONEYCOMB_SERVICE'] = 'pseudo_service'
      ENV['HONEYCOMB_DATASET'] = 'my-pseudo-service'

      Honeycomb.init

      expect(Honeycomb.client.writekey).to eq 'fake'
      expect(Honeycomb.service_name).to eq 'pseudo_service'
      expect(Honeycomb.client.dataset).to eq 'my-pseudo-service'
    end
  end

  context 'inferred parameters' do
    it 'infers service name from the dataset if not specified' do
      Honeycomb.init writekey: 'dummy', dataset: 'dummy_service'

      expect(Honeycomb.service_name).to eq 'dummy_service'
    end
  end
end
