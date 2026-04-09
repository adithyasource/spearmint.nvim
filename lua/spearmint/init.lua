local M = {}

local globals = {}

local path = vim.fn.stdpath("data") .. "/spearmint.json"

local function save()
  local file = io.open(path, "w")
  if file then
    file:write(vim.fn.json_encode(globals))
    file:close()
  end
end

local function load()
  local file = io.open(path, "r")
  if file then
    local store = file:read("*a")
    file:close()
    if store and store ~= "" then
      globals = vim.fn.json_decode(store)
    end
  end
end

local function set_mark()
  local char = vim.fn.getcharstr()
  globals[char] = {
    filePath = vim.api.nvim_buf_get_name(0),
    pos = vim.api.nvim_win_get_cursor(0)
  }
  save()
end

local function jump()
  local char = vim.fn.getcharstr()
  local toJump = globals[char]
  if toJump then
    vim.cmd("edit " .. vim.fn.fnameescape(toJump.filePath))
    vim.api.nvim_win_set_cursor(0, toJump.pos)
  end
end

function M.setup(opts)
  opts = opts or {}

  load()

  vim.api.nvim_create_autocmd({ "BufLeave" }, {
    callback = function()
      local filePath = vim.api.nvim_buf_get_name(0)
      local pos = vim.api.nvim_win_get_cursor(0)
      for char, toJumpData in pairs(globals) do
        if toJumpData.filePath == filePath then
          globals[char].pos = pos
        end
      end
    end
  })

  -- so that latest cursor saved on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = save
  })

  vim.keymap.set("n", opts.set_key or "m", set_mark)
  vim.keymap.set("n", opts.jump_key or "'", jump)
end

return M
