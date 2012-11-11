" This must be first, because it changes other options as side effect
set nocompatible
filetype off                   " required!

" Vundle {{{
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle "gmarik/vundle"
" }}}


" Plugins {{{
" Syntax highlight

" MarkDown (github)
Bundle "plasticboy/vim-markdown"

" General plugins

" NERDtree (github)
Bundle "scrooloose/nerdtree"
nmap <F4> :NERDTreeToggle<CR>

" TComment (github)
Bundle "tomtom/tcomment_vim"

" snipMate (github)
Bundle "msanders/snipmate.vim"

" tabbar (vim.org/scripts)
Bundle "TabBar"

" sass syntax
Bundle "tpope/vim-haml"

" vim-rails
Bundle "tpope/vim-rails"

" FuzzyFinder (vim-scripts)
" L9 is a FuzzyFinder dependency
Bundle "L9"
Bundle "FuzzyFinder"
nmap <Leader>fb :FufBuffer<CR> 
nmap <Leader>ff :FufFile<CR> 

" CommandT (% git)
Bundle "git://git.wincent.com/command-t.git"
let g:CommandTMaxFiles=60000
" let g:CommandTPath+=
" Remember to compile C files when installing:
"
" $ cd .vim/bundle/command-t/ruby/command-t/
" $ ruby extconf.rb
" $ make
"
"
" Bundle 'greyblake/vim-preview'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'spiiph/vim-space'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-powerline'
" Bundle 'spolu/dwm.vim'

"
" colorschemes {{{
Bundle 'tomasr/molokai'
Bundle 'altercation/vim-colors-solarized'
Bundle 'sjl/badwolf'
" }}}

" This is not really a plugin but...
filetype plugin on
" autocomplete menu
set ofu=syntaxcomplete#Complete
" Map omni menu
inoremap <C-space> <C-x><C-o>
" Close helpwindow when leaving inputmode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" autocmd <CR> * if pumvisible() == -1|pclose|endif

" }}}

filetype plugin indent on

" General mappings {{{

" change the mapleader from \ to ,
let mapleader = ","

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Easy window navigation (might not work with NERDtree)
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Toggle trough buffers (Also possible to use Alt+(num)
map <F2> :bprevious<CR>
map <F3> :bnext<CR>
imap <F2> <Esc>:bprevious<CR>
imap <F3> <Esc>:bnext<CR>

" close current buffer
" map <Leader>d :bd<CR>
map <Leader>d :call CleanClose(0)<CR>

" map fc <Esc>:call CleanClose(1)
" 
" map fq <Esc>:call CleanClose(0)

" From:
" http://stackoverflow.com/questions/256204/
" close-file-without-quitting-vim-application
function! CleanClose(tosave)
  if (a:tosave == 1)
    w!
  endif
  let todelbufNr = bufnr("%")
  let newbufNr = bufnr("#")
  if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
    exe "b".newbufNr
  else
    bnext
  endif

  if (bufnr("%") == todelbufNr)
    new
  endif
  exe "bd".todelbufNr
endfunction


" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d filetype=%s:",
        \ &tabstop, &shiftwidth, &textwidth)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>


" Leader q closes window
nnoremap <Leader>q :q<CR>

" map Esc to øø TODO: remove since never used?
imap øø <Esc>
vmap øø <Esc>

" Disable insert when Double mousepad click
map  <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
map  <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map  <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map  <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>


" vertical window split
noremap <leader>v <C-w>v

" horizontal window split 
noremap <leader>s <C-w>s
" }}}

" Change cursor color in insert mode
if &term =~ "xterm\\|screen-256color|vte-256color|termite"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;gray\x7"
  silent !echo -ne "\033]12;gray\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal
endif

" General settings (Need cleanup) {{{

" from zaiste vimrc NEED CLEANUP


set hidden " open new file without saving current buffer (no more !-error)

set history=200             " remember commands and search history
set undolevels=1000         " use many muchos levels of undo

set wildmenu
set ruler

" Ignore certain filetypes (very handy when using command-t) {{{
set wildignore+=*.swp,*.bak,*.*~,*.orig                 " Backup files
set wildignore+=*.o,*.d,*.obj,*.pyc,*.class,*.exe,*.dll " Binary files
set wildignore+=*.icns,*.ico,*.icontainer               " Icon files
set wildignore+=*.png,*.jpg,*.JPG,*.gif                 " image files
set wildignore+=*.eps,*.pdf,*.PDF,*.dvi,*.ps            " Graphic files
set wildignore+=*.svg,*.psd,*.ai,*.xbm                  " graphic
set wildignore+=*.doc,*.docx,*.ppt,*.xls,*.xlsx         " Documents (MS)
set wildignore+=*.odt,*.ods,*.odp                       " Documents (OO)
set wildignore+=*.aux,*.out                             " latex trash
set wildignore+=*.po,*.mo,*.pot                         " Translation files
set wildignore+=*.sln                                   " App specific
set wildignore+=*.ttf,*.otf                             " Fonts
set wildignore+=*.mp3,*.m4a                             " Audio
" Ignore some standard folders aswell
" Really need a whitelist instead of this, for making command-t useable
set wildignore+=python-env/**                           " My python virtualenv.
" }}}

set title           " change the terminal's title
autocmd VimEnter * set vb t_vb=
" set vb t_vb=
set noerrorbells    " don't beep
"set vb             " mute spkr


" Vim UI {
" Highlight current column, and enable toggle.
set cursorline
nnoremap <F9> :set nocursorline!<CR> 
set incsearch       " Highlight as you type search phrase.
set laststatus=2    " Always show the status line.
set encoding=utf-8  " Necessary to show unicode glyphs
if has("gui_running")
  let g:Powerline_symbols = 'fancy'
endif
" set list

" set listchars=extends:❯,precedes:❮

set ruler
set shell=/bin/zsh
set number          " Turn on line numbers.
set mouse=a         " Enable mouse in terminal emulators.
set showcmd         " Show the command being typed.

set nofoldenable    " Don't fold.
" tab/spaces settings (important for python)
" tab = 4 space
" set smartindent " (use autoindent because 'smart' fucks up python)
set nosmartindent
set tabstop=4
set shiftwidth=4
set expandtab
set textwidth=79    " following python's PEP8
set colorcolumn=80
set autoindent

" Don't backup files.
set nobackup
set noswapfile

" set lazyredraw      " Trying out lazyredraw for imporved performance.
" }}}

if &t_Co > 2 || has("gui_running")
  syntax enable " enable syntax highlighting, when the terminal has colors.
endif

if &t_Co >= 256 || has("gui_running")
  "colorscheme mustang          " Alternative theme.
  " colorscheme molokai
  " colorscheme badwolf
  set background=dark
  let g:solarized_termcolors=256 
  let g:solarized_italic=0
  " let g:solarized_degraded=0
  " let g:solarized_bold = 0
  colorscheme solarized
  set guifont=Terminus\ 8     " Font + size (Awesome WM).
  " set guifont=Ubuntu\ Mono\ 10  " Font + size (Awesome WM).
  " set guifont="Source Sans Pro 10"  " Font + size (Awesome WM).
  let g:enhanceFontName = "Monaco for powerline"
  
  " Gvim fixing
  set go-=T                     " hide gvim toolbar.
  set go-=m                     " hide gvim menu.
  set guioptions+=LlRrb         " Hide scrollbars,
  set guioptions-=LlRrb         " Gvim need this stupid fix.
endif
" }}}

" filetype settings {{{
" Compass/sass
autocmd FileType css,sass,haml,scss setlocal sw=2 ts=2
" vim script
autocmd FileType vim setlocal sw=2 ts=2
"  COMMIT_EDITMSG
autocmd FileType gitcommit setlocal tw=72 cc=73
" html
autocmd FileType html,htmldjango setlocal sw=2 ts=2 tw=0 cc=0
" tex
autocmd FileType tex setlocal sw=2 ts=2
" }}}

" This should only be for tex
set makeprg=make\ -C\ %:h

map <F5> :make<CR>

" Abbrivations {{{1
iab py# #!/usr/bin/env python
iab sh# #!/bin/sh
iab bash# #!/bin/bash
iab stdio# #include <stdio.h>
" }}}1

" Vim-latex-settings
" set grepprg=grep\ -nH\ $*
" let g:tex_flavor='latex'

" Toggle spell {{{
" f7 toggle english
" f8 toggle danish
func! ToggleSpl( lang ) 
  if &l:spl =~ '\v(^|,)\V'.escape(a:lang,'\').'\v(,|$)' 
  "Alternatively, since 'spl' may not contain a comma this also
  "works: 
  "if index(split(&l:spl,','),a:lang) != -1 
    exec 'setl spl-='.a:lang 
  else 
    exec 'setl spl+='.a:lang 
  endif 
  :setl spell spl 
endfun 

" Spell languages
map <f7> :call ToggleSpl('en')<cr> 
map <f8> :call ToggleSpl('da')<cr>
" }}}
