//
//  broadListCell.m
//  LiveBroadCastDemo
//
//  Created by reborn on 16/10/28.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "broadListCell.h"
#import "LiveListModel.h"
#import <UIImageView+WebCache.h>

#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kScreenHeight               [UIScreen mainScreen].bounds.size.height
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ALD(x)                      (x * kScreenWidth/375.0)

@interface broadListCell ()
{
    UILabel     *addressL;
    UILabel     *liveL;
    UIImageView *headImageView;
    UILabel     *nameL;
    UILabel     *lookerL;
    UIImageView *bigPicView;
}

@end

@implementation broadListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), ALD(50), ALD(50))];
        headImageView.layer.cornerRadius = 15;
        headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:headImageView];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x + headImageView.frame.size.width + ALD(5), headImageView.frame.origin.y, ALD(120), ALD(20))];
        [self.contentView addSubview:nameL];
        
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x + headImageView.frame.size.width + ALD(5), nameL.frame.origin.y + nameL.frame.size.height + ALD(5), ALD(100), ALD(20))];
        addressL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:addressL];
        
        
        lookerL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - ALD(120), ALD(10), ALD(120), ALD(20))];
        lookerL.font = [UIFont systemFontOfSize:12];
        lookerL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:lookerL];
        
        bigPicView = [[UIImageView alloc] initWithFrame:CGRectMake(0, headImageView.frame.origin.y + headImageView.frame.size.width + ALD(5), kScreenWidth, ALD(300))];
        bigPicView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:bigPicView];
        
    }
    return self;
}

- (void)configCellWithData:(LiveListModel *)model
{
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",model.creator.portrait]];

    [headImageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    if (model.city.length == 0) {
        addressL.text = @"难道在火星";
    } else {
        addressL.text = model.city;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.creator.nick];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,str.length)];
    nameL.attributedText = str;

    [bigPicView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    NSString *lookersCount = [NSString stringWithFormat:@"%zd人在看", model.online_users];
    NSRange range = [lookersCount rangeOfString:[NSString stringWithFormat:@"%zd", model.online_users]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:lookersCount];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:Color(216, 41, 116) range:range];
    lookerL.attributedText = attr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
