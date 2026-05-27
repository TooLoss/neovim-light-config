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
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.bo.cindent = false
vim.bo.smartindent = false
vim.bo.autoindent = true
vim.opt.colorcolumn = "120"
vim.opt.rtp:append("/home/bilele/.local/share/nvim/site")

vim.g.mapleader = " "

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c" },
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.bo.cindent = false
    vim.bo.smartindent = false
    vim.bo.autoindent = true
  end
})

-- plugins
vim.pack.add {
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/dgox16/oldworld.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/rose-pine/neovim" }
}

require "mini.pick".setup()


require "nvim-treesitter".setup({
    highlight = { enable = true },
    indent = { enable = true }
})

require "typst-preview"

-- keymap
vim.keymap.set('n', "<leader>pv", vim.cmd.Ex)               -- file browser
-- vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")                -- block move down
-- vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv")                -- block move up
vim.keymap.set('n', "<leader>lf", vim.lsp.buf.format)       -- format code
vim.keymap.set('n', "<leader>gd", "<Cmd>Neogen<CR>")          -- generate doc
vim.keymap.set('n', "<leader>f", ":Pick files<CR>")         -- search file
vim.keymap.set('n', "<leader>h", ":Pick help<CR>")          -- search doc
vim.keymap.set('n', "<leader>s", "<Cmd>e #<CR>")        -- switch buffer
vim.keymap.set('n', "<leader>S", "<Cmd>bot sf #<CR>")   -- switch buffer
vim.keymap.set({'n', 'v'}, "<leader>y", '"+y')          -- system copy        
vim.keymap.set({'n', 'x'}, "<C-s>", [[<esc>:'<,'>s/\V/]]) -- subtitute mode
vim.keymap.set('n', "<M-j>", "<cmd>resize +2<CR>")          -- increase height
vim.keymap.set('n', "<M-k>", "<cmd>resize -2<CR>")          -- decrease height
vim.keymap.set('n', "<M-h>", "<cmd>vertical resize +5<CR>") -- increase width
vim.keymap.set('n', "<M-l>", "<cmd>vertical resize -5<CR>") -- decrase width
vim.keymap.set('n', "<C-b>", "<cmd>LspClangdSwitchSourceHeader<CR>") -- decrase width
vim.keymap.set("n", "<C-q>", ":copen<CR>", { silent = true }) -- open quickfix
vim.keymap.set('n', '<leader>q', vim.lsp.buf.format) -- format document
vim.keymap.set("n", "<leader>a",
	function() vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%"), } }, "a") end,
	{ desc = "Add current file to QuickFix" })

-- plugin config

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

vim.lsp.enable({ 
    "lua_ls",
    "clangd",
    "tinymist",
    "svelte",
    "vtsls",
    "ltex"
})

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
        "--compile-commands-dir=.",
        "--completion-style=detailed",
        "--fallback-style=llvm",
        "--header-insertion=iwyu",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cppm" },
    init_options = {
        fallbackFlags = {'--std=c++20'}
    }
})

require('nvim-treesitter').setup({
    ensure_installed = { "svelte", "javascript", "typescript", "html", "css", "lua", "typst" },
    install_dir = vim.fn.stdpath('data') .. '/site',
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    }
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Start tree-sitter for some languages (when it do not work)',
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang then
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})

vim.lsp.config("ltex", {
    root_dir = function(filename, bufnr)
        return vim.fs.root(bufnr, { ".git" }) or vim.fn.getcwd()
    end,
    settings = {
        ltex = {
            language = "fr",
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "fr",
            },
        },
    },
    filetypes = { "markdown", "tex", "text", "gitcommit", "typst" },
})

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- colorscheme
require("vague").setup({
    transparent = true
})
require("rose-pine").setup({
    variant = "auto",
    styles = {
        bold = true,
        italic = true,
        transparency = true,
    },
})

vim.cmd.colorscheme("rose-pine-moon")

vim.opt.termguicolors = true

-- clipboard
-- vim.opt.clipboard = 'unnamedplus'

vim.opt.runtimepath:append("/home/bilele/.local/share/nvim/site")
