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
      }
    end,
  },
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
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

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      vim.g.rainbow_delimiters = { highlight = scope_highlight }

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
          char = '▏',
        },
        whitespace = {
          highlight = scope_highlight,
          remove_blankline_trail = true,
        },
        scope = {
          highlight = scope_highlight,
          include = {
            node_type = {
              python = { 'function', 'class', 'block', 'compound_statement' },
              lua = { 'function', 'table_constructor', 'block' },
            },
          },
        },
        exclude = {
          filetypes = { 'help', 'dashboard', 'dashpreview', 'NvimTree', 'vista_kind', 'terminal', 'packer' },
        },
      }

      -- -- Define custom highlight groups
      -- vim.cmd [[
      --   highlight IndentBlanklineChar guifg=#2a2e36 gui=nocombine
      --   highlight IndentBlanklineContextChar guifg=#61afef gui=nocombine
      --   highlight IndentBlanklineSpaceChar guifg=#2a2e36 gui=nocombine
      --   highlight IndentBlanklineSpaceCharBlankline guifg=#2a2e36 gui=nocombine
      -- ]]

      -- Optionally, set additional context-specific highlights for Python and Lua
      vim.cmd [[
        augroup IndentBlanklineColors
            autocmd!
            autocmd FileType python highlight IndentBlanklineContextChar guifg=#98c379 gui=nocombine
            autocmd FileType lua highlight IndentBlanklineContextChar guifg=#e5c07b gui=nocombine
        augroup END
      ]]
    end,
    main = 'ibl',
    opts = {},
  },
}
