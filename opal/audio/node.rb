require 'audio/param_schedule'

module Audio
  module Node
    class Base
      include Native

      alias_native :inputs_limit, :numberOfInputs
      alias_native :outputs_limit, :numberOfOutputs

      attr_reader :audio_context, :connections, :output, :input

      def initialize(audio_context)
        @audio_context = audio_context
        @input, @output = nil

        method_name = "create#{self.class.name.split('::').last}"
        super `#{@audio_context.to_n}[#{method_name}]()`
      end

      def method_missing(name, value = nil)
        if name.end_with? '='
          `#@native[#{name.delete '='}].value = #{value.to_f}`
        elsif value.nil? || value == true
          `#@native[#{name}].value`
        elsif value == false
          Audio::ParamSchedule.new(`#@native[#{name}]`)
        else
          super
        end
      end

      def respond_to_missing?(method, include_all = false)
        `#@native[#{method.delete('=')}] != null`
      end

      def connect(to)
        case to
        when Node::Base then node_connector(to)
        when ParamSchedule then connector(to)
        else `#@native.connect(#{Native.try_convert(to)})`
        end
      end

      def disconnect(destination = nil)
        `#@native.disconnect(#{Native.convert(destination)})`
        @output = nil

        if destination && destination.is_a?(Node::Base)
          destination.input = nil
        end
      end

      private

      def node_connector(node)
        if node.audio_context != @audio_context
          fail ArgumentError, 'Destination must be ' \
                              'from the same audio context'
        end

        connector(node)
        node.input = self
      end

      def connector(destination)
        `#@native.connect(#{Native.convert(destination)})`
        @output = destination
      end

      protected

      attr_writer :input
    end

    class Gain < Base
    end

    class Oscillator < Base
      TYPES = %i(sine square sawtooth triangle custom)

      alias_native :start
      alias_native :stop

      alias_native :periodic_wave=, :setPeriodicWave

      def type=(type)
        unless TYPES.include?(type)
          raise ArgumentError, "type #{type} doesn't exists"
        end

        `#@native.type =  type`
      end

      def type
        `#@native.type`
      end

      def when_finished(&block)
        `#@native.onended = block()`
      end
    end

    class Delay < Base
    end

    class DynamicsCompressor < Base
      alias_native :reduction
    end

    class BiquadFilter < Base

      TYPES = %i(lowpass highpass bandpass lowshelf highshelf peaking notch allpass)

      def type=(type)
        unless TYPES.include?(type)
          raise ArgumentError, "type #{type} doesn't exists"
        end

        `#@native.type =  type`
      end

      def type
        `#@native.type`
      end
    end

    class StereoPanner < Base
      alias_native :normalize
    end
  end
end
