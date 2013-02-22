
class Colors
  class Codes
    constructor: (@colors) ->
      @init()
    init: ->
      delete @color
      @bg = false
      @soft = false
      @codes = []
    _write: (code) -> "\u001b[#{code}m"
    exec: (code, args) ->
      #console.log 'Codes#exec', args
      if code < 10
        @codes.push code
      else if code < 40
        @color = code
      else if code == 40
        @bg = true
      else if code == 90
        @soft = true

      if args.length != 0
        @write args
      else
        @colors
    write: (args) ->
        #console.log 'Codes#write', args..., @color, @bg, @soft, @codes
        if @color?
          @color += 10 if @bg
          @color += 60 if @soft
          @codes.push @color
        #console.log 'Codes#write', @codes.join(';'), args
        result = @_write(@codes.join ';')+args.join(' ')+@_write(0)
        @init()
        return result
  constructor: ->
    # ANSI escape code
    @_sgrCodes =
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
      @_sgrCodes[k] = 30+v
    @_sgrCodes.bg = @_sgrCodes.background = 40
    @_sgrCodes.soft = 90
    for color, code of @_sgrCodes
      do (code) =>
        #console.log 'Colors#const', color
        @[color] = (args...) =>
          @_codes.exec code, args
    @_codes = new Codes(@)

module.exports = new Colors()
