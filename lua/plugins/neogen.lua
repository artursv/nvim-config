return {
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      enabled = true,
      languages = {
        php = {
          template = {
            annotation_convention = "phpdoc" -- Options: "phpdoc" (default) or "psalm"
          }
        }
      },
      snippet_engine = "luasnip" -- If you're using LuaSnip, otherwise use your snippet engine of choice
    },
    -- Add keybindings if desired
    keys = {
      { "<Leader>ng", function() require("neogen").generate() end, desc = "Generate annotation" },
      { "<Leader>nf", function() require("neogen").generate({ type = "func" }) end, desc = "Generate function annotation" },
      { "<Leader>nc", function() require("neogen").generate({ type = "class" }) end, desc = "Generate class annotation" },
    },
  }
}
