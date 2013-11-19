//
//  GameOverLayer.m
//  TuxDemo2
//
//  Created by Marius Constantinescu on 08/11/13.
//  Copyright 2013 Marius Constantinescu. All rights reserved.
//

#import "GameOverLayer.h"
#import "MenuLayer.h"
#import "TuxGameLayer.h"


@implementation GameOverLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) sceneWithScore:(int)score
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [[GameOverLayer alloc] initWithScore:score];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) initWithScore:(int)score
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		[[CCDirector sharedDirector] resume];
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You ate %d fish in 60 seconds",score]  fontName:@"Marker Felt" fontSize:34];
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height*3/4 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		[[CCDirector sharedDirector] runningScene];
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];

		
		// New Game  Item
		CCMenuItem *newGame = [CCMenuItemFont itemWithString:@"Restart" target:self selector:@selector(newGameTapped)];
		newGame.color = ccGREEN;
		// Main Menu Item
		CCMenuItem *mainMenu = [CCMenuItemFont itemWithString:@"Main Menu" target:self selector:@selector(mainMenuTapped)];
		mainMenu.color = ccRED;

		CCMenu *menu = [CCMenu menuWithItems:newGame, mainMenu, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
		
	}
	return self;
}

- (void) newGameTapped
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TuxGameLayer scene] ]];
}

- (void) mainMenuTapped
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene] ]];
}


@end
