"ctrlp dir
"like spacemacs SPC ff
"author:tracyone@live.cn

call add(g:ctrlp_ext_vars, {
      \ 'init': 'ctrlp#findfile#init()',
      \ 'accept': 'ctrlp#findfile#accept',
      \ 'lname': 'Find Files',
      \ 'sname': 'FF',
      \ 'type': 'path',
      \ 'sort': 0,
      \ 'specinput': 0,
      \ })

let s:text = []
function! ctrlp#findfile#init() abort
  return s:text
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
"press ctrl-v will not exit ctrlp
function! ctrlp#findfile#accept(mode, str) abort
    let l:file_or_dir=matchstr(a:str,".*[^@]")
    "enter will cd else open netrw
    if isdirectory(l:file_or_dir) && a:mode ==# 'e' 
        call ctrlp#exit()
        execute 'cd 'l:file_or_dir
        call ctrlp#findfile#start()
    else
        call ctrlp#exit()
        if a:mode ==# 'e'
            let l:HowToOpen='e'
        elseif a:mode ==# 't'
            let l:HowToOpen='tabnew'
        elseif a:mode ==# 'v'
            let l:HowToOpen='vsplit'
        elseif a:mode ==# 'h'
            let l:HowToOpen='sp'
        else
            let l:HowToOpen='e'
        endif
        execute l:HowToOpen.' '.l:file_or_dir
    endif
endfunction

function! ctrlp#findfile#id() abort
  return s:id
endfunction

function! s:systemlist(expr, ...)
    if a:0 == 1
        return split(system(a:expr, a:1),nr2char(10))
    else
        return split(system(a:expr),nr2char(10))
    endif
endfunction

function! ctrlp#findfile#start() abort
    if has('win64') || has('win32')
        let s:text = s:systemlist('dir /B /D')
        let l:text_dir=filter(deepcopy(s:text),'isdirectory(v:val)')
        call filter(s:text,'isdirectory(v:val) == 0')
        call map(l:text_dir, 'v:val."\\"')
        call extend(s:text, l:text_dir)
        call add(s:text, '..\')
    else
        let s:text = s:systemlist('ls -a -F')
    endif
    call ctrlp#init(ctrlp#findfile#id()) 
endfunction
