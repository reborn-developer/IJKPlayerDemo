//
//  broadListCell.h
//  LiveBroadCastDemo
//
//  Created by reborn on 16/10/28.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
@interface broadListCell : UITableViewCell

- (void)configCellWithData:(LiveListModel *)model;

@end
