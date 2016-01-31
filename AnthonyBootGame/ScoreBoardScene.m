//
//  ScoreBoardScene.m
//  AnthonyBootGame
//
//  Created by Matthias Vermeulen on 30/01/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "ScoreBoardScene.h"
#import "GameScene.h"

@implementation ScoreBoardScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
//        SKTexture* groundTexture = [SKTexture textureWithImageNamed:@"gameoverscreen"];
//        groundTexture.filteringMode = SKTextureFilteringLinear;
//        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:groundTexture];
//        background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
//        [self addChild:background];
        
        SKAction *gameOver= [SKAction playSoundFileNamed:@"gameover.caf" waitForCompletion:NO];
        SKNode *gameOverSound = [[SKNode alloc]init];
        [gameOverSound runAction:gameOver];
        [self addChild:gameOverSound];
        
        self.backgroundColor = [SKColor blackColor];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"GAME OVER";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 60;
        label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:label];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        int scoreVar = [prefs integerForKey:@"score"];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        scoreLabel.text = [NSString stringWithFormat:@"SCORE: %i", scoreVar];
        scoreLabel.fontColor = [SKColor whiteColor];
        scoreLabel.fontSize = 60;
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+200);
        [self addChild:scoreLabel];
        
        
        
        SKLabelNode *restart = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        restart.text = @"Tap to play again";
        restart.fontColor = [SKColor whiteColor];
        restart.fontSize = 30;
        restart.position = CGPointMake(size.width/2, -50);
        
        SKAction *moveLabel = [SKAction moveToY:(size.height/2 - 40) duration:2.0];
        [restart runAction:moveLabel];
        [self addChild:restart];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    GameScene *mainScene = [GameScene sceneWithSize:self.size];
    [self.view presentScene:mainScene transition:[SKTransition crossFadeWithDuration:1.5 ]];
    
}

@end
