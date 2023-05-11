return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin",     -- remote to use
    channel = "stable",    -- "stable" or "nightly"
    version = "latest",    -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly",    -- branch name (NIGHTLY ONLY)
    commit = nil,          -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil,     -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false,  -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false,     -- automatically quit the current session after a successful update
    remotes = {            -- easily add new remotes to track
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
        enabled = true,     -- enable or disable format on save globally
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
    -- -- VOLAR
    -- local function get_typescript_server_path(root_dir)
    --   -- local global_ts = "/home/[yourusernamehere]/.npm/lib/node_modules/typescript/lib
    --   -- Alternative location if installed as root:
    --   -- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
    --   local global_ts = "/usr/local/lib/node_modules/typescript/lib"
    --   local found_ts = ""
    --   local function check_dir(path)
    --     found_ts = util.path.join(path, "node_modules", "typescript", "lib")
    --     if util.path.exists(found_ts) then return path end
    --   end
    --   if util.search_ancestors(root_dir, check_dir) then
    --     return found_ts
    --   else
    --     return global_ts
    --   end
    -- end
    -- require("lspconfig").volar.setup {
    --   filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
    --   on_new_config = function(new_config, new_root_dir)
    --     new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
    --   end,
    -- }

    -- eslint
    require("lspconfig").eslint.setup {
      root_dir = util.root_pattern ".git",
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    }

    -- start jest for current file in toggle terminal
    local function get_current_buffer_info()
      local bufnr = vim.api.nvim_get_current_buf()
      local filename = vim.api.nvim_buf_get_name(bufnr)
      local directory = vim.fn.fnamemodify(filename, ":p:h")
      return directory, filename
    end
    local function save_and_run_jest()
      local directory, filename = get_current_buffer_info()
      vim.cmd "w"
      local command = 'TermExec direction=vertical size=80 cmd="pnpm jest ' .. filename .. '" dir=' .. directory
      vim.cmd(command)
    end
    vim.keymap.set("n", "<leader>oo", save_and_run_jest, { silent = true, noremap = true, desc = "Test file" })

    -- fix path display in telescope
    require("telescope").setup {
      defaults = {
        path_display = { "truncate" },
      },
    }

    -- codeium auto-toggle
    local disable_on_directories = { "ryter" }
    local function disable(dir)
      if vim.g.codeium_enabled == true then
        vim.cmd "CodeiumDisable"
        local reason = ""
        if dir then reason = " (due to access to '*/" .. dir .. "/*')" end
        vim.notify("Codeium disabled" .. reason)
      end
    end
    local function enable(dir)
      if vim.g.codeium_enabled == false then
        vim.cmd "CodeiumEnable"
        local reason = ""
        if dir then reason = " (due to access to '" .. dir .. "')" end
        vim.notify("Codeium enabled" .. reason)
      end
    end
    -- diable on certain directories
    local function disable_on_directory_match()
      local abs_path = vim.fn.expand "%:p"
      if abs_path == "" then return end
      local path_components = vim.fn.split(abs_path, "/")
      for i = #path_components, 1, -1 do
        local dir_name = path_components[i]
        if vim.tbl_contains(disable_on_directories, dir_name) then return disable(dir_name) end
      end
      enable(abs_path)
    end
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = { "*" },
      callback = disable_on_directory_match,
    })
  end,
}
