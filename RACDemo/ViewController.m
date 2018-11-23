//
//  ViewController.m
//  RACDemo
//
//  Created by lishuai on 2018/9/5.
//  Copyright © 2018年 lishuai. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *fetchCodeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSignal *enabledSignal = [self.textfield.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length == 11);
    }];
    RACSignal *(^counterSignal)(NSNumber *count) = ^RACSignal *(NSNumber *count) {
        RACSignal *countSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] scanWithStart:count reduce:^id _Nullable(NSNumber * _Nullable running, NSDate * _Nullable next) {
            return @(running.integerValue-1);
        }] takeUntilBlock:^BOOL(NSNumber *  _Nullable x) {
            return x.integerValue < 0;
        }];
        return [countSignal startWith:count];
    };
    RACCommand *command = [[RACCommand alloc] initWithEnabled:enabledSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return counterSignal(@10);
    }];
    
    [command execute:@10];
    RACSignal *timerSignal = [[command.executionSignals switchToLatest] map:^id _Nullable(id  _Nullable value) {
        return [value stringValue];
    }];
    RACSignal *signalString = [[command.executing filter:^BOOL(NSNumber * _Nullable value) {
        return ![value boolValue];
    }] mapReplace:@"获取验证码"];
    @weakify(self);
    [[RACSignal merge:@[timerSignal, signalString]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.fetchCodeBtn setTitle:x forState:UIControlStateNormal];
    }];
    
    self.fetchCodeBtn.rac_command = command;
}

@end
