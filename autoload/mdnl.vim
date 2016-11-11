" create markdown new line
" mode
"   1: markdown line break
"   2: create new list item
"   3: markdown line break(split mode)
"   4: create new list item(split mode)
function! mdnl#add_new_line(mode)
  let split_mode = (a:mode == 1 || a:mode == 2) ? 0 : 1

  let line = line('.') - (split_mode ? 1 : 0)
  let list_prefix = s:get_markdown_list_prefix(getline(line))

  let line_str = (a:mode == 1 || a:mode == 3) ? 
        \ s:get_next_indent(line, list_prefix) :
        \ s:get_new_listitem(line, list_prefix) 

  if split_mode
    let temp_line_strs = matchlist(getline('.'), '^\(\s*\)\(\S\+\)')
    let new_line_str = empty(temp_line_strs) ? '' : temp_line_strs[2]
    call setline(line + 1, line_str . new_line_str)
  else
    call append(line, line_str)
    call cursor(line + 1, 0)
  endif
endfunction

" get new line indent
function! s:get_next_indent(line, list_prefix)
  let indent_str = repeat(' ', shiftwidth())
  let tmp_indent = repeat(' ', indent(a:line))
  
  if !empty(a:list_prefix)
    return tmp_indent . indent_str
  endif

  return tmp_indent
endfunction

" get new list item
function! s:get_new_listitem(line, list_prefix)
  let tmp_indent_size = indent(a:line)

  " if temp line doesn't have list prefix, search it until indent change
  if empty(a:list_prefix)
    let start_line = s:search_paragraph_startline(tmp_indent_size, a:line)
    let list_prefix = s:get_markdown_list_prefix(getline(start_line))
    let tmp_indent_size = tmp_indent_size - shiftwidth()
  else
    let list_prefix = a:list_prefix
  endif
  let indent_str = repeat(' ', tmp_indent_size)

  if !empty(list_prefix)
    if list_prefix =~ '\v[0-9]+'
      " when checkbox list, add it.
      let matches = matchlist(list_prefix, '\v([0-9]+)(\.\s\[\s\])?')
      let prefix = matches[1] + 1 . (empty(matches[2]) ? '.' : matches[2])
    else
      let prefix = list_prefix 
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

" get markdown list char
function! s:get_markdown_list_prefix(line)
  let left_trimed_line = substitute(a:line, '^\s*\(.\{-}\)', '\1', '')
  let matches = matchlist(left_trimed_line, '\v^(([+*-]|([0-9]+)(\.))(\s\[(x|\s)\])?(\s))')
  
  if empty(matches)
    return ''
  elseif !empty(matches[5])
    return matches[2] . substitute(matches[5], 'x', ' ', '')
  elseif !empty(matches[3])
    return matches[3]
  elseif !empty(matches[2])
    return matches[2]
  endif
endfunction

" create table header
function! mdnl#make_table_header(...)
  let line = line('.')
  let header_row = '|'
  let second_line = '|'

  for header in a:000
    let header_row = header_row . header . '|'
    let second_line = second_line . '---|'
  endfor

  :execute ":normal i" . header_row
  call append(line, second_line)
  call append(line + 1, '')
  call cursor(line + 2, 0)
endfunction

" create table row
function! mdnl#make_table_row(...)
  let line = line('.')
  let previous = getline(line - 1)
  let previous_count = len(split(previous, '|'))
  let row = '|'
  let col_count = 1

  for content in a:000
    let row = row . content . '|'
    let col_count = col_count + 1
  endfor

  while col_count <= previous_count
    let row = row . '|'
    let col_count = col_count + 1
  endwhile

  :execute ":normal i" . row
  call append(line, '')
  call cursor(line + 1, 0)
endfunction
