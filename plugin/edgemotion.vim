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

noremap <silent><expr> <Plug>(edgemotion-j) edgemotion#move(1)
noremap <silent><expr> <Plug>(edgemotion-k) edgemotion#move(0)

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
