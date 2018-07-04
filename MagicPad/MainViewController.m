//
//  ViewController.m
//  MagicPad
//
//  Created by LAgagggggg on 2018/7/2.
//  Copyright © 2018 notme. All rights reserved.
//

#import "MainViewController.h"
#import "MGPMultipeerConnectivityManager.h"
#import "MGPAdjustView.h"

struct dataStruct{
    CGPoint trans;
    BOOL click;
};

@interface MainViewController ()
@property MGPMultipeerConnectivityManager * manager;
@property (strong, nonatomic) IBOutlet UIView *unconnectedView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *touchView;
@property BOOL isMenuPoped;
@property BOOL isConnected;
@property float trackPadSensitivity;
@end

@implementation MainViewController
float menuPopedX;
float menuUnpopedX;
float animationDuration=0.8;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readDefault];
    [self creatUI];
    //连接
    self.manager=[[MGPMultipeerConnectivityManager alloc]init];
    self.isConnected=NO;
    [self addObserver:self forKeyPath:@"manager.isConnected" options:NSKeyValueObservingOptionNew context:nil];
    //设置弹出菜单
    self.isMenuPoped=NO;
    //触摸板
    UIPanGestureRecognizer * pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate=self;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tap.delegate=self;
    [self.touchView addGestureRecognizer:pan];
    [self.touchView addGestureRecognizer:tap];
}

-(void)creatUI{
    menuPopedX=[UIScreen mainScreen].bounds.size.width-self.menuView.frame.size.width+100;
    menuUnpopedX=[UIScreen mainScreen].bounds.size.width;
    UIBezierPath* leftRound = [UIBezierPath bezierPathWithRoundedRect:self.menuView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:leftRound.CGPath];
    self.menuView.layer.mask=shape;
}

//手势
-(void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint trans = [pan translationInView:pan.view];
    trans.x*=self.trackPadSensitivity;
    trans.y*=self.trackPadSensitivity;
    struct dataStruct dataS={trans,NO};
    NSData * data=[NSData dataWithBytes:&dataS length:sizeof(dataS)];
    [self.manager sendData:data];
    [pan setTranslation:CGPointZero inView:pan.view ];
}

-(void)tap{
    struct dataStruct dataS={CGPointMake(0, 0),YES};
    NSData * data=[NSData dataWithBytes:&dataS length:sizeof(dataS)];
    [self.manager sendData:data];
}

//读取用户设置
-(void)readDefault{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.trackPadSensitivity=[defaults floatForKey:@"trackPadSensitivity"];
    if (self.trackPadSensitivity==0) self.trackPadSensitivity=1;
}

//连接状态变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"manager.isConnected"]&&object==self) {
        self.isConnected=self.manager.isConnected;
        [self performSelectorOnMainThread:@selector(connectHint) withObject:nil waitUntilDone:NO];
    }
}

-(void)connectHint{
    if (self.isConnected) {
        self.unconnectedView.hidden=YES;
    }
    else{
        self.unconnectedView.hidden=NO;
    }
}

- (IBAction)connect:(id)sender {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"未连接" message:@"请使用Mac端连接手机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * act=[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:act];
    [self showViewController:alert sender:nil];
}

//弹出菜单
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
    {
        if(!self.isMenuPoped){
            [self popMenu];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self putbackMenu];
            });
        }
    }
}

-(void)popMenu{
    menuPopedX=[UIScreen mainScreen].bounds.size.width-self.menuView.frame.size.width+100;
    menuUnpopedX=[UIScreen mainScreen].bounds.size.width;
    self.isMenuPoped=YES;
    CGRect frame=self.menuView.frame;
    frame.origin.x=menuPopedX;
    self.menuView.hidden=NO;
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.menuView.frame=frame;
    } completion:nil];
}

-(void)putbackMenu{
    menuPopedX=[UIScreen mainScreen].bounds.size.width-self.menuView.frame.size.width+100;
    menuUnpopedX=[UIScreen mainScreen].bounds.size.width;
    self.isMenuPoped=NO;
    CGRect frame=self.menuView.frame;
    frame.origin.x=menuUnpopedX;
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.menuView.frame=frame;
    } completion:^(BOOL finished) {
        self.menuView.hidden=YES;
        if (self.menuView.alpha!=0.3) {
            self.menuView.alpha=0.3;
        }
    }];
}
//点击菜单中的按钮
- (IBAction)disconnect:(id)sender {
    [self.manager disconnect];
}

- (IBAction)popAdjustView:(id)sender {
    MGPAdjustView * adjustView = [[MGPAdjustView alloc]initWithFrame:self.menuView.frame andSensitivityValue:self.trackPadSensitivity];
    [self.view addSubview:adjustView];
    adjustView.sensitivityChangeBlock = ^(float value) {
        self.trackPadSensitivity=value;
        [[NSUserDefaults standardUserDefaults] setFloat:value forKey:@"trackPadSensitivity"];
    };
    [adjustView show];
    [UIView animateWithDuration:animationDuration animations:^{
        self.menuView.alpha=0;
    } completion:^(BOOL finished) {
        [self putbackMenu];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
