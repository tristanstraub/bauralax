window.Q = Quintus(development: true)
  .include("Sprites, Math, Scenes, Input, 2D, Touch, UI")
  .setup(maximize: true, scaleToFit: true)     # Add a canvas element onto the page
  .controls()  # Add in default controls (keyboard, buttons)
  .touch()     # Add in touch support (for the UI)

$(document).ready -> Game.start()