set nocompatible              " required
syntax enable
set tabstop=4
set expandtab
set autoindent

set nocompatible        " required
filetype off            " requireood


set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2


set luadll=/path/to/liblua.5.2.dylib

set hidden
set showtabline=0

let maplocalleader="\<Space>"

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'


" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
" let Vundle manage Vundle, required
Plugin 'preservim/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'        " NerdTree git functionality
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight' " NerdTree syntax highlighting
Plugin 'PhilRunninger/nerdtree-visual-selection'
Plugin 'preservim/tagbar'
Plugin 'ojroques/vim-oscyank'
Plugin 'vim-ctrlspace/vim-ctrlspace'        " Tabs/Buffers/Fuzzy/Workspaces/Bookmarks
Plugin 'vim-airline/vim-airline'            " Lean & mean status/tabline for vim
Plugin 'vim-airline/vim-airline-themes'     " Themes for airline
Plugin 'fisadev/FixedTaskList.vim'          " Pending tasks list
Plugin 'yuttie/comfortable-motion.vim'      " Smooth scrolling
Plugin 'MattesGroeger/vim-bookmarks'        " Bookmarks
Plugin 'thaerkh/vim-indentguides'           " Visual representation of indents
Plugin 'digitalrounin/vim-yaml-folds'       " Yaml folding
Plugin 'w0rp/ale'                           " Async Lint Engine
Plugin 'Valloric/YouCompleteMe'             " Code Completion

" Other
Plugin 'tpope/vim-surround'                 " Parentheses, brackets, quotes, XML tags, and more
Plugin 'flazz/vim-colorschemes'             " Colorschemes
Plugin 'vimwiki/vimwiki'                    " Personal Wiki
Plugin 'jreybert/vimagit'                   " Git Operations
Plugin 'kien/rainbow_parentheses.vim'       " Rainbow Parentheses
Plugin 'mhinz/vim-startify'                 " Vim Start Page
"Snippets support
Plugin 'garbas/vim-snipmate'                " Snippets manager
Plugin 'MarcWeber/vim-addon-mw-utils'       " dependencies #1
Plugin 'tomtom/tlib_vim'                    " dependencies #2
Plugin 'honza/vim-snippets'                 " snippets repo

"Languages support
Plugin 'scrooloose/nerdcommenter'           " Easy code documentation
Plugin 'mitsuhiko/vim-sparkup'              " Sparkup(XML/jinja/htlm-django/etc.) support

"Python
Plugin 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'mitsuhiko/vim-python-combined'
Plugin 'vim-syntastic/syntastic'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'jmcantrell/vim-virtualenv'

Plugin 'Yggdroot/indentLine'
Plugin 'jlanzarotta/bufexplorer'

Plugin 'github/copilot.vim'

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'

Plugin 'airblade/vim-gitgutter'


" All of your Plugins must be added before the following line
Plugin 'ryanoasis/vim-devicons'             " Dev Icons

Plugin 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)
" Plug 'ryanoasis/vim-devicons' Icons without colours
Plugin 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-commentary'
Plugin 'EdenEast/nightfox.nvim'
Plugin 'lervag/vimtex'

set encoding=UTF-8
call vundle#end()                           " required



filetype off
filetype plugin on
filetype plugin indent on

"=====================================================
"" General settings
"=====================================================
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif
set encoding=utf-8
set t_Co=256                                " 256 colors

" set guifont=mononoki\ Nerd\ Font\ 18
set guifont=DejaVu\ Sans\ Mono\ Bold\ for\ Powerline
colorscheme wombat256mod                    " set vim colorscheme
let g:airline_theme='wombat'                " set airline theme
syntax enable                               " enable syntax highlighting

let g:loaded_python_provider = 1
set shell=/bin/bash
set number                                  " show line numbers
set ruler
set ttyfast                                 " terminal acceleration

set tabstop=4                               " 4 whitespaces for tabs visual presentation
set shiftwidth=4                            " shift lines by 4 spaces
set smarttab                                " set tabs for a shifttabs logic
set expandtab                               " expand tabs into spaces
set autoindent                              " indent when moving to the next line while writing code

set cursorline                              " shows line under the cursor's line
set showmatch                               " shows matching part of bracket pairs (), [], {}

set enc=utf-8	                            " utf-8 by default

set nobackup 	                            " no backup files
set nowritebackup                           " only in case you don't want a backup file while editing
set noswapfile 	                            " no swap files

set backspace=indent,eol,start              " backspace removes all (indents, EOLs, start) What is start?

set scrolloff=20                            " let 10 lines before/after cursor during scroll

set clipboard=unnamedplus                       " use system clipboard
set clipboard+=unnamedplus                       " use system clipboard

set exrc                                    " enable usage of additional .vimrc files from working directory
set secure                                  " prohibit .vimrc files to execute shell, create files, etc...
" to yank to system clipboard
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif
vnoremap <leader>c :OSCYank<CR>

"=====================================================
"" Tabs / Buffers settings
"=====================================================
tab sball
set switchbuf=useopen
set laststatus=2
nmap <F9> :bprev<CR>
nmap <F10> :bnext<CR>
nmap <silent> <leader>q :SyntasticCheck # <CR> :bp <BAR> bd #<CR>

"=====================================================
"" YouCompleteMe Settings
"=====================================================

"=====================================================
"" Ale Settings (Linting)
"=====================================================
" Use Ale.
" Show Ale in Airline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Ale Gutter
let g:ale_sign_column_always = 1

"=====================================================
"" Relative Numbering
"=====================================================
nnoremap <F4> :set relativenumber!<CR>

"=====================================================
"" Search settings
"=====================================================
set incsearch	                            " incremental search
set hlsearch	                            " highlight search results

"=====================================================
"" Comfortable Motion Settings
"=====================================================
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"
let g:comfortable_motion_no_default_key_mappings = 1

"=====================================================
"" AirLine settings
"=====================================================
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline_powerline_fonts=1

"=====================================================
"" TagBar settings
"=====================================================
let g:tagbar_autofocus=0
let g:tagbar_width=42
" autocmd BufEnter *.py :call tagbar#autoopen(0)
autocmd BufWinLeave *.py :TagbarClose

"=====================================================
"" NERDTree settings
"=====================================================
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '__pycache__$']     " Ignore files in NERDTree
let g:NERDTreeWinSize=70
nmap " :NERDTreeToggle<CR>
nmap ^ :NERDTreeFind<CR>
nmap  <Leader>r :NERDTreeFocus<cr>R<c-w><c-p>
nmap <leader>s :NERDTreeFind<cr>

"=====================================================
"" NERDComment Settings
"=====================================================
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1


"=====================================================
"" DevIcon Settings
"=====================================================
" loading the plugin
let g:webdevicons_enable = 1

" adding the flags to NERDTree
let g:webdevicons_enable_nerdtree = 1

" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 1

" adding to vim-airline's statusline
let g:webdevicons_enable_airline_statusline = 1

" turn on/off file node glyph decorations (not particularly useful)
let g:WebDevIconsUnicodeDecorateFileNodes = 1

" use double-width(1) or single-width(0) glyphs
" only manipulates padding, has no effect on terminal or set(guifont) font
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

" whether or not to show the nerdtree brackets around flags
let g:webdevicons_conceal_nerdtree_brackets = 0

" the amount of space to use after the glyph character (default ' ')
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '

" Force extra padding in NERDTree so that the filetype icons line up vertically
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:NERDTreeWinSize=40

" change the default character when no match found
let g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol = 'ƛ'

" set a byte character marker (BOM) utf-8 symbol when retrieving file encoding
" disabled by default with no value
let g:WebDevIconsUnicodeByteOrderMarkerDefaultSymbol = ''

" enable folder/directory glyph flag (disabled by default with 0)
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" enable open and close folder/directory glyph flags (disabled by default with 0)
let g:DevIconsEnableFoldersOpenClose = 1

" enable pattern matching glyphs on folder/directory (enabled by default with 1)
let g:DevIconsEnableFolderPatternMatching = 1

" enable file extension pattern matching glyphs on folder/directory (disabled by default with 0)
let g:DevIconsEnableFolderExtensionPatternMatching = 0


"=====================================================
"" SnipMate settings
"=====================================================
let g:snippets_dir='~/.vim/vim-snippets/snippets'

"=====================================================
"" Rainbow Parentheses Autoload
"=====================================================
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

"=====================================================
"" Indent Guides Settings
"=====================================================
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
"=====================================================
"" Python settings
"=====================================================

" python executables for different plugins
let g:pymode_python='python'


nmap <leader>g :YcmCompleter GoTo<CR>
nmap <leader>d :YcmCompleter GoToDefinition<CR>

let g:ale_emit_conflict_warnings = 0
let g:airline#extensions#ale#enabled = 1
let g:pymode_rope_lookup_project = 0
let g:airline#extensions#tabline#enabled = 1

" rope
let g:pymode_rope=0
let g:pymode_rope_completion=0
let g:pymode_rope_complete_on_dot=0
let g:pymode_rope_auto_project=0
let g:pymode_rope_enable_autoimport=0
let g:pymode_rope_autoimport_generate=0
let g:pymode_rope_guess_project=0

" documentation
let g:pymode_doc=0
let g:pymode_doc_bind='K'

" lints
let g:pymode_lint=0

" virtualenv
let g:pymode_virtualenv=1

" breakpoints
let g:pymode_breakpoint=1
let g:pymode_breakpoint_key='<leader>b'

" syntax highlight
let g:pymode_syntax=1
let g:pymode_syntax_slow_sync=1
let g:pymode_syntax_all=1
let g:pymode_syntax_print_as_function=g:pymode_syntax_all
let g:pymode_syntax_highlight_async_await=g:pymode_syntax_all
let g:pymode_syntax_highlight_equal_operator=g:pymode_syntax_all
let g:pymode_syntax_highlight_stars_operator=g:pymode_syntax_all
let g:pymode_syntax_highlight_self=g:pymode_syntax_all
let g:pymode_syntax_indent_errors=g:pymode_syntax_all
let g:pymode_syntax_string_formatting=g:pymode_syntax_all
let g:pymode_syntax_space_errors=g:pymode_syntax_all
let g:pymode_syntax_string_format=g:pymode_syntax_all
let g:pymode_syntax_string_templates=g:pymode_syntax_all
let g:pymode_syntax_doctests=g:pymode_syntax_all
let g:pymode_syntax_builtin_objs=g:pymode_syntax_all
let g:pymode_syntax_builtin_types=g:pymode_syntax_all
let g:pymode_syntax_highlight_exceptions=g:pymode_syntax_all
let g:pymode_syntax_docstrings=g:pymode_syntax_all

" highlight 'long' lines (>= 80 symbols) in python files
augroup vimrc_autocmds
    autocmd!
    autocmd FileType python,rst,c,cpp highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python,rst,c,cpp match Excess /\%81v.*/
    autocmd FileType python,rst,c,cpp set nowrap
    autocmd FileType python,rst,c,cpp set colorcolumn=80
augroup END

" code folding
let g:pymode_folding=0

" pep8 indents
let g:pymode_indent=1

" code running
let g:pymode_run=1
let g:pymode_run_bind='<F5>'

let g:ale_sign_column_always = 0
let g:ale_emit_conflict_warnings = 0
let g:airline#extensions#ale#enabled = 1
let g:pymode_rope_lookup_project = 0
let g:airline#extensions#tabline#enabled = 1

imap <F5> <Esc>:w<CR>:!clear;python %<CR>


autocmd StdinReadPre * let g:isReadingFromStdin = 1
autocmd VimEnter * nested if !argc() && !exists('g:isReadingFromStdin') | Startify | endif
autocmd VimEnter * nested if !argc() && !exists('g:isReadingFromStdin') | NERDTree | endif

let g:tagbar_ctags_bin = "/usr/bin/ctags"
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
let g:indentLine_char = '⦙'
set mouse=a

" Vim syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Ale linter and fixers

" Fix files with prettier, and then ESLint.
let g:ale_linters = { 'python': ['flake8', 'pydocstyle', 'bandit', 'mypy']}
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'python': ['black', 'isort']
            \}

let g:ale_fix_on_save = 1

let g:snipMate = { 'snippet_version' : 1 }


"YCM
"
let g:ycm_enable_semantic_highlighting = 1
let g:ycm_semantic_triggers = {
    \ 'c,cpp,python,java,go,php,perl,elixir,erlang,scala,vim': ['re!\w{2}'],
    \ }
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0
let g:ycm_python_binary_path='/opt/miniconda/bin/python3'
let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']


" NerdTree settings

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif


" Vim go to test
nnoremap <Leader>gt :A<CR>


" copied from https://unix.stackexchange.com/questions/653509/icons-are-not-displayed-in-vim-airline-and-nerdtree
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodeDefaultSymbol = '∆'

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['nerdtree'] = ''


nnoremap <S-O> :GFiles<CR>
nnoremap <S-B>   :CtrlPBuffer<CR>
noremap Zz <c-w>_ \| <c-w>\|
noremap Zo <c-w>=

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>


" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","
