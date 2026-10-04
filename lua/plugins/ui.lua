return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = function()
			local focused = true

			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})

			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})

			return {
				routes = {
					{
						filter = {
							event = "notify",
							find = "No information available",
						},
						opts = {
							skip = true,
						},
					},
					{
						filter = {
							cond = function()
								return not focused
							end,
						},
						view = "notify_send",
						opts = {
							stop = false,
						},
					},
				},

				commands = {
					all = {
						view = "split",
						opts = {
							enter = true,
							format = "details",
						},
						filter = {},
					},
				},

				presets = {
					lsp_doc_border = true,
				},
			}
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
			render = "compact",
			stages = "fade_in_slide_out",

			background_colour = "#000000",
		},
	},

	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{
				"<Tab>",
				"<Cmd>BufferLineCycleNext<CR>",
				desc = "Next tab",
			},
			{
				"<S-Tab>",
				"<Cmd>BufferLineCyclePrev<CR>",
				desc = "Prev tab",
			},
			{ "A-S-Left", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Right" },
			{ "A-S-Right", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Left" },
		},
		opts = {
			options = {
				mode = "tabs",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = {
				globalstatus = true,
			},

			sections = {
				lualine_a = {
					"mode",
				},

				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
				},

				lualine_c = {
					{
						"filename",
						path = 1,
						file_status = true,
						symbols = {
							modified = "",
							readonly = " 󰌾 ",
							unnamed = "[No Name]",
							newfile = "[New]",
						},
					},
				},

				lualine_x = {
					{
						"lsp_status",
						icon = "",
						show_name = true,
					},
					"encoding",
					"filetype",
				},

				lualine_y = {
					"progress",
				},

				lualine_z = {
					"location",
				},
			},
		},
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = {
					enabled = false,
					font = "+2",
				},
			},
		},
		keys = {
			{
				"<leader>z",
				"<cmd>ZenMode<cr>",
				desc = "Zen Mode",
			},
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
	},
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
				extra_groups = {
					"NormalFloat",
					"FloatBorder",
				},
			})
		end,
	},
}
