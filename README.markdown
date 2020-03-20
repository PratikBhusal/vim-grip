vim-grip: vim plugin wrapper for [joeyespo/grip]
================================================================================

Table of Contents
--------------------------------------------------------------------------------
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Options](#options)
- [Commands](#commands)
- [FAQ](#faq)
- [Todo](#todo)
- [License](#license)

Dependencies
--------------------------------------------------------------------------------
- [grip](https://github.com/joeyespo/grip) working standalone
- A version of vim with `has('job')` set to `1` or neovim
- **Optional:** [`xdg-open`](https://www.freedesktop.org/wiki/Software/xdg-utils/)
for Linux with a supported desktop environment

Installation
--------------------------------------------------------------------------------
**Step 1: Ensure all [dependencies](#dependencies) are met**

**Step 2: Install the plugin with your preferred plugin manager**

| Plugin Manager | Install with... |
| -------------- | --------------- |
| [Dein]         | `call dein#add('PratikBhusal/vim-grip')`   |
| [Minpac]       | `call minpac#add('PratikBhusal/vim-grip')` |
| [Pathogen]     | `git clone https://github.com/PratikBhusal/vim-grip ~/.vim/bundle/vim-grip`|
| [Plug]         | `Plug 'PratikBhusal/vim-grip'`             |
| [Vundle]       | `Plugin 'PratikBhusal/vim-grip'`           |
| Manual         | Put the files into your `~/.vim` directory |

**Step 3: Test the plugin by opening a markdown file. See the
[options](#options) and [commands](#commands) sections on how to configure and
use the plugin, respectively.**

Options
--------------------------------------------------------------------------------
### `g:grip_on`
This option shows whether or not grip is enabled. If you wish to disable this
plugin, do the following:

```viml
let g:grip_on = 0
```

### `g:grip_default_map`
vim-grip defines some default mappings for one to use if they wish.
[`:GripStart`](#gripstart-fileport) is set to  `F2`and
[`:GripExport`](#gripexport-fileport) is set to `F5`. If you do not want
the default mappings, set this option to `0`.

**Defaults:**
```viml
let g:grip_default_map = 1


if g:grip_default_map
    nnoremap <buffer> <silent> <F2> :silent update <bar> GripStart <cr>

    if windows
        nnoremap <buffer> <silent> <F5> :silent update <bar> GripExport <bar>
            \ :silent ! start /min %:r.html<cr>
    elseif linux && executable('xdg-open')
        nnoremap <buffer> <silent> <F5> :silent update <bar> GripExport <bar>
            \ :silent exec '!xdg-open ' . expand('%:r') . '.html &'<cr>
    endif
endif
```

### `g:grip_disable_when_no_jobs`
When enabled, vim-grip automatically hides the commands
[`:GripStop`](#gripstop-fileport),
[`:GripClean`](#gripclean),
[`:GripList`](#griplist),
and [`:GripGoto`](#gripgoto-port)
when no jobs started by [`:GripStart`](#igripstart-fileport) are currently running. If you
wish to have them visible at all times **after the first job has started by
[`:GripStart`](#gripstart-fileport)**, set this variable to `0`.

**Default:**
```viml
let g:grip_disable_when_no_jobs = 1
```

Commands
--------------------------------------------------------------------------------
### `:GripStart [File/Port]`
Start an asynchronous grip job. If no argument is given, the current markdown
file in focus is chosen. If a file name is given, a grip instance for that
file is created. Both a valid relative and absolute path are acceptable
parameters.If a port (i.e. a positive integer) is given, the current file will
be created at that port value. Port values start at 6419 and go up until an
unoccupied port is found.

**Examples:**
```
:GripStart

:GripStart README.markdown

:GripStart 6419
```

### `:GripExport [File/Port]`
Export the current markdown file to a html file. If no argument is given, the
current markdown file in focus is exported. If a file name is given, that file
is exported. Both a valid relative and absolute path are acceptable parameters.
If a port (i.e. a positive integer) is gen, the file corresponding to the grip
instance at that port will be exported.

**Examples:**
```
:GripExport

:GripExport README.markdown

:GripExport 6419
```

### `:GripStop [File/Port]`
Stop an asynchronous grip job. If no argument is given, the current markdown
file in focus is chosen. If a file name is given, a grip instance for that
file is stopped if one exists. Both a valid relative and absolute path are
acceptable parameters. If a port (i.e. a positive integer) is given and there is
a job running at that port, the corresponding job stops.

**Examples:**
```
:GripStop

:GripStop README.markdown

:GripStop 6419
```

### `:GripList`
List the currently running grip jobs created by
[`:GripStart`](#igripstart-fileport). For each active job, the port and the file
corresponding to that port is shown. **Only active jobs are visible.**

Example:
```
:GripList

Port  File
6419  ~/.vim/src/vim-grip/README.markdown
6420  ~/.vim/src/vim-grip/LICENSE.markdown
```

### `:GripClean[!]`
Clean any dead grip jobs (or **all** jobs with **`!`**) created by
[`:GripStart`](#igripstart-fileport).

**Example 1:**
```
:GripList

Port  File
6419  ~/.vim/src/vim-grip/README.markdown
6420  ~/.vim/src/vim-grip/LICENSE.markdown

:GripClean

:GripList

Port  File
6419  ~/.vim/src/vim-grip/README.markdown
6420  ~/.vim/src/vim-grip/LICENSE.markdown
```
**Example 2:**
```
:GripList

Port  File
6419  ~/.vim/src/vim-grip/README.markdown
6420  ~/.vim/src/vim-grip/LICENSE.markdown

:GripClean!

:GripList
```

### `:GripGoto {Port}`
Goes to a file based on the corresponding active grip instance that was started
by [`:GripStart`](#igr ipstart-fileport). Where
[`:buffer`](https://vimhelp.appspot.com/windows.txt.html#%3Abuffer) goes to a
file based on the buffer number, `:GripGoto` goes to a file based on the port
number. If you want to go to a file based on the file name, use the built-in
[`:edit`](https://vimhelp.appspot.com/editing.txt.html#edit-a-file) command.

FAQ
--------------------------------------------------------------------------------
- Does this work for neovim?
    - Yes

Todo
--------------------------------------------------------------------------------
- Test plugin on MacOS

License
--------------------------------------------------------------------------------
Apache 2.0 License. Copyright © 2018-2020 Pratik Bhusal

[Dein]: https://github.com/Shougo/dein.vim
[Minpac]: https://github.com/k-takata/minpac
[Pathogen]: https://github.com/tpope/vim-pathogen
[Plug]: https://github.com/junegunn/vim-plug
[Vundle]: https://github.com/VundleVim/Vundle.vim
[joeyespo/grip]: https://github.com/joeyespo/grip
