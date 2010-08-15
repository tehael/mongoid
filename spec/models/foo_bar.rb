class Foo
  include Mongoid::Document
  field :translated_name, :type => Hash

  embeds_many :bars
end

class Bar
  include Mongoid::Document
  field :translated_name, :type => Hash

  embedded_in :foo, :inverse_of => :bars
end