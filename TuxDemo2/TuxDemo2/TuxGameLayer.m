//
//  TuxGameLayer.m
//  TuxDemo2
//
//  Created by Marius Constantinescu on 31/10/13.
//  Copyright Marius Constantinescu 2013. All rights reserved.
//


// Import the interfaces
#import "TuxGameLayer.h"
#import "AppDelegate.h"
#import "GameOverLayer.h"

#pragma mark - TuxGameLayer

@interface TuxGameLayer()

@property (strong, nonatomic) CCSprite *tux;      //player
@property (strong) CCArray *fishes;
@property (strong) CCLabelTTF *scoreLabel;
@property (strong) CCLabelTTF *secondsLabel;
@property (assign, nonatomic) int secondsFromStart;
@property (assign, nonatomic) BOOL leftTouch;
@property (assign, nonatomic) BOOL rightTouch;
@property (assign, nonatomic) float acc;
@property (assign, nonatomic) float timer;
@property (assign, nonatomic) int turn;
@property (assign, nonatomic) int noOfPoints;

@end

// HelloWorldLayer implementation
@implementation TuxGameLayer



// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TuxGameLayer *layer = [TuxGameLayer node];
	
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
		
		_leftTouch = NO;
		_rightTouch = NO;
		_acc = 1;
		
		// allow touches
        self.touchEnabled=YES;
		
		_secondsFromStart = 0;
		_noOfPoints = 0;
        
        [self scheduleUpdate];
        
        srand(time(NULL));
        _timer = 0;
        _turn = 0;
        
        // the array of falling fish
        _fishes = [[CCArray alloc] initWithCapacity:6];
	
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        // create and position the score label
		_scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"STHeitiJ-Light" fontSize:15];
        _scoreLabel.position = ccp(_scoreLabel.contentSize.width/2 + 10, size.height - _scoreLabel.contentSize.height/2);
		
		//create and position the seconds label
		_secondsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time: %d", _secondsFromStart] fontName:@"STHeitiJ-Light" fontSize:15];
		_secondsLabel.position = ccp(size.width - _secondsLabel.contentSize.width/2 - 10, size.height - _secondsLabel.contentSize.height/2);
        
        // create and initialize the background
        CCSprite *bg = [CCSprite spriteWithFile:@"back.png"];
        //position the background
        bg.position =  ccp( size.width /2 , size.height/2 );
        
        // create and position tux
        _tux = [CCSprite spriteWithFile:@"stand-.png"];
        _tux.position = ccp(size.width /2 , _tux.contentSize.height/2);
        
        // animate tux;
        CCAnimation *anim = [CCAnimation animation];
		
        [anim addSpriteFrameWithFilename:@"stand0.png"];
        [anim addSpriteFrameWithFilename:@"stand1.png"];
        [anim setDelayPerUnit:0.1f];
        
        CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
        [_tux runAction:repeat];
        
        [self addChild: bg];
        [self addChild: _tux];
        for(int i = 0; i < 6; i++)
        {
            CCSprite* fish = [CCSprite spriteWithFile:@"fishy-.png"];
            fish.position = ccp(-fish.contentSize.width/2 , 0);
            [self addChild:fish z:0 tag:2];
            [_fishes addObject:fish];
        }
	}
    
    [self addChild: _scoreLabel];
	[self addChild:_secondsLabel];
	return self;
}

#pragma mark - touches handler

-(CGPoint) locationFromTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}


//Called when a finger just begins touching the screen:
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self locationFromTouches:touches];
    CGSize size = [[CCDirector sharedDirector] winSize];
    //this controlls tux. if user touches screen in ints right quarter, tux move right; same for left
    if(touchPoint.x < size.width/4) {
        self.leftTouch = YES;
    }
    else if(touchPoint.x > size.width - size.width/4) {
        self.rightTouch = YES;
    }
}

//Called when a finger is lifted off the screen:
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.leftTouch = NO;
    self.rightTouch = NO;
    self.acc = 1;
}

# pragma mark - update

-(void) update:(ccTime)delta
{
    CGPoint pos = self.tux.position;
    CGSize size = [[CCDirector sharedDirector] winSize];
    // move tux right or left
    if(self.leftTouch) {
        pos.x -= (delta * 30 * self.acc);
        if(pos.x < self.tux.contentSize.width/2)
            pos.x = self.tux.contentSize.width/2;
        self.acc += 0.1;
    }
    else if(self.rightTouch) {
        pos.x += (delta * 30 * self.acc);
        if(pos.x > size.width - self.tux.contentSize.width/2)
            pos.x = size.width - self.tux.contentSize.width/2;
        self.acc += 0.1;
    }
    
    // update tux's position
    self.tux.position = pos;
    
    
    // move falling fish
    int x = rand()%480;
    self.timer += delta;
    if(self.timer >= 1.0) {
        //every second, a new fish tarts falling
        CCSprite * f =[self.fishes objectAtIndex:self.turn];
        f.position = ccp(x,330);
        CCMoveTo *mv = [CCMoveTo actionWithDuration:3.0f position:ccp(x,-30)];
        [[self.fishes objectAtIndex:self.turn] runAction:mv];
        self.timer = 0;
        self.turn = (self.turn + 1) % 6;
		
		self.secondsFromStart += 1;
		self.secondsLabel.string = [NSString stringWithFormat:@"Time: %d",self.secondsFromStart];
		
		if (self.secondsFromStart == 50) {
			self.secondsLabel.color = ccRED;
		}
		
		if (self.secondsFromStart >= 60){
			[self gameOver];
		}
	}
	
    // collision detection using bounding boxes
    [self detectFishCollision];
	
}

-(void)detectFishCollision
{
	CGRect tuxRect = CGRectMake(self.tux.position.x - self.tux.contentSize.width/2, self.tux.position.y - self.tux.contentSize.height/2, self.tux.contentSize.width, self.tux.contentSize.height);
	
	for (CCSprite* f in self.fishes) {
		
        CGRect fishRect = CGRectMake(f.position.x - f.contentSize.width/2, f.position.y - f.contentSize.height/2, f.contentSize.width, f.contentSize.height);
		
        //if it intersects a falling fish
        if(CGRectIntersectsRect(tuxRect, fishRect)) {
            [f stopAllActions];
            f.position = ccp(0, -30);
			
            // update score
            self.noOfPoints++;
            self.scoreLabel.string = [NSString stringWithFormat:@"Score: %d", self.noOfPoints];
        }
    }

}


-(void)gameOver
{
	[[CCDirector sharedDirector] pause];
	[[CCDirector sharedDirector] replaceScene:[GameOverLayer sceneWithScore:self.noOfPoints]];
	
}

@end
