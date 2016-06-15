scriptencoding utf-8
if exists('g:loaded_mdnl')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" markdown line break
inoremap <silent><buffer> <Plug>(mdnl_linebreak) <Esc>A<Space><Space><Esc>:call mdnl#add_new_line(1)<CR>A
" markdown new list item
inoremap <silent><buffer> <Plug>(mdnl_new_listitem) <ESC>:call mdnl#add_new_line(2)<CR>A

nnoremap <silent><buffer> <Plug>(mdnl_split_as_paragraph) i<Space><Space><CR><ESC>:call mdnl#add_new_line(3)<CR>
inoremap <silent><buffer> <Plug>(mdnl_split_as_paragraph) <Space><Space><CR><ESC>:call mdnl#add_new_line(3)<CR>A
nnoremap <silent><buffer> <Plug>(mdnl_split_as_list) i<CR><ESC>:call mdnl#add_new_line(4)<CR>
inoremap <silent><buffer> <Plug>(mdnl_split_as_list) <CR><ESC>:call mdnl#add_new_line(4)<CR>A

let g:loaded_mdnl = 1

let &cpo = s:save_cpo
unlet s:save_cpo
