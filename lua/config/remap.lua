vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv:")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv:")
vim.keymap.set("n", "<leader>s", function()
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })

vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { silent = true })

vim.keymap.set("n", "<S-h>", "<cmd>BufferLineMovePrev<CR>")
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineMoveNext<CR>")

vim.keymap.set("n", "<leader>bl", ":ls<CR>", { silent = true })

vim.api.nvim_create_autocmd("SwapExists", {
    callback = function()
        vim.v.swapchoice = "e" -- automatically choose "Edit anyway"
    end
})

for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        vim.cmd("buffer " .. i)
    end, { silent = true })
end
