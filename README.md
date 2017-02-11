# XCProvisioner

XCProvisioner allows you to achieve the best of both worlds: to have Xcode Automatic signing while writing code and fine-grained control over the provisioning in CI.


## Motivation

Automatic signing (in Xcode 8) works great locally, on developer's machine, but it doesn't handle very well CI environments.

If you have set Automatic signing for your project and you try to explicitly specify a provisioning profile (for an AdHoc build, for example) to `xcodebuild` then you get this error:
> XXX does not support provisioning profiles. XXX does not support provisioning profiles, but provisioning profile YYY has been manually specified. Set the provisioning profile value to "Automatic" in the build settings editor.

You can only disable Automatic signing in Xcode (manually). Apple doesn't provide any solution to disable Automatic signing from a script.
Because of this, you have to give up on Automatic signing, which is a pity.

Here is where XCProvisioner comes handy. It allows you to use Automatic signing while developing locally, and switch to Manual signing and set the provisioning profile specifier for the targets that requires special signing care.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xcprovisioner'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xcprovisioner

## Usage
```sh
xcprovisioner \
--project YourProject.xcodeproj \
--target TargetName \
--configuration Release \
--specifier 'Your Project AppStore Profile'
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

