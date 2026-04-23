Spearmint = {}
local globals = {}
local liveTerminals = {}
local path = vim.fn.stdpath("data") .. "/spearmint.json"

local function notify(msg)
  vim.notify("spearmint: " .. msg, vim.log.levels.INFO)
end

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

    if not store and store ~= "" then return end

    local ok, decoded = pcall(vim.json.decode, store)
    if ok then
      globals = decoded
    else
      print("stored data invalid; resetting")
      globals = {}
    end
  end
end

local function update_pos()
  local projectPath = vim.fn.getcwd()
  local pathData = globals[projectPath]
  if not pathData then
    return
  end
  local relFilePath = vim.fn.expand("%:.")
  local pos = vim.api.nvim_win_get_cursor(0)
  for char, toJumpData in pairs(pathData) do
    if toJumpData.relFilePath == relFilePath then
      globals[projectPath][char].pos = pos
    end
  end
end

Spearmint.set_mark = function()
  local projectPath = vim.fn.getcwd()
  local char = vim.fn.getcharstr()
  globals[projectPath] = globals[projectPath] or {}
  if vim.bo.buftype == 'terminal' then
    globals[projectPath][char] = {
      type = "term",
    }
    liveTerminals[char] = {
      pos = vim.api.nvim_win_get_cursor(0),
      buf = vim.api.nvim_get_current_buf(),
    }
  else
    globals[projectPath][char] = {
      type = "file",
      pos = vim.api.nvim_win_get_cursor(0),
      relFilePath = vim.fn.expand("%:."),
    }
  end
  save()
end

Spearmint.jump = function()
  local projectPath = vim.fn.getcwd()
  local char = vim.fn.getcharstr()
  local toJump = globals[projectPath][char]

  if toJump == nil then notify("no mark set") end

  if not toJump then return end

  if vim.fn.expand("%:.") == toJump.relFilePath then return end

  if toJump.type == "file" then
    vim.cmd("edit " .. toJump.relFilePath)
    vim.api.nvim_win_set_cursor(0, toJump.pos)
    return
  end

  -- checking if the toterm is actually a terminal in the current session
  -- if it isnt and its still a valid terminal, that means nvim reused the
  -- id or didnt flush it out of memory
  -- idk why; had to do this cause windows didnt work for some reason ¯\(ツ)/¯
  local live = liveTerminals[char]

  if live and vim.api.nvim_buf_is_valid(live.buf) and vim.bo[live.buf].buftype == "terminal" then
    vim.api.nvim_set_current_buf(live.buf)
    return
  end

  -- new buffer
  vim.cmd("terminal")

  liveTerminals[char] = {
    pos = vim.api.nvim_win_get_cursor(0),
    buf = vim.api.nvim_get_current_buf(),
  }
end

Spearmint.setup = function()
  load()
  vim.api.nvim_create_autocmd({ "BufLeave" }, {
    callback = update_pos
  })
  -- so that latest cursor saved on exit
  vim.api.nvim_create_autocmd("BufWinLeave", {
    callback = function()
      update_pos()
      save()
    end
  })
end

return Spearmint
