
vim.opt.fileencoding = 'utf-8'
-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy' },

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use 'mhartington/formatter.nvim' -- install Formatter Plugin
  use 'WhoIsSethDaniel/mason-tool-installer.nvim' -- for installing Mason tools automatically

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'
  use 'kdheepak/lazygit.nvim' -- lazygit needs to be installed on the system
  use 'aspeddro/gitui.nvim' -- gitui needs to be installed on the system

  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  use 'ellisonleao/gruvbox.nvim' -- Gruvbox Theme (it is the best change my mind)
  use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"  } -- Todos
  use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" } -- Trouble useful for todos
  use { "rust-lang/rust.vim" }

  -- Add support for nushell language
  use { "LhKipp/nvim-nu", { run = ":TSInstall nu" } }

  -- Obsidian.md
  use {
   "epwalsh/obsidian.nvim",
    tag = "*",
    requires = {
      "hrsh7th/nvim-cmp",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set conceal level for obsidian.nvim
vim.o.conceallevel = 2

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- gitui
require('gitui').setup()

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vimdoc', 'vim', 'markdown', 'markdown_inline' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.nu = {
  install_info = {
    url = "https://github.com/nushell/tree-sitter-nu",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "nu",
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- tsserver = {},
  -- gopls = {},
  -- pyright = {},
  clangd = {},
  csharp_ls = {},
  rust_analyzer = {},
  pylsp = {},
  texlab = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = {
  'clangd',
  'csharp_ls',
  'rust_analyzer',
  'pylsp',
  'texlab'}
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- [[ Configure todo-comments ]]
-- see `:help todo-comments`
require("todo-comments").setup()

-- [[ Configure Trouble ]]
-- see `:help trouble`
require("trouble").setup()

-- Ensure formatters are installed
require("mason-tool-installer").setup {
  ensure_installed = {
    'clang-format',
    'rustfmt',
    'csharpier',
  },
  auto_update = true,
  debounce_hours = 3,
}

-- [[ Configure formatter ]]
-- see `:help formatter`
local util = require "formatter.util"
local function remove_trailing_cr(input)
  if (nil == input) then
    return nil
  end
  for i, line in pairs(input) do
    input[i] = line:gsub("\r", "")
  end
  return input
end
require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    cs = {
      function()
        return {
          exe = "dotnet csharpier",
          args = {
            "--skip-write",
            "--write-stdout",
            util.get_current_buffer_file_path(),
          },
          stdin = true,
          transform = remove_trailing_cr,
        }
      end
    },
    rust = {
      require("formatter.filetypes.rust").rustfmt
    },
    cpp = {
      require("formatter.filetypes.cpp").clangformat
    },
    c = {
      require("formatter.filetypes.c").clangformat
    },
    ["*"] = {
      function()
        return {
          exe = "\"C:\\Program Files\\Git\\usr\\bin\\sed.exe\"",
          args = {
            "'s/[ \t]*$//'",
          },
          stdin = true,
        }
      end
    }
  }
}

-- change default shell to Bash
vim.o.shell = "cmd"
-- [[ Configure nvim-nu ]]
require("nu").setup{
  use_lsp_features = false
}

-- [[ Configure obsidian.nvim ]]
require("obsidian").setup({
  -- A list of vault names and paths.
  -- Each path should be the path to the vault root. If you use the Obsidian app,
  -- the vault root is the parent directory of the `.obsidian` folder.
  -- You can also provide configuration overrides for each workspace through the `overrides` field.
  workspaces = {
    {
      name = "notes",
      path = "~/Documents/KNOWLEDGE",
      overrides = {
        notes_subdir = "Zettelkasten",
      }
    },
  },

  -- Alternatively - and for backwards compatibility - you can set 'dir' to a single path instead of
  -- 'workspaces'. For example:
  -- dir = "~/vaults/work",

  -- Optional, set to true to use the current directory as a vault; otherwise
  -- the first workspace is opened by default.
  detect_cwd = false,

  -- Optional, if you keep notes in a specific subdirectory of your vault.

  -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
  -- levels defined by "vim.log.levels.*".
  log_level = vim.log.levels.INFO,

  daily_notes = {
    -- Optional, if you keep daily notes in a separate directory.
    folder = "Meetings",
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d-",
    -- Optional, if you want to change the date format of the default alias of daily notes.
    alias_format = "%B %-d, %Y",
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = "Templates/Meeting.md",
  },

  ---- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
  --completion = {
  --  -- Set to false to disable completion.
  --  nvim_cmp = true,

  --  -- Trigger completion at 2 chars.
  --  min_chars = 2,

  --  -- Where to put new notes created from completion. Valid options are
  --  --  * "current_dir" - put new notes in same directory as the current buffer.
  --  --  * "notes_subdir" - put new notes in the default notes subdirectory.
  --  new_notes_location = "notes_subdir",

  --  -- Control how wiki links are completed with these (mutually exclusive) options:
  --  --
  --  -- 1. Whether to add the note ID during completion.
  --  -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
  --  -- Mutually exclusive with 'prepend_note_path' and 'use_path_only'.
  --  prepend_note_id = true,
  --  -- 2. Whether to add the note path during completion.
  --  -- E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
  --  -- Mutually exclusive with 'prepend_note_id' and 'use_path_only'.
  --  prepend_note_path = false,
  --  -- 3. Whether to only use paths during completion.
  --  -- E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
  --  -- Mutually exclusive with 'prepend_note_id' and 'prepend_note_path'.
  --  use_path_only = false,
  --},

  -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
  -- way then set 'mappings = {}'.
  mappings = {
  },

  -- Optional, customize how names/IDs for new notes are created.
  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    -- In this case a note with the title 'My new note' will be given an ID that looks
    -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,

  -- Optional, boolean or a function that takes a filename and returns a boolean.
  -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
  disable_frontmatter = false,

  -- Optional, alternatively you can customize the frontmatter data.
  note_frontmatter_func = function(note)
    -- This is equivalent to the default frontmatter function.
    local out = { id = note.id, aliases = note.aliases, tags = note.tags }
    -- `note.metadata` contains any manually added fields in the frontmatter.
    -- So here we just make sure those fields are kept in the frontmatter.
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end
    return out
  end,

  -- Optional, for templates (see below).
  templates = {
    subdir = "Templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    -- A map for custom variables, the key should be the variable and the value a function
    substitutions = {},
  },

  -- Optional, customize the backlinks interface.
  backlinks = {
    -- The default height of the backlinks pane.
    height = 10,
    -- Whether or not to wrap lines.
    wrap = true,
  },

  -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
  -- URL it will be ignored but you can customize this behavior here.
  follow_url_func = function(url)
    -- Open the URL in the default web browser.
    vim.fn.jobstart({"cmd", "/C", "start", url})  -- Windows
    -- vim.fn.jobstart({"open", url})  -- Mac OS
    -- vim.fn.jobstart({"xdg-open", url})  -- linux
  end,

  -- Optional, set to true if you use the Obsidian Advanced URI plugin.
  -- https://github.com/Vinzent03/obsidian-advanced-uri
  use_advanced_uri = false,

  -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
  open_app_foreground = false,

  -- Optional, by default commands like `:ObsidianSearch` will attempt to use
  -- telescope.nvim, fzf-lua, fzf.vim, or mini.pick (in that order), and use the
  -- first one they find. You can set this option to tell obsidian.nvim to always use this
  -- finder.
  finder = "telescope.nvim",

  -- Optional, configure key mappings for the finder. These are the defaults.
  -- If you don't want to set any mappings this way then set
  finder_mappings = {
    -- Create a new note from your query with `:ObsidianSearch` and `:ObsidianQuickSwitch`.
    -- Currently only telescope supports this.
    new = "<C-n>",
  },

  -- Optional, sort search results by "path", "modified", "accessed", or "created".
  -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
  -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
  sort_by = "modified",
  sort_reversed = true,

  -- Optional, determines how certain commands open notes. The valid options are:
  -- 1. "current" (the default) - to always open in the current window
  -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
  -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
  open_notes_in = "current",

  -- Optional, configure additional syntax highlighting / extmarks.
  -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
  ui = {
    enable = true,  -- set to false to disable all additional syntax features
    update_debounce = 200,  -- update delay after a text change (in milliseconds)
    -- Define how various check-boxes are displayed
    checkboxes = {
      -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
      [" "] = { char = "", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
      [">"] = { char = ">", hl_group = "ObsidianRightArrow" },
      ["~"] = { char = " ", hl_group = "ObsidianTilde" },
      -- Replace the above with this if you don't have a patched font:
      -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
      -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

      -- You can also add more custom ones...
    },
    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    -- Replace the above with this if you don't have a patched font:
    -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    reference_text = { hl_group = "ObsidianRefText" },
    highlight_text = { hl_group = "ObsidianHighlightText" },
    tags = { hl_group = "ObsidianTag" },
    hl_groups = {
      -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#89ddff" },
      ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
      ObsidianTilde = { bold = true, fg = "#ff5370" },
      ObsidianRefText = { underline = true, fg = "#c792ea" },
      ObsidianExtLinkIcon = { fg = "#c792ea" },
      ObsidianTag = { italic = true, fg = "#89ddff" },
      ObsidianHighlightText = { bg = "#75662e" },
    },
  },

  -- Specify how to handle attachments.
  attachments = {
    -- The default folder to place images in via `:ObsidianPasteImg`.
    -- If this is a relative path it will be interpreted as relative to the vault root.
    -- You can always override this per image by passing a full path to the command instead of just a filename.
    img_folder = "assets/imgs",  -- This is the default
    -- A function that determines the text to insert in the note when pasting an image.
    -- It takes two arguments, the `obsidian.Client` and a plenary `Path` to the image file.
    -- This is the default implementation.
    ---@param client obsidian.Client
    ---@param path Path the absolute path to the image file
    ---@return string
    img_text_func = function(client, path)
      local link_path
      local vault_relative_path = client:vault_relative_path(path)
      if vault_relative_path ~= nil then
        -- Use relative path if the image is saved in the vault dir.
        link_path = vault_relative_path
      else
        -- Otherwise use the absolute path.
        link_path = tostring(path)
      end
      local display_name = vim.fs.basename(link_path)
      return string.format("![%s](%s)", display_name, link_path)
    end,
  },

  -- Optional, set the YAML parser to use. The valid options are:
  --  * "native" - uses a pure Lua parser that's fast but potentially misses some edge cases.
  --  * "yq" - uses the command-line tool yq (https://github.com/mikefarah/yq), which is more robust
  --    but much slower and needs to be installed separately.
  -- In general you should be using the native parser unless you run into a bug with it, in which
  -- case you can temporarily switch to the "yq" parser until the bug is fixed.
  yaml_parser = "native",
})
-- personal settings
local tabwidth = 2
vim.o.tabstop = tabwidth
vim.o.shiftwidth = tabwidth
vim.o.expandtab = false
vim.o.scrolloff = 8
vim.o.cursorline = true
vim.o.listchars="eol:$,tab:>_,trail:~,extends:>,precedes:<,space:␣"
vim.keymap.set('n', '<C-S>', ':wall<cr>:qall<cr>', { silent = true, desc = 'Write all buffers and close windows' })
vim.keymap.set('i', '<C-S>', '<C-c>:wall<cr>:qall<cr>', { silent = true, desc = 'Write all buffers and close windows' })
vim.keymap.set('n', '<leader>n', ':cn<cr>', { silent = true, desc = 'Jump to next quickfix error' })
vim.keymap.set('n', '<leader>p', ':cp<cr>', { silent = true, desc = 'Jump to previous quickfix error' })
vim.keymap.set('n', '<leader>j', ']c', { silent = true, desc = 'Jump to start of next change' })
vim.keymap.set('n', '<leader>k', '[c', { silent = true, desc = 'Jump to start of previous change' })
vim.keymap.set('t', '<leader><Esc>', '<C-\\><C-n>', { silent = true, desc = 'Exit Terminal' })
vim.keymap.set('t', '<C-W>', '<C-\\><C-n><C-W>', { desc = 'Window commands for Terminal'})
local opts = { silent = true, desc = '[T]oggle line [n]umbers' }
vim.keymap.set('t', '<leader>tn', '<C-\\><C-o>:set number! relativenumber!<cr>', opts)
vim.keymap.set('n', '<leader>tn', ':set number! relativenumber!<cr>', opts)
opts = { silent = true, desc = 'Toggle printing of whitespace charaters' }
vim.keymap.set('n', '<F5>', ':set list!<CR>', opts)
vim.keymap.set('i', '<F5>', '<C-o>:set list!<CR>', opts)
vim.keymap.set('c', '<F5>', '<C-c>:set list!<CR>', opts)
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { silent = true, desc = 'Launch [L]azy[G]it' })
vim.keymap.set('n', '<leader>gu', ':Gitui<CR>', { silent = true, desc = 'Launch [G]it[u]i' })
-- Todo keymappings
vim.keymap.set('n', '<leader>tf', ':TodoTelescope keywords=FIX,FIXME,BUG,FIXIT,ISSUE<CR>', { silent = true, desc = 'Open [T]odos [F]ixes' })
vim.keymap.set('n', '<leader>tw', ':TodoTelescope keywords=WARNING,WARN,XXX<CR>', { silent = true, desc = 'Open [T]odos [W]arnings' })
vim.keymap.set('n', '<leader>tt', ':TodoTelescope keywords=TODO<CR>', { silent = true, desc = 'Open [T]odos [T]odo' })
vim.keymap.set('n', '<leader>td', ':TodoTelescope<CR>', { silent = true, desc = 'Open [T]o[d]os' })
-- keymapping for time stamps
vim.keymap.set('n', '<leader>ts', ':lua vim.api.nvim_set_current_line(vim.api.nvim_get_current_line()..os.date("%H:%M"))<cr>', { silent = true, desc = 'Append current [T]ime[s]tamp' })
vim.keymap.set('n', '<leader>ds', ':lua vim.api.nvim_set_current_line(vim.api.nvim_get_current_line()..os.date("%d.%m.%y"))<cr>', { silent = true, desc = 'Append current [D]ate[s]tamp' })
vim.keymap.set('n', 'gf', function ()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "gf"
  end
end,
{ noremap = false, expr = true, desc = "Follow markdown link" })
vim.keymap.set('n', '<leader>x', function()
  return require("obsidian").util.toggle_checkbox()
end,
{ desc = "Toggle markdown checkbox" })
vim.keymap.set('n', '<leader>so',  '<cmd>ObsidianSearch<CR>',
{ silent = true, desc = 'Text search in Obsidian vault files' })
