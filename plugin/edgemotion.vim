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

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
