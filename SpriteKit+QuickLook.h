//
//  SpriteKit+QuickLook.h
//  SB+SpriteKit
//
//  Created by Steffen Itterheim on 13/03/14.
//  Distributed under MIT License
//

#import <SpriteKit/SpriteKit.h>

@interface QuickLookHelper : NSObject
@end

@interface SKNode (QuickLook)
-(id) debugQuickLookObject;
@end

@interface SKTexture (QuickLook)
-(id) debugQuickLookObject;
@end
@interface SKTextureAtlas (QuickLook)
-(id) debugQuickLookObject;
@end
@interface SKAction (QuickLook)
-(id) debugQuickLookObject;
@end
@interface SKView (QuickLook)
-(id) debugQuickLookObject;
@end
@interface SKPhysicsBody (QuickLook)
-(id) debugQuickLookObject;
@end
@interface SKPhysicsWorld (QuickLook)
-(id) debugQuickLookObject;
@end
@interface SKPhysicsJoint (QuickLook)
-(id) debugQuickLookObject;
@end
@interface SKTransition (QuickLook)
-(id) debugQuickLookObject;
@end
@interface SKKeyframeSequence (QuickLook)
-(id) debugQuickLookObject;
@end
