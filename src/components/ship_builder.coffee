Q.component 'shipBuilder',

  added: ->
    @timer = setInterval @build.bind(this), @entity.p.buildRate or 1000
    # @timer = setTimeout @build.bind(this), @entity.p.buildRate or 1000

  stopBuilding: ->
    clearInterval @timer

  nextCoords: ->
    { x, y } = @entity.p

    rotation = @entity.p.shipEmitRotation or 18
    dist     = @entity.p.shipEmitDistance or (@entity.asset().width / 2 + 10) # hypot

    @lastAngle ?= 0
    @lastAngle += rotation

    x: x + Q.offsetX( @lastAngle, dist )
    y: y + Q.offsetY( @lastAngle, dist )

  build: ->
    { team, x, y } = @entity.p

    coords = @nextCoords()
    ship = new Q.Ship(x: x, y: y, team: team, path: [ coords ])

    @entity.stage.insert ship
    @entity.trigger 'shipBuilder:shipBuilt', ship
