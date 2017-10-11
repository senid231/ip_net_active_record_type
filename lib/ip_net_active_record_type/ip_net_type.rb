require 'active_model/type/value'
require_relative 'ip_net'

module IpNetActiveRecordType
  class IpNetType < ActiveModel::Type::Value

    def cast_value(value)
      case value
        when IpNetActiveRecordType::IpNet
          value
        when IPAddr
          IpNetActiveRecordType::IpNet.from_ipaddr(value)
        else
          IpNetActiveRecordType::IpNet.new(value)
      end
    end

    def serialize(value)
      value.to_s
    end

  end
end