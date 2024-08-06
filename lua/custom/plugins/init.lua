-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  -- {
  --   'goolord/alpha-nvim',
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons',
  --   },
  --
  --   config = function()
  --     local alpha = require 'alpha'
  --     local dashboard = require 'alpha.themes.startify'
  --
  --     local function lolcat_header(header)
  --       local handle = io.popen("echo '" .. table.concat(header, '\n') .. "' | lolcat")
  --       local result = handle:read '*a'
  --       handle:close()
  --       return vim.split(result, '\n')
  --     end
  --
  --     local header = {
  --       [[                                                                       ]],
  --       [[                                                                       ]],
  --       [[                                                                       ]],
  --       [[                                                                       ]],
  --       [[                                                                     ]],
  --       [[       ████ ██████           █████      ██                     ]],
  --       [[      ███████████             █████                             ]],
  --       [[      █████████ ███████████████████ ███   ███████████   ]],
  --       [[     █████████  ███    █████████████ █████ ██████████████   ]],
  --       [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
  --       [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
  --       [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
  --       [[                                                                       ]],
  --       [[                                                                       ]],
  --       [[                                                                       ]],
  --     }
  --
  --     dashboard.section.header.val = lolcat_header(header)
  --
  --     -- require('alpha').setup {
  --     --   layout = {
  --     --     { type = 'text', val = lolcat_header(header), opts = { position = 'center' } },
  --     --     -- Add other components like buttons here
  --     --   },
  --     --   -- Add other settings if needed
  --     -- }
  --     -- Define a highlight group for the header
  --     -- vim.api.nvim_set_hl(0, 'AlphaHeader', { fg = '#bce368', bg = 'NONE', bold = true })
  --     --
  --     -- Apply the highlight group to the header
  --     dashboard.section.header.opts = {
  --       position = 'center',
  --       -- hl = 'AlphaHeader',
  --     }
  --
  --     alpha.setup(dashboard.opts)
  --   end,
  -- },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      local cat_cmd = 'cat | lolcat -F 0.3'
      require('dashboard').setup {
        shortcut_type = 'number',
        theme = 'hyper',
        hide = {
          statusline = false, -- hide statusline default is true
          tabline = true, -- hide the tabline
          winbar = true, -- hide winbar
        },
        preview = {
          command = cat_cmd,
          file_path = '$HOME/.config/nvim/lua/custom/utils/dashboard_header.txt', -- preview file path
          file_height = 11, -- preview file height
          file_width = 70, -- preview file width
        },
        config = {
          header = {
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
          },
          footer = {},
          shortcut = {},
          packages = { enable = false }, -- show how many plugins neovim loaded
          -- limit how many projects list, action when you press key or enter it will run this action.
          -- action can be a functino type, e.g.
          -- action = func(path) vim.cmd('Telescope find_files cwd=' .. path) end
          project = { enable = false, limit = 8, icon = '', label = '', action = 'Telescope find_files cwd=' },
          -- mru = { limit = 10, icon = ' ', label = '', cwd_only = false },
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          close_command = 'bdelete! %d', -- can be a string | function, see "Mouse actions"
          right_mouse_command = 'bdelete! %d', -- can be a string | function, see "Mouse actions"
          left_mouse_command = 'buffer %d', -- can be a string | function, see "Mouse actions"
          middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
          indicator = {
            icon = '▌', -- this should be omitted if indicator style is not 'icon'
            style = 'icon', -- can also be 'underline'|'none',
          },
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
          },
          buffer_close_icon = '✕',
          modified_icon = '',
          close_icon = '✕',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 18,
          max_prefix_length = 15, -- prefix used when a buffer is deduplicated
          tab_size = 18,
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level)
            local icon = level:match 'error' and ' ' or ' '
            return ' ' .. icon .. count
          end,
          offsets = { { filetype = 'Neotree', text = 'File Explorer', text_align = 'left' } },
          show_buffer_icons = true, -- disable filetype icons for buffers
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
          separator_style = 'thin', -- | "thick" | "thin" | { 'any', 'any' },
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          sort_by = 'id',
        },
      }

      -- Keybindings to move between tabs
      vim.api.nvim_set_keymap('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>6', ':BufferLineGoToBuffer 6<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>7', ':BufferLineGoToBuffer 7<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>8', ':BufferLineGoToBuffer 8<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>9', ':BufferLineGoToBuffer 9<CR>', { noremap = true, silent = true })

      -- Keybindings to cycle through buffers
      vim.api.nvim_set_keymap('n', '<leader>ll', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>hh', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'ggandor/leap.nvim',
    keys = { 's', 'S' }, -- Specify keys that trigger loading
    config = function()
      require('leap').add_default_mappings()
      -- The below settings make Leap's highlighting closer to what you've been
      -- used to in Lightspeed.

      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey
      vim.api.nvim_set_hl(0, 'LeapMatch', {
        -- For light themes, set to 'black' or similar.
        fg = 'black',
        bg = '#32c202',
        bold = true,
        nocombine = true,
      })

      -- Lightspeed colors
      -- primary labels: bg = "#f02077" (light theme) or "#ff2f87"  (dark theme)
      -- secondary labels: bg = "#399d9f" (light theme) or "#99ddff" (dark theme)
      -- shortcuts: bg = "#f00077", fg = "white"
      -- You might want to use either the primary label or the shortcut colors
      -- for Leap primary labels, depending on your taste.
      vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
        fg = 'white',
        bg = '#ff2f87',
        bold = true,
        nocombine = true,
      })
      vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
        fg = 'white',
        bg = '#4287f5',
        bold = true,
        nocombine = true,
      })
      -- Try it without this setting first, you might find you don't even miss it.
      require('leap').opts.highlight_unlabeled_phase_one_targets = true
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'kawre/neotab.nvim',
  },
  {
    'abecodes/tabout.nvim',
    lazy = false,
    config = function()
      require('tabout').setup {
        tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true, -- shift content if tab out is not possible
        act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        completion = false, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = '(', close = ')' },
          { open = '[', close = ']' },
          { open = '{', close = '}' },
          { open = '[', close = ']' },
          { open = '{', close = '}' },
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = '`', close = '`' },
          { open = '<', close = '>' },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      }
    end,
    dependencies = { -- These are optional
      'nvim-treesitter/nvim-treesitter',
      'L3MON4D3/LuaSnip',
      'hrsh7th/nvim-cmp',
      'kawre/neotab.nvim',
    },
    opt = true, -- Set this to true if the plugin is optional
    event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },
  {
    'L3MON4D3/LuaSnip',
    keys = function()
      -- Disable default tab keybinding in LuaSnip
      return {}
    end,
  },
  {
    'brenoprata10/nvim-highlight-colors',
    config = function()
      require('nvim-highlight-colors').setup {}
    end,
  },
  {
    'tpope/vim-obsession',
  },
  { 'eandrju/cellular-automaton.nvim' },
  { 'wakatime/vim-wakatime', lazy = false },
}
