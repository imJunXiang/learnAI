//
//  ViewController.m
//  AI_001
//
//  Created by leying on 2017/10/24.
//  Copyright © 2017年 junxiang. All rights reserved.
//

#import "ViewController.h"

#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)

typedef enum : NSUInteger {
    MOVETYPE_UP,
    MOVETYPE_DOWN,
    MOVETYPE_LEFT,
    MOVETYPE_RIGHT,
} MOVETYPE;
@interface ViewController ()
@property (nonatomic ,retain) UIView    *gridView;
@property (nonatomic ,retain) NSArray   *startArr;
@property (nonatomic ,retain) NSArray   *endArr;
// 空的label , tag 代表位置，拿到该lable取tag,即可拿到位置
@property (nonatomic ,retain) UILabel   *zeroLable;
@property (nonatomic ,assign) CGPoint   zeroEndLocation;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _startArr = @[@(13),@(8),@(7),@(2),@(5),@(14),@(3),@(0),@(6),@(12),@(11),@(1),@(9),@(4),@(15),@(10)];
    
    // 最终文案和这个相同 就停止
    _endArr = @[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10),@(11),@(12),@(13),@(14),@(15),@(0)];
    
    _zeroEndLocation = CGPointMake(3, 3);
    [self createAllView];
    
}

// 移动函数，上下左右移动
- (void)moveWithMoveType:(MOVETYPE)move_type {
    
    NSInteger locationTag = _zeroLable.tag;
    NSInteger row = locationTag / 4;
    NSInteger col = locationTag % 4;
    
    NSInteger moveTag;
    switch (move_type) {
        case MOVETYPE_UP: {
            if (row <=0) {
                // 不能上
                return;
            }
            // 可以上移，进行上移操作(就是交换tag和frame)
            moveTag = (row - 1) * 4 + col;
        }
            break;
        case MOVETYPE_DOWN: {
            if (row >=3) {
                // 不能下
                return;
            }
            // 可以下移，进行下移操作(就是交换tag和frame)
            moveTag = (row + 1) * 4 + col;
        }
            break;
        case MOVETYPE_LEFT: {
            if (col <= 0) {
                // 不能左
                return;
            }
            // 可以左移，进行左移操作(就是交换tag和frame)
            moveTag = row * 4 + (col - 1);
        }
            break;
        case MOVETYPE_RIGHT: {
            if (col >= 3) {
                // 不能右
                return;
            }
            // 可以右移，进行右移操作(就是交换tag和frame)
            moveTag = row * 4 + (col + 1);
        }
            break;
            
        default: {
            
        }
            break;
    }
    
    for (UILabel *lable in _gridView.subviews) {
        if (lable.tag == moveTag) {
            // 找到了交换的，进行交换
            CGRect frame = _zeroLable.frame;
            NSInteger zeroTag = _zeroLable.tag;
            
            _zeroLable.tag = lable.tag;
            lable.tag = zeroTag;
            [UIView animateWithDuration:0.3 animations:^{
                _zeroLable.frame = lable.frame;
                lable.frame = frame;
            }];
            
            break;
        }
    }
}

- (NSInteger)backAfterMoveDistanceWithMoveType:(MOVETYPE)move_type {
    // 返回移动后的距离
    NSInteger locationTag = _zeroLable.tag;
    NSInteger row = locationTag / 4;
    NSInteger col = locationTag % 4;
    
    CGPoint beginPoint = CGPointMake(row, col);
    CGPoint endPoint;
    CGPoint moveCourentPoint;
    NSInteger moveZeroTag;
    switch (move_type) {
        case MOVETYPE_UP: {
            if (row <=0) {
                // 不能上
                return 100000;
            }
            moveZeroTag = _zeroLable.tag - 4;
            endPoint = CGPointMake(row-1, col);
        }
            break;
        case MOVETYPE_DOWN: {
            if (row >=3) {
                // 不能下
                return 100000;
            }
            moveZeroTag = _zeroLable.tag + 4;
            endPoint = CGPointMake(row+1, col);
        }
            break;
        case MOVETYPE_LEFT: {
            if (col <= 0) {
                // 不能左
                return 100000;
            }
            moveZeroTag = _zeroLable.tag - 1;
            endPoint = CGPointMake(row, col-1);
        }
            break;
        case MOVETYPE_RIGHT: {
            if (col >= 3) {
                // 不能右
                return 100000;
            }
            moveZeroTag = _zeroLable.tag + 1;
            endPoint = CGPointMake(row, col+1);
        }
            break;
            
        default: {
            
        }
            break;
    }
    
    // 获取到交互后的tag了，现在还没有换
    for (UILabel *lable in _gridView.subviews) {
        if (lable.tag == moveZeroTag) {
            // 找到了交换label,获取text,判断目标位置
            for (int i = 0 ; i < 16 ; i++) {
                NSNumber *num = _endArr[i];
                if ([lable.text intValue] == [num intValue]) {
                    // 拿到交互模块的位置
                    moveCourentPoint = CGPointMake(i / 4, i % 4);
                    break;
                }
            }
            
            break;
        }
    }
    
    // 四个位置都有了，计算变化之后
    NSInteger zeroChange = fabs((endPoint.x - _zeroEndLocation.x)) + fabs((endPoint.y - _zeroEndLocation.y));
    NSInteger moveChange = fabs((beginPoint.x - moveCourentPoint.x)) + fabs((beginPoint.y - moveCourentPoint.y));
    
    return zeroChange + moveChange;
}

// 计算移动的点距目标的距离
- (void)loopMove {
    // 上下左右各移动一次，取最优
    NSInteger count = 10000;
    int moveS = 0;
    for (int i = 0; i < 4; i ++) {
        if (count > [self backAfterMoveDistanceWithMoveType:i]) {
            moveS = i;
            count = [self backAfterMoveDistanceWithMoveType:i];
        }
    }
    
    // 选出最优，进行移动
    NSLog(@"%ld",count);
    [self moveWithMoveType:moveS];
}

// 创建 初始化控件
- (void)createAllView {
    _gridView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, SCREENWIDTH - 20)];
    _gridView.center = CGPointMake(SCREENWIDTH *0.5, SCREENHEIGHT *0.5);
    
    _gridView.backgroundColor = [UIColor yellowColor];
    // 添加子View
    CGFloat gap = 5;
    CGFloat lableX = 0;
    CGFloat lableY = 0;
    CGFloat lableW = (SCREENWIDTH - 20 - gap*3) * 0.25;
    CGFloat lableH = lableW;
    
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 4; j ++) {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(lableX+i%4*(lableW+gap), lableY+j%4*(lableH+gap), lableW, lableH)];
            // 赋值 tag ,可通过tag 计算位置
            lable.tag = j * 4 + i;
            lable.textAlignment = NSTextAlignmentCenter;
            if ([_startArr[j * 4 + i] integerValue] == 0) {
                _zeroLable = lable;
                lable.text = @"空";
                lable.backgroundColor = [UIColor yellowColor];
            } else {
                lable.text = [NSString stringWithFormat:@"%d",[_startArr[j * 4 + i] intValue]];
                lable.backgroundColor = [UIColor greenColor];
            }
            
            [_gridView addSubview:lable];
        }
    }
    
    [self.view addSubview:_gridView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    // 在这里写移动方法
    
    [self loopMove];
}
@end
