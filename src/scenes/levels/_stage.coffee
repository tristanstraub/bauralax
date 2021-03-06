class Stage extends Scene
  @type = 'game'

  constructor: (@QStage) ->
    @setupStage()
    @applyStrategy()
    @addBackground()
    @addPlanets()

  autoScale: ->
    padding = 75
    min =
      x: _.reduce( @planets, ((min, p) -> min = _.min [ p.x, min ]), @planets[0].x )
      y: _.reduce( @planets, ((min, p) -> min = _.min [ p.y, min ]), @planets[0].y )

    max =
      x: _.reduce( @planets, ((max, p) -> max = _.max [ p.x, max ]), @planets[0].x )
      y: _.reduce( @planets, ((max, p) -> max = _.max [ p.y, max ]), @planets[0].y )

    playableWidth  = max.x - min.x + padding * 2
    playableHeight = max.y - min.y + padding * 2
    scaleWidth     = _.min [ 1, Q.cssWidth / playableWidth ]
    scaleHeight    = _.min [ 1, Q.cssHeight / playableHeight ]

    _.min [ scaleWidth, scaleHeight ]

  setupStage: ->
    @QStage.add "viewport"
    @QStage.add "selectionControls"
    Q.hammerTouchInput.on 'zoom-out', @onZoomOut
    Q.hammerTouchInput.on 'zoom-in', @onZoomIn

    { x, y } = @viewport?.coords or Q.center()
    @QStage.viewport.centerOn x, y
    @QStage.viewport.scale = @viewport?.scale or @autoScale()

    # @QStage.collide = (obj, options) ->

  addBackground: =>
    @QStage.insert(new Q.Background)
    @QStage.insert(new Q.Star) for [1..(Q.width * Q.height / 10000)]

  addPlanets: =>
    for p in @planets
      @QStage.insert new Q.Planet(p)

  applyStrategy: =>
    for teamName, conf of (@enemyStrategem or {})
      Team[ teamName ]?.useStrategy conf.strategy

    @QStage.on 'prestep', (dt) =>
      for teamName, conf of (@enemyStrategem or {})
        Team[ teamName ].step( dt )

  transitionTo: (Stage) =>
    fadeables = Q.select('Planet').items.concat Q.select('Star').items
    @QStage.on 'step', (dt) =>
      _.each fadeables, (sprite) ->
        sprite.p.opacity = _.max [ 0, sprite.p.opacity - 0.02 ]

      return unless _.all( fadeables, (sprite) -> sprite.p.opacity is 0 )
      _.invoke fadeables, 'destroy'
      _.each Q.select('Ship').items, (ship) ->
        _.delay (-> ship.explode()), Q.random(0, 500)

      @QStage.off 'step'

      _.delay (->
        Q.clearStages()
        Stage.load()
      ), 1000

  stepViewportTo: ({x, y}) ->
    vX = @QStage.viewport.x
    vY = @QStage.viewport.y

    maxStepDistance = 20
    targetAngle     = Q.angle vX, vY, x, y
    tripDistance    = Q.distance vX, vY, x, y
    stepDistance    = _.min [ tripDistance, maxStepDistance ] # step hypotenuse

    xDistance       = Q.offsetX targetAngle, stepDistance
    yDistance       = Q.offsetY targetAngle, stepDistance

    coords =
      x: ( xDistance * Q.axis( targetAngle ).x ) + x
      y: ( yDistance * Q.axis( targetAngle ).y ) + y

    @QStage.viewport.centerOn coords.x, coords.y

  zoomIncrementFor: (velocity) ->
    _.max [ 0.05, Math.abs( velocity ) ]

  onZoomOut: (e) =>
    console.log 'zoom-out'
    @QStage.viewport.scale = _.max [ 0.4, @QStage.viewport.scale - @zoomIncrementFor( e.velocity ) ]
    @stepViewportTo( center ) if center = e.initialCenter

  onZoomIn: (e) =>
    console.log 'zoom-in'
    @QStage.viewport.scale = _.min [ 1.4, @QStage.viewport.scale + @zoomIncrementFor( e.velocity ) ]
    @stepViewportTo( center ) if center = e.initialCenter
