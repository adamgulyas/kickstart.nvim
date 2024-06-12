return {
  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require 'rainbow-delimiters'

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    config = function()
      local base_highlight = {
        'RainbowBaseRed',
        'RainbowBaseYellow',
        'RainbowBaseBlue',
        'RainbowBaseViolet',
        'RainbowBaseGreen',
        'RainbowBaseCyan',
        'RainbowBaseOrange',
      }
      local scope_highlight = {
        'RainbowScopeRed',
        'RainbowScopeYellow',
        'RainbowScopeBlue',
        'RainbowScopeViolet',
        'RainbowScopeGreen',
        'RainbowScopeCyan',
        'RainbowScopeOrange',
      }

      local hooks = require 'ibl.hooks'
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowBaseRed', { fg = '#4d2333' })
        vim.api.nvim_set_hl(0, 'RainbowBaseYellow', { fg = '#6b5231' })
        vim.api.nvim_set_hl(0, 'RainbowBaseBlue', { fg = '#37516a' })
        vim.api.nvim_set_hl(0, 'RainbowBaseOrange', { fg = '#692F5C' })
        vim.api.nvim_set_hl(0, 'RainbowBaseGreen', { fg = '#4b6241' })
        vim.api.nvim_set_hl(0, 'RainbowBaseViolet', { fg = '#583d6a' })
        vim.api.nvim_set_hl(0, 'RainbowBaseCyan', { fg = '#385262' })
        vim.api.nvim_set_hl(0, 'RainbowScopeRed', { fg = '#f7768e' })
        vim.api.nvim_set_hl(0, 'RainbowScopeYellow', { fg = '#e0af68' })
        vim.api.nvim_set_hl(0, 'RainbowScopeBlue', { fg = '#7aa2f7' })
        vim.api.nvim_set_hl(0, 'RainbowScopeOrange', { fg = '#ED7BD4' })
        vim.api.nvim_set_hl(0, 'RainbowScopeGreen', { fg = '#9ece6a' })
        vim.api.nvim_set_hl(0, 'RainbowScopeViolet', { fg = '#bb9af7' })
        vim.api.nvim_set_hl(0, 'RainbowScopeCyan', { fg = '#7dcfff' })
      end)

      require('ibl').setup {
        indent = {
          highlight = base_highlight,
          char = '│',
        },
        whitespace = {
          highlight = { 'Function', 'Label' },
          remove_blankline_trail = true,
        },
        scope = {
          highlight = scope_highlight,
        },
      }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
    main = 'ibl',
    opts = {},
  },
}
