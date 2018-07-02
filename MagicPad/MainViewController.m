//
//  ViewController.m
//  MagicPad
//
//  Created by LAgagggggg on 2018/7/2.
//  Copyright © 2018 notme. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIView *unconnectedView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property BOOL isMenuPoped;
@property (strong, nonatomic) IBOutlet UIView *touchView;
@property (nonatomic) UIView * traceBall;
@property BOOL isConnected;
@property MGPMultipeerConnectivityManager * manager;
@end

@implementation MainViewController
float menuPopedY;
float menuUnpopedY;
float animationDuration=0.8;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager=[[MGPMultipeerConnectivityManager alloc]init];
    //设置弹出菜单
    self.isMenuPoped=NO;
    menuPopedY=[UIScreen mainScreen].bounds.size.height-self.menuView.frame.size.height;
    menuUnpopedY=[UIScreen mainScreen].bounds.size.height;
    CGRect frame=self.menuView.frame;
    frame.origin.y=menuUnpopedY;
    self.menuView.frame=frame;
    //触摸板
    self.traceBall=[[UIView alloc]initWithFrame:CGRectMake(200, 200, 50, 50)];
    self.traceBall.backgroundColor=[UIColor redColor];
    self.traceBall.alpha=0.3;
    self.traceBall.layer.cornerRadius=self.traceBall.frame.size.height/2;
    [self.touchView addSubview:self.traceBall];
    UIPanGestureRecognizer * pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate=self;
    [self.touchView addGestureRecognizer:pan];
}

-(void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint trans = [pan translationInView:pan.view];
    CGRect frame=self.traceBall.frame;
    frame.origin.x+=trans.x;
    frame.origin.y+=trans.y;
    self.traceBall.frame=frame;
    [pan setTranslation:CGPointZero inView:pan.view ];
}

//弹出菜单
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    menuPopedY=[UIScreen mainScreen].bounds.size.height-self.menuView.frame.size.height;
    menuUnpopedY=[UIScreen mainScreen].bounds.size.height;
    if (event.type == UIEventSubtypeMotionShake)
    {
        if(!self.isMenuPoped){
            self.isMenuPoped=YES;
            CGRect frame=self.menuView.frame;
            frame.origin.y=menuPopedY;
            [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.menuView.frame=frame;
            } completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isMenuPoped=NO;
                CGRect frame=self.menuView.frame;
                frame.origin.y=menuUnpopedY;
                [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.menuView.frame=frame;
                } completion:nil];
            });
        }
    }
}
- (IBAction)connect:(id)sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"未连接" message:@"请使用Mac端连接手机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * act=[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:act];
    [self showViewController:alert sender:nil];
}

//-(BOOL)canBecomeFirstResponder{
//    return YES;
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

@end
