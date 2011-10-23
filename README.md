Nonopaste.vim
========

This is a vimscript for creating nonopaste ( http://www.kazeburo.dotcloud.com ).

For the latest version please see https://github.com/banyan/nonopaste.vim

Usage:
------

- Post current buffer to nonopaste

        :Nonopaste

- Post selected text to nonopaste

        :'<,'>Nonopaste

Options:
------

You can use options, write it to .vimrc.

Set nickname, if you want to change nickname.
default nickname is `id -un` which is equivalent to `whoami`.

    let g:nonopaste_nick = "foobar"

Set url, if you want to change url to post.
default url is "http://www.kazeburo.dotcloud.com".

    let g:nonopaste_url = "http://nonopaste.local"

Requirements:
--------

- curl command (http://curl.haxx.se/)

License:
--------

    MIT license
    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Install:
--------

Copy it to your plugin and autoload directory.
