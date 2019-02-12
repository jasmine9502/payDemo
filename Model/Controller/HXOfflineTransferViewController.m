//
//  HXOfflineTransferViewController.m
//  HxSales
//
//  Created by 张玥 on 2018/12/24.
//  Copyright © 2018 wum. All rights reserved.
//

#import "HXOfflineTransferViewController.h"
@interface HXOfflineTransferViewController () {
    BOOL isShowCertificate;
}
@property (weak, nonatomic) IBOutlet UIView *certificationView;
@property (weak, nonatomic) IBOutlet UITextField *receiverTextfield;

@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@end

@implementation HXOfflineTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isShowCertificate = NO;
    self.certificationView.hidden = YES;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmInfoAction:(id)sender {
    if([self.receiverTextfield.text isEqualToString:@""]) {
        [Util  showHudTipStr:@"请输入收款人信息"];
    } else {
        if ([self.bankTextField.text isEqualToString:@""]) {
            [Util  showHudTipStr:@"请输入收款银行信息"];
        } else {
            if ([self.accountTextField.text isEqualToString:@""]) {
                [Util  showHudTipStr:@"请输入收款账户信息"];
            } else {
                [self.accountTextField resignFirstResponder];
                self.certificationView.hidden = NO;
            }
        }
    }
}

- (IBAction)verifyAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)upLoadCertification:(id)sender {
    //点击选取图片
}

@end
