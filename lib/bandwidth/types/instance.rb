require 'active_support/core_ext/string/inflections'

module Bandwidth
  class Types
    module Instance
      def self.included base
        base.extend ClassMethods
        base.instance_variable_set :@attributes, {}
      end

      def initialize parsed_json
        attributes = self.class.instance_variable_get :@attributes
        attributes.each do |attribute, coercion|
          value = parsed_json[attribute.to_s.camelcase(:lower)]
          coerced = coerce value, coercion

          define_singleton_method attribute do
            coerced
          end
        end
      end

    protected
      def coerce value, coercion
        if coercion == nil
          value
        elsif coercion == Float
          value.to_f
        elsif coercion == Time
          Time.parse value
        end
      end

      module ClassMethods
        def attribute name, coercion = nil
          @attributes[name] = coercion
        end
      end
    end
  end
end