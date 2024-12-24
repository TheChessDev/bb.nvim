local M = {}
local Job = require("plenary.job")

local config = {
	bb_cli_path = "bb-cli", -- Path to the bb-cli executable
}

function M.fetch_pull_requests(callback)
	Job:new({
		command = config.bb_cli_path,
		args = { "pr", "list", "--json" },
		on_exit = function(job, return_val)
			vim.schedule(function()
				if return_val == 0 then
					local output = table.concat(job:result(), "\n")
					local success, data = pcall(vim.fn.json_decode, output)
					if success then
						callback(data or {})
					else
						vim.notify("Failed to parse PR JSON: " .. tostring(data), vim.log.levels.ERROR)
						callback({})
					end
				else
					local error_msg = table.concat(job:stderr_result(), "\n")
					vim.notify("Failed to fetch PRs: " .. error_msg, vim.log.levels.ERROR)
					callback({})
				end
			end)
		end,
	}):start()
end

return M
