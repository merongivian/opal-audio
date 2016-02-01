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

  describe '#connect' do
    xit 'connects to a node' do
      audio_context = Audio::Context.new

      oscillator_node = audio_context.oscillator
      delay_node      = audio_context.delay

      expect { oscillator_node.connect delay_node }
        .to change { oscillator_node.inputs_quantity }.from(0).to(1)
    end

    it 'throws an error when connecting to a node from another context' do
      base_node = Audio::Context.new.oscillator
      node_from_other_context = Audio::Context.new.gain

      expect { base_node.connect node_from_other_context }
        .to raise_error(
          ArgumentError,
          'Destination node must be from the same audio context'
        )
    end

    xit 'connects to an audio param' do
    end
  end

  describe '#disconnect' do
    describe 'with a destination node' do
      xit'disconnects from it' do
      end

      xit'disconnects from a node with an especific output index' do
      end

      xit'disconnects from a node with an especific output and input index' do
      end
    end

    xit'disconnects from all available connections' do
    end
  end
end
