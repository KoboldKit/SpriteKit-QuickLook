SpriteKit-QuickLook
===================

Tired of not seeing any details of Sprite Kit classes in the debugger?

These categories add QuickLook strings (requires Xcode 5.1+) to Sprite Kit nodes for easier debugging of Sprite Kit apps.

License: **MIT License**

Watch a demo video (Sprite Kit demo at 1:03):
https://www.youtube.com/watch?v=ToH4YbTSDAU

To use: 
-------
- add SpriteKit+QuickLook.h and .m to your project
- while debugging, click on a Sprite Kit object variable's QuickLook (eye) icon or the info (i) icon (provided the variable is a reference of a Sprite Kit class)

Learn more about Xcode 5.1 QuickLook here (has details on how to bring up the QuickLook view): 
https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/CustomClassDisplay_in_QuickLook/CH01-quick_look_for_custom_objects/CH01-quick_look_for_custom_objects.html

To use the Summary strings:
-------------

This is an unsupported, optional feature.

- create or update ~/.lldbinit with the contents of the lldbinit file
- copy or create a symlink of SpriteKitDebug.py in ~/SpriteKitDebug.py
- restart Xcode

The Xcode variables display should now show Sprite Kit objects' summary strings (description) next to the variable. This provides some useful context without having to go through QuickLook, for example a SKTexture object will display the texture name and size next to it, which is probably the most important info you need from an SKTexture object.

Example output:
------------

Instead of just getting <SKSpriteNode: 0x111702210> with no info on property values, you can quicklook or log Sprite Kit classes with all their properties. You can issue a quicklook anytime anywhere from within the debugger, so you don't need to NSLog anything in order to get this info. It's right there where and when you need it the most!

Here are some example output strings. Note how even private ivars and their values are being dumped, and the variables are sorted by name.

SKLabelNode Example
-----------
```
<SKLabelNode> name:'(null)' text:'' fontName:'Helvetica' position:{0, 0}
SKNode:
  alpha = 1
  children = ()
  controller = <null>
  csprite = <null>
  frame = NSRect: {{0, 0}, {0, 0}}
  hidden = 0
  info = <null>
  kkScene = <null>
  model = <null>
  name = <null>
  node = <null>
  parent = <null>
  paused = 0
  physicsBody = <null>
  position = NSPoint: {0, 0}
  scene = <null>
  speed = 1
  userData = <null>
  userInteractionEnabled = 0
  xRotation = 0
  xScale = 1
  yOffsetInPoints = 0
  yRotation = 0
  yScale = 1
  zPosition = 0
  zRotation = 0
  _actions = ()
  _actionsToRemove = ()
  _anchorPoint = NSPoint: {0, 0}
  _deleteList = ()
  _info = <null>
  _keyedActions = {}
  _keyedSubSprites = {}
  _needsDelete = 0
  _showBounds = 0
  _size = NSSize: {0, 0}
  _spritesNeedsRemove = 0
  _spritesToRemove = ()
  _untransformedBounds = NSRect: {{inf, inf}, {inf, inf}}
SKLabelNode:
  blendMode = Alpha
  color = <null>
  colorBlendFactor = 0
  fontColor = UIDeviceRGBColorSpace 1 1 1 1
  fontName = 'Helvetica'
  fontSize = 32
  horizontalAlignmentMode = Center
  text = ''
  verticalAlignmentMode = Baseline
  _bmf = <null>
  _labelBlendMode = 0
  _labelColor = <null>
  _labelColorBlend = 0
  _textRect = NSRect: {{0, 0}, {0, 0}}
  _textSprite = <null>
  _textSprites = ()
```

SKView Example
-----------
```
<SKView: 0xb77d610; frame = (0 0; 0 0); layer = <CAEAGLLayer: 0xb77cfb0>>
SKView:
  asynchronous = 1
  frameInterval = 1
  ignoresSiblingOrder = 0
  paused = 0
  pixelSize = NSSize: {0, 0}
  scene = <null>
  showsDrawCount = 0
  showsFPS = 0
  showsNodeCount = 0
  showsPhysics = 0
  _colorRenderBuffer = 0
  _context = <null>
  _depthStencilRenderBuffer = 0
  _disableInput = 0
  _displayLink = <SKDisplayLink: 0xb77dfe0>
  _fps = 0
  _frameBuffer = 0
  _frames = 0
  _hasRenderedForCurrentUpdate = 0
  _hasRenderedOnce = 0
  _isInTransition = 0
  _nextScene = <null>
  _prevBackingScaleFactor = 0
  _prevSpritesRendered = 0
  _prevSpritesRenderedSubmitted = 0
  _prevViewAspect = 0
  _renderer = <null>
  _renderQueue = <OS_dispatch_queue: com.apple.spritekit.renderQueue[0xb77db20]>
  _scene = <null>
  _shouldCenterStats = 0
  _showsCoreAnimationFPS = 0
  _showsCPUStats = 0
  _showsCulledNodesInNodeCount = 0
  _showsGPUStats = 0
  _showsSpriteBounds = 0
  _showsTotalAreaRendered = 0
  _spriteArrayHint = <null>
  _spriteRenderCount = -1431655766
  _spritesRendered = 0
  _spritesSubmitted = 0
  _spriteSubmitCount = -1431655766
  _statsLabel = <null>
  _timeBeginFrameCount = -1
  _timePreviousUpdate = -1
  _touchMap = {}
  _transitionDuration = 0
  _transitionTime = 0
  _updateQueue = <OS_dispatch_queue: com.apple.main-thread[0x33fbe00]>
  _usesAsyncUpdateQueue = 0
```
