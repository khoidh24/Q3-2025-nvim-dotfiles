return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			keymap = {
				preset = "default",
			},
			completion = {
				menu = {
					winblend = vim.o.pumblend,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 300,
				},
				ghost_text = {
					enabled = true,
				},
			},
			signature = {
				enabled = true,
				window = {
					winblend = vim.o.pumblend,
				},
			},
			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
				},
			},
		},
	},

	{
		"mason-org/mason.nvim",
		lazy = false,
		opts = {
			ui = {
				border = "rounded",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)

			local tools = {
				"stylua",
				"prettier",
				"eslint_d",
				"goimports",
				"gofumpt",
				"golangci-lint",
				"google-java-format",
				"ruff",
				"jsonlint",
			}

			local registry = require("mason-registry")

			registry.refresh(function()
				for _, name in ipairs(tools) do
					if registry.has_package(name) then
						local package = registry.get_package(name)

						if not package:is_installed() and not package:is_installing() then
							package:install({}, function(success)
								if not success then
									vim.schedule(function()
										vim.notify("Failed to install " .. name, vim.log.levels.ERROR)
									end)
								end
							end)
						end
					end
				end
			end)
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		dependencies = {
			"saghen/blink.cmp",
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.diagnostic.config({
				underline = true,
				severity_sort = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				float = {
					border = "rounded",
					source = true,
				},
			})

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = {
								"vim",
							},
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
						completion = {
							callSnippet = "Replace",
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.config("ts_ls", {})
			vim.lsp.config("gopls", {})
			vim.lsp.config("jdtls", {})
			vim.lsp.config("pyright", {})
			vim.lsp.config("jsonls", {})
			vim.lsp.config("dartls", {})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"gopls",
					"jdtls",
					"pyright",
					"jsonls",
				},
				automatic_enable = true,
			})

			if vim.fn.executable("dart") == 1 then
				vim.lsp.enable("dartls")
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {
					clear = true,
				}),
				callback = function(event)
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, {
							buffer = event.buf,
							silent = true,
							desc = desc,
						})
					end

					map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
					map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
					map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
					map("n", "gr", vim.lsp.buf.references, "References")
					map("n", "gy", vim.lsp.buf.type_definition, "Type Definition")

					map("n", "K", vim.lsp.buf.hover, "Hover")
					map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")

					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")

					map("n", "<leader>cd", vim.diagnostic.open_float, "Diagnostics")

					map({ "n", "v" }, "<leader>cf", function()
						require("conform").format({
							async = true,
							lsp_format = "fallback",
						})
					end, "Format")
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		cmd = {
			"ConformInfo",
		},
		opts = {
			formatters_by_ft = {
				lua = {
					"stylua",
				},

				javascript = {
					"prettier",
				},
				javascriptreact = {
					"prettier",
				},
				typescript = {
					"prettier",
				},
				typescriptreact = {
					"prettier",
				},

				go = {
					"goimports",
					"gofumpt",
				},

				java = {
					"google-java-format",
				},

				python = {
					"ruff_format",
				},

				dart = {
					"dart_format",
				},

				json = {
					"prettier",
				},
				jsonc = {
					"prettier",
				},
			},

			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = {
					"eslint_d",
				},
				javascriptreact = {
					"eslint_d",
				},
				typescript = {
					"eslint_d",
				},
				typescriptreact = {
					"eslint_d",
				},

				go = {
					"golangcilint",
				},

				python = {
					"ruff",
				},

				json = {
					"jsonlint",
				},
			}

			vim.api.nvim_create_autocmd({
				"BufWritePost",
				"InsertLeave",
			}, {
				group = vim.api.nvim_create_augroup("UserLint", {
					clear = true,
				}),
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
