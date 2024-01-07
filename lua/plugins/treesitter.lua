return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
    },
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = { "lua", "javascript", "typescript", "html", "sql", "bash" },
        highlight = { enable = true },
        indent = { enable = true }
      })
    end
  },
  { "elgiano/nvim-treesitter-angular", branch = "topic/jsx-fix" },
  { -- Additional text objects via treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  }
}
