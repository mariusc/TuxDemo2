//
//  HelloWorldLayer.h
//  TuxDemo2
//
//  Created by Marius Constantinescu on 31/10/13.
//  Copyright Marius Constantinescu 2013. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface TuxGameLayer : CCLayer
{
	CCSprite *tux;      //player
    BOOL touched;
    BOOL left;
    BOOL right;
    float acc;
    float timer;
    int turn;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) update:(ccTime)delta;
@property (retain) CCArray *fishes;
@property (retain) CCLabelTTF *score;
@property (retain) CCLabelTTF *seconds;
@property int noOfPoints;

@end
