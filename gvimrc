set guifont=Ubuntu\ Mono
set linespace=2
set antialias

" Don't beep
set visualbell

set background=light
color solarized

set guioptions-=T   " No toolbar
set guioptions-=r   " No scrollbars

set noballooneval
set balloonexpr=""

if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert
end
