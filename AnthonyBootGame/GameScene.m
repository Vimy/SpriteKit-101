//
//  GameScene.m
//  AnthonyBootGame
//
//  Created by Matthias Vermeulen on 27/01/16.
//  Copyright (c) 2016 Noizy. All rights reserved.
//

#import "GameScene.h"
#import "ScoreBoardScene.h"

@interface GameScene()
{
    SKSpriteNode *_boat;
    SKSpriteNode *_enemyBoat;
    NSMutableArray *_explosionTextures;
    SKLabelNode *_labelLivesLeft;
    SKLabelNode *_distanceLabel;
    SKLabelNode *_distanceInMeters;
    NSMutableArray *ScoreKeeperSprites;
    SKSpriteNode* _islandSprite;
    int _distanceUpdateVar;
}
@end

static const uint8_t player = 1;
static const uint8_t enemyCategory = 2;


@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    
    _distanceUpdateVar = 0;
    
     // self.scaleMode = SKSceneScaleModeResizeFill;
    //self.scaleMode = SKSceneScaleModeAspectFit;
   // self.scaleMode = SKSceneScaleModeFill;
   // self.scaleMode = SKSceneScaleModeResizeFill;
    
    [self runAction:[SKAction playSoundFileNamed:@"soundtrack.wav" waitForCompletion:NO]];
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    //http://code.tutsplus.com/tutorials/build-an-airplane-game-with-sprite-kit-project-setup--mobile-19891
    [self setupLabels];
    [self spawnBoat];
    [self setupBackground];
    [self setupIsland];
    [self addLivesSprites];
    
    SKAction *spawnEnemies = [SKAction sequence:@[[SKAction waitForDuration:2 withRange:1],
                                                  [SKAction performSelector:@selector(spawnEnemyBoat) onTarget:self]]];
    [self runAction:[SKAction repeatActionForever:spawnEnemies]];
    
    //[self spawnEnemyBoat];
  
}

#pragma mark - Setup Level

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)setupLabels
{
    // view.ignoresSiblingOrder = NO;
    // Setup your scene here
    _labelLivesLeft = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _labelLivesLeft.text = @"Lives:";
    _labelLivesLeft.fontSize = 20;
    _labelLivesLeft.position = CGPointMake((self.size.width/4)+_labelLivesLeft.frame.size.width+15, self.size.height-_labelLivesLeft.frame.size.height);
    [self addChild:_labelLivesLeft];
    
    _distanceLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _distanceLabel.fontSize = 20;
    _distanceLabel.text = @"Distance:";
    //   _distanceLabel.position = CGPointMake(self.size.width-_distanceLabel.frame.size.width, _labelLivesLeft.position.y);
    _distanceLabel.position = CGPointMake(600, _labelLivesLeft.position.y);
    NSLog (@"Position distanceLabel: %@", [NSValue valueWithCGPoint:_distanceLabel.position]);
    NSLog (@"Position labelLivesLeft: %@", [NSValue valueWithCGPoint:_labelLivesLeft.position]);
    [self addChild:_distanceLabel];
    
    
    _distanceInMeters = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _distanceInMeters.fontSize = 20;
    _distanceInMeters.text = @"0";
    //   _distanceLabel.position = CGPointMake(self.size.width-_distanceLabel.frame.size.width, _labelLivesLeft.position.y);
    _distanceInMeters.position = CGPointMake(650+_distanceLabel.frame.size.width/2, _labelLivesLeft.position.y);
    [self addChild:_distanceInMeters];
}


- (void)spawnEnemyBoat
{
    SKTexture *enemyBoatTexture = [SKTexture textureWithImageNamed:@"player3"];
    enemyBoatTexture.filteringMode = SKTextureFilteringNearest;
    _enemyBoat = [SKSpriteNode spriteNodeWithTexture:enemyBoatTexture];
    [_enemyBoat setScale:0.3];
    //_enemyBoat.position = CGPointMake(self.frame.size.width / 2, (self.frame.size.height /2)+50);
      //_enemyBoat.physicsBody.usesPreciseCollisionDetection = YES;
    _enemyBoat.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_enemyBoat.frame.size];
    _enemyBoat.physicsBody.categoryBitMask = enemyCategory;
    _enemyBoat.physicsBody.contactTestBitMask = player ;
    _enemyBoat.physicsBody.collisionBitMask = player;
    _enemyBoat.zPosition = -5;
    _enemyBoat.physicsBody.velocity = CGVectorMake(10, 340);
   
  //  _enemyBoat.physicsBody.affectedByGravity = NO;
    [self addChild:_enemyBoat];
    
}

-(void) addLivesSprites {
    ScoreKeeperSprites = [NSMutableArray new];
    for (int i = 0; i < 4; i++) {
        SKSpriteNode *boei = [SKSpriteNode spriteNodeWithImageNamed:@"boei"];
        boei.zPosition = -5;
        [boei setScale:0.5];
        
        int xPos = _labelLivesLeft.position.x + 50;
      //  int yPos = self.size.height-_myLabel.frame.size.height;
        boei.position = CGPointMake(xPos + 40*i, _labelLivesLeft.position.y);
        [ScoreKeeperSprites addObject:boei];
        [self addChild:boei ];
        
    }
}

- (void)spawnBoat
{
    //http://digitalbreed.com/2014/how-to-build-a-game-like-flappy-bird-with-xcode-and-sprite-kit#
    
    
    
    SKTexture *boatTexture1 = [SKTexture textureWithImageNamed:@"player"];
    boatTexture1.filteringMode = SKTextureFilteringNearest;
    _boat = [SKSpriteNode spriteNodeWithTexture:boatTexture1];
    [_boat setScale:1.0];
    _boat.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_boat.frame.size];
    _boat.position = CGPointMake((self.frame.size.width / 2)-150, self.frame.size.height /2);
    _boat.physicsBody.categoryBitMask = player;
   _boat.physicsBody.contactTestBitMask = enemyCategory;
    _boat.physicsBody.collisionBitMask = enemyCategory;
    _boat.zPosition = -5;
    _boat.physicsBody.dynamic = NO;
    //_boat.physicsBody.affectedByGravity = NO;
    [self addChild:_boat];
    
    NSLog(@"Bitmask : %u", _boat.physicsBody.categoryBitMask);
}

- (void)setupBackground
{
    CGSize coverageSize = CGSizeMake(2000,2000); //the size of the entire image you want tiled
    CGRect textureSize = CGRectMake(0, 0, 50, 50); //the size of the tile.
    CGImageRef backgroundCGImage = [UIImage imageNamed:@"water"].CGImage; //change the string to your image name
    UIGraphicsBeginImageContext(CGSizeMake(coverageSize.width, coverageSize.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(context, textureSize, backgroundCGImage);
    UIImage *tiledBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    SKTexture *backgroundTexture = [SKTexture textureWithCGImage:tiledBackground.CGImage];
    // SKSpriteNode *backgroundTiles = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    
    SKAction* moveWaterSprite = [SKAction moveByX:-backgroundTexture.size.width*2 y:0 duration:0.02 * backgroundTexture.size.width*2];
    SKAction* resetWaterSprite = [SKAction moveByX:backgroundTexture.size.width*2 y:0 duration:0];
    SKAction* moveWaterSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveWaterSprite, resetWaterSprite]]];
    
    
    
    
    for( int i = 0; i < 2 + self.frame.size.width / ( backgroundTexture.size.width * 2 ); ++i ) {
        SKSpriteNode *backgroundTiles = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        backgroundTiles.yScale = -1; //upon closer inspection, I noticed my source tile was flipped vertically, so this just flipped it back.
        backgroundTiles.position = CGPointMake(i * backgroundTiles.size.width, backgroundTiles.size.height / 2);
        backgroundTiles.zPosition = -10;
        
        [backgroundTiles runAction:moveWaterSpritesForever];
        
        [self addChild:backgroundTiles];
    }
}

- (void)setupIsland
{
    SKTexture* groundTexture = [SKTexture textureWithImageNamed:@"eiland"];
    groundTexture.filteringMode = SKTextureFilteringNearest;
    
    
    SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:0.01 * groundTexture.size.width*2];
    SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    
    for( int i = 0; i < 5 + self.frame.size.width / ( groundTexture.size.width * 2 ); ++i )
    {
        [self spawnCannon];
        _islandSprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [_islandSprite setScale:1.0];
        _islandSprite.position = CGPointMake(i * _islandSprite.size.width, _islandSprite.size.height / 2);
        _islandSprite.zPosition = 5;
        [_islandSprite runAction:moveGroundSpritesForever];
      //  sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.frame.size];
       // sprite.physicsBody.dynamic = NO;
        [self addChild:_islandSprite];
    }
}

- (void)spawnCannon
{
    SKTexture *cannonTexture = [SKTexture textureWithImageNamed:@"kanon"];
    cannonTexture.filteringMode = SKTextureFilteringNearest;

    SKSpriteNode *cannon = [SKSpriteNode spriteNodeWithTexture:cannonTexture];
    [cannon setScale:1.0];
    cannon.position = CGPointMake(cannon.size.width / 2, cannon.size.height / 2 );
    cannon.zPosition = -20;
    [self addChild:cannon];
}


- (void)explosion:(CGPoint)fromLocation
{
    
    SKTextureAtlas *explosionAtlas = [SKTextureAtlas atlasNamed:@"EXPLOSION"];
    NSArray *textureNames = [explosionAtlas textureNames];
    _explosionTextures = [NSMutableArray new];
    
    for (NSString *name in textureNames) {
        SKTexture *texture = [explosionAtlas textureNamed:name];
        [_explosionTextures addObject:texture];
    }
    
    
    
    SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures objectAtIndex:0]];
    explosion.zPosition = 1;
    explosion.scale = 0.6;
    explosion.position = fromLocation;
    
    [self addChild:explosion];
    
    SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures timePerFrame:0.10];
    SKAction *shipExplosionSound = [SKAction playSoundFileNamed:@"explosion_large.caf" waitForCompletion:NO];
    SKAction *remove = [SKAction removeFromParent];
    [explosion runAction:[SKAction sequence:@[shipExplosionSound,explosionAction,remove]] completion:^{
       ScoreBoardScene *endScene = [ScoreBoardScene sceneWithSize:self.size];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:_distanceUpdateVar forKey:@"score"];
        [self.view presentScene:endScene transition:[SKTransition doorsCloseHorizontalWithDuration:1]];
    }  ];

}

#pragma mark - Game logic

- (void)update:(CFTimeInterval)currentTime
{
    
    _distanceUpdateVar = _distanceUpdateVar + 1;
    _distanceInMeters.text =  [NSString stringWithFormat:@"%i", _distanceUpdateVar];

 
    
    float randY = [self randomValueBetween:_islandSprite.position.y+10 andValue:self.frame.size.height];
    float randDuration = [self randomValueBetween:2.0 andValue:10.0];
    
    _enemyBoat.position = CGPointMake(self.frame.size.width+_enemyBoat.size.width/2, randY);
    _enemyBoat.hidden = NO;
    
    CGPoint location = CGPointMake(-self.frame.size.width-_enemyBoat.size.width, randY);
    
    SKAction *moveAction = [SKAction moveTo:location duration:8];
    SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^() {
        //NSLog(@"Animation Completed");
        //_enemyBoat.hidden = YES;
    }];
    
    SKAction *moveEnemyAction = [SKAction sequence:@[moveAction,doneAction ]];
    [_enemyBoat runAction:moveEnemyAction];
    
    if ([_boat intersectsNode:_enemyBoat]) //werkt niet!
    {
        NSLog(@"Aanvaring! Bel de pliesie!");
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //     Called when a touch begins
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Location: %@", NSStringFromCGPoint(location));
        
        SKAction *moveToPoint = [SKAction moveTo:location duration:1];
        [_boat runAction:moveToPoint];
        
    }
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contact!");
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & player) != 0)
    {
        if (ScoreKeeperSprites.count > 0)
        {
            [secondBody.node removeFromParent];
            SKSpriteNode *node = [ScoreKeeperSprites lastObject];
            [node removeFromParent];
            [ScoreKeeperSprites removeLastObject];
            SKAction *shipRammingSound = [SKAction playSoundFileNamed:@"explosion_small.caf" waitForCompletion:NO];
            SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.1],
                                                   [SKAction fadeInWithDuration:0.1]]];
            SKAction *blinkForTime = [SKAction repeatAction:blink count:4];
            [_boat runAction:[SKAction sequence:@[shipRammingSound, blinkForTime]]];
        }
        else
        {
            // Setup your scene here
//         SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"AppleSDGothicNeo-Bold "];
//            
//            gameOverLabel.text = @"GAME OVER";
//            gameOverLabel.fontSize = 40;
//            gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
            
            
            [_boat removeFromParent];
            [self explosion:_boat.position];
            [self removeAllActions];
           // [self addChild:gameOverLabel];
        }

  
    }
}

@end

