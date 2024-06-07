return {
  {
    'github/copilot.vim',
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'github/copilot.vim' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
      question_header = '',
      answer_header = '',
      error_header = '',
      allow_insecure = true,
      window = {
        width = 0.45,
      },
      mappings = {
        submit_prompt = {
          insert = '',
        },
        reset = {
          normal = '',
          insert = '',
        },
      },
      prompts = {
        Explain = {
          mapping = '<leader>ae',
          description = 'AI Explain',
        },
        Review = {
          mapping = '<leader>ar',
          description = 'AI Review',
        },
        Tests = {
          mapping = '<leader>at',
          description = 'AI Tests',
        },
        Fix = {
          mapping = '<leader>af',
          description = 'AI Fix',
        },
        Optimize = {
          mapping = '<leader>ao',
          description = 'AI Optimize',
        },
        Docs = {
          mapping = '<leader>ad',
          description = 'AI Documentation',
        },
        CommitStaged = {
          mapping = '<leader>ac',
          description = 'AI Generate Commit',
        },
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
