"=============================================================================
" FILE: autoload/edgemotion.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8

let s:DIRECTION = { 'FORWARD': 1, 'BACKWARD': 0 }

function! edgemotion#move(dir) abort
  if mode(1) is# 'no'
    normal! V
  endif
  let next_cmd = a:dir is# s:DIRECTION.FORWARD ? 'gj' : 'gk'
  let prev_cmd = a:dir is# s:DIRECTION.FORWARD ? 'gk' : 'gj'
  let orig_col = virtcol('.')
  let last_line = line('.')
  while 1
    execute 'normal!' next_cmd
    if (virtcol('.') < orig_col) || (orig_col is# 1 && getline('.') ==# '')
      execute 'normal!' prev_cmd
      break
    elseif line('.') is# last_line
      break
    endif
    let last_line = line('.')
  endwhile
endfunction

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
