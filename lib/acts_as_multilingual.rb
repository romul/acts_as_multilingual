module Multilingual
  require 'ya2yaml'

  mattr_accessor :languages

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_multilingual(fields_array, options = {})
		  languages = Multilingual.languages
      languages = options[:languages] if options[:languages]

	    fields_array.each do |method|
		  method = method.to_s
	      define_method("ml_#{method}") do |*args|
	        yml = YAML.load(send("#{method}_ml").to_s)
	        yml ||= {}
	        languages.each { |lang| yml[lang] ||= "" }
	        yml
	      end

	      define_method(method) do |*args|
	        send("ml_#{method}")[I18n.locale.to_sym]
	      end

        define_method("#{method}=") do |value, *args|
          ml_values = send "ml_#{method}"
          ml_values[I18n.locale.to_sym] = value
          yml = ml_values.ya2yaml
          send "#{method}_ml=", yml
        end

	      languages.each do |lang|
	        define_method("#{method}_#{lang}") do |*args|
	          send("ml_#{method}")[lang]
	        end

	        define_method("#{method}_#{lang}=") do |value, *args|
	          ml_values = send "ml_#{method}"
	          ml_values[lang] = value
            yml = ml_values.ya2yaml
	          send "#{method}_ml=", yml
	        end
	      end
	    end
    end
  end

end

