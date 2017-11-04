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
  let orig_vcol = virtcol('.')
  let orig_col = col('.')

  let curswant = getcurpos()[4]
  if curswant > 100000
    call winrestview({'curswant': len(getline('.'))})
  endif

  let saveview = winsaveview()
  execute 'normal!' next_cmd
  let virtualedit_save = &virtualedit
  let &virtualedit = ''
  try
    let next_vcol = virtcol('.')
    call winrestview(saveview)
    if orig_vcol is# next_vcol
      call s:move_to_edge(next_cmd, prev_cmd, orig_vcol)
    else
      call s:move_to_next_edge(next_cmd, prev_cmd, orig_vcol)
    endif
  finally
    let &virtualedit = virtualedit_save
  endtry
endfunction

function! s:move_to_edge(next_cmd, prev_cmd, orig_vcol) abort
  while 1
    execute 'normal!' a:next_cmd
    if (virtcol('.') < a:orig_vcol) || (a:orig_vcol is# 1 && getline('.') ==# '')
      execute 'normal!' a:prev_cmd
      break
    elseif line('.') is# 1 || line('.') is# line('$')
      break
    endif
  endwhile
endfunction

function! s:move_to_next_edge(next_cmd, prev_cmd, orig_vcol) abort
  while 1
    execute 'normal!' a:next_cmd
    if (virtcol('.') >= a:orig_vcol) ||
    \  (a:orig_vcol is# 1 && getline('.') !=# '') ||
    \  (line('.') is# 1 || line('.') is# line('$'))
      break
    endif
  endwhile
endfunction

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
