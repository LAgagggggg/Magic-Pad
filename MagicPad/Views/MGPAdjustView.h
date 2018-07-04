//
//  adjustView.h
//  MagicPad
//
//  Created by LAgagggggg on 2018/7/4.
//  Copyright © 2018 notme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGPAdjustView : UIView

@property (nonatomic,strong) void (^sensitivityChangeBlock)(float value);
- (instancetype)initWithFrame:(CGRect)frame andSensitivityValue:(float)value;
-(void)show;

@end
