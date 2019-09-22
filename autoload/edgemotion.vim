"=============================================================================
" FILE: autoload/edgemotion.vim
" AUTHOR: haya14busa
" License: MIT license
"
" TERMINOLOGY:
" - land: non-white code block.
" - shore: edge of land.
" - sea: white space.
"
" Visualization of code block:
" Code block regex: [^[:space:]][[:space:]]\ze[^[:space:]]\|[^[:space:]]
" :let @/ = '[^[:space:]][[:space:]]\ze[^[:space:]]\|[^[:space:]]' | set hls
"=============================================================================
scriptencoding utf-8

let s:DIRECTION = { 'FORWARD': 1, 'BACKWARD': 0 }
let s:floating_win_ids = []

function! edgemotion#cursor_clean() abort
  call map(s:floating_win_ids, 'nvim_win_close(v:val, v:false)')
  let s:floating_win_ids = []
endfunction

function! edgemotion#cursor_move() abort
  if &number == 0
    return
  endif
  call edgemotion#cursor_clean()
  call s:line_numbers_display()
endfunction

function! s:line_numbers_display()
  call s:line_numbers(-1)
  call s:line_numbers(1)
endfunction

function! edgemotion#move(op, dir) abort
  let cnt = v:prevcount " get count of the previous command.
  if cnt == 0
    let cnt += 1
  endif

  let delta = a:dir is# s:DIRECTION.FORWARD ? 1 : -1
  let curswant = getcurpos()[4]
  if curswant > 100000
    call winrestview({'curswant': len(getline('.'))-1})
  endif
  let vcol = virtcol('.')
  let orig_lnum = line('.')

  let lnum = orig_lnum
  let last_lnum = line('$')

  let c = 1
  while c <= cnt

    let island_start = s:island(lnum, vcol)
    let island_next = s:island(lnum + delta, vcol)

    let should_move_to_land = !(island_start && island_next)

    if should_move_to_land
      if (island_start && !island_next)
        let lnum += delta
      endif
      while lnum != 0 && lnum <= last_lnum && !s:island(lnum, vcol)
        let lnum += delta
      endwhile
    else
      while lnum != 0 && lnum <= last_lnum && s:island(lnum, vcol)
        let lnum += delta
      endwhile
      let lnum -= delta
    endif

    let c += 1
  endwhile

  " Edge not found.
  if lnum == 0 || lnum == last_lnum + 1
    return
  endif

  let move_cmd = a:dir is# s:DIRECTION.FORWARD ? 'j' : 'k'

  " Visual mode
  let is_v = a:op =~# "^[vV\<C-v>]"
  if is_v
    norm! gv
    call feedkeys(abs(lnum-orig_lnum) . move_cmd, 'nt')
    return ''
  endif

  call feedkeys(a:op. abs(lnum-orig_lnum) . move_cmd, 'nt')
endfunction

function! s:island(lnum, vcol) abort
  let c = s:get_virtcol_char(a:lnum, a:vcol)
  if c ==# ''
    return 0
  endif
  if !s:iswhite(c)
    return 1
  endif
  let pattern = printf('^.\{-}\zs.\%%<%dv.\%%>%dv.', a:vcol+1, a:vcol)
  let m = matchstr(getline(a:lnum), pattern)
  let chars = split(m, '\zs')
  if len(chars) !=# 3
    return 0
  endif
  return !s:iswhite(chars[0]) && !s:iswhite(chars[2])
endfunction

function! s:iswhite(str) abort
  return a:str =~# '^[ \t]$'
endfunction

function! s:get_virtcol_char(lnum, vcol) abort
  let pattern = printf('^.\{-}\zs\%%<%dv.\%%>%dv', a:vcol+1, a:vcol)
  return matchstr(getline(a:lnum), pattern)
endfunction

" Same loop as above but displays in the line number the edge value (using nvim_open_win)
function! s:line_numbers(delta) abort
  let delta = a:delta
  let vcol = virtcol('.')
  let orig_lnum = line('.')

  let lnum = orig_lnum
  let last_lnum = line('w$') " last line visible in current window
  let first_lnum = line('w0') " last line visible in current window

  let c = 1
  while c <= 20

    let island_start = s:island(lnum, vcol)
    let island_next = s:island(lnum + delta, vcol)

    let should_move_to_land = !(island_start && island_next)

    if should_move_to_land
      if (island_start && !island_next)
        let lnum += delta
      endif
      while lnum != 0 && lnum <= last_lnum && !s:island(lnum, vcol)
        let lnum += delta
      endwhile
    else
      while lnum != 0 && lnum <= last_lnum && s:island(lnum, vcol)
        let lnum += delta
      endwhile
      let lnum -= delta
    endif


    " Edge not found.
    if lnum == 0 || lnum == last_lnum + 1 || lnum < first_lnum
      return
    endif

    let first_visible_line = line('w0')

    let s:floating_buf = nvim_create_buf(v:false, v:true)


    call nvim_buf_set_lines(s:floating_buf, 0, -1, v:true, [(c < 10 ? ' ': '').c])
    let opts = {'relative': 'win', 'width': 2,
          \ 'height': 1, 'col': s:gutterpadding()-1,
          \ 'row': lnum - first_visible_line}
    let s:win = nvim_open_win(s:floating_buf, 0, opts)
    call add(s:floating_win_ids, s:win)

    call nvim_win_set_option(s:win, 'number', v:false)
    call nvim_win_set_option(s:win, 'relativenumber', v:false)
    call nvim_win_set_option(s:win, 'cursorline', v:false)
    call nvim_win_set_option(s:win, 'cursorcolumn', v:false)
    call nvim_win_set_option(s:win, 'colorcolumn', '')
    call nvim_win_set_option(s:win, 'conceallevel', 2)
    call nvim_win_set_option(s:win, 'signcolumn', "no")
    call nvim_win_set_option(s:win, 'winhl', 'Normal:CursorLineNr')

    call nvim_buf_set_option(s:floating_buf, "buftype", "nofile")
    call nvim_buf_set_option(s:floating_buf, "bufhidden", "delete")

    let c += 1

  endwhile
endfunction

" from wincent dotfiles
function! s:gutterpadding() abort
  let l:signcolumn=0
  if exists('+signcolumn')
    if &signcolumn == 'yes'
      let l:signcolumn=2
    elseif &signcolumn == 'auto'
      let l:signs=execute('sign place buffer=' .bufnr('%'))
      if match(l:signs, 'line=') != -1
        let l:signcolumn=2
      endif
    endif
  endif

  let l:minwidth=2
  let l:gutterWidth=max([strlen(line('$')) , &numberwidth, l:minwidth]) + l:signcolumn
  return l:gutterWidth-2
endfunction

" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
