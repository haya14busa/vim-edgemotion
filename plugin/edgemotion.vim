"=============================================================================
" FILE: plugin/edgemotion.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_edgemotion
endif
if exists('g:loaded_edgemotion')
  finish
endif
let g:loaded_edgemotion = 1

" Cancel the pending cmd and call Edgemotion with the old canceled cmd as an argument
nnoremap <silent><Plug>(edgemotion-j) <Esc>:<C-U>:call edgemotion#move('', 1)<CR>
nnoremap <silent><Plug>(edgemotion-k) <Esc>:<C-U>:call edgemotion#move('', 0)<CR>
xnoremap <silent><Plug>(edgemotion-j) <Esc>:<C-U>:call edgemotion#move(visualmode(), 1)<CR>
xnoremap <silent><Plug>(edgemotion-k) <Esc>:<C-U>:call edgemotion#move(visualmode(), 0)<CR>
onoremap <silent><Plug>(edgemotion-j) <Esc>:<C-U>:call edgemotion#move(v:operator, 1)<CR>
onoremap <silent><Plug>(edgemotion-k) <Esc>:<C-U>:call edgemotion#move(v:operator, 0)<CR>


" Global options definition.
let g:edgemotion#line_numbers_overwrite  = get(g:, 'edgemotion#line_numbers_overwrite',
      \ get(g:, 'edgemotion#line_numbers_overwrite', 0))
if g:edgemotion#line_numbers_overwrite
  if exists('*nvim_create_buf')
    autocmd! CursorHold * call edgemotion#cursor_move()
    autocmd! CursorMoved * call edgemotion#cursor_clean()
    autocmd! InsertLeave * call edgemotion#cursor_move()
  endif
endif

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
