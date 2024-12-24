local M = {}
local api = require("bb.api")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.list_prs()
	api.fetch_pull_requests(function(prs)
		vim.schedule(function()
			if #prs == 0 then
				vim.notify("No Pull Requests found for this repository.", vim.log.levels.INFO)
				return
			end

			local pr_entries = {}
			for _, pr in ipairs(prs) do
				table.insert(pr_entries, string.format("#%d %s (%s)", pr.id, pr.title, pr.author or "Unknown"))
			end

			pickers
				.new({}, {
					prompt_title = "Pull Requests",
					finder = finders.new_table({
						results = pr_entries,
					}),
					sorter = require("telescope.config").values.generic_sorter({}),
					attach_mappings = function(prompt_bufnr, _)
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local selection = action_state.get_selected_entry()
							print("Selected: " .. selection[1])
						end)
						return true
					end,
				})
				:find()
		end)
	end)
end

return M
