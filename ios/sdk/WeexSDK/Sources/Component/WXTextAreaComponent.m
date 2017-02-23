/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXTextAreaComponent.h"

typedef UITextView WXTextAreaView;

@interface WXTextAreaComponent()

@property (nonatomic, strong) WXTextAreaView *textView;

@end

@implementation WXTextAreaComponent {
    UIEdgeInsets _border;
    UIEdgeInsets _padding;
}

-(void)viewDidLoad
{
    _padding = UIEdgeInsetsZero;
    _border = UIEdgeInsetsZero;
    if (self.placeholderString) {
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.numberOfLines = 0;
        [_textView addSubview:self.placeHolderLabel];
    }
    _textView.delegate = self;
    [super viewDidLoad];
}

- (UIView *)loadView
{
    _textView = [[WXTextAreaView alloc] init];
    return _textView;
}
#pragma mark -Overwrite method
-(NSString *)text
{
    return _textView.text;
}

- (void)setText:(NSString *)text
{
    _textView.text = text;
}

-(void)setTextColor:(UIColor *)color
{
    [_textView setTextColor:color];
}

-(void)setTextAlignment:(NSTextAlignment)textAlignForStyle
{
    [_textView setTextAlignment:textAlignForStyle];
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [_textView setUserInteractionEnabled:userInteractionEnabled];
}

-(void)setEnabled:(BOOL)enabled
{
    _textView.editable = enabled;
    _textView.selectable = enabled;
}

-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    [_textView setReturnKeyType:returnKeyType];
}

-(void)setInputAccessoryView:(UIView *)inputAccessoryView
{
    [_textView setInputAccessoryView:inputAccessoryView];
}

-(void)setEditSelectionRange:(NSInteger)selectionStart selectionEnd:(NSInteger)selectionEnd
{
    [self.textView becomeFirstResponder];
    UITextPosition *startPos =  [self.textView positionFromPosition:self.textView.beginningOfDocument offset:selectionStart];
    UITextPosition *endPos = [self.textView positionFromPosition:self.textView.beginningOfDocument offset:selectionEnd];
    UITextRange *textRange = [self.textView textRangeFromPosition:startPos
                                                       toPosition:endPos];
    self.textView.selectedTextRange = textRange;
}

-(NSDictionary *)getEditSelectionRange
{
    NSInteger selectionStart = [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:self.textView.selectedTextRange.start];
    NSInteger selectionEnd = [self.textView offsetFromPosition:self.textView.beginningOfDocument toPosition:self.textView.selectedTextRange.end];
    NSDictionary *res = @{@"selectionStart":@(selectionStart),@"selectionEnd":@(selectionEnd)};
    return res;
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType
{
    [_textView setKeyboardType:keyboardType];
}

-(void)setSecureTextEntry:(BOOL)secureTextEntry
{
    [_textView setSecureTextEntry:secureTextEntry];
}

-(void)setEditPadding:(UIEdgeInsets)padding
{
    _padding = padding;
    [self _updateTextContentInset];
}

-(void)setEditBorder:(UIEdgeInsets)border
{
    _border = border;
    [self _updateTextContentInset];
}

-(void)setAttributedPlaceholder:(NSMutableAttributedString *)attributedString font:(UIFont *)font
{
    if (self.placeholderColor) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.placeholderColor range:NSMakeRange(0, self.placeholderString.length)];
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.placeholderString.length)];
    }
    self.placeHolderLabel.backgroundColor = [UIColor clearColor];
    CGRect expectedLabelSize = [attributedString boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX}
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                              context:nil];
    
    self.placeHolderLabel.clipsToBounds = NO;
    CGRect newFrame = self.placeHolderLabel.frame;
    newFrame.size.height = ceil(expectedLabelSize.size.height);
    newFrame.size.width = _textView.frame.size.width;
    newFrame.origin.x = 4; // the cursor origin.x
    newFrame.origin.y = 7; // the cursor origin.y
    self.placeHolderLabel.frame = newFrame;
    self.placeHolderLabel.attributedText = attributedString;
}

-(void)setFont:(UIFont *)font
{
    [_textView setFont:font];
}

#pragma mark -Private Method
- (void)_updateTextContentInset
{
    [_textView setTextContainerInset:UIEdgeInsetsMake(_padding.top + _border.top,
                                                      _padding.left + _border.left,
                                                      _padding.bottom + _border.bottom,
                                                      _border.right + _border.right)];
}

@end
