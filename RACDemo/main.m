//
//  main.m
//  RACDemo
//
//  Created by lishuai on 2018/9/5.
//  Copyright © 2018年 lishuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/*
 {1, 2, 3, 4, 5, 234} 6
 {1, 2, 3, 4, 5, 234} 5
 {1, 2, 3, 4, 5, 234} 4
 {1, 2, 3, 4, 5, 234} 3
 {1, 2, 3, 4, 5, 234} 2
 {1, 2, 3, 4, 5, 234} 1   return 1
 
 ? = max(array, 6);
 ? = max(array, 5);
 ? = max(array, 4);
 ? = max(array, 3);
 ? = max(array, 2);
 1 = max(array, 1);
 */

int max(int *array, int count) {
    
    if (count == 1) return array[0];

    int headMax = max(array, count - 1);
    
    return headMax > array[count-1] ? headMax : array[count - 1];
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        int a[] = {1, 2, 3, 4, 5, 234};
        
        int m = max(a, sizeof(a)/sizeof(int));
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
