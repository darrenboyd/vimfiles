""
"" Thanks:
""   Mislav Marohnić <mislav.uniqpath.com>
""   Gary Bernhardt  <destroyallsoftware.com>
""   Drew Neil  <vimcasts.org>
""   Tim Pope  <tbaggery.com>
""   Janus  <github.com/carlhuda/janus>
""

set nocompatible
set encoding=utf-8
set exrc                    " load vimrc from current directory

call pathogen#infect()
filetype plugin indent on

runtime macros/matchit.vim  " enables % to cycle through `if/else/endif`

syntax enable
set background=dark
color railscasts
set synmaxcol=800           " don't try to highlight long lines

" set nonumber    " line numbers aren't needed
set number      " line numbers are needed
set ruler       " show the cursor position all the time
set cursorline  " highlight the line of the cursor
set showcmd     " show partial commands below the status line
set shell=bash  " avoids munging PATH under zsh
let g:is_bash=1 " default shell syntax
set history=200 " remember more Ex commands
set scrolloff=3 " have some context around the current line always on screen

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Auto-reload buffers when file changed on disk
set autoread

" Disable swap files; systems don't crash that often these days
set updatecount=0

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

"" Whitespace
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode
" Joining lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j            " Delete comment char when joining commented lines
endif
set nojoinspaces                  " Use only 1 space after "." when joining lines, not 2
" Indicator chars
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮
set showbreak=↪\ 

"" Searching
set hlsearch                      " highlight matches
set incsearch                     " incremental searching
set ignorecase                    " searches are case insensitive...
set smartcase                     " ... unless they contain at least one capital letter
set gdefault                      " have :s///g flag by default on

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=100

" Ragel syntax (default to ruby as host language)
let g:ragel_default_subtype='ruby'

function! s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  " Avoid showing trailing whitespace when in insert mode
  au InsertEnter * :set listchars-=trail:•
  au InsertLeave * :set listchars+=trail:•

  " Some file types use real tabs
  au FileType {make,gitconfig} set noexpandtab

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json setf javascript

  " https://github.com/sstephenson/bats
  au BufNewFile,BufRead *.bats setf sh

  au BufNewFile,BufRead *.rl setfiletype ragel

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python setl softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  " mark Jekyll YAML frontmatter as comment
  au BufNewFile,BufRead *.{md,markdown,html,xml} sy match Comment /\%^---\_.\{-}---$/

  " magic markers: enable using `H/S/J/C to jump back to
  " last HTML, stylesheet, JS or Ruby code buffer
  au BufLeave *.{erb,html}      exe "normal! mH"
  au BufLeave *.{css,scss,sass} exe "normal! mS"
  au BufLeave *.{js,coffee}     exe "normal! mJ"
  au BufLeave *.{rb}            exe "normal! mC"
augroup END

" don't use Ex mode, use Q for formatting
map Q gq

" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

" toggle the current fold
:nnoremap <Space> za

let mapleader=","

" yank to system clipboard
map <leader>y "*y
map <leader>v "*p

" paste lines from unnamed register and fix indentation
nmap <leader>p pV`]=
nmap <leader>P PV`]=

" expand %% to current directory in command-line mode
" http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

map <leader>gl :CommandT lib<cr>
map <leader>gt :CommandTTag<cr>
map <leader>f :CommandT<cr>
map <leader>F :CommandT %%<cr>

let g:CommandTMaxHeight=12
let g:CommandTMinHeight=4

let g:turbux_command_test_unit = 'ruby -Ilib:test'
" let g:turbux_command_cucumber = 'cucumber -f progress'

let g:ackprg = 'ag --nogroup --nocolor --column'

" In command-line mode, C-a jumps to beginning (to match C-e)
cnoremap <C-a> <Home>

" <Tab> indents if at the beginning of a line; otherwise does completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" ignore Rubinius, Sass cache files
set wildignore+=tmp/**,*.rbc,.rbx,*.scssc,*.sassc
" ignore Bundler standalone/vendor installs & gems
set wildignore+=bundle/**,vendor/bundle/**,vendor/cache/**,vendor/gems/**
set wildignore+=node_modules/**

" toggle between last open buffers
nnoremap <leader><leader> <c-^>

command! GdiffInTab tabedit %|vsplit|Gdiff
nnoremap <leader>d :GdiffInTab<cr>
nnoremap <leader>D :tabclose<cr>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>
command! ConvertHash :normal %s/:\([^ ]*\)\(\s*\)=>/\1:/g
command! TabsTo2Spaces :normal %s/\t/  /g

if exists(":Tabularize")

  AddTabularPattern => /^[^=>]*\zs=>

  nmap <Leader>a{ :Tabularize /{<CR>
  vmap <Leader>a{ :Tabularize /{<CR>
  nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
  vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
  nmap <Leader>a> :Tabularize /^[^=>]*\zs=><CR>
  vmap <Leader>a> :Tabularize /^[^=>]*\zs=><CR>
  nmap <Leader>a: :Tabularize /:<CR>
  vmap <Leader>a: :Tabularize /:<CR>
  nmap <Leader>a:: :Tabularize /:\zs<CR>
  vmap <Leader>a:: :Tabularize /:\zs<CR>
  nmap <Leader>a, :Tabularize /,<CR>
  vmap <Leader>a, :Tabularize /,<CR>
  nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
  vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

  vmap <Leader>ah :Tabularize/^[^:]*\zs:/l0l1<CR>
  vmap <Leader>ahh :Tabularize/^[^:]*\zs:/r0l1l0<CR>
endif

" Typical command-# tab navigation
" From: https://superuser.com/questions/382060/shortcut-to-switch-tabs-in-macvim
" Meta+1-0 jumps to tab 1-10
let s:windowmapnr = 0
let s:wins='1234567890'
while (s:windowmapnr < strlen(s:wins))
    exe 'noremap <silent> <D-' . s:wins[s:windowmapnr] . '> ' . (s:windowmapnr + 1) . 'gt'
    exe 'inoremap <silent> <D-' . s:wins[s:windowmapnr] . '> <C-O>' . (s:windowmapnr + 1) . 'gt'
    exe 'cnoremap <silent> <D-' . s:wins[s:windowmapnr] . '> <C-C>' . (s:windowmapnr + 1) . 'gt'
    exe 'vnoremap <silent> <D-' . s:wins[s:windowmapnr] . '> <C-C>' . (s:windowmapnr + 1) . 'gt'
    let s:windowmapnr += 1
endwhile
unlet s:windowmapnr s:wins


" populate arglist with files from the quickfix list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

set splitright
set splitbelow

function MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    sp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    sp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc


if has("statusline") && !&cp
  set laststatus=2                   " always show the status bar
  set statusline=%<%1*\ %f\ %*       " filename
  set statusline+=%2*%m%r%*          " modified, readonly
  set statusline+=\ %3*%y%*          " filetype
  set statusline+=\ %4*%{fugitive#head()}%0*
  set statusline+=%=                 " left-right separation point
  set statusline+=\ %5*%l%*/%L[%p%%] " current line/total lines
  set statusline+=\ %5*%v%*[0x%B]    " current column [hex char]
endif

hi StatusLine term=inverse,bold cterm=NONE ctermbg=24 ctermfg=189
hi StatusLineNC term=inverse,bold cterm=NONE ctermbg=24 ctermfg=153
hi User1 term=inverse,bold cterm=NONE ctermbg=29 ctermfg=159
hi User2 term=inverse,bold cterm=NONE ctermbg=29 ctermfg=16
hi User3 term=inverse,bold cterm=NONE ctermbg=24
hi User4 term=inverse,bold cterm=NONE ctermbg=24 ctermfg=221
hi User5 term=inverse,bold cterm=NONE ctermbg=24 ctermfg=209
