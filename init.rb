require File.dirname(__FILE__) + '/lib/acts_as_multilingual'
Multilingual.languages = [:ru, :en]
ActiveRecord::Base.send :include, Multilingual

