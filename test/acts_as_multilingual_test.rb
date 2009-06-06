require File.dirname(__FILE__) + '/test_helper.rb'

class TestPost < ActiveRecord::Base
  acts_as_multilingual [:title, :body], :languages => [:en, :ru]
end

class ActsAsMultilingualTest < ActiveSupport::TestCase
  load_schema

  def test_schema_has_loaded_correctly
    assert_equal [], TestPost.all
  end

  def test_add_methods
    p = TestPost.new
    [:title, :title_ru, :title_en, :title_ru=, :title_en=, :ml_title,
    :body, :body_ru, :body_en, :body_ru=, :body_en=, :ml_body].
    each do |method|
    	assert_equal true, p.respond_to?(method)
	end
  end

  def test_empty_initialize
    p = TestPost.new
    [:title, :title_ru, :title_en, :body, :body_ru, :body_en].each do |method|
  	  assert_equal "", p.send(method)
 	end
  end

  def test_assignment
    p = TestPost.new(:title_ru => "Заголовок", :title_en => "Title",
    			 :body_ru => "Содержимое", :body_en => "Content")

    assert_equal "Title", p.title_en
    assert_equal "Content", p.body_en
    assert_equal "Заголовок", p.title_ru
    assert_equal "Содержимое", p.body_ru

    I18n.locale = 'en'
    assert_equal p.title_en, p.title
    assert_equal p.title_en, p.ml_title[:en]
    assert_equal p.body_en, p.body
    assert_equal p.body_en, p.ml_body[:en]

    I18n.locale = 'ru'
    assert_equal p.title_ru, p.title
    assert_equal p.title_ru, p.ml_title[:ru]
    assert_equal p.body_ru, p.body
    assert_equal p.body_ru, p.ml_body[:ru]
  end

end

