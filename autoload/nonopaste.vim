"=============================================================================
" File        : nonopaste.vim
" Author      : Kohei Hasegawa <ameutau@gmail.com>
" WebPage     : http://github.com/banyan/nonopaste.vim
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be
"     included in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
"     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
"     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
"     LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
"     OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
"     WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:nonopaste_nick')
  let g:nonopaste_nick = system("id -un")
endif

if !exists('g:nonopaste_url')
  let g:nonopaste_url = "http://www.kazeburo.dotcloud.com"
endif

function! s:get_browser_command()
  let nonopaste_browser_command = get(g:, 'nonopaste_browser_command', '')
  if nonopaste_browser_command == ''
    if has('win32') || has('win64')
      let nonopaste_browser_command = '!start rundll32 url.dll,FileProtocolHandler %URL%'
    elseif has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin'
      let nonopaste_browser_command = 'open %URL%'
    elseif executable('xdg-open')
      let nonopaste_browser_command = 'xdg-open %URL%'
    elseif executable('firefox')
      let nonopaste_browser_command = 'firefox %URL% &'
    else
      let nonopaste_browser_command = ''
    endif
  endif
  return nonopaste_browser_command
endfunction

function! s:open_browser(location)
  let cmd = s:get_browser_command()
  if len(cmd) == 0
    redraw
    echohl WarningMsg
    echo "It seems that you don't have general web browser. Open URL below."
    echohl None
    echo a:location
    return
  endif
  if cmd =~ '^!'
    let cmd = substitute(cmd, '%URL%', '\=shellescape(a:location)', 'g')
    silent! exec cmd
  elseif cmd =~ '^:[A-Z]'
    let cmd = substitute(cmd, '%URL%', '\=a:location', 'g')
    exec cmd
  else
    let cmd = substitute(cmd, '%URL%', '\=shellescape(a:location)', 'g')
    call system(cmd)
  endif
endfunction

function! nonopaste#Nonopaste(count, line1, line2, ...)
  let s:curl_cmd = 'curl -i'
  let s:url      = g:nonopaste_url . "/add"
  let body       = join(getline(a:line1, a:line2), "\n")
  let nick       = g:nonopaste_nick

  " escape quotation
  let body = substitute(body, '"', '\\"', "g")

  let post_data = ' --form-string "nick=' . nick . '"'
                  \ . ' --form-string "body=' . body . '"'

  let confirm = input("Are you sure to post? [" . s:url . "] (y/n [n]): ")
  if confirm != "y"
    echo ""
    return
  endif
  let cmd = s:curl_cmd . ' ' . post_data . ' ' . s:url

  echon 'Posting it to nonopaste... '

  let res      = system(cmd)
  let headers  = split(res, '\(\r\?\n\|\r\n\?\)')
  let location = matchstr(headers, '^Location: ')
  let location = substitute(location, '^[^:]\+: ', '', '')
  if len(location) > 0
    redraw
    if (has('clipboard'))
      let @*=location
    endif
    echomsg 'Done: ' . location

    if get(g:, 'nonopaste_open_browser_after_post', 0) == 1
      call s:open_browser(location)
    endif

  else
    let message = matchstr(headers, '^Status: ')
    let message = substitute(message, '^[^:]\+: [0-9]\+ ', '', '')
    echohl ErrorMsg | echomsg 'Post failed: ' . message | echohl None
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: set et:
" vim: foldmethod=marker
