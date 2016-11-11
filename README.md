[![Build Status](https://travis-ci.org/gk0909c/md-nl.svg?branch=master)](https://travis-ci.org/gk0909c/md-nl)  

# md-nl
My markDown Utils

## New Line
This help you a time like this,
+ markdown line break
+ create new list item

### usage
setting example
```
imap <S-CR> <Plug>(mdnl_linebreak)     "To add new paragraph line.
imap <C-CR> <Plug>(mdnl_new_listitem)  "To add new listitem.
```

#### To add new paragraph line
```markdown
+ some contents
+ some paragraph line|
```

you type Shift+Enter, to be
```markdown
+ some contents
+ some paragraph line<Space><Space>
  |
```

#### To add new paragraph line
```markdown
1. list 1
2. list 2|
```

you type Ctrl+Enter, to be
```markdown
1. list 1
2. list 2
3. |
```

## describe tables
### headers
`:MdnlTableHeader Col1 Col2 Col3` command makes
```markdown
|Col1|Col2|Col3|
|---|---|---|
```

### rows
`:MdnlTableRow data1 data2 data3` command makes
```markdown
|data1|data2|data3|
```

## and more
see doc/mdnl.txt
