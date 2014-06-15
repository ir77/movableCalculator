//
//  ViewController.m
//  movableCalculator2
//
//  Created by ucuc on 2014/02/23.
//  Copyright (c) 2014年 ucuc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

int label_origin_x = 150;
int label_origin_y = 190;
int label_size_x   = 150;
int label_size_y   = 50;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 初期化
    myLabelArray  = [NSMutableArray array];
    labelCount    = 1;
    makeLabelFlag = NO;
    dragALabel    = NO;
    dragedButton  = nil;
    
    mode          = 0;
    //[self.myPlusButton setBackgroundColor:[UIColor blackColor]];
    // 画像を指定したボタン例文
    UIImage *img = [UIImage imageNamed:@"plus2.png"];  // ボタンにする画像を生成する
    [self.myPlusButton setImage:img forState:UIControlStateNormal];
    [self.myPlusButton setUserInteractionEnabled:false];
    
    [myLabelArray addObject:[NSNull null]];
    
    // ラベル生成
    [self makeLabel];
    
    [self.myButton0 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton1 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton2 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton3 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton4 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton5 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton6 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton7 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton8 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.myButton9 addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    //ボタンの影を消すならそのうち使う
    self.myButton1.tag = -1;
    self.myButton2.tag = -2;
    self.myButton3.tag = -3;
    self.myButton4.tag = -4;
    self.myButton5.tag = -5;
    self.myButton6.tag = -6;
    self.myButton7.tag = -7;
    self.myButton8.tag = -8;
    self.myButton9.tag = -9;
    self.myButton0.tag = -10;
}

// --------------------------- ラベルの動的な生成 ---------------------------
#pragma mark - making dynamic label
-(void)makeLabel
{
    
    UILabel* label = [[UILabel alloc] initWithFrame
                      :CGRectMake(label_origin_x, label_origin_y, label_size_x, label_size_y)];
    label.userInteractionEnabled = true;
    //[[label layer] setBackgroundColor:
     //[[UIColor colorWithRed:102/255 green:255/255 blue:255/255 alpha:0.8] CGColor]];
    [[label layer] setBackgroundColor:
    [[UIColor colorWithRed:204/255 green:204/255 blue:204/255 alpha:0.1] CGColor]];

    [[label layer] setCornerRadius:12.0]; //丸角具合

    label.text = @"0";
    label.font = [UIFont systemFontOfSize:50];
    nowNumber = 0;
    
    // --- start テキストの内容によりラベルの大きさを変える ---
    [label sizeToFit];
    label.minimumScaleFactor = 5.0f;
    
    
    // 配列がすべて詰まっているなら最後にラベルを追加
    if (labelCount == [myLabelArray count]) {
        label.tag = labelCount;
        nowLabel = labelCount;

        [myLabelArray addObject:label];
        [self.view addSubview:myLabelArray[labelCount]];
    
    // 配列に空きがあるなら間にラベルを追加
    } else {
        nowLabel = [self searchNextInsertPoint];
        label.tag = nowLabel;

        myLabelArray[nowLabel] = label;
        [self.view addSubview:myLabelArray[nowLabel]];
    }
    labelCount++;
}

-(int)searchNextInsertPoint
{
    for (int i=1; i<[myLabelArray count]; i++) {
        if ([myLabelArray[i] isEqual:[NSNull null]]) {
            return i;
        }
    }
    NSLog(@"Search Next Insert Point Error!");
    return -1;
}

// ---------------------------ドラッグ関係のメソッド------------------------------------
#pragma mark - drag
//ボタンのドラッグ
-(void)onTouchDragInside:(UIButton*)btn withEvent:(UIEvent*)event
{
    UITouch *touch=[[event touchesForView:btn] anyObject];
    CGPoint prevPos=[touch previousLocationInView:btn];
    CGPoint pos=[touch locationInView:btn];
    float dX=pos.x-prevPos.x;
    float dY=pos.y-prevPos.y;
    btn.center=CGPointMake(btn.center.x+dX,btn.center.y+dY);
    dragedButton = btn;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    // スタート地点からのドラッグ
    if ([[touch view] tag] != 0) {
        UILabel *label = [myLabelArray objectAtIndex:[[touch view] tag]];
        firstLocation = label.center;

        dragALabel = YES;
        if ([[touch view] tag] == nowLabel) {
            // ここがスタート地点ならドラッグ終了時にmakelabelする
            makeLabelFlag = YES;
        }
    } else {
        dragALabel = NO;
        makeLabelFlag = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    //NSLog(@"location.x => %f", location.x);
    //NSLog(@"location.y => %f", location.y);
    
    if (dragALabel) {
        UILabel *label = [myLabelArray objectAtIndex:[[touch view] tag]];
        label.center = location;
        [[touch view] setCenter:location];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self.view];

    if (dragALabel) {
        // locationが〜以下ならLabelを削除する
        if (location.y > 250) {
            [self deleteLabel:(int)[[touch view] tag]];
        } else if (location.y >200 && firstLocation.y > 200) {
            UILabel *label = [myLabelArray objectAtIndex:[[touch view] tag]];
            label.center = firstLocation;
            makeLabelFlag = NO;
        } else {
            for (int i=1; i<[myLabelArray count]; i++) {
                // 配列の空き部分なら飛ばす && 自身なら飛ばす
                if (![myLabelArray[i] isEqual:[NSNull null]] && [[touch view] tag] != i) {
                    // 現在ドラッグ中のラベルと残りのラベルとの衝突判定
                    if ([self viewsDoCollide:myLabelArray[[[touch view] tag]] :myLabelArray[i]]) {
                        [self mergeLabel:(int)[[touch view] tag] :i];
                        break;
                    }
                }
            }
        }
        
        if (makeLabelFlag) {
            [self makeLabel];
            
            makeLabelFlag = NO;
            // 移動後は小数点モードを解除する
            periodFlag = 0;
        }
    }
}

// ---------------------------ラベルの統合や削除処理---------------------------
#pragma mark - merge or delete label
- (void)deleteLabel:(int)draggingObject
{
    NSLog(@"deletelabel draggingObject=> %d",draggingObject);
    // ラベルを削除
    [[self.view viewWithTag:draggingObject] removeFromSuperview];
    myLabelArray[draggingObject] = [NSNull null];
    labelCount--;
}

- (void)deleteLabelwithObject:(NSNumber *)draggingObject
{
    int tempNum = [draggingObject intValue];
    // ラベルを削除
    [[self.view viewWithTag:tempNum] removeFromSuperview];
    myLabelArray[tempNum] = [NSNull null];
    labelCount--;
}


- (double)calc:(double)num1 dragedNumber:(double)dragedNum
{
    double tempNumber = 0;
    
    switch (mode) {
        case 0:
            tempNumber = num1 + dragedNum;
            break;
        case 1:
            tempNumber = num1 - dragedNum;
            break;
        case 2:
            tempNumber = num1 * dragedNum;
            break;
        case 3:
            tempNumber = num1 / dragedNum;
            break;
        default:
            NSLog(@"===Mode Error===");
            break;
    }
    return tempNumber;
}

- (NSString *)makeStringByCalcedNumber:(double)num1 DragedNumber:(double)dragedNum
{
    if (mode == 3 && dragedNum == 0) {
        return @"Error";
    } else {
        double tempNumber = [self calc:num1 dragedNumber:dragedNum];
        return [NSString stringWithFormat:@"%g", tempNumber];
    }

    return @"Error";
}

- (void)mergeLabel:(int)draggingObject :(int)secondObject
{
    labelCount--;
    
    // ラベルを削除
    [[self.view viewWithTag:draggingObject] removeFromSuperview];
    
    // 合成
    UILabel *label1 = myLabelArray[draggingObject];
    UILabel *label2 = myLabelArray[secondObject];
    double num1 = [label1.text doubleValue];
    double num2 = [label2.text doubleValue];
    label2.text = [self makeStringByCalcedNumber:num2 DragedNumber:num1];
    [label2 sizeToFit];
    
    if ([label2.text isEqualToString:@"Error"]) {
        [self performSelector:@selector(deleteLabelwithObject:)
                   withObject:[NSNumber numberWithInt:secondObject]
                   afterDelay:1];
    } else {
        myLabelArray[secondObject] = label2;
    }
    myLabelArray[draggingObject] = [NSNull null];
}

- (void)mergeButtonAndLabel:(int)draggingButtonNumber :(int)secondObject
{
    // 合成
    UILabel *label = myLabelArray[secondObject];
    label.text = [self makeStringByCalcedNumber:[label.text doubleValue] DragedNumber:draggingButtonNumber];
    [label sizeToFit];
   
    if ([label.text isEqualToString:@"Error"]) {
        [self performSelector:@selector(deleteLabelwithObject:)
                   withObject:[NSNumber numberWithInt:secondObject]
                   afterDelay:1];
    } else {
        myLabelArray[secondObject] = label;
    }
}

-(BOOL)viewsDoCollide:(UIView *)draggingView1 :(UIView *)view2
{
    if(CGRectIntersectsRect(draggingView1.frame, view2.frame))
    {
        return YES;
    }
    return NO;
}

// --------------------------- 数字ボタンの処理 ---------------------------
#pragma mark - number button
- (void) addNumber: (int)myNumber :(UIButton *)myButton{
    // 1〜9の数字ボタンを直接動かした場合
    if (dragedButton) {
        for (int i=1; i<[myLabelArray count]; i++) {
            // 配列の空き部分なら飛ばす && 自身なら飛ばす
            if (![myLabelArray[i] isEqual:[NSNull null]]) {
                // ドラッグしたボタンと残りのラベルとの衝突判定
                if ([self viewsDoCollide:dragedButton :myLabelArray[i]]) {
                    [self mergeButtonAndLabel:myNumber :i];
                    break;
                }
            }
        }
        [self.view addSubview:myButton];
        dragedButton = nil;
    //1〜9の数字ボタンをタップした場合
    } else {
        UILabel *label = myLabelArray[nowLabel];
        
        //Labelの位置を左に動かすことでLabelが右にずれていく防ぐ
        CGRect rect = label.frame;
        if (nowNumber!=0) {
            label.frame = CGRectMake(rect.origin.x-13, rect.origin.y, rect.size.width, rect.size.height);
        }
        //マイナスの抜けでLabelがズレるのを防ぐ
        if (nowNumber < 0 && myNumber == -1) {
            label.frame = CGRectMake(rect.origin.x+13, rect.origin.y, rect.size.width, rect.size.height);
        }

        
        if (myNumber==-1) {
            nowNumber = nowNumber * -1;
        } else {
            if (periodFlag > 0) {
                nowNumber = nowNumber + myNumber / pow(10, periodFlag);
                NSLog(@"now number %f", nowNumber);
                periodFlag++;
            } else {
                nowNumber = nowNumber * 10 + myNumber;
            }
        }

        label.text = [NSString stringWithFormat:@"%g", nowNumber];
        [label sizeToFit];
        
        // 再描画
        [self.view addSubview:label];
    }
}

- (IBAction)myButton0:(id)sender {
    [self addNumber:0 :self.myButton0];
}

- (IBAction)myButton1:(id)sender {
    [self addNumber:1 :self.myButton1];
}

- (IBAction)myButton2:(id)sender {
    [self addNumber:2 :self.myButton2];
}

- (IBAction)myButton3:(id)sender {
    [self addNumber:3 :self.myButton3];
}

- (IBAction)myButton4:(id)sender {
    [self addNumber:4 :self.myButton4];
}

- (IBAction)myButton5:(id)sender {
    [self addNumber:5 :self.myButton5];
}

- (IBAction)myButton6:(id)sender {
    [self addNumber:6 :self.myButton6];
}

- (IBAction)myButton7:(id)sender {
    [self addNumber:7 :self.myButton7];
}

- (IBAction)myButton8:(id)sender {
    [self addNumber:8 :self.myButton8];
}

- (IBAction)myButton9:(id)sender {
    [self addNumber:9 :self.myButton9];
}

#pragma mark - mode change
- (void) changeMode {
    UIImage *img;
    switch (mode) {
        case 0:
            img = [UIImage imageNamed:@"plus.png"];
            [self.myPlusButton setImage:img forState:UIControlStateNormal];
            [self.myPlusButton setUserInteractionEnabled:true];
            break;
        case 1:
            img = [UIImage imageNamed:@"Minus.png"];
            [self.myMinusButton setImage:img forState:UIControlStateNormal];
            [self.myMinusButton setUserInteractionEnabled:true];
            break;
        case 2:
            img = [UIImage imageNamed:@"multi.png"];
            [self.myMultipleButton setImage:img forState:UIControlStateNormal];
            [self.myMultipleButton setUserInteractionEnabled:true];
            break;
        case 3:
            img = [UIImage imageNamed:@"divi.png"];
            [self.myDivisionButton setImage:img forState:UIControlStateNormal];
            [self.myDivisionButton setUserInteractionEnabled:true];
            break;
        default:
            NSLog(@"===Mode Change Error===");
            break;
    }
}

- (IBAction)myPlusButton:(id)sender {
    [self changeMode];
    mode = 0;
    UIImage *img = [UIImage imageNamed:@"plus2.png"];  // ボタンにする画像を生成する
    [self.myPlusButton setImage:img forState:UIControlStateNormal];
    [self.myPlusButton setUserInteractionEnabled:false];
}

- (IBAction)myMinusButton:(id)sender {
    [self changeMode];
    mode = 1;
    UIImage *img = [UIImage imageNamed:@"Minus3.png"];  // ボタンにする画像を生成する
    [self.myMinusButton setImage:img forState:UIControlStateNormal];
    [self.myMinusButton setUserInteractionEnabled:false];
}

- (IBAction)myMultipleButton:(id)sender {
    [self changeMode];
    mode = 2;
    UIImage *img = [UIImage imageNamed:@"multi2.png"];  // ボタンにする画像を生成する
    [self.myMultipleButton setImage:img forState:UIControlStateNormal];
    [self.myMultipleButton setUserInteractionEnabled:false];
}

- (IBAction)myDivisionButton:(id)sender {
    [self changeMode];
    mode = 3;
    UIImage *img = [UIImage imageNamed:@"divi2.png"];  // ボタンにする画像を生成する
    [self.myDivisionButton setImage:img forState:UIControlStateNormal];
    [self.myDivisionButton setUserInteractionEnabled:false];
}

- (IBAction)myPeriodButton:(id)sender {
    if (periodFlag == 0) {
        periodFlag = 1;
        UILabel *label = myLabelArray[nowLabel];
        label.text = [label.text stringByAppendingString:@"."];
        [label sizeToFit];
    }
}

- (IBAction)myPlusMinusButton:(id)sender {
    [self addNumber:-1 :nil];
}

#pragma mark - other
//NSString *str = @"hoge";
//[ViewController isDigit:str];
+(BOOL)isDigit:(NSString *)text
{
    NSCharacterSet *digitCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    NSScanner *aScanner = [NSScanner localizedScannerWithString:text];
    [aScanner setCharactersToBeSkipped:nil];
    
    [aScanner scanCharactersFromSet:digitCharSet intoString:NULL];
    return [aScanner isAtEnd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
