local utils = require 'utils'

if not utils.is_executable 'flutter' then
  return {}
end

return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('flutter-tools').setup {
      debugger = {
        -- NOTE: sometimes its not necessary and takes too much space. disabled it for now
        enabled = false,
      },
    }
    require('telescope').load_extension 'flutter'

    require('flutter-tools').setup_project {
      {
        name = 'Web',
        device = 'chrome',
        -- flavor = 'WebApp',
        web_port = '4000',
        additional_args = { '--wasm' },
      },
      {
        name = 'Linux',
        device = 'linux',
      },
      {
        name = 'Android', -- an arbitrary name that you provide so you can recognise this config
        flavor = 'DevFlavor', -- your flavour
        target = 'lib/main_dev.dart', -- your target
        cwd = 'example', -- the working directory for the project. Optional, defaults to the LSP root directory.
        device = 'pixel6pro', -- the device ID, which you can get by running `flutter devices`
        dart_define = {
          API_URL = 'https://dev.example.com/api',
          IS_DEV = 'true',
        },
        pre_run_callback = nil, -- optional callback to run before the configuration
        -- exposes a table containing name, target, flavor and device in the arguments
        dart_define_from_file = 'config.json', -- the path to a JSON configuration file
      },
      {
        name = 'Profile',
        flutter_mode = 'profile', -- possible values: `debug`, `profile` or `release`, defaults to `debug`
      },
    }

    vim.keymap.set('n', '<leader>fd', function()
      require('telescope').extensions.flutter.commands()
    end, { desc = 'Flutter menu' })

    vim.keymap.set('n', '<leader>fl', ':FlutterLogToggle<CR>', { desc = 'Flutter menu' })
  end,
}
