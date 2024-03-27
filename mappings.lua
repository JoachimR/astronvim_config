-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

    ["<leader>gs"] = { "<cmd>Telescope git_status<CR>", desc = "Find all git unstaged files" },

    ["<S-l>"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    ["<S-h>"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    ["<C-m>"] = {
      vim.diagnostic.goto_next,
      desc = "Go to next issue",
    },

    ["<C-j>"] = {
      "<cmd>Gitsigns prev_hunk<CR>",
      desc = "Go to previous hunk",
    },
    ["<C-n>"] = {
      "<cmd>Gitsigns next_hunk<CR>",
      desc = "Go to next hunk",
    },
    ["VV"] = {
      "V$%",
      desc = "select body",
    },
    ["<leader>i"] = {
      "<cmd>:TypescriptAddMissingImports<CR>",
      desc = "Typescript add missing imports",
    },
    ["n"] = { "nzz" },
    ["N"] = { "Nzz" },
    ["{"] = { "{zz" },
    ["}"] = { "}zz" },
    ["<C-d>"] = { "8jjzz" },
    ["<C-u>"] = { "8kkzz" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  v = {
    ["p"] = {
      '"_dP',
      desc = "paste+replace without losig yanked text",
    },
  },
}
