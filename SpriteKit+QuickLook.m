//
//  SpriteKit+QuickLook.m
//  SB+SpriteKit
//
//  Created by Steffen Itterheim on 13/03/14.
//  Distributed under MIT License
//

#import "SpriteKit+QuickLook.h"
#import <objc/runtime.h>

static NSString* NSStringFromBool(BOOL b)
{
	return b ? @"YES" : @"NO";
}

static NSString* NSShortStringFromCGRect(CGRect r)
{
	return [NSString stringWithFormat:@"{{%.2f, %.2f}, {%.2f, %.2f}}", r.origin.x, r.origin.y, r.size.width, r.size.height];
}

static NSString* NSShortStringFromCGSize(CGSize s)
{
	return [NSString stringWithFormat:@"{%.2f, %.2f}", s.width, s.height];
}

static NSString* NSShortStringFromCGPoint(CGPoint p)
{
	return [NSString stringWithFormat:@"{%.2f, %.2f}", p.x, p.y];
}

static void dumpIvarNamesForClass(Class klass)
{
	NSMutableString* names = [NSMutableString stringWithFormat:@"%@ ivars:\n", NSStringFromClass(klass)];
	
	unsigned int count = 0;
	Ivar* ivars = class_copyIvarList(klass, &count);
	for (unsigned int i = 0; i < count; i++)
	{
		[names appendFormat:@"%s (%s)\n", ivar_getName(ivars[i]), ivar_getTypeEncoding(ivars[i])];
	}
	
	NSLog(@"%@\n", names);
}

@implementation QuickLookHelper

-(id) init
{
	self = [super init];
	if (self)
	{
		dumpIvarNamesForClass([SKAction class]);
		dumpIvarNamesForClass([SKKeyframeSequence class]);
		dumpIvarNamesForClass([SKTexture class]);
		dumpIvarNamesForClass([SKTextureAtlas class]);
		dumpIvarNamesForClass([SKTransition class]);
		dumpIvarNamesForClass([SKView class]);
		
		dumpIvarNamesForClass([SKPhysicsBody class]);
		dumpIvarNamesForClass([SKPhysicsContact class]);
		dumpIvarNamesForClass([SKPhysicsJoint class]);
		dumpIvarNamesForClass([SKPhysicsJointFixed class]);
		dumpIvarNamesForClass([SKPhysicsJointLimit class]);
		dumpIvarNamesForClass([SKPhysicsJointPin class]);
		dumpIvarNamesForClass([SKPhysicsJointSliding class]);
		dumpIvarNamesForClass([SKPhysicsJointSpring class]);
		dumpIvarNamesForClass([SKPhysicsWorld class]);

		dumpIvarNamesForClass([SKNode class]);
		dumpIvarNamesForClass([SKScene class]);
		dumpIvarNamesForClass([SKCropNode class]);
		dumpIvarNamesForClass([SKEffectNode class]);
		dumpIvarNamesForClass([SKEmitterNode class]);
		dumpIvarNamesForClass([SKLabelNode class]);
		dumpIvarNamesForClass([SKShapeNode class]);
		dumpIvarNamesForClass([SKSpriteNode class]);
		dumpIvarNamesForClass([SKVideoNode class]);
		
		// private classes
		dumpIvarNamesForClass(NSClassFromString(@"SKTextureCache"));
		dumpIvarNamesForClass(NSClassFromString(@"SKBitmapFont"));

	}
	return self;
}

@end


@implementation SKNode (QuickLook)

-(void) debugDescriptionForNodeSubclassWithDelimiter:(NSString*)delimiter desc:(NSMutableString*)desc
{
}

-(void) debugDescriptionForColorAndBlendModeWithDelimiter:(NSString*)delimiter desc:(NSMutableString*)desc
{
	if ([self respondsToSelector:@selector(color)] && [self respondsToSelector:@selector(colorBlendFactor)] && [self respondsToSelector:@selector(blendMode)])
	{
		[desc appendFormat:@"%@color:%@%@colorBlendFactor:%.2f", delimiter, [(SKSpriteNode*)self color], delimiter, [(id)self colorBlendFactor]];
		
		NSString* blendMode = nil;
		switch ([(id)self blendMode]) {
			case SKBlendModeAdd:
				blendMode = @"Add";
				break;
			case SKBlendModeAlpha:
				blendMode = @"Alpha";
				break;
			case SKBlendModeMultiply:
				blendMode = @"Multiply";
				break;
			case SKBlendModeMultiplyX2:
				blendMode = @"MultiplyX2";
				break;
			case SKBlendModeReplace:
				blendMode = @"Replace";
				break;
			case SKBlendModeScreen:
				blendMode = @"Screen";
				break;
			case SKBlendModeSubtract:
				blendMode = @"Subtract";
				break;
				
			default:
				blendMode = @"(unknown)";
				break;
		}
		[desc appendFormat:@"%@blendMode:%@", delimiter, blendMode];
	}
}

-(void) debugDescriptionForSizeAndAnchorPointWithDelimiter:(NSString*)delimiter desc:(NSMutableString*)desc
{
	if ([self respondsToSelector:@selector(size)] && [self respondsToSelector:@selector(anchorPoint)])
	{
		[desc appendFormat:@"%@size:%@%@anchorPoint:%@", delimiter, NSShortStringFromCGSize([(SKSpriteNode*)self size]), delimiter, NSShortStringFromCGPoint([(SKSpriteNode*)self anchorPoint])];
	}
}

-(NSString*) debugDescriptionWithDelimiter:(NSString*)delimiter
{
	NSMutableString* desc = [NSMutableString string];
	[desc appendFormat:@"<%@: %p>%@name:'%@'%@position:%@%@rotation:%.2f%@scale:{%.2f, %.2f}",
	 NSStringFromClass([self class]), self, delimiter, self.name, delimiter, NSShortStringFromCGPoint(self.position), delimiter, self.zRotation, delimiter, self.xScale, self.yScale];
	
	if ([self isMemberOfClass:[SKNode class]] == NO)
	{
		[desc appendFormat:@"%@==>%@", delimiter, delimiter];
		[self debugDescriptionForNodeSubclassWithDelimiter:delimiter desc:desc];
		[desc appendFormat:@"%@<==", delimiter];
	}
	
	[desc appendFormat:@"%@frame:%@%@accumulatedFrame:%@%@zPos:%.2f", delimiter, NSShortStringFromCGRect(self.frame), delimiter, NSShortStringFromCGRect([self calculateAccumulatedFrame]), delimiter, self.zPosition];
	[desc appendFormat:@"%@speed:%.2f%@alpha:%.2f%@hidden:%@%@userInteractionEnabled:%@%@paused:%@",
	 delimiter, self.speed, delimiter, self.alpha, delimiter, NSStringFromBool(self.hidden), delimiter, NSStringFromBool(self.userInteractionEnabled), delimiter, NSStringFromBool(self.paused)];
	[desc appendFormat:@"%@hasActions:%@%@parent:<%@: %p>%@scene:<%@: %p>",
	 delimiter, NSStringFromBool(self.hasActions), delimiter, NSStringFromClass([self.parent class]), self.parent, delimiter, NSStringFromClass([self.scene class]), self.scene];
	if (self.children.count)
	{
		[desc appendFormat:@"%@children:%@", delimiter, self.children];
	}
	else
	{
		[desc appendFormat:@"%@children:0", delimiter];
	}
	if (self.physicsBody)
	{
		[desc appendFormat:@"%@physicsBody:%@", delimiter, self.physicsBody.description];
	}
	if (self.userData.count)
	{
		[desc appendFormat:@"%@userData:%@", delimiter, self.userData];
	}
	else
	{
		[desc appendFormat:@"%@userData:0", delimiter];
	}
	
	return desc;
}

-(id) debugQuickLookObject
{
	return [self debugDescriptionWithDelimiter:@"\n"];
}
@end

@implementation SKScene (QuickLook)
-(void) debugDescriptionForNodeSubclassWithDelimiter:(NSString*)delimiter desc:(NSMutableString*)desc
{
	NSString* scaleMode = nil;
	switch (self.scaleMode) {
		case SKSceneScaleModeAspectFill:
			scaleMode = @"AspectFill";
			break;
		case SKSceneScaleModeAspectFit:
			scaleMode = @"AspectFit";
			break;
		case SKSceneScaleModeFill:
			scaleMode = @"Fill";
			break;
		case SKSceneScaleModeResizeFill:
			scaleMode = @"ResizeFill";
			break;
			
		default:
			scaleMode = @"(unknown)";
			break;
	}
	[desc appendFormat:@"scaleMode:%@%@backgroundColor:%@", scaleMode, delimiter, self.backgroundColor];
	[self debugDescriptionForSizeAndAnchorPointWithDelimiter:delimiter desc:desc];
	[desc appendFormat:@"%@view:<%@: %p>%@physicsWorld:%@", delimiter, NSStringFromClass([self.view class]), self.view, delimiter, [self.physicsWorld debugDescription]];
}
@end

@implementation SKSpriteNode (QuickLook)
-(void) debugDescriptionForNodeSubclassWithDelimiter:(NSString*)delimiter desc:(NSMutableString*)desc
{
	[desc appendFormat:@"texture:[%@]", self.texture.description];
	[self debugDescriptionForSizeAndAnchorPointWithDelimiter:delimiter desc:desc];
	[desc appendFormat:@"%@centerRect:%@", delimiter, NSShortStringFromCGRect(self.centerRect)];
	[self debugDescriptionForColorAndBlendModeWithDelimiter:delimiter desc:desc];
}
@end

@implementation SKLabelNode (QuickLook)
-(void) debugDescriptionForNodeSubclassWithDelimiter:(NSString*)delimiter desc:(NSMutableString*)desc
{
	[desc appendFormat:@"text:'%@'", self.text];
	[desc appendFormat:@"%@fontName:'%@'%@fontSize:%.1f%@fontColor:%@", delimiter, self.fontName, delimiter, self.fontSize, delimiter, self.fontColor];

	NSString* vAlign = nil;
	switch (self.verticalAlignmentMode) {
		case SKLabelVerticalAlignmentModeBaseline:
			vAlign = @"Baseline";
			break;
		case SKLabelVerticalAlignmentModeBottom:
			vAlign = @"Bottom";
			break;
		case SKLabelVerticalAlignmentModeCenter:
			vAlign = @"Center";
			break;
		case SKLabelVerticalAlignmentModeTop:
			vAlign = @"Top";
			break;
			
		default:
			vAlign = @"(unknown)";
			break;
	}
	
	NSString* hAlign = nil;
	switch (self.horizontalAlignmentMode) {
		case SKLabelHorizontalAlignmentModeCenter:
			hAlign = @"Center";
			break;
		case SKLabelHorizontalAlignmentModeLeft:
			hAlign = @"Left";
			break;
		case SKLabelHorizontalAlignmentModeRight:
			hAlign = @"Right";
			break;
			
		default:
			hAlign = @"(unknown)";
			break;
	}
	
	[desc appendFormat:@"%@vAlign:%@%@hAlign:%@", delimiter, vAlign, delimiter, hAlign];
	[self debugDescriptionForColorAndBlendModeWithDelimiter:delimiter desc:desc];
}
@end


@implementation SKTexture (QuickLook)
-(NSString*) debugDescriptionWithDelimiter:(NSString*)delimiter
{
	NSMutableString* desc = [NSMutableString string];
	[desc appendFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
	[desc appendFormat:@"%@imageName:'%@'", delimiter, [[self valueForKey:@"imgName"] lastPathComponent]];
	[desc appendFormat:@"%@size:%@%@textureRect:%@", delimiter, NSShortStringFromCGSize(self.size), delimiter, NSShortStringFromCGRect(self.textureRect)];
	
	NSString* filteringMode = nil;
	switch (self.filteringMode) {
		case SKTextureFilteringLinear:
			filteringMode = @"Linear";
			break;
		case SKTextureFilteringNearest:
			filteringMode = @"Nearest";
			break;
			
		default:
			filteringMode = @"(unknown)";
			break;
	}
	[desc appendFormat:@"%@filteringMode:%@", delimiter, filteringMode];

	[desc appendFormat:@"%@usesMipmaps:%@%@isData:%@%@isPath:%@%@isRotated:%@%@isCompressed:%@",
	 delimiter, NSStringFromBool(self.usesMipmaps), delimiter, NSStringFromBool([[self valueForKey:@"isData"] boolValue]), delimiter, NSStringFromBool([[self valueForKey:@"isPath"] boolValue]),
	 delimiter, NSStringFromBool([[self valueForKey:@"isRotated"] boolValue]), delimiter, NSStringFromBool([[self valueForKey:@"isCompressed"] boolValue])];
	[self descriptionForTextureCache:[self valueForKey:@"textureCache"] delimiter:delimiter desc:desc];
	[desc appendFormat:@"%@originalAtlasName:%@%@originalTexture:%@", delimiter, [self valueForKey:@"originalAtlasName"], delimiter, [self valueForKey:@"originalTexture"]];
	[desc appendFormat:@"%@subTextureName:%@", delimiter, [self valueForKey:@"subTextureName"]];

	return desc;
}

-(void) descriptionForTextureCache:(id)texCache delimiter:(NSString*)delimiter desc:(NSMutableString*)desc
{
	[desc appendFormat:@"%@textureCache:[<%@: %p>", delimiter, NSStringFromClass([texCache class]), texCache];
	[desc appendFormat:@"%@size:%@%@pixelSize:%@", delimiter, NSShortStringFromCGSize([[texCache valueForKey:@"size"] CGSizeValue]),
	 delimiter, NSShortStringFromCGSize([[texCache valueForKey:@"pixelSize"] CGSizeValue])];
	[desc appendFormat:@"%@isLoaded:%@%@hasAlpha:%@%@isPOT:%@", delimiter, NSStringFromBool([[texCache valueForKey:@"isLoaded"] boolValue]),
	 delimiter, NSStringFromBool([[texCache valueForKey:@"hasAlpha"] boolValue]), delimiter, NSStringFromBool([[texCache valueForKey:@"isPOT"] boolValue])];
	[desc appendString:@"]"];
}

-(id) debugQuickLookObject
{
	return [self debugDescriptionWithDelimiter:@"\n"];
}
@end

@implementation SKTextureAtlas (QuickLook)

-(NSString*) debugDescriptionWithDelimiter:(NSString*)delimiter
{
	NSMutableString* desc = [NSMutableString string];
	[desc appendFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
	[desc appendFormat:@"%@atlasName:'%@'", delimiter, [self valueForKey:@"atlasName"]];
	[desc appendFormat:@"%@textureNames:%@", delimiter, self.textureNames];
	return desc;
}

-(id) debugQuickLookObject
{
	return [self debugDescriptionWithDelimiter:@"\n"];
}
@end
