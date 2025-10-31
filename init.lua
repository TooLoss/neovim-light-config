-- Lighweight Configuration

-- parameters
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.backup = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.scrolloff = 10
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

vim.g.mapleader = " "

-- keymap
vim.keymap.set('n', "<leader>pv", vim.cmd.Ex)         -- file browser
vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")          -- block move down
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv")          -- block move up
vim.keymap.set('n', "<leader>lf", vim.lsp.buf.format) -- format code
vim.keymap.set('n', "<leader>f", ":Pick files<CR>")   -- search file
vim.keymap.set('n', "<leader>h", ":Pick help<CR>")    -- search doc
vim.keymap.set('n', "<leader>s", ":update")           -- update

-- plugins
vim.pack.add {
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/dgox16/oldworld.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" }
	--{ src = "https://github.com/mason-org/mason.nvim" }
}

require "mini.pick".setup()
require "nvim-treesitter.configs".setup({
    ensure_installed = {"ada"},
    highlight = { enable = true}
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

-- lsp server
-- require "mason".setup() 

vim.lsp.enable({ "lua_ls", "ada_language_server-bin", "ada_language_server", "clangd", "vtsls", "svelte" })
vim.lsp.config("lua_ls",
    {
        settings = {
            Lua = {
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                }
            }
        }
    }) -- correct init.lua errors
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--fallback-style=llvm",
        "--header-insertion=iwyu",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
})

-- colorscheme
vim.cmd.colorscheme("vague")

vim.opt.termguicolors = true
