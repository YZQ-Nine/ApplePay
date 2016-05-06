//
//  ViewController.m
//  ApplePayTest
//
//  Created by Apple on 16/4/26.
//  Copyright © 2016年 YZQ. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <PassKit/PassKit.h>
@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"支付" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(100, 100, 100, 100)];
    [btn addTarget:self action:@selector(payment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)payment:(UIButton *)sender{

    //1创建订单请求的对象
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    //2.创建商品订单信息对象
    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"鞋" amount:[NSDecimalNumber decimalNumberWithString:@"100"]];
    
    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"库" amount:[NSDecimalNumber decimalNumberWithString:@"200"]];
    
    PKPaymentSummaryItem *item3 = [PKPaymentSummaryItem summaryItemWithLabel:@"衣" amount:[NSDecimalNumber decimalNumberWithString:@"300"]];
    
    PKPaymentSummaryItem *item4 = [PKPaymentSummaryItem summaryItemWithLabel:@"袜" amount:[NSDecimalNumber decimalNumberWithString:@"400"]];
    
    request.paymentSummaryItems = @[item1, item2, item3, item4];
    
    //2.1指定的国家地区编码
    request.countryCode = @"CN";
    
    //2.2指定国家货币种类
    request.currencyCode = @"CNY";
    
    //2.3支持的网上银行支付的方式
    request.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard];
    
    //2.4指定App所需的商业ID
    request.merchantIdentifier = @"wetetew.com.sdf.apple.pay";//注意格式
    
    //2.5指定订单接收的地址在哪里
    request.requiredBillingAddressFields = PKAddressFieldEmail|PKAddressFieldPostalAddress;
    
    //2.6指定支付范围
    request.merchantCapabilities = PKMerchantCapabilityEMV;
    
    //3.创建支付界面显示对象
    PKPaymentAuthorizationViewController *pvc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    
    pvc.delegate = self;
    
    if (!pvc) {
        
        NSLog(@"支付界面创建失败,请检查");
        
    } else {
        
        [self presentViewController:pvc animated:YES completion:nil];
    
    }
    
}
//在支付过程中需要调用这个方法,这个方法直接影响支付结果在支付界面的显示
//payment代表支付对象,有关于支付的所有信息都在这个对象中,1.token(订单信息) ; 2.address
//completion 是一个block回调块,传递的参数直接影响界面结果的显示

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion{
    //1.取到token
    PKPaymentToken *token = payment.token;
    
    //2.获取订单地址
    NSString *address = payment.billingContact.postalAddress.city;
    
    //2.1获取到token和address之后,发送到自己的服务器上,有自己的服务器与银行商家进行接口调用和支付,将结果返回到这里.
    //2.2我们根据结果生成对应状态的对象,根据对像显示不同的支付结构
    
    //3.创建状态对象
    PKPaymentAuthorizationStatus status = PKPaymentAuthorizationStatusFailure;
    completion(status);
    

}

//支付完成时进行调用

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{

    [controller dismissViewControllerAnimated:YES completion:nil];
}



@end
