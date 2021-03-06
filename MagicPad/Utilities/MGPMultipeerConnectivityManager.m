//
//  MGPMultipeerConnectivityManager.m
//  MagicPad
//
//  Created by LAgagggggg on 2018/7/2.
//  Copyright © 2018 notme. All rights reserved.
//

#import "MGPMultipeerConnectivityManager.h"

@interface MGPMultipeerConnectivityManager()

@property (nonatomic,strong) MCPeerID * peerID;
@property (nonatomic,strong) MCSession * session;
@property (nonatomic,strong) MCSession * sessionTo;
@property (nonatomic,strong) NSOutputStream * stream;
@property BOOL isStreaming;
@end

@implementation MGPMultipeerConnectivityManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        //获取设备名称
        self.isConnected=NO;
        self.isStreaming=NO;
        NSString * name = [UIDevice currentDevice].name;
        //用户
        _peerID = [[MCPeerID alloc]initWithDisplayName:name];
        //为用户建立连接
        _session = [[MCSession alloc]initWithPeer:_peerID];
        //设置代理
        _session.delegate = self;
        //设置广播服务(发送方)
        _advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:@"type" discoveryInfo:nil session:_session];
        [_advertiser start];
    }
    return self;
}

#pragma mark MCSession代理方法
/**
 *  当检测到连接状态发生改变后进行存储
 *
 *  @param session MC流
 *  @param peerID  用户
 *  @param state   连接状态
 */
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnected) {
        //保存这个连接
        self.isConnected=YES;
        self.sessionTo=session;
        [self.advertiser stop];
    }
    else{
        self.isConnected=NO;
        [self.advertiser start];
    }
}

- (void)sendData:(NSData *)data{
    if (self.isConnected) {
        [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
//        if(_stream==nil||!self.isStreaming){
//            self.stream=[self.session startStreamWithName:@"remoteControlStream" toPeer:self.session.connectedPeers[0] error:nil];
//            self.stream.delegate=self;
//            [self.stream scheduleInRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];
//            [self.stream open];
//            self.isStreaming=YES;
//        }
//        [self.stream write:data.bytes maxLength:data.length];
    }
}

- (void)disconnect{
    [self.sessionTo disconnect];
    self.isConnected=NO;
    [self.advertiser start];
//    [self.stream close];
}
/**
 *  接收到消息
 *
 *  @param session MC流
 *  @param data    传入的二进制数据
 *  @param peerID  用户
 */
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
}
/**
 *  接收数据流
 *
 *  @param session    MC流
 *  @param stream     数据流
 *  @param streamName 数据流名称（标示）
 *  @param peerID     用户
 */
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}
/**
 *  开始接收资源
 */
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}
/**
 *  资源接收结束
 */
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

- (void)browserViewControllerDidFinish:(nonnull MCBrowserViewController *)browserViewController { 
    
}

- (void)browserViewControllerWasCancelled:(nonnull MCBrowserViewController *)browserViewController { 
    
}

- (void)browser:(nonnull MCNearbyServiceBrowser *)browser foundPeer:(nonnull MCPeerID *)peerID withDiscoveryInfo:(nullable NSDictionary<NSString *,NSString *> *)info { 
    
}

- (void)browser:(nonnull MCNearbyServiceBrowser *)browser lostPeer:(nonnull MCPeerID *)peerID { 
    
}

@end
