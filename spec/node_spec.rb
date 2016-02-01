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
    let(:biquad_filter) { Audio::Context.new.biquad_filter }

    it 'sets raw values' do
      expect { biquad_filter.detune = 2 }
        .to change { biquad_filter.detune }.from(0).to(2)
    end

    it 'also sets audioparam values' do
      expect do
        biquad_filter.frequency = Audio::Context.new.oscillator.frequency(false)
      end.to change { biquad_filter.frequency }.from(350).to(440)
    end
  end
end
