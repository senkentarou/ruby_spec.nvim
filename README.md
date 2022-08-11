# ruby_spec.nvim
* rspec commands!

## Installation
* Plug

```
Plug 'senkentarou/ruby_spec.nvim'
```

## Setup
* Please set your nvim confg before use.
```
require('ruby_spec').setup {}
```

* For customizing, please setup as below,
```
require('ruby_spec').setup {
  marker_directory = '.git',  -- .git is commonly seen on rails project
  rspec_commands = {
    'bundle',
    'exec',
    'rspec'
  }
}
```

## Usage
* Open toggle rspec file.
  * `:ToggleRspecFile`
* Run all rspec on file.
  * `:RunRspec`
* Run rspec at line.
  * `:RunRspecAtLine`

## Integration
* These RunRspec commands run on terminal thanks to [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) plugin command!
* If you installed toggleterm.nvim, rspec would be tested with `TermExec` command. (or not would be tested with `terminal` command.)

## For development
* Load under development plugin files on root repository.

```
nvim --cmd "set rtp+=."
```
