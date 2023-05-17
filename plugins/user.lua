return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "Exafunction/codeium.vim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
      vim.keymap.set("n", "<leader>;", function()
        if vim.g.codeium_enabled == true then
          vim.cmd "CodeiumDisable"
        else
          vim.cmd "CodeiumEnable"
        end
      end, { noremap = true, desc = "Toggle Codeium active" })

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
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      vim.keymap.set(
        "v",
        "<leader>rr",
        ":lua require('refactoring').select_refactor()<CR>",
        { noremap = true, silent = true, expr = false, desc = "Select refactoring" }
      )
    end,
  },
  {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    config = function()
      require("better_escape").setup {
        mapping = { "bb", "jj", "kk" },
      }
    end,
  },
}
