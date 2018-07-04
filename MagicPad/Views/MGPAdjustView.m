//
//  adjustView.m
//  MagicPad
//
//  Created by LAgagggggg on 2018/7/4.
//  Copyright © 2018 notme. All rights reserved.
//

#import "MGPAdjustView.h"
#import <Masonry.h>

@implementation MGPAdjustView

- (instancetype)initWithFrame:(CGRect)frame andSensitivityValue:(float)value
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor darkTextColor];
        UIBezierPath* leftRound = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:leftRound.CGPath];
        self.layer.mask=shape;
        UIButton * returnBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        [returnBtn addTarget:self action:@selector(finishAdjust) forControlEvents:UIControlEventTouchUpInside];
        [returnBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [self addSubview:returnBtn];
        [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.bottom.equalTo(self.mas_bottom).with.offset(-15);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.width.equalTo(@(50));
        }];
        UISlider * slider=[[UISlider alloc]init];
        [self addSubview:slider];
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(15);
            make.bottom.equalTo(self.mas_bottom).with.offset(-15);
            make.left.equalTo(returnBtn.mas_right).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-115);
        }];
        slider.maximumValue=3;
        slider.minimumValue=0.5;
        slider.value=value;
        slider.continuous=YES;
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.alpha=0;
    }
    return self;
}

-(void)show{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=0.3;
    }];
}

// slider变动时
- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.sensitivityChangeBlock(slider.value);
}

- (void)finishAdjust{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
