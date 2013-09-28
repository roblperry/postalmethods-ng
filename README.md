postalmethods-ng
================

A Ruby wrapper for [PostalMethods](http://postalmethods.com/) SOAP API.

Unlike official postalmethods gem depending on abandoned soap4r library
postalmethods-ng built around Savon SOAP Client v2.

Installation
------------

Add this line to your application's Gemfile:

    gem 'postalmethods-ng'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install postalmethods-ng

Usage
-----

~~~
require 'postalmethods'

pmc = PostalMethods::Client.new(
  username: "username",
  password: "password"
)

letter_id = pmc.send_letter_and_address(
  file: "/path/to/file.pdf",
  description: "Sample letter",
  address: {
    attention_line_1: "John Doe",
    attention_line_2: "IT Department",
    company: "ACME Software",
    address_1: "123 Long Rd",
    address_2: "Unit 404",
    city: "Oblivion",
    state: "KS",
    postal_code: "55505",
    country: "United States of America"
  })

letter_status = pmc.get_status(letter_id)

puts letter_status.first[:description]
~~~

Contributing
------------

I've tried my best to make the library compact and simple whilst robust
and convenient to use, but you are more than welcomed to hack and patch it,
just don't forget to send pull requests to share your improvements.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
