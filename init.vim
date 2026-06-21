call plug#begin('~/.local/share/nvim/plugged')
" Theme
Plug 'folke/tokyonight.nvim'
" File tree
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
" Search
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" LSP / Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" ------------------------
" Appearance
" ------------------------
set number
set relativenumber
set cursorline
set termguicolors
colorscheme tokyonight
set mouse=a
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set splitbelow
set splitright
set ignorecase
set smartcase
syntax on
filetype plugin indent on

" ------------------------
" Nvim Tree
" ------------------------
lua << EOF
require("nvim-tree").setup({
    view = {
        width = 35,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
    on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
        -- Unbind <C-t> inside tree to prevent "go up directory"
        vim.keymap.del("n", "<C-t>", { buffer = bufnr })
    end,
})
EOF

nnoremap <C-t> :NvimTreeToggle<CR>

" ------------------------
" Telescope
" ------------------------
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>

" ------------------------
" Coc
" ------------------------
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <leader>rn <Plug>(coc-rename)
let g:coc_global_extensions = [
\ 'coc-go',
\ 'coc-json',
\ 'coc-eslint',
\ 'coc-prettier'
\ ]

" ------------------------
" Terminal toggle (Ctrl+\)
" ------------------------
let g:term_buf = 0
let g:term_win = 0

function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        " If focus is on NvimTree, move to editor first
        if &filetype == 'NvimTree'
            wincmd l
        endif
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

nnoremap <C-\> :call TermToggle(&lines/3)<CR>
inoremap <C-\> <Esc>:call TermToggle(&lines/3)<CR>
tnoremap <C-\> <C-\><C-n>:call TermToggle(&lines/3)<CR>

" ------------------------
" Split navigation
" ------------------------
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Same keys work from inside terminal too
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" ------------------------
" Clipboard
" ------------------------
" Ctrl+Shift+C to copy to system clipboard
vnoremap <C-S-v> "+y
nnoremap <C-S-v> "+yy
