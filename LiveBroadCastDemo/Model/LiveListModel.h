//
//  LiveListModel.h
//  LiveBroadCastDemo
//
//  Created by reborn on 16/10/28.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "livePerson.h"
@interface LiveListModel : NSObject
@property (nonatomic, strong)NSString   *stream_addr;    //直播流地址
@property (nonatomic, strong)NSString   *city;           //所在城市
@property (nonatomic, assign)NSInteger  online_users;    //观看的人
@property (nonatomic, strong)livePerson *creator;        //主播
@end
