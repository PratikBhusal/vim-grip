" Plugin Guard {{{
if (exists('g:grip_on') && !g:grip_on) ||
   \    !has('job') ||
   \    &compatible ||
   \    !executable('grip')
    finish
endif
" Plugin Guard }}}

call grip#create_commands(v:false)

if g:grip_default_map
    let s:linux = has('unix') && !has('macunix') && !has('win32unix')
    let s:windows = has('win32') || has('win64')

    nnoremap <buffer> <silent> <F2> :silent update <bar> GripStart  <cr>
    if s:windows
        nnoremap <buffer> <silent> <F5> :silent update <bar> GripExport <bar>
            \ silent ! start /min %:r.html<cr>
    elseif s:linux && executable('xdg-open')
        nnoremap <buffer> <silent> <F5> :silent update <bar> GripExport <bar>
            \ silent exec '!xdg-open ' . expand('%:r') . '.html &'<cr>
    endif
endif

" vim: set expandtab softtabstop=4 shiftwidth=4 foldmethod=marker:
