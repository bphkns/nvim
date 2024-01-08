return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    require('neo-tree').setup({
      filesystem = {
      },
      window = {
        position = "right"
      }
    })
    vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal right<CR>", {})
    vim.keymap.set("n", "<leader>gs", ":Neotree git_status <CR>", {})
  end
}
