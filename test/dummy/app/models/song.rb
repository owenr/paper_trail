# Example from 'Overwriting default accessors' in ActiveRecord::Base.
class Song < ActiveRecord::Base
  has_paper_trail
  attr_accessor :name

  # Uses an integer of seconds to hold the length of the song
  def length=(minutes)
    write_attribute(:length, minutes.to_i * 60)
  end
  def length
    read_attribute(:length) / 60
  end

  # override attributes hashes like some libraries do
  def attributes_with_name
    if name
      attributes_without_name.merge(:name => name)
    else
      attributes_without_name
    end
  end

  # `alias_method_chain` is deprecated in rails 5, but we cannot use the
  # suggested replacement, `Module#prepend`, because we still support ruby 1.9.
  alias_method :attributes_without_name, :attributes
  alias_method :attributes, :attributes_with_name

  def changed_attributes_with_name
    if name
      changed_attributes_without_name.merge(:name => name)
    else
      changed_attributes_without_name
    end
  end

  # `alias_method_chain` is deprecated in rails 5, but we cannot use the
  # suggested replacement, `Module#prepend`, because we still support ruby 1.9.
  alias_method :changed_attributes_without_name, :changed_attributes
  alias_method :changed_attributes, :changed_attributes_with_name
end
