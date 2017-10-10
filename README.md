# IpNetActiveRecordType

Allows to use `inet` type correctly with `ActiveRecord`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ip_net_active_record_type'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ip_net_active_record_type

## Usage

```ruby
class Client < ActiveRecord::Base
  attribute :ip_sub_net, IpNetActiveRecordType::IpNetType.new
end

c = Client.create! ip_sub_net: '127.0.0.0/26'
c.ip_sub_net = '127.0.0.0/25'
c.attribute_changed?(:ip_sub_net) # true
c.save!
ip_net = Client.find(c.id).ip_sub_net
ip_net.to_s # 127.0.0.0/26
ip_net.to_s(:ip_with_hex_mask) # 127.0.0.0/255.255.255.192
ip_net.to_s(:ip_only) # 127.0.0.0
```

## Development

After checking out the repo, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, 
which will create a git tag for the version, push git commits and tags, 
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/senid231/ip_net_active_record_type. 
This project is intended to be a safe, welcoming space for collaboration, 
and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the IpNetActiveRecordType project’s codebases, issue trackers, 
chat rooms and mailing lists is expected to follow the 
[code of conduct](https://github.com/[USERNAME]/ip_net_active_record_type/blob/master/CODE_OF_CONDUCT.md).
