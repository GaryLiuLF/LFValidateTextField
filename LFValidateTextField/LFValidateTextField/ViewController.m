//
//  ViewController.m
//  LFValidateTextField
//
//  Created by Gary-刘林飞 on 2018/1/17.
//  Copyright © 2018年 LiuLinFei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<
UITextFieldDelegate,
UITextViewDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *textField1;

@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (weak, nonatomic) IBOutlet UITextField *textField3;

@property (weak, nonatomic) IBOutlet UITextField *textField4;

@end

#define NUMBER @"0123456789"
#define LETTER @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define LETTER_NUMBER @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.delegate = self;
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textField3];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)textFieldEditChanged:(id)notification {
    
    UITextRange *selectedRange = self.textField3.markedTextRange;
    UITextPosition *position = [self.textField3 positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        // 过滤非汉字字符
        self.textField3.text = [self filterCharactor:self.textField3.text withRegex:@"[^\u4e00-\u9fa5]"];
        
//        if (self.textField3.text.length >= 4) {
//            self.textField3.text = [self.textField3.text substringToIndex:4];
//        }
    }
    else { // 有高亮文字
        // do nothing
    }
}

#pragma mark - TextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    if (textField != self.textField3) {
//        return YES;
//    }
//    // 过滤非汉字字符
//    textField.text = [self filterCharactor:textField.text withRegex:@"[^\u4e00-\u9fa5]"];
//    if (textField.text.length >= 4) {
//        textField.text = [textField.text substringToIndex:4];
//    }
//    return NO;
//}

- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *validateStr = @"";
    if (textField == self.textField1) {
        validateStr = NUMBER;
    }
    else if (textField == self.textField2) {
        validateStr = LETTER;
    }
    else if (textField == self.textField4) {
        validateStr = LETTER_NUMBER;
    }
    else {
        return YES;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:validateStr]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

//#pragma mark - UITextViewDelegate
///// 限制长度
//- (void)textViewDidChange:(UITextView *)textView {
//    NSInteger number = [textView.text length];
//    if (number > 10) {
//        textView.text = [textView.text substringToIndex:10];
//    }
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
