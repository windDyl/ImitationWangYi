//
//  NewsViewController.m
//  ImitationWangYi
//
//  Created by Ethank on 2017/1/7.
//  Copyright © 2017年 DY. All rights reserved.
//

#import "NewsViewController.h"

#import "TopViewController.h"
#import "EntertainmentViewController.h"
#import "SportViewController.h"
#import "VideoViewController.h"
#import "CarViewController.h"
#import "ScienceViewController.h"
#import "FashionViewController.h"
#import "PhotoViewController.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

static CGFloat const titleLabelW = 70;
static CGFloat const ratio = 0.3;

@interface NewsViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong)UILabel *selectedLabel;

@property (nonatomic, strong)NSMutableArray *titleLabels;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子控制器
    [self setUpChildrenControllers];
    
    //子控制器标题
    [self setUpControllerTitle];
    
    //设置scrollView
    [self setUpScrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
//设置scrollView
- (void)setUpScrollView {
    NSUInteger count = self.childViewControllers.count;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.contentSize = CGSizeMake(titleLabelW * count, 0);
    
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.contentSize = CGSizeMake(kWidth * count, 0);
    self.contentScrollView.delegate = self;
}
//添加子控制器
- (void)setUpChildrenControllers {
    //头条
    TopViewController *topVc = [[TopViewController alloc] init];
    topVc.title = @"头条";
    [self addChildViewController:topVc];
    
    //娱乐
    EntertainmentViewController *entertainmentVC = [[EntertainmentViewController alloc] init];
    entertainmentVC.title = @"娱乐";
    [self addChildViewController:entertainmentVC];
    
    //体育
    SportViewController *sportVc = [[SportViewController alloc] init];
    sportVc.title = @"体育";
    [self addChildViewController:sportVc];
    
    //视频
    VideoViewController *videoVc = [[VideoViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    //汽车
    CarViewController *carVc = [[CarViewController alloc] init];
    carVc.title = @"汽车";
    [self addChildViewController:carVc];
    
    //科学
    ScienceViewController *scienceVc = [[ScienceViewController alloc] init];
    scienceVc.title = @"科学";
    [self addChildViewController:scienceVc];
    
    //时尚
    FashionViewController *fashionVc = [[FashionViewController alloc] init];
    fashionVc.title = @"时尚";
    [self addChildViewController:fashionVc];
    
    //图片
    PhotoViewController *photoVc = [[PhotoViewController alloc] init];
    photoVc.title = @"图片";
    [self addChildViewController:photoVc];

}

//子控制器标题
- (void)setUpControllerTitle {
    NSUInteger count = self.childViewControllers.count;
    for (int i = 0; i < count; i++) {
        UIViewController *vc = self.childViewControllers[i];
        UILabel *titleLabel = [[UILabel  alloc] initWithFrame:CGRectMake(titleLabelW * i, 0, titleLabelW, 44)];
        [self.titleScrollView addSubview:titleLabel];
        titleLabel.text = vc.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.highlightedTextColor = [UIColor redColor];
        titleLabel.userInteractionEnabled = YES;
        titleLabel.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleLabel:)];
        [titleLabel addGestureRecognizer:tap];
        [self.titleLabels addObject:titleLabel];
        if (i == 0) {
            [self clickTitleLabel:tap];
        }
    }
}
//title点击
- (void)clickTitleLabel:(UITapGestureRecognizer *)tap {
    UILabel *selectedLabel = (UILabel *)tap.view;
    //处理title字体颜色
    [self setClickLabel:selectedLabel];
    //设置title居中
    [self setTitleLabelCenterWith:selectedLabel];
    //滚动到当前子控制器的位置
    NSInteger index = selectedLabel.tag;
    CGFloat offsetX = index * kWidth;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    //展示子控制器
    [self showCurrentChildrenControllerWithIndex:index];
}
//处理title字体颜色
- (void)setClickLabel:(UILabel *)label {
    _selectedLabel.highlighted = NO;
    _selectedLabel.transform = CGAffineTransformIdentity;
    _selectedLabel.textColor = [UIColor blackColor];
    label.highlighted = YES;
    label.transform = CGAffineTransformMakeScale(ratio + 1, ratio + 1);
    _selectedLabel = label;
}
//展示子控制器
- (void)showCurrentChildrenControllerWithIndex:(NSInteger)index {
    UIViewController *showVC = self.childViewControllers[index];
    if (showVC.isViewLoaded) return;
    CGFloat offsetX = index * kWidth;
    showVC.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:showVC.view];
}

//设置title居中
- (void)setTitleLabelCenterWith:(UILabel *)label {
    CGFloat offsetX = label.center.x - kWidth * 0.5;
    if (offsetX < 0) offsetX = 0;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - kWidth;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    UILabel *selectedLabel = self.titleLabels[index];
    //展示子控制器
    [self showCurrentChildrenControllerWithIndex:index];
    //设置title居中
    [self setTitleLabelCenterWith:selectedLabel];
    //处理title字体颜色
    [self setClickLabel:selectedLabel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSInteger leftIndex = currentPage;
    NSInteger rightIndex = leftIndex + 1;
    UILabel *leftLabel = self.titleLabels[leftIndex];
    UILabel *rightLabel = nil;
    if (rightIndex < self.titleLabels.count - 1) {
        rightLabel = self.titleLabels[rightIndex];
    }
    CGFloat rightScale = currentPage - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    if (currentPage < 0 || rightIndex >= self.titleLabels.count) return;
    //设置字体形变
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * ratio + 1, leftScale * ratio + 1);
    rightLabel.transform = CGAffineTransformMakeScale(rightScale * ratio + 1, rightScale * ratio + 1);
    leftLabel.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    rightLabel.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1.0];
}

@end
