" Start Plugin Guard {{{ ----------------------------------------------------
if exists('g:grip_on') || !has('job') || &compatible || !executable('grip')
    let g:grip_on = 0
    finish
endif

let g:grip_on = '1.0.1'
let s:keepcpo = &cpoptions
set cpoptions&vim
" Start Plugin Guard }}} ----------------------------------------------------

" Options {{{ ------------------------------------------------------------------
let g:grip_default_map = get(g:, 'grip_default_map', v:true)

let g:grip_disable_when_no_jobs = get(g:, 'grip_disable_when_no_jobs', v:true)

let g:grip_auto_start = get(g:, 'grip_auto_start', v:false)
" Options }}} ------------------------------------------------------------------

" End Plugin Guard {{{ ---------------------------------------------------------
let &cpoptions = s:keepcpo
unlet s:keepcpo
" End Plugin Guard }}} ---------------------------------------------------------

" vim: set expandtab softtabstop=4 shiftwidth=4 foldmethod=marker:
