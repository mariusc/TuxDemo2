//
//  GameOverLayer.h
//  TuxDemo2
//
//  Created by Marius Constantinescu on 08/11/13.
//  Copyright 2013 Marius Constantinescu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayer

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) sceneWithScore:(int) score;
@end
