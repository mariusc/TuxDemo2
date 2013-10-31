//
//  HelloWorldLayer.m
//  TuxDemo2
//
//  Created by Marius Constantinescu on 31/10/13.
//  Copyright Marius Constantinescu 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize fishes;
@synthesize score;
@synthesize noOfPoints;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
		
		
		// allow touches
        self.touchEnabled=YES;
        
        
        [self scheduleUpdate];
        
        srand(time(NULL));
        timer = 0;
        turn = 0;
        
        // the array of alling fish
        fishes = [[CCArray alloc] initWithCapacity:6];
        
        
        
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        // create and position the score label
		score = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"STHeitiJ-Light" fontSize:15];
        score.position = ccp(score.contentSize.width/2 + 10, size.height - score.contentSize.height/2);
        
        // create and initialize the background
        CCSprite *bg = [CCSprite spriteWithFile:@"back.png"];
        //position the background
        bg.position =  ccp( size.width /2 , size.height/2 );
        
        
        // create and position tux
        tux = [CCSprite spriteWithFile:@"stand-.png"];
        tux.position = ccp( size.width /2 , tux.contentSize.height/2);
        
        // animate tux;
        CCAnimation *anim = [CCAnimation animation];
		
        [anim addSpriteFrameWithFilename:@"stand0.png"];
        [anim addSpriteFrameWithFilename:@"stand1.png"];
        [anim setDelayPerUnit:0.1f];
        
        CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
        [tux runAction:repeat];
        
        
        
        [self addChild: bg];
        [self addChild: tux];
        for(int i = 0; i < 6; i++)
        {
            CCSprite* asteroid = [CCSprite spriteWithFile:@"fishy-.png"];
            asteroid.position = ccp(-asteroid.contentSize.width/2 , 0);
            [self addChild:asteroid z:0 tag:2];
            [fishes addObject:asteroid];
        }
	}
    
    [self addChild: score];
	return self;
}

//==================== TOUCHES ======================




-(CGPoint) locationFromTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}


//Called when a finger just begins touching the screen:
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint touch = [self locationFromTouches:touches];
    CGSize size = [[CCDirector sharedDirector] winSize];
    //this controlls tux. if user touches screen in ints right quarter, tux move right; same for left
    if(touch.x < size.width/4 )
    {
        left = YES;
    }
    else if(touch.x > size.width - size.width/4 )
    {
        right = YES;
    }
}

//Called when a finger is lifted off the screen:
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    left = NO;
    right = NO;
    acc = 1;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
	[fishes release];
}

-(void) update:(ccTime)delta
{
    CGPoint pos = tux.position;
    CGSize size = [[CCDirector sharedDirector] winSize];
    // move tux right or left
    if(left)
    {
        pos.x -= (delta * 30 * acc);
        if(pos.x < tux.contentSize.width/2)
            pos.x = tux.contentSize.width/2;
        acc += 0.1;
    }
    else if(right)
    {
        pos.x += (delta * 30 * acc);
        if(pos.x > size.width - tux.contentSize.width/2)
            pos.x = size.width - tux.contentSize.width/2;
        acc += 0.1;
    }
    
    // keep tux in the screen
    float imageWidthHalved = [tux texture].contentSize.width * 0.5f;
    float leftBorderLimit = imageWidthHalved;
    float rightBorderLimit = size.width - imageWidthHalved;
    if (pos.x < leftBorderLimit)
    {
        pos.x = leftBorderLimit;
    }
    else if (pos.x > rightBorderLimit)
    {
        pos.x = rightBorderLimit;
    }
    // update tux's position
    tux.position = pos;
    
    
    // move falling fish
    int x = rand()%480;
    timer += delta;
    if(timer >= 1.0)
    {
        //every second, a new fish tarts falling
        CCSprite * f =[fishes objectAtIndex:turn];
        f.position = ccp(x,330);
        CCMoveTo *mv = [CCMoveTo actionWithDuration:3.0f position:ccp(x,-30)];
        [[fishes objectAtIndex:turn] runAction:mv];
        timer = 0;
        turn = (turn + 1) % 6;
    }
    // collision detection using bounding boxes
    CGRect fishRect;
    CCSprite * f;
    CGRect tuxRect = CGRectMake(tux.position.x - tux.contentSize.width/2, tux.position.y - tux.contentSize.height/2, tux.contentSize.width, tux.contentSize.height);
	for(int j = 0; j < 6; j++)
    {
        f = [fishes objectAtIndex:j];
        fishRect = CGRectMake(f.position.x - f.contentSize.width/2, f.position.y - f.contentSize.height/2, f.contentSize.width, f.contentSize.height);
        
        
		
        //daca se intersecteaza cu racheta
        if(CGRectIntersectsRect(tuxRect, fishRect)) {
            //CCSprite * bum = [CCSprite spriteWithFile:@"bum.png"];
            //[[SimpleAudioEngine sharedEngine] playEffect:@"bum.mp3"];
            //bum.position = tux.position;
            //CCScaleTo *scale =[CCScaleTo actionWithDuration:1 scale:3];
            //CCHide *hide =[CCHide action];
            //CCSequence *seq = [CCSequence actions:scale, hide, nil];
            //[bum runAction:seq];
            //[self addChild:bum];
            [f stopAllActions];
            f.position = ccp(0, -30);
			
            // update score
            noOfPoints++;
            NSString *s = [NSString stringWithFormat:@"Score: %d", noOfPoints];
            NSLog(@"%@, %d",s, noOfPoints);
            score.string = s;
        }
    }
	
}


@end
