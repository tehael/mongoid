# encoding: utf-8
require "mongoid/matchers/default"
require "mongoid/matchers/all"
require "mongoid/matchers/exists"
require "mongoid/matchers/gt"
require "mongoid/matchers/gte"
require "mongoid/matchers/in"
require "mongoid/matchers/lt"
require "mongoid/matchers/lte"
require "mongoid/matchers/ne"
require "mongoid/matchers/nin"
require "mongoid/matchers/size"

module Mongoid #:nodoc:
  module Matchers
    # Determines if this document has the attributes to match the supplied
    # MongoDB selector. Used for matching on embedded associations.
    def matches?(selector)
      selector.each_pair do |key, value|
        return false unless matcher(key, value).matches?(value)
      end; true
    end

    protected
    # Get the matcher for the supplied key and value. Will determine the class
    # name from the key.
    def matcher(key, value)
      if value.is_a?(Hash) && /^\$(.+)/ =~ value.keys.first
        name = "Mongoid::Matchers::#{$1.camelize}"
        return name.constantize.new(expand_attribute(key))
      end
      Default.new(expand_attribute(key))
    end
    # Expand the attribute for given (period seperated) key. This is needed for (embedded)
    # documents with fields of type type Hash, and selector keys are trying to step into the hash.
    def expand_attribute(key)
      keys = key.to_s.split('.')
      attribute = attributes[keys[0]]
      attribute = keys[1..-1].inject(attribute) { |a, k| a = a ? a[k] : nil }
    end
  end
end
