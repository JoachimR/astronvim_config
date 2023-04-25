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
      vim.api.nvim_set_keymap(
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
  {
    "arnamak/stay-centered.nvim",
    event = "VeryLazy",
    config = function() require "stay-centered" end,
  },
}
