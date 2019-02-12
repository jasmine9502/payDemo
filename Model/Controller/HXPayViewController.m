//
//  HXPayViewController.m
//  HxSales
//
//  Created by 张玥 on 2018/12/24.
//  Copyright © 2018 wum. All rights reserved.
//

#import "HXPayViewController.h"
#import "PayUtils.h"
#import "UIView+TapGesture.h"
#import "UPPaymentControl.h"
#import "XMLDictionary.h"
#import "HXOfflineTransferViewController.h"
@interface HXPayViewController ()
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UIView *uppayView;
@property (weak, nonatomic) IBOutlet UIView *offlineTransferView;
@end

@implementation HXPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付方式";
    [self freshViewAndAddClickFunc];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"paySuccess" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)freshViewAndAddClickFunc {
    [self.wechatView addTapGestureRecognizerWithDelegate:self Block:^(UITapGestureRecognizer *tapRecognizer) {
        [PayUtils buy:PaymentMethodWechat];
    }];
    [self.alipayView addTapGestureRecognizerWithDelegate:self Block:^(UITapGestureRecognizer *tapRecognizer) {
        [PayUtils buy:PaymentMethodAlipay];
        [self paySuccess];
    }];
    [self.uppayView addTapGestureRecognizerWithDelegate:self Block:^(UITapGestureRecognizer *tapRecognizer) {
        BOOL ifResult = [[UPPaymentControl defaultControl] startPay:@"订单号" fromScheme:@"PayDemo" mode:@"00" viewController:self];
        if (ifResult) {
            NSLog(@"吊起银联成功");
        }else{
            NSLog(@"吊起银联失败");
        }
    }];
    [self.offlineTransferView addTapGestureRecognizerWithDelegate:self Block:^(UITapGestureRecognizer *tapRecognizer) {
        HXOfflineTransferViewController *vc = [[HXOfflineTransferViewController alloc]initWithNibName:@"HXOfflineTransferViewController" bundle:[NSBundle mainBundle]];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

- (void)paySuccess {
    [Util showHudTipStr:@"支付成功"];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
