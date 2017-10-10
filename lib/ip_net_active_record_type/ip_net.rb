require 'ipaddr'

module IpNetActiveRecordType
  class IpNet < ::IPAddr
    attr_reader :mask_addr, :addr

    def self.unmask(mask_addr, family)
      len = family == Socket::AF_INET ? 32 : 128
      mask_len = (0...len).detect { |i| (mask_addr & (2**i)) > 0 }
      mask_len.nil? ? 0 : (len - mask_len)
    end

    def self.from_ipaddr(ip_addr)
      return nil unless ip_addr.is_a?(IPAddr)
      mask = ip_addr.send :_to_string, ip_addr.instance_variable_get(:@mask_addr)
      self.new("#{ip_addr.to_s}/#{mask}")
    end

    def ==(other)
      other = coerce_other(other)
      addr == other.addr && family == other.family && mask_addr == other.mask_addr
    end

    def to_s(type = :ip_with_int_mask)
      case type
        when :ip_with_int_mask
          sprintf('%s/%d', ip, int_mask)
        when :ip_with_hex_mask
          sprintf('%s/%s', ip, hex_mask)
        else
          ip
      end
    end

    def int_mask
      self.class.unmask(@mask_addr, @family)
    end

    def hex_mask
      _to_string(@mask_addr)
    end

    def ip
      _to_string(@addr)
    end

    private

    def coerce_other(other)
      case other
        when IpNetActiveRecordType::IpNet
          other
        when IPAddr
          self.class.from_ipaddr(other)
        when String
          self.class.new(other)
        else
          self.class.new(other, @family)
      end
    end

  end
end