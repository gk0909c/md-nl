" create markdown new line
" mode
"   1: markdown line brean(add two space to temporary line end)
"   2: create new list item
function! mdnl#add_new_line(mode)
  let line = line('.')
  let list_prefix = s:get_markdown_list_prefix(getline(line))

  if a:mode == 1
    let line_str = s:get_next_indent(line, list_prefix)
  else
    let line_str = s:get_new_listitem(line, list_prefix)
  endif

  call append(line, line_str)
  call cursor(line + 1, 0)
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
      let matches = matchlist(list_prefix, '\v([0-9]+)(\.\s\[\s\])?')

      if empty(matches[2])
        let prefix = matches[1] + 1 . '.'
      else
        let prefix = matches[1] + 1 . matches[2]
      endif
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
