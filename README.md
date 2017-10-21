# `v`, a Vim command line wrapper

I wrote `v` to help with a couple of my common wants when starting Vim, it’s a script written in Ruby and the [source is on GitHub](https://github.com/benpickles/v). Here are the two things it does.

## Open `path/to/file:line-number`

If `v` is passed an argument matching `path/to/file:line-number` it will load the file and place the cursor on the specified line, this allows you to easily copy/paste output from tools such as RSpec and start editing in the correct place.

Example:

```sh
v ./spec/path/to/failure_spec.rb:123
```

## Automatically load `./Session.vim`

When `v` is run with no arguments it looks in the current directory for a file called `Session.vim` and loads it as a Vim session. Note that this only occurs when no arguments are passed, so you can load other specified files without spoiling your session.

## `--dry-run`

To see what `v` will execute for the given arguments add `--dry-run`.

Example:

```sh
$ v --dry-run ./spec/path/to/failure_spec.rb:123
vim ./spec/path/to/failure_spec.rb +123
```

## `--help`

What command line script would be complete without corresponding help? Run `v --help` for usage.
