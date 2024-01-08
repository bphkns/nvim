return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "angularls", "tsserver", "quick_lint_js", "html" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

      -- local util = require('lspconfig.util')
      -- local default_node_modules = vim.fn.getcwd() .. "/node_modules"
      --
      -- local ngls_cmd = {
      --   "ngserver",
      --   "--stdio",
      --   "--tsProbeLocations",
      --   default_node_modules,
      --   "--ngProbeLocations",
      --   default_node_modules,
      --   "--experimental-ivy",
      -- }
      lspconfig.angularls.setup({
        -- cmd = ngls_cmd,
        capabilities = capabilities,
        -- on_new_config = function(new_config)
          -- new_config.cmd = ngls_cmd
        -- end,
      -- }, {
        -- root_dir = util.root_pattern('angular.json', 'project.json')
      })
      lspconfig.quick_lint_js.setup({
        capabilities = capabilities,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
