//
//  ZLProgressView.h
//  ZLProgressViewDemo
//
//  Created by kevin on 2019/3/18.
//  Copyright © 2019 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 正弦曲线公式可表示为y=Asin(ωx+φ)+k：
 A，振幅，最高和最低的距离
 W，角速度，用于控制周期大小，单位x中的起伏个数
 K，偏距，曲线整体上下偏移量
 φ，初相，左右移动的值
 
 这个效果主要的思路是添加两条曲线 一条正玄曲线、一条余弦曲线 然后在曲线下添加深浅不同的背景颜色，从而达到波浪显示的效果
 */

NS_ASSUME_NONNULL_BEGIN

@interface ZLProgressView : UIView

/**
 * 设置进度 0～1
 */
@property (nonatomic, assign) CGFloat progress;

@end

NS_ASSUME_NONNULL_END
