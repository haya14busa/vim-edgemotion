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

noremap <silent> <Plug>(edgemotion-j) :<C-u>call edgemotion#move(1)<CR>
noremap <silent> <Plug>(edgemotion-k) :<C-u>call edgemotion#move(0)<CR>

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
