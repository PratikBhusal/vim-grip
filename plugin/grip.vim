" Start Plugin Guard {{{ ----------------------------------------------------
if exists('g:grip_on') || !has('job') || &compatible || !executable('grip')
    finish
endif

let g:grip_on = '1.0.0'
let s:keepcpo = &cpoptions
set cpoptions&vim
" Start Plugin Guard }}} ----------------------------------------------------

" Options {{{ ------------------------------------------------------------------
let g:grip_default_map = get(g:, 'grip_default_map', v:true)

let g:grip_disable_when_no_jobs = get(g:, 'grip_disable_when_no_jobs', v:true)
" Options }}} ------------------------------------------------------------------

" End Plugin Guard {{{ ---------------------------------------------------------
let &cpoptions = s:keepcpo
unlet s:keepcpo
" End Plugin Guard }}} ---------------------------------------------------------

" vim: set expandtab softtabstop=4 shiftwidth=4 foldmethod=marker:
