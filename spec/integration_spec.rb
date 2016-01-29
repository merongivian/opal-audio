require 'opal-audio'

describe Audio::Node do
  describe 'reader methods' do
    let(:oscillator) { Audio::Context.new.oscillator }
    let(:frequency) { oscillator.frequency }

    it 'returns a raw value' do
      expect(frequency).to be_a Number
    end

    context 'for audioparam values' do
      it 'returns audio params for especial values' do
        expect(oscillator.frequency false).to be_a Audio::ParamSchedule
      end

      it 'returns the same raw value' do
        expect(oscillator.frequency(false).to_f).to eq frequency
      end
    end
  end

  describe 'writer methods' do
    xit 'returns' do
      # expect(Audio::Context.dynamics_compressor.frequency(false).to_f).to eq frequency
    end
  end
end
