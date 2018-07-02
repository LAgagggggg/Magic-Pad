//
//  MGPMultipeerConnectivityManager.h
//  MagicPad
//
//  Created by LAgagggggg on 2018/7/2.
//  Copyright © 2018 notme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MGPMultipeerConnectivityManager : NSObject <MCSessionDelegate>

@property (nonatomic,strong)MCAdvertiserAssistant * advertiser;
@property BOOL isConnected;

-(void)disconnect;

@end


