[![img](https://travis-ci.org/quasiquoting/lodox.svg)](https://travis-ci.org/quasiquoting/lodox)
[![img](https://badge.fury.io/gh/quasiquoting%2Flodox.svg)](https:/github.com/quasiquoting/lodox/releases/latest)
[![img](https://img.shields.io/github/license/quasiquoting/lodox.svg)](LICENSE)

# Introduction

Like [Codox](https://github.com/weavejester/codox) for [LFE](https://github.com/rvirding/lfe). Check out the [self-generated documentation](http://quasiquoting.org/lodox/).

# Installation

First, make sure you have the [lfe-compile](https://github.com/lfe-rebar3/compile) plugin as a dependency in your
project's `rebar.config` or, better yet, in the the global [rebar3](https://github.com/rebar/rebar3) config, `~/.config/rebar3/rebar.config`:

```erlang
{plugins,
 [{'lfe-compile', ".*",
   {git, "git://github.com/lfe-rebar3/compile.git",
    {tag, "0.2.0"}}}]}
```

Then in your project's `rebar.config`, include the [provider pre-hook](https://www.rebar3.org/v3.0/docs/configuration#section-provider-hooks):

```erlang
{provider_hooks,
 [{pre, [{compile, {lfe, compile}}]}]}
```

Finally, add Lodox to your `plugins` list:

```erlang
{plugins,
 [% ...
  {lodox, ".*",
   {git, "git://github.com/quasiquoting/lodox.git",
    {tag, "0.5.0"}}}]}.
```

The recommended place for the Lodox plugin entry is the global [rebar3](https://github.com/rebar/rebar3) config, `~/.config/rebar3/rebar.config`,
but it works at the project level, too.

# Usage

In order for Lodox to work, your project must first be compiled:

```sh
rebar3 compile
```

Then, to invoke Lodox, simply run:

```sh
rebar3 lodox
```

Alternatively, you can `do` both at once:

```sh
rebar3 do compile, lodox
```

If all goes well, the output will look something like:

    Generated lodox v0.5.0 docs in /path/to/lodox/doc

And, as promised, [generated documentation](http://quasiquoting.org/lodox/) will be in the `doc` subdirectory of
your project.

Optionally, you can add Lodox as a `compile` [post-hook](https://www.rebar3.org/v3.0/docs/configuration#section-provider-hooks):

```erlang
{provider_hooks,
 [{pre,  [{compile, {lfe, compile}}]},
  {post, [{compile, lodox}]}]}.
```

# License

Lodox is licensed under [the MIT License](http://yurrriq.mit-license.org).

```text
The MIT License (MIT)
Copyright © 2015 Eric Bailey <quasiquoting@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

Significant code and inspiration from [Codox](https://github.com/weavejester/codox). Copyright © 2015 James Revees

Codox is distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.
