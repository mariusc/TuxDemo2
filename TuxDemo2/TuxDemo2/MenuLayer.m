//
//  MenuLayer.m
//  test
//
//  Created by Marius Constantinescu on 01/11/13.
//  Copyright Marius Constantinescu 2013. All rights reserved.
//


#import "MenuLayer.h"
#import "TuxGameLayer.h"

#import "AppDelegate.h"

#pragma mark - MenuLayer

@implementation MenuLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Hungry Tux" fontName:@"Marker Felt" fontSize:44];
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// position the label on the center of the screen
		titleLabel.position =  ccp( size.width /2 , size.height *3/4 );
		
		CCLabelTTF *subtitleLabel = [CCLabelTTF labelWithString:@"Eat all the fish you can in 60 seconds" fontName:@"Marker Felt" fontSize:30];
		subtitleLabel.position = ccp(size.width/2, size.height/2);
		
		// add the label as a child to this Layer
		[self addChild: titleLabel];
		[self addChild:subtitleLabel];
		
		
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
//		__block id copy_self = self;
		
//		// Achievement Menu Item using blocks
//		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			TuxGameLayer *game = [[TuxGameLayer alloc] init];
//			[[app navController] presentModalViewController:game animated:YES];
//			[game release];
//			
////			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
////			achivementViewController.achievementDelegate = copy_self;
////			
////			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
////			
////			[[app navController] presentModalViewController:achivementViewController animated:YES];
////			
////			[achivementViewController release];
//		}];
		
		// New Game Menu Item
		CCMenuItem *newGame = [CCMenuItemFont itemWithString:@"Start" target:self selector:@selector(newGameTapped)];
		newGame.color = ccGREEN;
		
		
//		CCMenuItem *newGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			TuxGameLayer *game = [[TuxGameLayer alloc] init];
//			[[app navController] presentModalViewController:game animated:YES];
//			[game release];

//			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
//			achivementViewController.achievementDelegate = copy_self;

//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//
//			[[app navController] presentModalViewController:achivementViewController animated:YES];
//
//			[achivementViewController release];
			
//		}];
		
		// Leaderboard Menu Item using blocks
//		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//			
//			
//			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
//			leaderboardViewController.leaderboardDelegate = copy_self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
//			
//			[leaderboardViewController release];
//		}];
		
		
		CCMenu *menu = [CCMenu menuWithItems:newGame, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/4)];
		
		// Add the menu to the layer
		[self addChild:menu];
		
	}
	return self;
}

- (void) newGameTapped
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TuxGameLayer scene] ]];
}



#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
