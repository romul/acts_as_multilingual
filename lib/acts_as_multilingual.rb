module Multilingual
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

	      languages.each do |lang|
	        define_method("#{method}_#{lang}") do |*args|
	          send("ml_#{method}")[lang]
	        end

	        define_method("#{method}_#{lang}=") do |value, *args|
	          ml_values = send "ml_#{method}"
	          ml_values[lang] = value
	          yml = options[:disable_url_encode] ?
	          		Multilingual.to_yml(ml_values, languages) :
	          		ml_values.to_yaml
	          send "#{method}_ml=", yml
	        end
	      end
	    end
    end
  end

  protected

    def self.to_yml(values, languages)
	    yaml = "--- \n"
	    languages.each do |lang|
	        yaml += ":#{lang}: " +
	        (values[lang] || '').gsub(/\n|\r/, '').gsub(':', '&#0058;') + "\n"
	    end
	    yaml + "\n"
	end
end

