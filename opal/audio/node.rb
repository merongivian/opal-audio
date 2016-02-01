require 'audio/param_schedule'

module Audio
  module Node
    class Base
      include Native

      def initialize(audio_context)
        method_name = "create#{self.class.name.split('::').last}"
        super `#{audio_context.to_n}[#{method_name}]()`
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

      def connect(destination)
        `#@native.connect(#{Native.convert(destination)})`
      end

      def disconnect(destination = nil, options = {})
        destination = Native.try_convert(destination)
        output      = options[:output] || 0
        input       = options[:input]  || 0

        if options.any?
          `#@native.disconnect(#{destination}, #{output}, #{input}) || nil`
        elsif destination
          `#@native.disconnect(#{destination})`
        else
          `#@native.disconnect()`
        end
      end
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
