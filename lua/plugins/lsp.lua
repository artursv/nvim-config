return {
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'intelephense',
          'phpactor',
          'psalm',
        }
      })

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Intelephense Setup
      lspconfig.intelephense.setup {
        capabilities = capabilities,
        settings = {
          intelephense = {
            files = {
              maxSize = 5000000,
            },
            completion = {
              insertUseDeclaration = true,
            },
            -- Ignore vendor and node_modules
            exclude = {
              "**/node_modules/**"
            }
          }
        },
        on_attach = function(client, bufnr)
          -- Keymaps
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = bufnr})
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = bufnr})
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {buffer = bufnr})
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer = bufnr})
        end
      }

      -- Phpactor Setup (alternative/additional PHP LSP)
      lspconfig.phpactor.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = bufnr})
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = bufnr})
        end
      }
    end
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        })
      }
    end
  },

  -- PHP Specific Plugins
  {
    'adalessa/laravel.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'tpope/vim-dotenv',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Laravel',
    keys = {
      { '<leader>la', ':Laravel artisan<cr>' },
      { '<leader>lr', ':Laravel routes<cr>' },
    }
  },

  -- PHP Debugging
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'leoluz/nvim-dap-go',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- PHP XDebug Configuration
      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. '/vscode-php-debug/out/phpDebug.js' }
      }

      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug',
          port = 9003,
          pathMappings = {
            ['/var/www/html'] = '${workspaceFolder}'
          }
        }
      }

      dapui.setup()
      
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
    end
  },

  -- Code Formatting
  {
    'stevearc/conform.nvim',
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          php = { "phpcbf" },
        },
        formatters = {
          phpcbf = {
            command = "/home/arturs/.config/composer/vendor/bin/phpcbf",
            args = {
              "--standard=WunderDrupal,PHPCompatibility,WunderSecurity",
              "--extensions=php,module,inc,install,test,profile,theme,css,info,txt,md,yml",
              "--encoding=utf-8",
              "-" -- format stdin
            },
            stdin = true,
          },
        },
      })

      -- Optional: Add key mappings for formatting
      vim.keymap.set({"n", "v"}, "<leader>f", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 5000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end
  },

  -- PHP Syntax Highlighting
  {
    'StanAngeloff/php.vim',
    ft = 'php'
  }
}
