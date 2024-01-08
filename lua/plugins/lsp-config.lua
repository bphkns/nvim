local util = require("lspconfig.util")
local function get_node_modules(root_dir)
  local lspNMRoot = util.find_node_modules_ancestor(root_dir)
  if lspNMRoot == nil then
    return ""
  else
    return lspNMRoot
  end
end

local default_node_modules = get_node_modules(vim.fn.getcwd())

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
      local lspconfig = require("lspconfig")
      local capabilities =  require("cmp_nvim_lsp").default_capabilities();

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

      local ngls_cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations",
        default_node_modules,
        "--ngProbeLocations",
        default_node_modules,
        -- "--includeCompletionsWithSnippetText",
        -- "--includeAutomaticOptionalChainCompletions",
        -- "--logToConsole",
        -- "--logFile",
        -- "/Users/mhartington/Github/StarTrack-ng/logs.txt"
      }
      lspconfig.angularls.setup({
        cmd = ngls_cmd,
        capabilities = capabilities,
        root_dir = util.root_pattern("angular.json"),
        on_new_config = function(new_config)
          new_config.cmd = ngls_cmd
        end,
      })

      lspconfig.quick_lint_js.setup({
        capabilities = capabilities,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set("n", "gI", vim.lsp.buf.implementation, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
