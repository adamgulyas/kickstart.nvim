function read_file_lines(file_path)
  local lines = {}
  for line in io.lines(file_path) do
    table.insert(lines, line)
  end
  return lines
end

return {
  {
    'goolord/alpha-nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },

    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'
      local startify = require 'alpha.themes.startify'
      require 'alpha.term'

      ASCII_IMAGES_FOLDER = os.getenv 'HOME' .. '/.config/nvim/lua/custom/ansi_images'

      -- Ascii images have the extension .cat, and colored ascii images have
      -- the extension .ccat,
      --
      -- Lolcat will only be used with the non colored ascii images
      local function list_files(path, extension)
        local files = {}
        local pfile = io.popen('ls ' .. path .. '/*' .. extension)

        if pfile ~= nil then
          for filename in pfile:lines() do
            table.insert(files, filename)
          end
        else
          print 'Error: pfile is nil'
        end

        return files
      end

      local function get_random_ascii_image(path)
        math.randomseed(os.clock())

        -- For some reason ls *.(cat|ccat) will not work under vim,
        -- so gotta ls twice and merge

        local images = list_files(path, '.cat')
        local colored_images = list_files(path, '.ccat')

        for _, v in pairs(colored_images) do
          table.insert(images, v)
        end

        return images[math.random(1, #images)]
      end

      local function remove_escaped_colors(str)
        return str:gsub('\27%[[0-9;]*m', '')
      end

      local function get_ascii_image_dim(path)
        local width = 0
        local height = 0

        local pfile = io.open(path, 'r')

        if pfile ~= nil then
          for line in pfile:lines() do
            -- Take into account colored output
            line = remove_escaped_colors(line)
            local current_width = vim.fn.strdisplaywidth(line)
            if current_width > width then
              width = current_width
            end
            height = height + 1
          end
        end

        -- For some reason, after the last update or something,
        -- I have to add 2 to width, otherwise the image is not
        -- displayed correctly
        width = width + 2

        return { width, height }
      end

      local function is_colored_image(path)
        return path:sub(-4) == 'ccat'
      end

      local random_image = get_random_ascii_image(ASCII_IMAGES_FOLDER)

      local image_width, image_height
      local dimensions = get_ascii_image_dim(random_image)
      if dimensions and #dimensions >= 2 then
        image_width, image_height = unpack(dimensions)
        -- Use image_width and image_height here
      else
        -- Handle the error case where dimensions are not valid
        print 'Error: Invalid dimensions returned for the image'
      end

      -- image_height = 24

      -- This avoids "process exited message"
      local command = 'cat | '
      command = command .. 'cat '

      -- if is_colored_image(random_image) then
      --   command = command .. 'cat '
      -- else
      --   -- command = "animated-lolcat"
      --   command = os.getenv 'HOME' .. '/.config/nvim/lua/custom/utils/animated_lolcat.sh '
      -- end

      local terminal = {
        type = 'terminal',
        command = command .. random_image .. ' | lolcat -F 0.3',
        width = image_width,
        height = image_height,

        opts = {
          redraw = true,
          window_config = {},
        },
      }

      -- local header = {
      --   type = 'text',
      --   val = read_file_lines(header_file),
      --   opts = {
      --     position = 'center',
      --     hl = 'Type',
      --     -- wrap = "overflow";
      --   },
      -- }

      local footer = {
        type = 'text',
        val = '',
        opts = {
          position = 'center',
          hl = 'Number',
        },
      }

      local function button(sc, txt, keybind, keybind_opts)
        return dashboard.button(sc, txt, keybind, keybind_opts)
      end

      local buttons = {
        type = 'group',
        val = {
          button('e', '  New file', '<cmd>ene <CR>'),
          button('SPC f f', '󰈞  Find file'),
          button('SPC f h', '󰊄  Recently opened files'),
          button('SPC f r', '  Frecency/MRU'),
          button('SPC f g', '󰈬  Find word'),
          button('SPC f m', '  Jump to bookmarks'),
          button('SPC s l', '  Open last session'),
        },
        opts = {
          spacing = 1,
        },
      }

      startify.section.top_buttons.val = {}
      startify.section.bottom_buttons.val = {
        startify.button('e', ' New', ':ene <BAR> startinsert <CR>'),
        startify.button('q', ' Quit', ':qa<CR>'),
      }

      startify.section.mru_cwd.val[2].opts.hl = 'BufferLineHintSelected'
      startify.section.mru_cwd.val[2].val = '󰊠 ' .. vim.fn.getcwd() .. '  '

      startify.section.mru.val[2].val = ' All  '
      startify.section.mru.val[2].opts.hl = 'BufferLineHintSelected'

      -- local image_padding = image_height + 8

      local section = {
        terminal = terminal,
        mru_cwd = startify.section.mru_cwd,
        mru = startify.section.mru,
        startify_buttons = startify.section.bottom_buttons,
        -- buttons = buttons,
        footer = footer,
      }

      dashboard.config.layout = {
        { type = 'padding', val = 1 },
        section.terminal,
        { type = 'padding', val = image_padding },
        section.mru_cwd,
        section.mru,
        { type = 'padding', val = 1 },
        section.startify_buttons,
        { type = 'padding', val = 1 },
        section.buttons,
        section.footer,
      }

      -----------------------------------------------------------------------------

      -- Save the original background color
      local original_bg = vim.fn.synIDattr(vim.fn.hlID 'Normal', 'bg', 'gui')
      vim.api.nvim_set_hl(0, 'AlphaBg', { bg = '#1B1B24' })

      -- Autocmd to set background color only for alpha-nvim buffer
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'alpha',
        callback = function()
          -- Set the Normal highlight only in this buffer
          vim.api.nvim_buf_set_option(0, 'modifiable', false) -- Make buffer non-modifiable
          vim.api.nvim_buf_set_option(0, 'buftype', 'nofile') -- Set buffer type to nofile

          -- Apply the custom background color for the alpha-nvim dashboard
          vim.cmd 'highlight Normal guibg=#1B1B24' -- Set background and foreground colors
        end,
      })

      local function set_original_bg()
        -- Restore the original background and foreground colors
        vim.cmd('highlight Normal guibg=' .. original_bg)
      end

      -- Automatically close the floating terminal when leaving the alpha dashboard
      vim.api.nvim_create_autocmd('BufLeave', {
        pattern = '*', -- Match any buffer leaving the dashboard
        callback = set_original_bg,
      })

      alpha.setup(dashboard.config)
    end,
  },
}
