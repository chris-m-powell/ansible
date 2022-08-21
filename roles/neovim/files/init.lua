-- plug-ins
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')
Plug('dense-analysis/ale')
Plug('nvim-lualine/lualine.nvim')
Plug('shaunsingh/nord.nvim')
Plug('kyazdani42/nvim-tree.lua')
Plug('soywod/himalaya', {['rtp'] = 'vim'})
Plug('romgrk/barbar.nvim')
Plug('lukas-reineke/indent-blankline.nvim')
Plug('numToStr/comment.nvim')
Plug('folke/which-key.nvim')
Plug('karb94/neoscroll.nvim')
Plug('lewis6991/gitsigns.nvim')
vim.call('plug#end')

-- basic options
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
vim.opt.termguicolors = true


-- gitsigns
require('gitsigns').setup()


-- neoscroll
require('neoscroll').setup()


-- indent_blankline
require('indent_blankline').setup()


-- nvim-tree
require('nvim-tree').setup({
  sort_by = "case_sensitive",
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = true,
  open_on_setup = true,
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  respect_buf_cwd = true,
  view = {
    adaptive_size = false,
    mappings = {
      custom_only = false,
      list = {
        { key = "h", action = "dir_up" },
        { key = "l", action = "dir_down" },
    --    { key = "l", action = "edit" },
        { key = "l", action = "edit_in_place" },
        { key = "cw", action = "rename" },
        { key = "yy", action = "copy" },
        { key = "dd", action = "cut" },
        { key = "pp", action = "paste" },
        { key = "dD", action = "remove" },
        { key = "ii", action = "toggle_file_info" },
        { key = "zh", action = "toggle_dotfiles" },
        { key = "t", action = "toggle_mark" },
      },
    },
  },
  renderer = {
    highlight_opened_files = "all",
    indent_markers = {
      enable = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "├",
        none = " ",
      }
    },
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false,
      },
      glyphs = {
        bookmark = "-",
      },
    },
  },
  filters = {
    dotfiles = true,
  },
})

local function toggle_replace()
  local view = require"nvim-tree.view"
  if view.is_visible() then
    view.close()
  else
    require"nvim-tree".open_replacing_current_buffer()
  end
end

-- which-key
require('which-key').setup {
  key_labels = {
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
}

local wk = require("which-key")
wk.register({
  f = { toggle_replace, "File tree" },
  b = {
    name = "Buffer management",
    q = {
      name = "Delete",
      q = { ":bdelete!<CR>", "Delete current buffer" },
      o = { ":%bd|e#|bd#<CR>", "Delete all other buffers" },
    },
    w = { ":write!<CR>", "Write current buffer" },
    j = { ":bprevious<CR>", "Go to previous buffer" },
    k = { ":bnext<CR>", "Go to next buffer" },
    ["1"] = { ":BufferGoto 1<CR>", "Go to buffer 1" },
    ["2"] = { ":BufferGoto 2<CR>", "Go to buffer 2" },
    ["3"] = { ":BufferGoto 3<CR>", "Go to buffer 3" },
    ["4"] = { ":BufferGoto 4<CR>", "Go to buffer 4" },
    ["5"] = { ":BufferGoto 5<CR>", "Go to buffer 5" },
    ["6"] = { ":BufferGoto 6<CR>", "Go to buffer 6" },
    ["7"] = { ":BufferGoto 7<CR>", "Go to buffer 7" },
    ["8"] = { ":BufferGoto 8<CR>", "Go to buffer 8" },
    ["9"] = { ":BufferGoto 9<CR>", "Go to buffer 9" },
    ["0"] = { ":BufferGoto 0<CR>", "Go to buffer 0" },
  },
  w = {
    name = "Window management",
    q = {
      name = "Close window",
      q = { ":close!<CR>", "Close current window" },
      o = { ":only<CR>", "Close all other windows" },
    },
    s = {
      name = "Split",
      s = { ":split<CR>", "Split with current buffer" },
      j = { ":sbp<CR>", "Split with previous buffer" },
      k = { ":sbn<CR>", "Split with next buffer" },
      t = { ":split +term<CR>", "Split with terminal buffer" },
    },
    v = {
      name = "Vertical split",
      v = { ":vsplit<CR>", "Vertical split with current buffer" },
      j = { ":vertical sbp<CR>", "Vertical split with previous buffer" },
      k = { ":vertical sbn<CR>", "Vertical split with next buffer" },
      t = { ":vsplit +term<CR>", "Vertical split with terminal buffer" },
    },
    h = { "<C-w>h", "Move to window on the left" },
    j = { "<C-w>j", "Move to window below" },
    k = { "<C-w>k", "Move to window above" },
    l = { "<C-w>l", "Move to window on the right" },
    x = { "<C-w>x", "Exchange current window with next" },
    H = { "<C-w>H", "Move window to far left" },
    J = { "<C-w>J", "Move window to very bottom" },
    K = { "<C-w>K", "Move window to very top" },
    L = { "<C-w>L", "Move window to far right" },
    ["<Down>"] = { ":resize -1<CR>", "Reduce horizontal split size" },
    ["<Up>"] = { ":resize +1<CR>", "Increase horizontal split size" },
    ["<left>"] = { ":vertical resize -1<CR>", "Reduce vertical split size" },
    ["<Right>"] = { ":vertical resize +1<CR>", "Increase vertical split size" },
    ["="] = { "<C-w>=", "Balance split windows" },
  },
  t = {
    name = "Tab management",
    n = { ":tabnew<CR>", "New tab" },
    q = { ":tabclose<CR>", "Close tab" },
    j = { ":tabprevious<CR>", "Previous tab" },
    k = { ":tabnext<CR>", "Next tab" },
    o = { ":tabo<CR>", "Close all other tabs" },
  }
}, { prefix= "<leader>" })


-- nord
vim.g.nord_contrast = false
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_italic = true
vim.g.nord_uniform_diff_background = true
require('nord').set()


-- barbar
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


-- comment
require('Comment').setup()


-- lualine
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


vim.api.nvim_set_keymap('n', '<ESC>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n><CR>', { noremap = true, silent = true })


-- return to last edit positions
vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])


-- handle non-Vim files
vim.cmd([[au BufRead *.pdf,*.jpg,*.png,*.gif sil exe "!xdg-open " . shellescape(expand("%:p")) | bd | let &ft=&ft | redraw!]])


-- detect external file changes
vim.cmd([[au FocusGained,BufEnter * checktime]])


-- no line numbers in Terminal
vim.cmd([[au TermOpen * setlocal nonumber norelativenumber]])
