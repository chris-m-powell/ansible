-- plug-ins
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')
Plug('dense-analysis/ale')
Plug('nvim-lualine/lualine.nvim')
Plug('chris-m-powell/nord.nvim')
Plug('chris-m-powell/nvim-tree.lua')
Plug('soywod/himalaya', {['rtp'] = 'vim'})
Plug('romgrk/barbar.nvim')
Plug('lukas-reineke/indent-blankline.nvim')
Plug('numToStr/comment.nvim')
Plug('folke/which-key.nvim')
Plug('karb94/neoscroll.nvim')
Plug('lewis6991/gitsigns.nvim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('akinsho/toggleterm.nvim', {['tag'] = '*'})
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
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
vim.opt.selection = 'inclusive'
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
-- vim.opt.foldmethod = 'manual'
-- vim.opt.foldenable = false


-- nvim-cmp
vim.opt.completeopt=menu,menuone,noselect
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "bash", "python", "cpp", "yaml", "latex", "json", "markdown", "regex" },
  auto_install = true,
  highlight = {
    enable = true,
  },
}


-- gitsigns
require('gitsigns').setup()


-- neoscroll
require('neoscroll').setup()


-- indent_blankline
require('indent_blankline').setup {
  show_current_context = true,
}


-- nvim-tree
local nvim_tree = require('nvim-tree')
local get_node = require('nvim-tree.lib').get_node_at_cursor
local has_children = function(node) return type(node.nodes) == 'table' and vim.tbl_count(node.nodes) > 0 end
local key_down = vim.api.nvim_replace_termcodes('<Down>', true, true, true)

nvim_tree_go_out = function()
  local node = get_node()

  if node.name == '..' then
    require('nvim-tree.lib').dir_up()
    return
  end

  nvim_tree.on_keypress('close_node')
end

nvim_tree_go_in = function()
  local node = get_node()

  if node.name == '..' then
    vim.fn.feedkeys(key_down)
    return
  end

  if has_children(node) and node.open == true then
    vim.fn.feedkeys(key_down)
    return
  end

  nvim_tree.on_keypress('edit')

  if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'NvimTree' then return end

  node = get_node()
  if has_children(node) then vim.fn.feedkeys(key_down) end
end

require('nvim-tree').setup({
  sort_by = "case_sensitive",
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = true,
  open_on_setup = true,
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  view = {
    adaptive_size = false,
    mappings = {
      custom_only = false,
      list = {
        { key = "h", cb = '<cmd>lua nvim_tree_go_out()<CR>' },
        { key = "l", cb = '<cmd>lua nvim_tree_go_in()<CR>' },
        { key = "cw", action = "full_rename" },
        { key = "yy", action = "copy" },
        { key = "dd", action = "cut" },
        { key = "pp", action = "paste" },
        { key = "dD", action = "remove" },
        { key = "zh", action = "toggle_dotfiles" },
        { key = "ii", action = "toggle_file_info" },
        { key = "<Tab>", action = "preview" },
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
    require"nvim-tree".open()
  end
end


-- which-key
require('which-key').setup {
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
}

local wk = require("which-key")
wk.register({
  f = { toggle_replace, "Toggle file tree" },
  t = { ":ToggleTerm<CR>", "Toggle terminal" },
  b = {
    name = "Buffers",
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

local nvim_tree_events = require('nvim-tree.events')
local bufferline_state = require('bufferline.state')

local function get_tree_size()
  return require'nvim-tree.view'.View.width
end

nvim_tree_events.subscribe('TreeOpen', function()
  bufferline_state.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('Resize', function()
  bufferline_state.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe('TreeClose', function()
  bufferline_state.set_offset(0)
end)


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
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename'},
    lualine_x = {},
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


-- toggleterm
require("toggleterm").setup {
  start_in_insert = false,
}

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')



-- misc keymaps
vim.api.nvim_set_keymap('n', '<ESC>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', ":resize -1<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-Up>', ":resize +1<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-Left>', ":vertical resize -1<CR>", { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<C-Right>', ":vertical resize +1<CR>", { noremap = true, silent = false })


-- return to last edit positions
vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])


-- handle non-Vim files
vim.cmd([[au BufRead *.pdf,*.jpg,*.png,*.gif sil exe "!xdg-open " . shellescape(expand("%:p")) | bd | let &ft=&ft | redraw!]])


-- detect external file changes
vim.cmd([[au FocusGained,BufEnter * checktime]])


-- no line numbers in Terminal
vim.cmd([[au TermOpen * setlocal nonumber norelativenumber]])
