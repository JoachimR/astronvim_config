return {
  -- test
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },
  -- Set colorscheme to use
  colorscheme = "catppuccin-mocha",
  -- colorscheme = "tokyonight",
  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- "sumneko_lua",
        "tsserver",
        "volar",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },
  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },
  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    local util = require "lspconfig.util"

    -- eslint
    require("lspconfig").eslint.setup {
      root_dir = util.root_pattern ".git",
      on_attach = function(client, bufnr)
        local filename = vim.fn.expand "%:t"
        local file_extension = vim.fn.fnamemodify(filename, ":e")
        if file_extension == "vue" or file_extension == "ts" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.cmd "EslintFixAll" end,
          })
        end
      end,
    }

    -- start test for current file in toggle terminal
    local function get_current_buffer_info()
      local bufnr = vim.api.nvim_get_current_buf()
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local directory = vim.fn.fnamemodify(filename, ":p:h")
      return directory, filename
    end
    local function save_and_run_jest()
      local directory, filename = get_current_buffer_info()
      vim.cmd "w"
      local command = 'TermExec direction=vertical size=80 cmd="pnpm test ' .. filename .. '" dir=' .. directory
      vim.cmd(command)
    end
    vim.keymap.set("n", "<leader>oo", save_and_run_jest, { silent = true, noremap = true, desc = "Test file" })

    -- fix path display in telescope
    require("telescope").setup {
      defaults = {
        path_display = { "truncate" },
      },
    }
  end,
}
