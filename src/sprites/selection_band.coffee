Q.Sprite.extend 'SelectionBand',
  init: (p) ->
    @_super _.defaults p,
      type   : Q.SPRITE_DEFAULT
      sensor : true
      asset  : '/assets/images/star.png'
      w      : 4
      h      : 4
      radius : 2

    @on 'hit.sprite', @, 'onCollision'

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
    ctx.arc(@p.radius / 2, @p.radius / 2, @p.radius / 2, 0, 180)
    ctx.fill()

    ctx.restore()

  onCollision: (collision) ->
    return unless ( ship = collision.obj ).isA("Ship")
    return unless ship.belongsToPlayer()
    ship.select()

