require 'opal-audio'

describe Audio::Node do
  #NOTE: let! doesn't work
  audio_context = Audio::Context.new

  describe 'reader methods' do
    let(:oscillator) { audio_context.oscillator }
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
    let(:biquad_filter) { audio_context.biquad_filter }

    it 'sets raw values' do
      expect { biquad_filter.detune = 2 }
        .to change { biquad_filter.detune }.from(0).to(2)
    end

    it 'also sets audioparam values' do
      expect do
        biquad_filter.frequency = audio_context.oscillator.frequency(false)
      end.to change { biquad_filter.frequency }.from(350).to(440)
    end
  end

  describe '#connect' do
    let(:base_node) { audio_context.gain }

    context 'for a node connection' do
      let(:destination) { audio_context.delay }

      before { base_node.connect destination }

      it 'sets the ouput for the base node' do
        expect(base_node.output).to eq destination
      end

      it 'sets the input for the destination node' do
        expect(destination.input).to eq base_node
      end
    end

    it 'connects a ParamSchedule and sets the output for the base node' do
      destination = audio_context.biquad_filter.frequency(false)

      expect { base_node.connect destination }
        .to change { base_node.output }.from(nil).to(destination)
    end

    it 'throws an error when connecting to a node from another context' do
      expect { base_node.connect(Audio::Context.new.gain) }
        .to raise_error(
          ArgumentError,
          'Destination must be from the same audio context'
        )
    end

    it 'throws an error when connecting to invalid objects' do
      Any = Class.new
      expect { base_node.connect(Any.new) }.to raise_error(
        ArgumentError,
        'Destination must be a Node or ParamSchedule'
      )
    end
  end

  describe '#disconnect' do
    let(:base_node) { audio_context.gain }

    context 'when disconnecting a node' do
      let(:destination) { audio_context.delay }

      before { base_node.connect destination }

      it 'erases the output for the base node' do
        expect { base_node.disconnect(destination) }
          .to change { base_node.output }.from(destination).to(nil)
      end

      it 'erases the input for the destination node' do
        expect { base_node.disconnect(destination) }
          .to change { destination.input }.from(base_node).to(nil)
      end
    end

    it 'disconnects from a ParamSchedule' do
      destination = audio_context.biquad_filter.frequency(false)
      base_node.connect destination

      expect { base_node.disconnect(destination) }
        .to change { base_node.output }.from(destination).to(nil)
    end

    it 'disconnects any connection' do
      destination = audio_context.delay
      base_node.connect(destination)

      expect { base_node.disconnect }
        .to change { base_node.output }.from(destination).to(nil)
    end
  end
end
