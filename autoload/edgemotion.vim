"=============================================================================
" FILE: autoload/edgemotion.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8

let s:DIRECTION = { 'FORWARD': 1, 'BACKWARD': 0 }

function! edgemotion#move(dir) abort
  if mode(1) is# 'v' || mode(1) is# 'V' || mode(1) is# 'CTRL_V'
    let is_visual = 1
  elseif mode(1) is# 'no'
    let is_visual = 0
    normal! V
  endif

  let virtualedit_save = &virtualedit
  let &virtualedit = ''
  try
    call s:edgemotion_internal(a:dir, is_visual)
  finally
    let &virtualedit = virtualedit_save
  endtry
endfunction

function! s:edgemotion_internal(dir, is_visual) abort
  let next_cmd = a:dir is# s:DIRECTION.FORWARD ? 'gj' : 'gk'
  let prev_cmd = a:dir is# s:DIRECTION.FORWARD ? 'gk' : 'gj'
  let orig_col = virtcol('.')
  call winrestview({'curswant': col('.') - 1})
  call s:move_to_edge(next_cmd, prev_cmd, orig_col, a:is_visual)
endfunction

function! s:move_to_edge(next_cmd, prev_cmd, orig_col, is_visual) abort
  let last_line = line('.')
  while 1
    if a:is_visual == 1
      execute a:next_cmd
    else
      execute 'normal!' a:next_cmd
    endif
    if (virtcol('.') < a:orig_col) || (a:orig_col is# 1 && getline('.') ==# '')
      if a:is_visual == 1
        execute a:prev_cmd
      else
        execute 'normal!' a:prev_cmd
      endif
      break
    elseif line('.') is# last_line
      break
    endif
    let last_line = line('.')
  endwhile
endfunction

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
