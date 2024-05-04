# LOVEU

`LOVEU`, pronounced as "Love You", represents the synergy between [Love2D](https://love2d.org/) and [Unity](https://unity.com/).
It is a collection of libraries designed to replicate Unity's data type structure within Love2D, while also including components created exclusively for Love2D's ecosystem. Components imported from Unity have been adapted, as required, to Lua and Love2D.

## How to use
1. Clone this repository (or download it)
2. Copy the file(s) of the type you want to use to your project
3. Require it in your script
4. Use it

## Example
```lua
package.path = package.path .. ";libs/?.lua"

local mathx = require "libs/loveu/mathx"
local Vector2 = require "libs/loveu/Vector2"

local v1 = Vector2(1, 2)
local v2 = Vector2(3, 4)

print(v1 * 2)   -- Vector2(2, 4)
print(v1 + v2)  -- Vector2(4, 6)


print(mathx.clamp(5, 0, 10))  -- 5
print(mathx.clamp(-5, 0, 10)) -- 0

```

## Data types
- **Vector2**: A 2D vector.
* More data types will be added in the future.

## Annotations
The libraries are typed with [LuaLS]() annotations. This means that you can use an IDE that supports LuaLS to get autocompletion and type checking.
For [VSCode](https://code.visualstudio.com/), you can use the [Lua Language Server](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) extension by [sumneko](https://github.com/sumneko).

## Testing
The project includes a test suite that can be run using [busted](https://lunarmodules.github.io/busted/).



## Versioning
We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository]( ).


## Code of Conduct
Please read the [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md) file for details on our code of conduct.

## Changelog
All notable changes to this project will be documented in the [CHANGELOG](CHANGELOG.md) file.


## Roadmap
- Add more data types
- Add more tests
- Add more examples

## Contributing
If you want to contribute to this project, please read the [CONTRIBUTING](CONTRIBUTING.md) file for details on our code of conduct, and the process for submitting pull requests to us.


## Caveats
- The libraries do not include any kind type checking, so be careful when using them.
This means that you can do things like `Vector2("a", "b")` and it will not throw an error.
This decision was made to keep the libraries as lightweight and fast as possible. We might consider adding type checking in the future if it is requested or if it becomes necessary or if the testing shows that the performance impact is negligible.


## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## Acknowledgments
- **[Love2D](https://love2d.org/)** - For creating an amazing 2D game framework.
- **[busted](https://lunarmodules.github.io/busted/)** - For creating an amazing testing framework.
- **[LuaLS](https://github.com/luals/lua-language-server)** - For creating an amazing lua language server. 
- **[You]()** - Thank you for taking the time to read this README.md file and for considering contributing to this project. Your support and contributions are greatly appreciated!

