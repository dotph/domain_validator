require 'minitest_helper'
require 'domain_validator'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

class TestDomainValidator < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DomainValidator::VERSION
  end

  def test_it_validates_standard_domains
    assert domain_valid? 'dot.ph'
    assert domain_valid? 'dot.net.ph'
    assert domain_valid? 'dot.com.ph'
    assert domain_valid? 'dot.org.ph'
  end

  def test_it_invalidates_bad_formatting
    assert domain_invalid? 'dot'
    assert domain_invalid? '123.ph'
    assert domain_invalid? 'dot--dot.ph'
    assert domain_invalid? 'a.ph'
    assert domain_invalid? '-foobar'
    assert domain_invalid? 'thisisaverylongdomainnamethatshouldnotbevalidandifitdoesitshouldthrowanerror.ph'
  end

  def domain_valid? name
    d = Domain.new 
    d.name = name

    return d.valid?
  end

  def domain_invalid? name
    d = Domain.new 
    d.name = name

    return d.invalid?
  end
end

class Domain
  include ActiveModel::Validations

  attr_accessor :name

  validates :name, domain: true

end