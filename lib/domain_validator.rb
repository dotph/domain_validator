require 'active_model'

class DomainValidator < ActiveModel::EachValidator
  VERSION = '0.0.0'
  VALID_EXTENSIONS = ['ph', 'com.ph', 'net.ph', 'org.ph']
  RESTRICTED_EXTENSIONS = ['mil.ph', 'ngo.ph', 'edu.ph', 'gov.ph']

  def validate_each(record, attribute, value)
    unless valid? value
      record.errors[attribute] << (options[:message] || "is not a valid domain")
    end
  end

  def valid? domain_name
    return false if domain_name.blank?
    return false if VALID_EXTENSIONS.include? domain_name
    return false if RESTRICTED_EXTENSIONS.include? domain_name

    root_name = domain_name.split('.', 2)[0]
    extension = domain_name.split('.', 2)[1]

    return false if extension.blank?

    too_short = (root_name.length < 3)
    too_long = (root_name.length > 63)
    special_chars = (root_name =~ /^[a-zA-Z0-9-]*$/).nil?
    invalid_extension = (not VALID_EXTENSIONS.include? extension)
    numbers_only = !(root_name =~ /^[0-9]*$/).nil?
    starts_with_dash = !(root_name =~ /^-/).nil?
    double_dash = root_name.include? '--'

    not (too_short or too_long or special_chars or invalid_extension \
      or numbers_only or starts_with_dash or double_dash)
  end
end
