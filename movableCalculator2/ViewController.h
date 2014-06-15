//
//  ViewController.h
//  movableCalculator2
//
//  Created by ucuc on 2014/02/23.
//  Copyright (c) 2014年 ucuc. All rights reserved.
//

/* to do list
 他のButtonの実装→デリートボタン, 1つ戻るボタン, オールクリアボタン, %ボタン
 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    // 全体のラベルデータの保持
    NSMutableArray *myLabelArray;
    // 配列の大きさは合成によって抜けたりするので配列数の管理は別の変数で行う必要がある
    int labelCount;
    // 現在電卓にセットされているラベル
    int nowLabel;
    // 現在電卓にセットされている数字
    double nowNumber;
    // 小数点モード 数字が増えるごとに足す数字の分母を増やす
    int periodFlag;
    // ドラッグ前の位置情報の保持
    CGPoint firstLocation;
    
    // 現在のモード（四則）
    // 0:+, 1:-, 2:*, 3:/
    int mode;
    
    BOOL makeLabelFlag;
    BOOL dragALabel;
    UIButton *dragedButton;
}

- (void)makeLabel;
- (int)searchNextInsertPoint;

- (void)deleteLabel:(int)draggingObject;
- (void)mergeLabel:(int)draggingObject :(int)secondObject;
- (void)mergeButtonAndLabel:(int)draggingButtonNumber :(int)secondObject;
- (BOOL)viewsDoCollide:(UIView *)draggingView1 :(UIView *)view2;
- (void) addNumber: (int)myNumber :(UIButton *)myButton;
+ (BOOL)isDigit:(NSString *)text;

@property (weak, nonatomic) IBOutlet UIButton *myButton0;
@property (weak, nonatomic) IBOutlet UIButton *myButton1;
@property (weak, nonatomic) IBOutlet UIButton *myButton2;
@property (weak, nonatomic) IBOutlet UIButton *myButton3;
@property (weak, nonatomic) IBOutlet UIButton *myButton4;
@property (weak, nonatomic) IBOutlet UIButton *myButton5;
@property (weak, nonatomic) IBOutlet UIButton *myButton6;
@property (weak, nonatomic) IBOutlet UIButton *myButton7;
@property (weak, nonatomic) IBOutlet UIButton *myButton8;
@property (weak, nonatomic) IBOutlet UIButton *myButton9;

- (IBAction)myButton0:(id)sender;
- (IBAction)myButton1:(id)sender;
- (IBAction)myButton2:(id)sender;
- (IBAction)myButton3:(id)sender;
- (IBAction)myButton4:(id)sender;
- (IBAction)myButton5:(id)sender;
- (IBAction)myButton6:(id)sender;
- (IBAction)myButton7:(id)sender;
- (IBAction)myButton8:(id)sender;
- (IBAction)myButton9:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *myPlusButton;
@property (weak, nonatomic) IBOutlet UIButton *myMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *myMultipleButton;
@property (weak, nonatomic) IBOutlet UIButton *myDivisionButton;

- (IBAction)myPlusButton:(id)sender;
- (IBAction)myMinusButton:(id)sender;
- (IBAction)myMultipleButton:(id)sender;
- (IBAction)myDivisionButton:(id)sender;

- (IBAction)myPeriodButton:(id)sender;
- (IBAction)myPlusMinusButton:(id)sender;

@end
