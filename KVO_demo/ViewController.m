//
//  ViewController.m
//  KVO_demo
//
//  Created by QQ on 2017/9/18.
//  Copyright © 2017年 QQ. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+ZZ_KVO.h"
#import "Person.h"

@interface ViewController ()

@property(nonatomic,strong) Person * p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _p = [[Person alloc] init];
    [_p ZZ_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)ZZ_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"change == %@",change);
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _p.age = 200;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
