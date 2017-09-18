//
//  Person.m
//  KVO_demo
//
//  Created by QQ on 2017/9/18.
//  Copyright © 2017年 QQ. All rights reserved.
//

#import "Person.h"

@implementation Person

-(void)setAge:(int)age{
    NSLog(@"我是Person的setAge");
    //自定义操作
    age = 10 + age;
    _age = age;
}

@end
