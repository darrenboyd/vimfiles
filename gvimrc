set guifont=Ubuntu\ Mono\ 11
set linespace=2
set antialias

" Don't beep
set visualbell

set background=light
color solarized

set guioptions-=T   " No toolbar
set guioptions-=r   " No scrollbars
set guioptions-=L   " No scrollbars
set guioptions-=m   " No menu

set noballooneval
set balloonexpr=""

nmap <leader>t :tabnew<CR>

set showtabline=2

if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert
end
