-- UI
vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.title = true
vim.opt.showcmd = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 0

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

vim.opt.wrap = false
vim.opt.breakindent = true

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"

vim.opt.mouse = ""
vim.opt.termguicolors = true

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smarttab = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.inccommand = "split"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Backspace
vim.opt.backspace = {
	"start",
	"eol",
	"indent",
}

-- Files / path
vim.opt.path:append("**")

vim.opt.wildignore:append({
	"*/node_modules/*",
	"*/.git/*",
	"*/dist/*",
	"*/build/*",
	"*/.next/*",
})

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.backupskip = {
	"/tmp/*",
	"/private/tmp/*",
}

-- Undo / history
vim.opt.undofile = true

local undodir = vim.fn.stdpath("state") .. "/undo"

if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.undodir = undodir
vim.opt.history = 1000

vim.opt.shada = {
	"!",
	"'100",
	"<50",
	"s10",
	"h",
}

-- Better editing
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.completeopt = {
	"menu",
	"menuone",
	"noselect",
}

-- Formatting
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.opt_local.formatoptions:append("r")
		vim.opt_local.formatoptions:remove({
			"o",
		})
	end,
})

-- Filetypes
vim.filetype.add({
	extension = {
		mdx = "mdx",
		astro = "astro",
	},

	filename = {
		Podfile = "ruby",
	},
})
