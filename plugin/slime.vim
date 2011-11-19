" Vim Slime
" =========

" {{{ User configurable keys
if !exists('g:vimSlimeSendKey')
  let g:vimSlimeSendKey = '<C-c><C-c>'
endif

if !exists('g:vimSlimeSetupKey')
  let g:vimSlimeSetupKey = '<C-c>v'
endif
" }}}

" {{{ Map keys to proper function calls
execute 'vmap ' . g:vimSlimeSendKey . " \"ry:call <SID>Send_to_Screen(@r)<CR>"
execute 'nmap ' . g:vimSlimeSendKey . " vip" . g:vimSlimeSendKey
execute 'nmap ' . g:vimSlimeSetupKey . " :call <SID>Screen_Vars()<CR>"
" }}}

if exists('g:loaded_VimSlime')
  finish
endif
let g:loaded_VimSlime = 1

" {{{ Core
function! s:Send_to_Screen(text)
  if !exists("b:slime")
    call s:Screen_Vars()
  end

  let escaped_text = substitute(shellescape(a:text), "\\\\\n", "\n", "g")
  call system("screen -S " . b:slime["sessionname"] . " -p " . b:slime["windowname"] . " -X stuff " . escaped_text)
endfunction

" Leave this function exposed as it's called outside the plugin context
function! Screen_Session_Names(A,L,P)
  return system("screen -ls | awk '/Attached/ {print $1}'")
endfunction

function! s:Screen_Vars()
  if !exists("b:slime")
    let b:slime = {"sessionname": "", "windowname": "0"}
  end

  let b:slime["sessionname"] = input("session name: ", b:slime["sessionname"], "custom,Screen_Session_Names")
  let b:slime["windowname"]  = input("window name: ", b:slime["windowname"])
endfunction
" }}}
