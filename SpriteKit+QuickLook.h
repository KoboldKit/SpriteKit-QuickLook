//
//  SpriteKit+QuickLook.h
//  SB+SpriteKit
//
//  Created by Steffen Itterheim on 13/03/14.
//  Distributed under MIT License
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (QuickLook)
-(NSString*) debugDescriptionWithDelimiter:(NSString*)delimiter;
@end

@interface SKScene (QuickLook)
@end

@interface SKSpriteNode (QuickLook)
@end

@interface SKLabelNode (QuickLook)
@end


@interface SKTexture (QuickLook)
-(NSString*) debugDescriptionWithDelimiter:(NSString*)delimiter;
@end

// more classes will be added over time ...
