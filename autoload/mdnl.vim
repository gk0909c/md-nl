" create markdown new line
" mode
"   1: markdown line brean(add two space to temporary line end)
"   2: create new list item
function! mdnl#add_new_line(mode)
  let line = line('.')
  let first_char = s:get_first_char(line)

  if a:mode == 1
    let line_str = s:get_next_indent(line, first_char)
  else
    let line_str = s:get_new_listitem(line, first_char)
  endif

  call append(line, line_str)
  call cursor(line + 1, 0)
endfunction

" get new line indent
function! s:get_next_indent(line, first_char)
  let indent_str = repeat(' ', shiftwidth())
  let tmp_indent = repeat(' ', indent(a:line))
  
  if s:is_markdown_list_prefix(a:first_char)
    return tmp_indent . indent_str
  endif

  return tmp_indent
endfunction

" get new list item
function! s:get_new_listitem(line, first_char)
  let tmp_indent_size = indent(a:line)

  if s:is_markdown_list_prefix(a:first_char)
    let first_char = a:first_char
  else
    let start_line = s:search_paragraph_startline(tmp_indent_size, a:line)
    let first_char = s:get_first_char(start_line)
    let tmp_indent_size = tmp_indent_size - shiftwidth()
  endif
  let indent_str = repeat(' ', tmp_indent_size)

  if s:is_markdown_list_prefix(first_char)
    if first_char =~ '\v[0-9]'
      let prefix = first_char + 1 . '.'
    else
      let prefix = first_char 
    endif

    return indent_str . prefix . ' '
  endif

  return indent_str 
endfunction

" Search start paragraph
function! s:search_paragraph_startline(temp_indent, row)
  let indent = indent(a:row)

  if indent >= a:temp_indent
    return s:search_paragraph_startline(a:temp_indent, a:row - 1)
  endif
  return a:row
endfunction

" judge markdown list prefix char
function! s:is_markdown_list_prefix(char)
  return a:char =~ '\v([+*-]|[0-9])'
endfunction

" get markdown list char
function! s:get_first_char(row)
  let left_trimed_line = substitute(getline(a:row), '^\s*\(.\{-}\)\s*$', '\1', '')
  return left_trimed_line[0]
endfunction
