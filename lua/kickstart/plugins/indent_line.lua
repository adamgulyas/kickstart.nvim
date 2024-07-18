local base_highlight = {
  'RainbowBaseCyan',
  'RainbowBaseViolet',
  'RainbowBaseGreen',
  'RainbowBaseBlue',
  'RainbowBaseOrange',
  'RainbowBaseYellow',
  'RainbowBaseRed',
}
local scope_highlight = {
  'RainbowScopeCyan',
  'RainbowScopeViolet',
  'RainbowScopeGreen',
  'RainbowScopeBlue',
  'RainbowScopeOrange',
  'RainbowScopeYellow',
  'RainbowScopeRed',
}

return {
  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      local status_ok, rainbow_delimiters = pcall(require, 'rainbow-delimiters')

      if not status_ok then
        print 'Rainbow Delimiters not found!'
        return
      end

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
          python = 'rainbow-delimiters',
        },
        priority = {
          [''] = 110,
          lua = 210,
          python = 210,
        },
        highlight = scope_highlight,
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      local hooks = require 'ibl.hooks'

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

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

      -- Reload highlights when colorscheme changes
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          hooks.trigger(hooks.type.HIGHLIGHT_SETUP)
        end,
      })
    end,
    main = 'ibl',
    opts = {},
  },
}
