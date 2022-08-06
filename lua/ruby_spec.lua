local vim = vim

function exists(path)
   local f = io.open(path, "r")

   if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function toggle_rspec_file()
  -- check .git repository (as root directory)
  if not exists('.git') then
    print('fatal: .git repository does not exist.')
    return
  end

  local current_file = vim.fn.expand('%:t')

  if not string.match(current_file, "%.rb$") then
    print('fatal: current file is not .rb file.')
    return
  end

  local current_dir = vim.fn.expand('%:h')
  local target_dir = nil
  local target_file = nil

  if string.match(current_dir, "/spec") then
    -- under "requests" directory files should be open as "controller".
    -- the other files should be opend as it under the "spec" directory.
    if string.match(current_dir, "/requests") then
      target_dir = string.gsub(current_dir, '^(.-)/spec/requests', '%1/app/controllers')
      target_file = string.gsub(current_file, '%.rb$', '_controller.rb')
    else
      target_dir = string.gsub(current_dir, '^(.-)/spec', '%1/app')
      target_file = string.gsub(current_file, '_spec%.rb$', '.rb')
    end
  elseif string.match(current_dir, "/app") then
    -- "controller" file should be opend as "request" spec.
    -- the other files should be opend as it under the "spec" directory.
    if string.match(current_dir, "/controllers") and string.match(current_file, "_controller%.rb$") then
      target_dir = string.gsub(current_dir, '^(.-)/app/controllers', '%1/spec/requests')
      target_file = string.gsub(current_file, '_controller%.rb$', '.rb')
    else
      -- replace base directory to "spec".
      target_dir = string.gsub(current_dir, '^(.-)/app', '%1/spec')
      target_file = string.gsub(current_file, '%.rb$', '_spec.rb')
    end
  else
    -- the other should be open as spec, but now only support under /app/ and /spec/ directory.
    print('fatal: toggle rspec file now only support under /app and /spec directory.')
    return
  end

  if target_dir and target_file then
    vim.fn.mkdir(target_dir, 'p')
    vim.api.nvim_command('e ' .. target_dir .. '/' .. target_file)
  else
    print('fatal: could not open file...')
    return
  end
end

local function run_rspec()
  local current_path = vim.fn.expand('%')

  if not string.match(current_path, "^.*/spec/.*%.rb$") then
    print('fatal: current path is not /spec/ directory or .rb file.')
    return
  end

  local open_term_cmd = 'split | wincmd j | resize 10 | terminal'

  vim.api.nvim_command(open_term_cmd .. ' bundle exec rails rspec ' .. current_path)
end

local function run_rspec_at_line()
  local current_path = vim.fn.expand('%')

  if not string.match(current_path, "^.*/spec/.*%.rb$") then
    print('fatal: current path is not /spec/ directory or .rb file.')
    return
  end

  local open_term_cmd = 'split | wincmd j | resize 10 | terminal'
  local current_line = vim.fn.line('.')

  vim.api.nvim_command(open_term_cmd .. ' bundle exec rails rspec ' .. current_path .. ':' .. current_line)
end

return {
  toggle_rspec_file = toggle_rspec_file,
  run_rspec = run_rspec,
  run_rspec_at_line = run_rspec_at_line
}
