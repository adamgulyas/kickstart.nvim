-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    'mxsdev/nvim-dap-vscode-js',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'python',
        'node2',
        'chrome',
        -- 'firefox',
      },
    }

    dap.adapters.python = {
      type = 'executable',
      command = 'python3',
      args = { '-m', 'debugpy.adapter' },
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Python File',
        program = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.glob(cwd .. '/app.py') ~= '' then
            return 'app.py'
          elseif vim.fn.glob(cwd .. '/main.py') ~= '' then
            return 'main.py'
          elseif vim.fn.glob(cwd .. '/test.py') ~= '' then
            return 'test.py'
          else
            return '${file}'
          end
        end,
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.glob(cwd .. '/pyproject.toml') ~= '' then
            return vim.fn.system('poetry env info --path'):gsub('%s+$', '') .. '/bin/python'
          elseif vim.fn.glob(cwd .. '/venv/bin/python') ~= '' then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.glob(cwd .. '/.venv/bin/python') ~= '' then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python3'
          end
        end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Django Project',
        program = '${workspaceFolder}/manage.py',
        args = { 'runserver', '--noreload' },
        pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.glob(cwd .. '/pyproject.toml') ~= '' then
            return vim.fn.system('poetry env info --path'):gsub('%s+$', '') .. '/bin/python'
          elseif vim.fn.glob(cwd .. '/venv/bin/python') ~= '' then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.glob(cwd .. '/.venv/bin/python') ~= '' then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python3'
          end
        end,
        django = true,
      },
    }

    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
    }

    dap.adapters.chrome = {
      type = 'executable',
      command = 'node',
      args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js' },
    }
    -- Configurations for JavaScript, TypeScript, and TypeScriptReact
    dap.configurations.javascript = {
      {
        name = 'Launch Chrome',
        type = 'chrome',
        request = 'launch',
        url = 'http://localhost:3000',
        webRoot = '${workspaceFolder}/src',
        userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
      },
      {
        name = 'Attach to Chrome',
        type = 'chrome',
        request = 'attach',
        -- program = '${file}',
        processId = require('dap.utils').pick_process,
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = 9222, -- Default debugging port for Chrome
        webRoot = '${workspaceFolder}/src',
      },
      {
        name = 'Launch File',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        name = 'Attach to Process',
        type = 'node2',
        request = 'attach',
        processId = require('dap.utils').pick_process,
        cwd = vim.fn.getcwd(),
      },
    }

    dap.configurations.typescript = dap.configurations.javascript
    dap.configurations.typescriptreact = dap.configurations.javascript

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    vim.keymap.set('n', '<leader>dpr', function()
      dap.repl.open({}, 'vsplit')
    end, { desc = 'Debug: Open REPL' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▼', collapsed = '▶', current_frame = '' },
      controls = {
        icons = {
          pause = '',
          play = '',
          step_into = '↳', -- 󰆹
          step_over = '↱', -- 󰆷
          step_out = '↲', -- 󰆸
          step_back = '←',
          run_last = '',
          terminate = '',
          disconnect = '',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    -- 󰃤
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = '', numhl = '' })

    vim.cmd [[
      highlight DapBreakpoint guifg=#FF7B85
      highlight DapStopped guifg=#FFF24D
    ]]

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
