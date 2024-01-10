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
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local lspconfig = require("lspconfig");

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

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
        root_dir = util.root_pattern("angular.json", "project.json"),
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

      local function goto_definition(split_cmd)
        local util = vim.lsp.util
        local log = require("vim.lsp.log")
        local api = vim.api

        -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
        local handler = function(_, result, ctx)
          if result == nil or vim.tbl_isempty(result) then
            local _ = log.info() and log.info(ctx.method, "No location found")
            return nil
          end

          local wc = 0
          local windows = vim.api.nvim_tabpage_list_wins(0)

          for _, v in pairs(windows) do
            local cfg = vim.api.nvim_win_get_config(v)
            local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(v), "filetype")

            if (cfg.relative == "" or cfg.external == false) and ft ~= "qf" then
              wc = wc + 1
            end
          end

          if result[1].uri ~= ctx.params.textDocument.uri and wc < 3 then
            vim.cmd(split_cmd)
          end

          util.jump_to_location(result[1], "utf-8")

          if #result > 1 then
            util.set_qflist(util.locations_to_items(result))
            api.nvim_command("copen")
            api.nvim_command("wincmd p")
          end
        end

        return handler
      end

      vim.lsp.handlers["textDocument/definition"] = goto_definition("vsplit")
    end,
  },
}
