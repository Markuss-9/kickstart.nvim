local M = {}

function M.is_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local uname = vim.loop.os_uname().sysname
M.is_linux = uname == 'Linux'
M.is_mac = uname == 'Darwin'
M.is_windows = uname:match 'Windows'

local function detect_linux_distro()
  if not M.is_linux then
    return nil
  end
  local f = io.open('/etc/os-release', 'r')
  if not f then
    return nil
  end

  local content = f:read '*a'
  f:close()

  local distro = content:match '^ID=(%S+)' or content:match '\nID=(%S+)'
  return distro and distro:gsub('"', '')
end

M.linux_distro = detect_linux_distro()

function M.is_distro(name)
  return M.linux_distro and M.linux_distro:lower() == name:lower()
end

return M
