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
  constructor: (codes) ->
    @codes = []
    Object.defineProperty @, 'codes', enumerable: false
    if codes?
      @codes.push codes...
  write: (text) ->
    "\u001b[#{@codes.join ';'}m#{text}\u001b[0m"

# Inject the formatting  methods in the class (and return a new object)
for k, v of sgrCodes
  do (v) ->
    Shell::[k] = (text) ->
      shell = new Shell @codes.concat v
      if text?
        shell.write text
      else
        shell

module.exports = new Shell()
