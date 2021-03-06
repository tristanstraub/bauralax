Q.Sprite.extend 'SelectionBand',
  init: (p) ->
    @_super _.defaults p,
      type   : Q.SPRITE_UI
      sensor : true
      asset  : 'star.png'
      w      : 4
      h      : 4
      radius : 2

  redraw: ({radius, x, y}) ->
    @p.radius = radius
    @p.w      = radius * 2
    @p.h      = radius * 2
    @p.x      = x
    @p.y      = y

    Q._generatePoints @, true

  draw: (ctx) ->
    ctx.globalCompositeOperation = 'lighter'
    ctx.save()

    ctx.beginPath()
    ctx.fillStyle = "rgba(255, 255, 255, 0.3)"
    ctx.arc 0, 0, @p.radius, 0, 180
    ctx.fill()

    ctx.restore()

  isInBounds: (sprite) ->
    dx   = @p.x - sprite.p.x
    dy   = @p.y - sprite.p.y
    rSum = @p.radius + _.max([ (sprite.asset().width / 2), 1 ])
    (dx * dx) + (dy * dy) <= (rSum * rSum)

