local M = {}

function M.setup()
	vim.api.nvim_create_user_command("BB", function()
		require("bb.ui").list_prs()
	end, {})
end

M.setup()

return M
