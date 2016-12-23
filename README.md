# Opto/Task

[![Build Status](https://travis-ci.org/kontena/opto-task.svg?branch=master)](https://travis-ci.org/kontena/opto-task)

Uses [Opto](https://github.com/kontena/opto/) based [Opto/Model](https://github.com/kontena/opto-model/) to create [Mutations](https://github.com/cypriss/mutations) kind of runnable tasks or service objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opto-task'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opto-task

## Usage

You can define tasks:

```ruby
require 'opto-task'

class RemoveFileTask
  include Opto.task

  attribute :path, :string

  def validate
    add_error :path, :not_found, "The file isn't there" unless File.exist?(Path)
  end

  def perform
    begin
      File.unlink(path)
      "great success"
    rescue Errno::EACCES
      add_error :path, :no_access, "You don't have the rights"
    end
  end

  def after
    puts "Your file will be missed"
  end
end
```

And then run them:

```ruby
task = RemoveFileTask.new(path: '/tmp/foo.txt')
result = task.run
result.success?
=> true
result.outcome
=> "great success"
```

..unless they're not valid:

```ruby
task = RemoveFileTask.new(path: '/tmp/foobar.txt')
task.valid?
=> false
result = task.run
result.success?
=> false
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/opto-task.

