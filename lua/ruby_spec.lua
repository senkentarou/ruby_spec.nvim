local vim = vim

local function rspec_command(args)
  local target_path = vim.fn.expand('%')

  if not string.match('/' .. target_path, "^.*/spec/.*%.rb$") then
    vim.notify('fatal: current path is not spec/ directory or .rb file.', vim.log.levels.ERROR)
    return
  end

  -- https://github.com/akinsho/toggleterm.nvim integration
  local cmd = table.concat(vim.g.ruby_spec.rspec_commands, ' ') .. ' ' .. target_path
  if args and args.line then
    cmd = cmd .. ':' .. args.line
  end

  return cmd
end

local DEFAULT_OPTIONS = {
  rspec_commands = {
    'bundle',
    'exec',
    'rspec',
  },
}

local ruby_spec = {}

function ruby_spec.setup(options)
  vim.g.ruby_spec = vim.tbl_deep_extend('force', DEFAULT_OPTIONS, options)
end

function ruby_spec.toggle_rspec_file()
  local current_file = vim.fn.expand('%:t')

  if not string.match(current_file, "%.rb$") then
    vim.notify('fatal: current file is not .rb file.', vim.log.levels.ERROR)
    return
  end

  local current_dir = vim.fn.expand('%:h')
  local target_dir = nil
  local target_file = nil

  if string.match(current_dir, "^spec/") then
    -- On "spec/" directory, "requests" directory files should be open as "controller.rb" file.
    -- The other files should be opend as it by target: ruby file is under "app" directory or not
    if string.match(current_dir, "/requests") then
      target_dir = string.gsub(current_dir, '^spec/requests', 'app/controllers')
      target_file = string.gsub(current_file, '_spec%.rb$', '_controller.rb')
    else
      target_dir = string.gsub(current_dir, '^spec/?(.*)', '%1')
      -- Check "app/" directory contents
      if vim.fn.isdirectory('app/' .. target_dir) > 0 then
        target_dir = 'app/' .. target_dir
      end

      target_file = string.gsub(current_file, '_spec%.rb$', '.rb')
    end
  elseif string.match(current_dir, "^app/") then
    -- On "app/" directory, "controller.rb" file should be opend as "request" spec.
    -- The other files should be opend as it under the "spec" directory.
    if string.match(current_dir, "/controllers") and string.match(current_file, "_controller%.rb$") then
      target_dir = string.gsub(current_dir, 'app/controllers', 'spec/requests')
      target_file = string.gsub(current_file, '_controller%.rb$', '_spec.rb')
    else
      -- replace base directory to "spec".
      target_dir = string.gsub(current_dir, '^app/', 'spec/')
      target_file = string.gsub(current_file, '%.rb$', '_spec.rb')
    end
  else
    -- On the other directory, it should be opend on "/spec" directory and "spec.rb" file.
    target_dir = 'spec/' .. current_dir
    target_file = string.gsub(current_file, '%.rb$', '_spec.rb')
  end

  if target_dir and target_file then
    vim.fn.mkdir(target_dir, 'p')
    vim.api.nvim_command('e ' .. target_dir .. '/' .. target_file)
  else
    vim.notify('fatal: could not open ' .. target_dir .. '/' .. target_file, vim.log.levels.ERROR)
  end
end

function ruby_spec.run_rspec(args)
  local cmd = rspec_command(args)

  if cmd == nil then
    return
  end

  vim.api.nvim_command('terminal ' .. cmd)
end

function ruby_spec.run_rspec_at_line()
  ruby_spec.run_rspec({
    line = vim.fn.line('.'),
  })
end

function ruby_spec.copy_rspec_command(args)
  local cmd = rspec_command(args)

  if cmd == nil then
    return
  end

  vim.api.nvim_command('let @+="' .. cmd .. '"')
  vim.notify('yanked: ' .. cmd)
end

function ruby_spec.copy_rspec_at_line_command(_)
  ruby_spec.copy_rspec_command({
    line = vim.fn.line('.'),
  })
end

return ruby_spec
