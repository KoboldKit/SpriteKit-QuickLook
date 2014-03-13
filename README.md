SpriteKit-QuickLook
===================

Tired of not seeing any debug info of Sprite Kit classes?

These categories add QuickLook (Xcode 5.1+) and debugDescription strings to Sprite Kit nodes for easier debugging of Sprite Kit apps.

To use: 
-------
- add SpriteKit+QuickLook.h and .m to your project
- while debugging, click on the QuickLook (eye) icon or the info (i) icon

Tip: these icons are below the variable inspector view and next to a Sprite Kit class reference tooltip after hovering on a reference with the mouse.
Learn more about Xcode 5.1 QuickLook here: https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/CustomClassDisplay_in_QuickLook/CH01-quick_look_for_custom_objects/CH01-quick_look_for_custom_objects.html

Example output:
------------

Instead of just getting <SKSpriteNode: 0x111702210> with no info on property values, you can quicklook or log Sprite Kit classes with all their properties. 
Here's an example output string:

```
Printing description of self->_background:
<SKSpriteNode: 0x111702210>
name:'(null)'
position:{0.00, 0.00}
rotation:0.00
scale:{1.00, 1.00}
===>
texture:(null)
centerRect:{{0.00, 0.00}, {1.00, 1.00}}
size:{0.00, 0.00}
anchorPoint:{0.50, 0.50}
color:UIDeviceRGBColorSpace 1 1 1 1
colorBlendFactor:0.00
blendMode:Alpha
<===
z:0.00
frame:{{0.00, 0.00}, {0.00, 0.00}}
accumulatedFrame:{{0.00, 0.00}, {0.00, 0.00}}
speed:1.00
alpha:1.00
hidden:NO
userInteractionEnabled:NO
paused:NO
hasActions:NO
parent:<SBButtonNode: 0x111700c80>
scene:<(null): 0x0>
children:0
userData:0
```

Tip: to change from "each property on a new line" to denser space-delimited output change the static `delimiter` variable to `@" "` if you prefer output to be on a single line.
