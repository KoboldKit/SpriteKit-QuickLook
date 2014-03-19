//
//  SpriteKit+QuickLook.m
//  SB+SpriteKit
//
//  Created by Steffen Itterheim on 13/03/14.
//  Distributed under MIT License
//

#import "SpriteKit+QuickLook.h"
#import <objc/runtime.h>

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

@interface QuickLookHelper ()
+(NSString*) debugDescriptionStringWithDelimiter:(NSString*)delimiter spriteKitObject:(id)object;
@end


@implementation SKNode (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKTexture (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKTextureAtlas (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKAction (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKView (QuickLook)
-(id) valueForUndefinedKey:(NSString*)key
{
	NSLog(@"SKView: KVC ignored undefined key '%@', returning nil", key);
	return nil;
}
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKPhysicsBody (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKPhysicsWorld (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKPhysicsJoint (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKTransition (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end
@implementation SKKeyframeSequence (QuickLook)
-(id) debugQuickLookObject
{
	return [QuickLookHelper debugDescriptionStringWithDelimiter:@"\n" spriteKitObject:self];
}
@end


@implementation QuickLookHelper

-(id) init
{
	self = [super init];
	if (self)
	{
		/*
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
		 */
		
		dumpIvarNamesForClass([SKLabelNode class]);
		
		SKNode* node = [SKLabelNode node];
		NSLog(@"%@", [node debugQuickLookObject]);
		SKView* view = [[SKView alloc] init];
		NSLog(@"%@", [view debugQuickLookObject]);
	}
	return self;
}

+(BOOL) isSpriteKitClass:(Class)klass
{
	return ([klass isSubclassOfClass:[SKNode class]] ||
			[klass isSubclassOfClass:[SKTexture class]] ||
			[klass isSubclassOfClass:[SKTextureAtlas class]] ||
			[klass isSubclassOfClass:[SKAction class]] ||
			[klass isSubclassOfClass:[SKView class]] ||
			[klass isSubclassOfClass:[SKPhysicsBody class]] ||
			[klass isSubclassOfClass:[SKPhysicsWorld class]] ||
			[klass isSubclassOfClass:[SKPhysicsJoint class]] ||
			[klass isSubclassOfClass:[SKTransition class]] ||
			[klass isSubclassOfClass:[SKKeyframeSequence class]]);
}

+(NSDictionary*) debugClassVarDictionaryForSpriteKitObject:(id)object
{
	NSMutableDictionary* classesDict = [NSMutableDictionary dictionary];
	NSMutableArray* classOrder = [NSMutableArray array];
	[classesDict setObject:classOrder forKey:@"classes"];
	
	Class klass = [object class];
	while ([QuickLookHelper isSpriteKitClass:klass])
	{
		NSMutableDictionary* ivarsDict = [NSMutableDictionary dictionary];
		
		unsigned int count = 0;
		objc_property_t* properties = class_copyPropertyList(klass, &count);
		for (unsigned int i = 0; i < count; i++)
		{
			objc_property_t prop = properties[i];
			NSString* propName = [NSString stringWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
			id value = [object valueForKey:propName];
			[ivarsDict setObject:value ? value : [NSNull null] forKey:propName];
		}
		
		count = 0;
		Ivar* ivars = class_copyIvarList(klass, &count);
		for (unsigned int i = 0; i < count; i++)
		{
			Ivar var = ivars[i];
			NSString* ivarName = [NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding];
			
			// only add ivars if there's no corresponding property of the same name
			NSString* ivarNameWithoutUnderscore = [ivarName substringFromIndex:1];
			if ([ivarsDict objectForKey:ivarNameWithoutUnderscore] == NO)
			{
				id value = [object valueForKey:ivarName];
				[ivarsDict setObject:value ? value : [NSNull null] forKey:ivarName];
			}
		}
		
		NSString* className = NSStringFromClass(klass);
		[classesDict setObject:ivarsDict forKey:className];
		[classOrder insertObject:className atIndex:0];
		
		klass = [klass superclass];
	}
	
	return classesDict;
}

+(NSString*) formattedStringForValue:(id)value varName:(NSString*)varName
{
	// TODO: physics body bitMasks
	
	NSString* valueString = nil;
	if ([varName isEqualToString:@"blendMode"] || [varName isEqualToString:@"particleBlendMode"])
	{
		switch ([value integerValue]) {
			case SKBlendModeAdd:
				valueString = @"Add";
				break;
			case SKBlendModeAlpha:
				valueString = @"Alpha";
				break;
			case SKBlendModeMultiply:
				valueString = @"Multiply";
				break;
			case SKBlendModeMultiplyX2:
				valueString = @"MultiplyX2";
				break;
			case SKBlendModeReplace:
				valueString = @"Replace";
				break;
			case SKBlendModeScreen:
				valueString = @"Screen";
				break;
			case SKBlendModeSubtract:
				valueString = @"Subtract";
				break;
			default:
				valueString = [NSString stringWithFormat:@"%d (unknown)", [value integerValue]];
				break;
		}
	}
	else if ([varName isEqualToString:@"scaleMode"])
	{
		switch ([value integerValue]) {
			case SKSceneScaleModeAspectFill:
				valueString = @"AspectFill";
				break;
			case SKSceneScaleModeAspectFit:
				valueString = @"AspectFit";
				break;
			case SKSceneScaleModeFill:
				valueString = @"Fill";
				break;
			case SKSceneScaleModeResizeFill:
				valueString = @"ResizeFill";
				break;
			default:
				valueString = [NSString stringWithFormat:@"%d (unknown)", [value integerValue]];
				break;
		}
	}
	else if ([varName isEqualToString:@"verticalAlignmentMode"])
	{
		switch ([value integerValue]) {
			case SKLabelVerticalAlignmentModeBaseline:
				valueString = @"Baseline";
				break;
			case SKLabelVerticalAlignmentModeBottom:
				valueString = @"Bottom";
				break;
			case SKLabelVerticalAlignmentModeCenter:
				valueString = @"Center";
				break;
			case SKLabelVerticalAlignmentModeTop:
				valueString = @"Top";
				break;
			default:
				valueString = [NSString stringWithFormat:@"%d (unknown)", [value integerValue]];
				break;
		}
	}
	else if ([varName isEqualToString:@"horizontalAlignmentMode"])
	{
		switch ([value integerValue]) {
			case SKLabelHorizontalAlignmentModeCenter:
				valueString = @"Center";
				break;
			case SKLabelHorizontalAlignmentModeLeft:
				valueString = @"Left";
				break;
			case SKLabelHorizontalAlignmentModeRight:
				valueString = @"Right";
				break;
			default:
				valueString = [NSString stringWithFormat:@"%d (unknown)", [value integerValue]];
				break;
		}
	}
	else if ([varName isEqualToString:@"filteringMode"])
	{
		switch ([value integerValue]) {
			case SKTextureFilteringLinear:
				valueString = @"Linear";
				break;
			case SKTextureFilteringNearest:
				valueString = @"Nearest";
				break;
			default:
				valueString = [NSString stringWithFormat:@"%d (unknown)", [value integerValue]];
				break;
		}
	}
	else if ([value isKindOfClass:[NSString class]])
	{
		valueString = [NSString stringWithFormat:@"'%@'", value];
	}
	else
	{
		valueString = [[value description] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	}

	return valueString;
}

+(NSString*) debugDescriptionStringWithDelimiter:(NSString*)delimiter spriteKitObject:(id)object
{
	NSMutableString* desc = [NSMutableString string];
	[desc appendFormat:@"%@%@", [object debugDescription], delimiter];
	
	NSDictionary* classVars = [QuickLookHelper debugClassVarDictionaryForSpriteKitObject:object];
	
	for (NSString* className in classVars[@"classes"])
	{
		[desc appendFormat:@"%@:%@", className, delimiter];
		
		NSDictionary* ivars = classVars[className];
		NSArray* keys = [ivars allKeys];
		keys = [keys sortedArrayUsingComparator:^(id obj1, id obj2)
				{
					if ([(NSString*)obj1 hasPrefix:@"_"] && [(NSString*)obj2 hasPrefix:@"_"] == NO)
					{
						return NSOrderedDescending;
					}
					else if ([(NSString*)obj1 hasPrefix:@"_"] == NO && [(NSString*)obj2 hasPrefix:@"_"])
					{
						return NSOrderedAscending;
					}
					return [obj1 localizedCaseInsensitiveCompare:obj2];
				}];
		
		for (NSString* ivarName in keys)
		{
			id value = [ivars objectForKey:ivarName];
			[desc appendFormat:@"  %@ = %@%@", ivarName, [QuickLookHelper formattedStringForValue:value varName:ivarName], delimiter];
		}
	}
	
	NSLog(@"desc: \n%@ \n", desc);
	
	return desc;
}

@end
