//
//  AppDelegate.m
//  RACDemo
//
//  Created by lishuai on 2018/9/5.
//  Copyright © 2018年 lishuai. All rights reserved.
//

#import "AppDelegate.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (Extend)
- (RACSignal *)ls_map:(id(^)(id value))block;
@end
@implementation RACSignal (Extend)
- (RACSignal *)ls_map:(id(^)(id value))block {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:block(x)];
        } error:^(NSError * _Nullable error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
@end

@interface AppDelegate ()

@end

@implementation AppDelegate

void signalTransform() {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull s) {
        [s sendNext:@1];
        [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
            [s sendCompleted];
        }];
        return nil;
    }];
    RACSignal *signal2 = [signal ls_map:^id(id value) {
        return @([value integerValue] * 2);
    }];
    [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
        [signal2 subscribeNext:^(id  _Nullable x) {
            NSLog(@"signal2 next: %@", x);
        } error:^(NSError * _Nullable error) {
            NSLog(@"signal2 error: %@", error);
        } completed:^{
            NSLog(@"signal2 completed");
        }];
    }];
}

void signalDispose() {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
            [subscriber sendNext:@2];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposed");
        }];
    }];
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal next: %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"signal error: %@", error);
    } completed:^{
        NSLog(@"signal completed");
    }];
    [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
        [disposable dispose];
    }];
    
}

void signalScheduler() {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
            [subscriber sendNext:@1];
            [subscriber sendNext:@2];
        }];
        
        [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal next: %@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"signal error: %@", error);
    } completed:^{
        NSLog(@"signal completed");
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    signalTransform();
//    signalDispose();
    signalScheduler();
    
    return YES;
}

@end
