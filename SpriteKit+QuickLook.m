//
//  SpriteKit+QuickLook.m
//  SB+SpriteKit
//
//  Created by Steffen Itterheim on 13/03/14.
//  Distributed under MIT License
//

#import "SpriteKit+QuickLook.h"

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

// change this to empty space if you don't like the line-breaks between properties
static const NSString* delimiter = @"\n";

@implementation SKNode (QuickLook)

-(NSString*) debugDescriptionForSubclass
{
	return @"";
}

-(NSString*) debugDescriptionForColorAndBlendMode
{
	NSMutableString* desc = [NSMutableString string];
	if ([self respondsToSelector:@selector(color)] && [self respondsToSelector:@selector(colorBlendFactor)] && [self respondsToSelector:@selector(blendMode)])
	{
		[desc appendFormat:@"color:%@%@colorBlendFactor:%.2f", [(SKSpriteNode*)self color], delimiter, [(id)self colorBlendFactor]];
		
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
	return desc;
}

-(NSString*) debugDescriptionForSizeAndAnchorPoint
{
	NSMutableString* desc = [NSMutableString string];
	if ([self respondsToSelector:@selector(size)] && [self respondsToSelector:@selector(anchorPoint)])
	{
		[desc appendFormat:@"size:%@%@anchorPoint:%@", NSShortStringFromCGSize([(id)self size]), delimiter, NSShortStringFromCGPoint([(id)self anchorPoint])];
	}
	return desc;
}

-(NSString*) debugDescription
{
	NSMutableString* desc = [NSMutableString string];
	[desc appendFormat:@"<%@: %p>%@name:'%@'%@position:%@%@rotation:%.2f%@scale:{%.2f, %.2f}",
	 NSStringFromClass([self class]), self, delimiter, self.name, delimiter, NSShortStringFromCGPoint(self.position), delimiter, self.zRotation, delimiter, self.xScale, self.yScale];
	[desc appendFormat:@"%@===>%@%@%@<===", delimiter, delimiter, self.debugDescriptionForSubclass, delimiter];
	[desc appendFormat:@"%@z:%.2f%@frame:%@%@accumulatedFrame:%@", delimiter, self.zPosition, delimiter, NSShortStringFromCGRect(self.frame), delimiter, NSShortStringFromCGRect([self calculateAccumulatedFrame])];
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
		[desc appendFormat:@"%@physicsBody:%@", delimiter, [self.physicsBody debugDescription]];
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
	return self.debugDescription;
}

@end

@implementation SKScene (QuickLook)
-(NSString*) debugDescriptionForSubclass
{
	NSMutableString* desc = [NSMutableString string];
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
	[desc appendFormat:@"%@%@", delimiter, [self debugDescriptionForSizeAndAnchorPoint]];
	[desc appendFormat:@"%@view:<%@: %p>%@physicsWorld:%@", delimiter, NSStringFromClass([self.view class]), self.view, delimiter, [self.physicsWorld debugDescription]];
	return desc;
}
@end

@implementation SKSpriteNode (QuickLook)
-(NSString*) debugDescriptionForSubclass
{
	NSMutableString* desc = [NSMutableString string];
	[desc appendFormat:@"texture:%@%@centerRect:%@", self.texture.debugDescription, delimiter, NSShortStringFromCGRect(self.centerRect)];
	[desc appendFormat:@"%@%@", delimiter, [self debugDescriptionForSizeAndAnchorPoint]];
	[desc appendFormat:@"%@%@", delimiter, [self debugDescriptionForColorAndBlendMode]];
	return desc;
}
@end

@implementation SKLabelNode (QuickLook)
-(NSString*) debugDescriptionForSubclass
{
	NSMutableString* desc = [NSMutableString string];
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
	[desc appendString:[self debugDescriptionForColorAndBlendMode]];
	return desc;
}
@end