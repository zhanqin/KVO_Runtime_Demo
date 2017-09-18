//
//  NSObject+ZZ_KVO.m
//  KVO_demo
//
//  Created by QQ on 2017/9/18.
//  Copyright © 2017年 QQ. All rights reserved.
//

#import "NSObject+ZZ_KVO.h"
#import <objc/message.h>

@implementation NSObject (ZZ_KVO)

-(void)ZZ_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    //动态添加一个类
    NSString * oldClassName = NSStringFromClass([self class]);
    NSString * newClassName = [@"ZZKVO_" stringByAppendingString:oldClassName];
    //OC转C
    const char * newName = [newClassName UTF8String];
    //定义一个类
    Class MyClass = objc_allocateClassPair([self class], newName, 0);
    //重写setAge方法
    class_addMethod(MyClass, @selector(setAge:), (IMP)setAge, "");
    //注册这个类
    objc_registerClassPair(MyClass);
    //改变isa指针,让self指向子类
    object_setClass(self, MyClass);
    //给对象绑定观察者对象
    objc_setAssociatedObject(self, @"observer", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/*
 有默认参数
void setAge(id self,SEL _cmd,int age){
    NSLog(@"哥们来啦~~~");
}
 */

//id self,SEL _cmd,默认参数
//子类重写父类的setAge方法，OC中一般都会先调用[super method],这样如果父类的setAge方法里对age值做过什么处理，子类里面也会做一样的处理，所以在这里，也需要先调用父类的setAge方法
void setAge(id self,SEL _cmd,int age){
    //子类自己
    id class = [self class];
    //父类
    id superClass = class_getSuperclass([self class]);
    //让自己指向父类
    object_setClass(self, superClass);
    //存放age改变之前的值
    NSMutableDictionary * changeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int oldOutCount = 0;
    //由于已经让self指向了自己的父类，所以在取属性的时候，可以直接用[self class]拿到age
    Ivar * oldivars = class_copyIvarList([self class], &oldOutCount);
    for (unsigned int i = 0; i < oldOutCount; i ++) {
        Ivar ivar = oldivars[i];
        const char * name = ivar_getName(ivar);
        NSString * nameString = [[NSString alloc] initWithUTF8String:name];
        if ([nameString isEqualToString:@"_age"]) {
            [changeDic setValue:[self valueForKey:nameString] forKey:[NSString stringWithFormat:@"old%@",nameString]];
        }
    }
    free(oldivars);
    //调用父类的setAge方法,类似于OC的[super setAge:age]
    //objc_getAssociatedObject(<#id object#>, <#const void *key#>)这个方法需要设置xcode的一个属性才能用，默认的无法提示出这个方法并且会报错
    objc_msgSend(self, @selector(setAge:),age);
    //让self指向自己
    object_setClass(self, class);
    NSLog(@"我是ZZKVO_Person的setAge");
    unsigned int newOutCount = 0;
    //已经让self指向了自己，所以如果还是直接用[self class]的话是拿不到age属性的，因为age是父类的，并且现在这个子类的属性列表为空，容易在取值的时候造成崩溃，所以用superClass
    Ivar * newivars = class_copyIvarList(superClass, &newOutCount);
    for (unsigned int i = 0; i < newOutCount; i ++) {
        Ivar ivar = newivars[i];
        const char * name = ivar_getName(ivar);
        NSString * nameString = [[NSString alloc] initWithUTF8String:name];
        if ([nameString isEqualToString:@"_age"]) {
            [changeDic setValue:[self valueForKey:nameString] forKey:[NSString stringWithFormat:@"new%@",nameString]];
        }
    }
    free(newivars);
    if ([[changeDic objectForKey:@"old_age"] intValue] != [[changeDic objectForKey:@"new_age"] intValue]) {
        //通知外界
        id observer = objc_getAssociatedObject(self, @"observer");
        [observer ZZ_observeValueForKeyPath:@"age" ofObject:self change:changeDic context:nil];
    }
    
}

-(void)ZZ_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
}


@end
