set nocompatible
set cursorline
set background=dark
set number
set numberwidth=5
set autoindent
set smartindent
set ruler
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set visualbell
set expandtab
set t_vb=
set termguicolors
set noshowmode
set tags=tags

set foldmethod=indent
set foldlevel=99

nnoremap <space> za

filetype indent plugin on
syntax on
colors zenburn

call plug#begin('~/.vim/plugged')

Plug 'jnurmine/zenburn'
Plug 'yggdroot/indentline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'

call plug#end()

let g:airline_powerline_fonts = 1
let g:airline_theme='dark'

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'
let g:gitgutter_override_sign_column_highlight = 1

highlight SignColumn guibg=bg
highlight SignColumn ctermbg=bg
