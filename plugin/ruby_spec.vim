scriptencoding utf-8

if exists('g:loaded_to_ruby_spec')
    finish
endif
let g:loaded_to_ruby_spec = 1

let s:save_cpo = &cpo
set cpo&vim

command! ToggleRspecFile lua require('ruby_spec').toggle_rspec_file()
command! RunRspec lua require('ruby_spec').run_rspec()
command! RunRspecAtLine lua require('ruby_spec').run_rspec_at_line()
command! CopyRspecCommand lua require('ruby_spec').copy_rspec_command()
command! CopyRspecAtLineCommand lua require('ruby_spec').copy_rspec_at_line_command()

let &cpo = s:save_cpo
unlet s:save_cpo
