local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')
Plug('dense-analysis/ale')
Plug('nvim-lualine/lualine.nvim')
Plug('shaunsingh/nord.nvim')
Plug('francoiscabrol/ranger.vim')
Plug('rbgrouleff/bclose.vim')
Plug('soywod/himalaya', {['rtp'] = 'vim'})
Plug('romgrk/barbar.nvim')
Plug('lukas-reineke/indent-blankline.nvim')
-- Plug('numToStr/comment.nvim')
vim.call('plug#end')

vim.g.mapleader = " "

vim.opt.timeoutlen  = 500
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.encoding = 'utf-8'
vim.opt.textwidth = 100
vim.opt.scrolloff = 10
vim.opt.clipboard:append('unnamedplus')
vim.opt.guicursor= ''
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.selection = 'exclusive'
vim.opt.backspace = {'eol', 'start', 'indent'}
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.showmode = false 
vim.opt.autochdir = true
vim.opt.wildmenu = true
vim.opt.showmatch = true
vim.opt.hidden = true
vim.opt.ruler = true
vim.opt.magic = true
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.autoread = true
vim.opt.cursorline = true
vim.opt.whichwrap:append('h')
vim.opt.whichwrap:append('l')

require('indent_blankline').setup {}

local bufferline_state = require('bufferline.state')

vim.g.nord_contrast = false
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_italic = true
vim.g.nord_uniform_diff_background = true
require('nord').set()

require('bufferline').setup {
  animation = true,
  auto_hide = false,
  tabpages = true,
  closable = false,
  clickable = true,
  icons = 'numbers',
  icon_close_tab = 'x',
  icon_custom_colors = true,
  icon_separator_active = '',
  icon_separator_inactive = '',
  insert_at_end = true,
}

-- require('Comment').setup()

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'nord',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', {
        'diagnostics', 
        sources = {'ale'},
        sections = {'error', 'warn', 'info', 'hint'},
        diagnostics_color = {
          error = 'DiagnosticError',
          warn  = 'DiagnosticWarn',
          info  = 'DiagnosticInfo',
          hint  = 'DiagnosticHint',
        },
        symbols = { error = 'E', warn  = 'W', info  = 'I', hint  = 'H' },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      },
    },
    lualine_c = {'filename'},
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

vim.api.nvim_set_keymap('n', '<leader>j', ':bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>qq',':bdelete!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', ':edit<SPACE>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>ww', ':write!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':split<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-q>', ':close!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':split<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>W', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-x>', '<C-w>x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-down>', ':resize -1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-up>', ':resize +1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-left>', ':vertical resize -1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-right>', ':vertical resize +1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><CR>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<ESC>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pp',':setlocal paste!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ss',':setlocal spell!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cd',':cd %:p:h<CR>:pwd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n><CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', ':terminal<SPACE>', { noremap = true, silent = false })

-- return to last edit positions
vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

-- handle non-Vim files
vim.cmd([[au BufRead *.pdf,*.jpg,*.png,*.gif sil exe "!xdg-open " . shellescape(expand("%:p")) | bd | let &ft=&ft | redraw!]])

-- detect external file changes
vim.cmd([[au FocusGained,BufEnter * checktime]])

-- no line numbers in Terminal
vim.cmd([[au TermOpen * setlocal nonumber norelativenumber]])

-- insert mode in Terminal
-- vim.cmd[[au BufEnter * if &buftype == 'terminal' | :startinsert! | endif]]
