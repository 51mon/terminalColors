# ANSI escape code
sgrCodes =
  reset: 0
  bold: 1
  dark: 2
  italic: 3
  underline: 4
  blink: 5
  invert: 7
  hide: 8
  strike: 9
colors =
  black: 0
  red: 1
  green: 2
  yellow: 3
  blue: 4
  magenta: 5
  cyan: 6
  white: 7
for k, v of colors
  sgrCodes[k] = 30+v
  sgrCodes['bg_'+k] = 40+v
  sgrCodes['soft_'+k] = 90+v
  sgrCodes['soft_bg_'+k] = 100+v

class Shell
  constructor: (_code, _codes) ->
    @codes = []
    Object.defineProperty @, 'codes', enumerable: false
    if _code?
      @codes.push _code
    if _codes?
      @codes.push _codes...
    #console.log 'constructor', @codes
  write: (text) ->
    #console.log 'write', @codes
    "\u001b[#{@codes.join ';'}m#{text}\u001b[0m"

insertCode = (v) -> # Don't mutate (update) the object, create a new one
      (text) ->
        shell = new Shell v, @codes
        if text?
          shell.write text
        else
          shell
for k, v of sgrCodes
  Shell::[k] = insertCode v

module.exports = new Shell()
