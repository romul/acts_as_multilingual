ActiveRecord::Schema.define(:version => 0) do
  create_table :test_posts, :force => true do |t|
    t.column :title_ml, :text
    t.column :body_ml, :text
  end
end

