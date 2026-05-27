--LOSS-NVIM-LIGHTCONFIG--

-- Thank's to https://github.com/ymic9963/nvim/ for inspiring me doing this config

--SETTINGS--
vim.g.mapleader = " "
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
vim.opt.pumborder= "rounded"
vim.bo.cindent = false
vim.bo.smartindent = false
vim.bo.autoindent = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.colorcolumn = "99"
vim.g.netrw_special_syntax = true
vim.g.netrw_liststyle = 1        -- style netrw
vim.g.netrw_banner = 0           -- delete banner
vim.opt.path:append{"**"}        -- Use :find for all subdirectories
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
vim.opt.wildoptions:append{"fuzzy"} -- Fuzzy wild menu
vim.opt.foldenable = false
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevelstart = 99

--KEYMAPS--
vim.keymap.set("n", "<leader>o", ":Explore .<CR>", {desc = "Netrw explore from cwd"})
vim.keymap.set("n", "<leader>O", ":Explore <CR>", {desc= "Netrw explore from file directory"})
vim.keymap.set("n", "<leader>re", ":%s/<C-R><C-W>/", {desc = "Shortcut to replace current word under cursor"})
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]], {desc = "Paste from system clipboard"})
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], {desc = "Copy to system clipboard"})
vim.keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv", {desc = "Move a selection down"})
vim.keymap.set("v", "<leader>k", ":m '<-2<CR>gv=gv", {desc = "Move a selection up"})
vim.keymap.set("v", "<", "<gv", {desc = "Indent left and reselect"})
vim.keymap.set("v", ">", ">gv", {desc = "Indent right and reselect"})
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", {desc = "Increase window height"})
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", {desc = "Decrease window height"})
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", {desc = "Decrease window width"})
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", {desc = "Increase window width"})
vim.keymap.set('n', "<C-b>", "<cmd>LspClangdSwitchSourceHeader<CR>", {desc = "Switch source/header"})
vim.keymap.set('n', "<leader>f", ":Pick files<CR>", {desc= "Search files"})
vim.keymap.set('n', "<leader>h", ":Pick help<CR>", {desc= "Search helps"})

--END-KEYMAPS--

--PLUGINS--
local repo = "https://github.com/"

vim.pack.add({ repo .. "neovim/nvim-lspconfig"})

--colorscheme--
vim.o.termguicolors = true
vim.pack.add({ repo .. "vague2k/vague.nvim"})
vim.pack.add({ repo .. "rose-pine/neovim"})
vim.cmd.packadd('vague.nvim')
vim.cmd.packadd('neovim')
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
vim.cmd.colorscheme('rose-pine-moon')
--end-colorscheme--

vim.pack.add({ repo .. "mason-org/mason.nvim"})
require("mason").setup()

vim.pack.add({ repo .. "nvim-treesitter/nvim-treesitter" })

vim.pack.add({ repo .. "nvim-treesitter/nvim-treesitter-context" })
require("treesitter-context").setup({
    max_lines = 3,
})

vim.pack.add({ repo .. "nvim-mini/mini.test" })
require("mini.test").setup()

vim.pack.add({ repo .. "nvim-mini/mini.pick" })
require("mini.pick").setup()

vim.pack.add({ repo .. "chomosuke/typst-preview.nvim"})
require("typst-preview").setup({})

vim.pack.add({ repo .. "catgoose/nvim-colorizer.lua" })
require("colorizer").setup({})

vim.cmd.packadd('nohlsearch')
vim.cmd.packadd('nvim.undotree')
vim.cmd.packadd('nvim.difftool')

--LSP--
local ensure_installed = {
    "clangd",
    "lua-language-server"
}

-- auto install Mason
local installed_package_names = require('mason-registry').get_installed_package_names()
for _, v in ipairs(ensure_installed) do
    if not vim.tbl_contains(installed_package_names, v) then
        vim.cmd(":MasonInstall " .. v)
    end
end

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

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
    on_attach = function ()
        vim.api.nvim_set_hl(0, '@lsp.type.variable.lua', {})
    end
})

-- From https://www.reddit.com/r/neovim/comments/1p0a576/comment/nphwtrg
-- load from mason
local installed_packages = require("mason-registry").get_installed_packages()
local installed_lsp_names = vim.iter(installed_packages):fold({}, function(acc, pack)
    table.insert(acc, pack.spec.neovim and pack.spec.neovim.lspconfig)
    return acc
end)

vim.lsp.enable(installed_lsp_names)

-- Lsp diagnostics
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
})

--END-LSP--

--AUTOCOMMANDS--
local config_augroup = vim.api.nvim_create_augroup("Config", { clear = true })

-- Builtin LSP autocompletion
-- From https://www.reddit.com/r/neovim/comments/1mhusus/comment/n733xp9
vim.api.nvim_create_autocmd("LspAttach", {
    group = config_augroup,
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        -- Autocompletion
        if client:supports_method("textDocument/completion") then
            -- These three lines here are for auto-triggering on any keypress, I am unsure if I want this or not
            -- local chars = {}
            -- for i = 32, 126 do table.insert(chars, string.char(i)) end
            -- client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable( true, client.id, ev.buf,
            {
                autotrigger = true,
                convert = function(item)
                    local abbr = item.label
                    abbr = #abbr > 30 and abbr:sub(1, 29) .. "…" or abbr

                    local menu = item.detail or ""
                    menu = #menu > 30 and menu:sub(1, 29) .. "…" or menu

                    return { abbr = abbr, menu = menu }
                end
            })
        end

        -- Documentation formatting when using auto-completion
        if client:supports_method("completionItem/resolve") then
            local _, cancel_prev = nil, function() end
            vim.api.nvim_create_autocmd("CompleteChanged", {
                group = config_augroup,
                buffer = ev.buf,
                callback = function(event)
                    cancel_prev()
                    local info = vim.fn.complete_info({ "selected" })
                    local completionItem = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
                    if not completionItem then return end
                    cancel_prev = vim.lsp.buf_request_all( event.buf, vim.lsp.protocol.Methods.completionItem_resolve, completionItem,
                    function(results)
                        if not results then return end
                        for _, v in ipairs(results) do
                            local item = v.result
                            local docs = (item.documentation or {}).value
                            local win = vim.api.nvim__complete_set(info["selected"], { info = docs })
                            if win.winid and vim.api.nvim_win_is_valid(win.winid) then
                                vim.treesitter.start(win.bufnr, item.documentation.kind)
                                vim.wo[win.winid].conceallevel = 3
                            end
                        end
                    end)
                end,
            })
        end
    end
})

-- From https://github.com/nvim-treesitter/nvim-treesitter/issues/8221#issuecomment-3436658280
vim.api.nvim_create_autocmd("FileType", {
    pattern = { '*' },
    group = config_augroup,
    callback = function(args)
        local treesitter = require('nvim-treesitter')
        local lang = vim.treesitter.language.get_lang(args.match)
        if vim.list_contains(treesitter.get_available(), lang) then
            if not vim.list_contains(treesitter.get_installed(), lang) then
                treesitter.install(lang):wait()
            end
            vim.treesitter.start(args.buf)
        end
    end,
    desc = "Enable nvim-treesitter and install parser if not installed"
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cpp", "c" },
    callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.bo.cindent = false
        vim.bo.smartindent = false
        vim.bo.autoindent = true
    end
})

vim.api.nvim_create_autocmd("WinEnter", {
    pattern = { "*" },
    group = config_augroup,
    callback = function()
        vim.fn.matchadd("TODO", 'TODO:')
        vim.fn.matchadd("INFO", 'INFO:')
        vim.fn.matchadd("FIX", 'FIX:')
        vim.fn.matchadd("BUG", 'BUG:')
    end,
    desc = "Make colorscheme Special Comments at every window"
})

--END-AUTOCOMMANDS--

--COMMANDS--
-- From https://www.reddit.com/r/neovim/comments/1qb0qbf/i_replaced_whichkey_plugin_with_basic_lua_script/
vim.api.nvim_create_user_command('ListCustomKeymaps', function()
    local keymaps = vim.api.nvim_exec2("verbose map", { output = true }).output
    local lines = vim.split(keymaps, "\n")
    local buff = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(buff)
    vim.api.nvim_buf_set_lines(buff, 0, -1, false, lines)
end,
{ desc = 'List keymaps' })

--END-COMMANDS--
