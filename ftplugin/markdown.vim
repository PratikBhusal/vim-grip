" Plugin Guard {{{
if (exists('g:grip_on') && !g:grip_on) ||
   \    !(has('job') || exists('*jobstart()') ) ||
   \    &compatible ||
   \    !executable('grip')

    let b:grip_on = 0
    finish
endif
let b:grip_on = '1.1.0'
let s:keepcpo = &cpoptions
set cpoptions&vim
" Plugin Guard }}}

call grip#create_commands(v:false)

" TODO: Because `g:grip_default_map` is deprecated, eventually remove this at
" some point. Figure out how to notify people or if I should just break it in
" some arbritrary commit.
if get(g:, 'grip_default_map', v:false)
    let s:linux = has('unix') && !has('macunix') && !has('win32unix')
    let s:windows = has('win32') || has('win64')

    nnoremap <buffer> <silent> <F2> :silent update <bar> GripStart <cr>
    if s:windows
        nnoremap <buffer> <silent> <F5> :silent update <bar> GripExport <bar>
            \ silent ! start /min %:r.html<cr>
    elseif s:linux && executable('xdg-open')
        nnoremap <buffer> <silent> <F5> :silent update <bar> GripExport <bar>
            \ silent exec '!xdg-open ' . expand('%:r') . '.html &'<cr>
    endif
endif

if get(g:, 'grip_auto_start', v:false)
    GripStart %:p
endif

" End Plugin Guard {{{ ---------------------------------------------------------
let &cpoptions = s:keepcpo
unlet s:keepcpo
" End Plugin Guard }}} ---------------------------------------------------------

" vim: set expandtab softtabstop=4 shiftwidth=4 foldmethod=marker:
