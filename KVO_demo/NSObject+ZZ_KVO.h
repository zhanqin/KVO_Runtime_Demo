//
//  NSObject+ZZ_KVO.h
//  KVO_demo
//
//  Created by QQ on 2017/9/18.
//  Copyright © 2017年 QQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZZ_KVO)

-(void)ZZ_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
