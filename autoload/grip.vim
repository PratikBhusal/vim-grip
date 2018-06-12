let s:grip_instances = {}
let s:windows = has('win32') || has('win64')
let s:slash = ( (exists('+shellslash') && !&shellslash) ? '\' : '/' )

function! grip#create_commands(create_extras) abort " {{{
    command! -nargs=? -buffer -complete=file      GripStart  :call s:start(<f-args>)
    command! -nargs=? -buffer -complete=file -bar GripExport :call s:export(<f-args>)

    if a:create_extras
        command! -nargs=? -complete=file                   GripStop  :call s:stop(<f-args>)
        command! -nargs=0 -bang                            GripClean :call s:clean(<bang>0)
        command! -nargs=0 -bar                             GripList  :call s:list()
        command! -nargs=1 -complete=customlist,s:port_list GripGoto  :call s:goto(<f-args>)
    endif
endfunction " }}}

function! grip#delete_commands(delete_extra) abort " {{{
    " echom 'Disable extra: ' . a:delete_extra
    if !len(s:grip_instances) && a:delete_extra
        if exists(':GripStop')
            delcommand GripStop
        endif
        if exists(':GripClean')
            delcommand GripClean
        endif
        if exists(':GripList')
            delcommand GripList
        endif
        if exists(':GripGoto')
            delcommand GripGoto
        endif
    endif
endfunction " }}}

function! s:start(...) abort " {{{
    let l:is_port = a:0 && a:1 !~? '\D'

    try
        " If no argument was given, working on the current file
        " If full path given, use function argument
        " Otherwise, convert relative path to full path

        let l:path = (!a:0 || l:is_port) ? expand('%:p')
        \ : (!s:windows && a:1[0] ==# '/') ||
        \   (s:windows  && split(a:1, s:slash)[0] =~# '\u:') ? a:1
            \ : s:simplify_path(a:1)
    catch /'Invalid Argument'/
        echohl ErrorMsg | echom 'Invalid Argument!' | echohl None
        finish
    endtry

    if len(s:grip_instances)
        call s:clean(v:false)
    endif

    if !s:find(l:path, v:false)
        let l:new_port = l:is_port && !has_key(s:grip_instances, a:1)
            \ ? str2nr(a:1) : 6419
        while has_key(s:grip_instances, l:new_port)
            let l:new_port += 1
        endwhile

        let s:grip_instances[l:new_port] = job_start([
            \ 'grip',
                \ l:path,
                \ expand(l:new_port),
                \ '-b',
                \ '--quiet',
        \ ])

        if !exists(':GripStop') || !exists(':GripClean') ||
        \  !exists(':GripList') || !exists(':GripGoto')
            call grip#create_commands(v:true)
        endif
    else
        silent! exec '!grip ' . l:path . ' -b --quiet '
    endif
endfunction " }}}

function! s:export(...) abort " {{{
    let l:is_port = a:0 && a:1 !~? '\D'

    try
        let l:path = (!a:0) ? expand('%:p')
            \ : (l:is_port) ? s:find(a:1, v:true)
                \ : (!s:windows && a:1[0] ==# '/') ||
                \   (s:windows  && split(a:1, s:slash)[0] =~# '\u:') ? a:1
                    \ : s:simplify_path(a:1)
    catch /'Invalid Argument'/
        echohl ErrorMsg | echom 'Invalid Argument!' | echohl None
        finish
    endtry

    if l:path isnot? v:null
        silent! exec '!grip --export --quiet ' .
        \(l:is_port ? job_info(s:grip_instances[l:path]).cmd[1] : l:path)
    endif

endfunction " }}}

function! s:stop(...) abort " {{{
    let l:is_port = a:0 && a:1 !~? '\D'

    try
        let l:wanted = (!a:0) ? expand('%:p')
            \ : l:is_port ||
            \   (!s:windows && a:1[0] ==# '/') ||
            \   (s:windows  && split(a:1, s:slash)[0] =~# '\u:') ? a:1
                \ : s:simplify_path(a:1)
    catch /'Invalid Argument'/
        echohl ErrorMsg | echom 'Invalid Argument!' | echohl None
        finish
    endtry

    let l:wanted_port = s:find(l:wanted, l:is_port)

    if l:wanted_port
        call job_stop(s:grip_instances[l:wanted_port])
        unlet s:grip_instances[l:wanted_port]
    endif

    call grip#delete_commands(g:grip_disable_when_no_jobs)
endfunction " }}}

function! s:clean(should_clean_all) abort " {{{
    for l:instance in keys(s:grip_instances)
        if a:should_clean_all ||
            \job_status(s:grip_instances[l:instance]) ==# 'dead'

            call job_stop(s:grip_instances[l:instance])
            unlet s:grip_instances[l:instance]
        endif
    endfor

    call grip#delete_commands(g:grip_disable_when_no_jobs)
endfunction " }}}

function! s:list() abort " {{{
    if len(s:grip_instances)
        echo 'Port  File'
        for l:instance in keys(s:grip_instances)
            if job_status(s:grip_instances[l:instance]) !=# 'dead'
                echo printf('%-5s %s', l:instance,
                    \job_info(s:grip_instances[l:instance]).cmd[1])
            endif
        endfor
    endif
endfunction " }}}

function! s:goto(wanted) abort " {{{
    if a:wanted !~? '\D' && has_key(s:grip_instances, a:wanted)
        silent! exec 'edit ' . job_info(s:grip_instances[a:wanted]).cmd[1]
    endif
endfunction " }}}

function! s:port_list(...) " {{{
    return keys(s:grip_instances)
endfunction " }}}

function! s:simplify_path(file_name) abort " {{{
    let l:full_path = split(expand('%:p:h'), s:slash)

    for l:alteration in split(a:file_name, s:slash)
        if l:alteration ==# '..'
            if (s:windows && len(l:full_path) == 1) || !len(l:full_path)
                throw 'Invalid Argument'
            endif
            call remove(l:full_path, -1)
        else
            call add(l:full_path, l:alteration)
        endif
    endfor

    return (g:windows ? '' : s:slash) . join(l:full_path, s:slash)
endfunction " }}}

function! s:find(wanted, is_port) abort " {{{
    if !a:is_port
        for l:instance in keys(s:grip_instances)
            if job_info(s:grip_instances[l:instance]).cmd[1] ==# a:wanted
                return l:instance
            endif
        endfor
    endif

    return ( ( a:is_port && has_key(s:grip_instances, a:wanted) )
            \  ? a:wanted : v:null )
endfunction " }}}
