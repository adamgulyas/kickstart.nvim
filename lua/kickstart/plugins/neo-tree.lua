-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local M = {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    -- Set custom Git symbols directly within the setup call
    require('neo-tree').setup {
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = '󰗨', --  this can only be used in the git_status source
            renamed = '', -- this can only be used in the git_status source
            -- Status type
            untracked = '',
            ignored = '', --      󰧵
            unstaged = '', --  
            staged = '',
            conflict = '',
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {},
        },
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
      auto_open = true,
      update_to_buf_dir = {
        enable = true,
        auto_open = true,
      },
      update_cwd = true,
      view = {
        width = 30,
        side = 'left',
        auto_resize = true,
      },
    }
  end,
  cmd = 'Neotree',
  keys = {
    -- Use the custom function for the backslash keybinding
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
}

return M
