# BodyCheck

Additional checks for [Credo](https://github.com/rrrene/credo)

Currently supported:

## Installation

Add `body_check` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # You don't need to add credo as well
    {:body_check, "~> 0.1.0"}
  ]
end
```

Create a .credo.exs configuration file if you don't already have one

```
mix credo.gen.config
```

And add these checks to the checks section of .credo.exs

```
checks: [
  # Arguments of a function head do not go over multiple lines
  {BodyCheck.NoMultiLineFunctionHeads, []}
]
```
