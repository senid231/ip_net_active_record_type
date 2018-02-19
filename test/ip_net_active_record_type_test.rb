require 'test_helper'
require 'active_support/core_ext/hash/keys'

class IpNetActiveRecordTypeTest < Minitest::Test

  def assert_ip_net_to_s(input_string, expected_string)
    ip_net = IpNetActiveRecordType::IpNet.new(input_string)
    assert_equal expected_string, ip_net.to_s
  end

  def assert_equal_inspect_with_ipaddr(input_string)
    ip_net = IpNetActiveRecordType::IpNet.new(input_string)
    ip_net_inspect = ip_net.inspect.gsub(IpNetActiveRecordType::IpNet.to_s, IPAddr.to_s)
    ip_addr = IPAddr.new(input_string)
    assert_equal ip_addr.inspect, ip_net_inspect
  end

  def assert_ip_nets_equal(first_string, second_string)
    first_ip_net = IpNetActiveRecordType::IpNet.new(first_string)
    second_ip_net = IpNetActiveRecordType::IpNet.new(second_string)
    assert_equal first_ip_net, second_ip_net
  end

  def refute_ip_nets_equal(first_string, second_string)
    first_ip_net = IpNetActiveRecordType::IpNet.new(first_string)
    second_ip_net = IpNetActiveRecordType::IpNet.new(second_string)
    refute_equal first_ip_net, second_ip_net
  end

  def test_that_it_has_a_version_number
    refute_nil ::IpNetActiveRecordType::VERSION
  end

  def test_ipv4_to_s
    assert_ip_net_to_s '127.0.0.3/26', '127.0.0.0/26'
    assert_ip_net_to_s '10.0.0.4', '10.0.0.4/32'
    assert_ip_net_to_s '10.0.0.4/32', '10.0.0.4/32'
    assert_ip_net_to_s '127.0.0.4/1', '0.0.0.0/1'
    assert_ip_net_to_s '127.0.0.4/0', '0.0.0.0/0'
    assert_ip_net_to_s '127.45.23.67/27', '127.45.23.64/27'

    ip_net = IpNetActiveRecordType::IpNet.new('127.0.0.3/26')
    assert_equal ip_net.to_s(:ip_with_hex_mask), '127.0.0.0/255.255.255.192'
    assert_equal ip_net.to_s(:ip_with_int_mask), '127.0.0.0/26'
    assert_equal ip_net.to_s(:ip_only), '127.0.0.0'
  end

  def test_ipv4_equal_ipaddr
    assert_equal_inspect_with_ipaddr '127.0.0.3/26'
    assert_equal_inspect_with_ipaddr '10.0.0.4'
    assert_equal_inspect_with_ipaddr '10.0.0.4/32'
    assert_equal_inspect_with_ipaddr '127.0.0.4/1'
    assert_equal_inspect_with_ipaddr '127.0.0.4/0'
    assert_equal_inspect_with_ipaddr '127.45.23.67/27'
  end

  def test_ipv4_compare
    assert_ip_nets_equal '127.0.0.0/25', '127.0.0.0/25'
    assert_ip_nets_equal '127.0.0.3/26', '127.0.0.0/26'
    assert_ip_nets_equal '10.0.0.4', '10.0.0.4/32'
    assert_ip_nets_equal '10.0.0.4/32', '10.0.0.4/32'
    assert_ip_nets_equal '127.0.0.4/1', '0.0.0.0/1'
    assert_ip_nets_equal '127.0.0.4/0', '0.0.0.0/0'
    assert_ip_nets_equal '127.45.23.67/27', '127.45.23.64/27'

    refute_ip_nets_equal '127.0.0.0/25', '127.0.0.0/26'
    refute_ip_nets_equal '10.0.0.1/32', '10.0.0.1/31'
    refute_ip_nets_equal '10.0.0.3', '10.0.0.4'
  end

  def test_ipv6_to_s
    assert_ip_net_to_s '2001:db8:abcd:0012::0/64', '2001:0db8:abcd:0012:0000:0000:0000:0000/64'
    assert_ip_net_to_s '2001:0db8:abcd:0012:0000:0000:0000:0000/64', '2001:0db8:abcd:0012:0000:0000:0000:0000/64'
    assert_ip_net_to_s '2001:0db8:abcd:0012:0000:0000:0000:fa12', '2001:0db8:abcd:0012:0000:0000:0000:fa12/128'
    assert_ip_net_to_s '2001:0db8:abcd:0012:0000:0000:0000:fa12/128', '2001:0db8:abcd:0012:0000:0000:0000:fa12/128'
    assert_ip_net_to_s '2001:0db8:abcd:0012:0000:0000:0000:fa12/61', '2001:0db8:abcd:0010:0000:0000:0000:0000/61'
    assert_ip_net_to_s '001:0db8:abcd:0012:0000:0000:0000:fa12/1', '0000:0000:0000:0000:0000:0000:0000:0000/1'
    assert_ip_net_to_s '2001:0db8:abcd:0012:0000:0000:0000:fa12/0', '0000:0000:0000:0000:0000:0000:0000:0000/0'
    assert_ip_net_to_s '2001:0db8:abcd:0012:0000:0000:0000:fa12/124', '2001:0db8:abcd:0012:0000:0000:0000:fa10/124'

    ip_net = IpNetActiveRecordType::IpNet.new('2001:db8:abcd:0012::0/64')
    assert_equal ip_net.to_s(:ip_with_int_mask), '2001:0db8:abcd:0012:0000:0000:0000:0000/64'
    assert_equal ip_net.to_s(:ip_only), '2001:0db8:abcd:0012:0000:0000:0000:0000'

    assert_equal ip_net.to_s(:ip_with_hex_mask),
                 '2001:0db8:abcd:0012:0000:0000:0000:0000/ffff:ffff:ffff:ffff:0000:0000:0000:0000'
  end

  def test_ipv6_equal_ipaddr
    assert_equal_inspect_with_ipaddr '2001:db8:abcd:0012::0/64'
    assert_equal_inspect_with_ipaddr '2001:0db8:abcd:0012:0000:0000:0000:0000/64'
    assert_equal_inspect_with_ipaddr '2001:0db8:abcd:0012:0000:0000:0000:fa12'
    assert_equal_inspect_with_ipaddr '2001:0db8:abcd:0012:0000:0000:0000:fa12/128'
    assert_equal_inspect_with_ipaddr '2001:0db8:abcd:0012:0000:0000:0000:fa12/61'
    assert_equal_inspect_with_ipaddr '001:0db8:abcd:0012:0000:0000:0000:fa12/1'
    assert_equal_inspect_with_ipaddr '001:0db8:abcd:0012:0000:0000:0000:fa12/0'
    assert_equal_inspect_with_ipaddr '2001:0db8:abcd:0012:0000:0000:0000:fa12/124'
  end

  def test_ipv6_compare
    assert_ip_nets_equal '2001:db8:abcd:0012::0/64', '2001:0db8:abcd:0012:0000:0000:0000:0000/64'
    assert_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:0000/64', '2001:0db8:abcd:0012:0000:0000:0000:0000/64'
    assert_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:fa12', '2001:0db8:abcd:0012:0000:0000:0000:fa12/128'
    assert_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:fa12/128', '2001:0db8:abcd:0012:0000:0000:0000:fa12/128'
    assert_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:fa12/61', '2001:0db8:abcd:0010:0000:0000:0000:0000/61'
    assert_ip_nets_equal '001:0db8:abcd:0012:0000:0000:0000:fa12/1', '0000:0000:0000:0000:0000:0000:0000:0000/1'
    assert_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:fa12/0', '0000:0000:0000:0000:0000:0000:0000:0000/0'
    assert_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:fa12/124', '2001:0db8:abcd:0012:0000:0000:0000:fa10/124'

    refute_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:0000/64', '2001:0db8:abcd:0012:0000:0000:0000:0000/63'
    refute_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:fa10/124', '2001:0db8:abcd:0012:0000:0000:0000:fa12/128'
    refute_ip_nets_equal '2001:0db8:abcd:0012:0000:0000:0000:fa12', '2001:0db8:abcd:0012:0000:0000:0000:fa13'
  end

  def test_type
    type = IpNetActiveRecordType::IpNetType.new
    ip = '127.0.0.0/26'
    ip_net = IpNetActiveRecordType::IpNet.new(ip)
    ip_addr = IPAddr.new(ip)
    assert_equal ip, type.serialize(ip_net)
    assert_equal ip_net, type.deserialize(ip_addr)
    assert_equal ip_net, type.deserialize(ip)
    assert_equal ip_net, type.cast(ip_addr)
    assert_equal ip_net, type.cast(ip)
  end

  def test_type_incorrect_value
    type = IpNetActiveRecordType::IpNetType.new
    ip = 'test'
    assert_equal nil, type.cast(ip)
  end

end
