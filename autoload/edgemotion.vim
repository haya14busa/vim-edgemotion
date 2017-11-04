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
  let virtualedit_save = &virtualedit
  let &virtualedit = ''
  try
    call s:edgemotion_internal(a:dir)
  finally
    let &virtualedit = virtualedit_save
  endtry
endfunction

function! s:edgemotion_internal(dir) abort
  let next_cmd = a:dir is# s:DIRECTION.FORWARD ? 'gj' : 'gk'
  let prev_cmd = a:dir is# s:DIRECTION.FORWARD ? 'gk' : 'gj'
  let orig_col = virtcol('.')
  call winrestview({'curswant': col('.') - 1})
  call s:move_to_edge(next_cmd, prev_cmd, orig_col)
endfunction

function! s:move_to_edge(next_cmd, prev_cmd, orig_col) abort
  let last_line = line('.')
  while 1
    execute 'normal!' a:next_cmd
    if (virtcol('.') < a:orig_col) || (a:orig_col is# 1 && getline('.') ==# '')
      execute 'normal!' a:prev_cmd
      break
    elseif line('.') is# last_line
      break
    endif
    let last_line = line('.')
  endwhile
endfunction

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
