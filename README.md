# md-nl
MarkDown New Line with vim.

This help you a time like this,
+ markdown line break
+ create new list item

## usage
setting example
```
imap <S-CR> <Plug>(mdnl_linebreak)     "To add new paragraph line.
imap <C-CR> <Plug>(mdnl_new_listitem)  "To add new listitem.
```

### To add new paragraph line
```markdown
+ some contents
+ some paragraph line|
```

you type Shift+Enter, tobe
```markdown
+ some contents
+ some paragraph line<Space><Space>
  |
```

### To add new paragraph line
```markdown
1. list 1
2. list 2|
```

you type Ctrl+Enter, tobe
```markdown
1. list 1
2. list 2
3. |
```
