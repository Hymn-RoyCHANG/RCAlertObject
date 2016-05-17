//
//  RCAlertObject.m
//  ImagePicker
//
//  Created by Roy on 16/4/28.
//  Copyright © 2016年 Roy CHANG. All rights reserved.
//

#import "RCAlertObject.h"
#import <objc/runtime.h>

#ifdef RC_Foundation_IOS_7_1
#undef RC_Foundation_IOS_7_1
#endif

#ifdef NSFoundationVersionNumber_iOS_7_1
#define RC_Foundation_IOS_7_1       NSFoundationVersionNumber_iOS_7_1
#else
#define RC_Foundation_IOS_7_1       (1047.25)
#endif

#define RC_CANCEL_DEFINDEX          -99
#define RC_DESTRUCTIVE_DEFINDEX     -88

///两种重要索引
typedef struct RCAlertIndexes
{
    ///取消按钮索引
    NSInteger cancelIndex;
    ///‘销毁’性（红色）按钮索引
    NSInteger destructiveIndex;
    ///后继使用索引
    NSInteger succeedIndex;
}RCAlertIndexes;

NSString *const kActionIndex = @"RCActionIndex";

@interface UIAlertAction (ActionIndex)

@property (nonatomic, assign) NSInteger actionIndex;

@end

@implementation UIAlertAction (ActionIndex);

@dynamic actionIndex;

- (void)setActionIndex:(NSInteger)actionIndex
{
    objc_setAssociatedObject(self, &kActionIndex, @(actionIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)actionIndex
{
    NSNumber *index = objc_getAssociatedObject(self, &kActionIndex);
    return index.integerValue;
}

@end

@interface RCAlertObject ()

@property (nonatomic, assign) RCAlertType internalAlertType;

@property (nonatomic, strong) id internalAlertObject;

@property (nonatomic, weak) NSString *internalTitle;

@property (nonatomic, weak) NSString *internalCancelBtnTitle;

@property (nonatomic, weak) NSString *internalDestructiveBtnTitle;

@property (nonatomic, assign, getter = isAboveIOS_7) BOOL aboveIOS_7;

@property (nonatomic, assign, getter = isAddedOtherButtons) BOOL addedOtherButtons;

@end

@implementation RCAlertObject

@synthesize title = _title;
@synthesize message = _message;
@synthesize alertDelegate = _alertDelegate;

- (instancetype)initWithAlertType:(RCAlertType)alertType title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle
{
    self = [super init];
    if(self)
    {
        switch(alertType)
        {
            case RCAlertTypeActionSheet:
            {
                self.internalAlertType = RCAlertTypeActionSheet;
            }
                break;
                
            default:
            {
                self.internalAlertType = RCAlertTypeAlert;
            }
                break;
        }
        
        self.addedOtherButtons = NO;
        self.aboveIOS_7 = NO;
        if(RC_Foundation_IOS_7_1 < NSFoundationVersionNumber)
        {
            self.aboveIOS_7 = YES;
        }
        
        self.internalTitle = title;
        self.internalCancelBtnTitle = (cancelButtonTitle && 0 != cancelButtonTitle.length) ? cancelButtonTitle : nil;
        self.internalDestructiveBtnTitle = (destructiveButtonTitle && 0 != destructiveButtonTitle.length) ? destructiveButtonTitle : nil;
        [self initializer];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.addedOtherButtons = NO;
        self.aboveIOS_7 = NO;
        if(RC_Foundation_IOS_7_1 < NSFoundationVersionNumber)
        {
            self.aboveIOS_7 = YES;
        }
        
        self.internalAlertType = RCAlertTypeAlert;
        [self initializer];
    }
    
    return self;
}

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [_internalAlertObject release];
    [super dealloc];
#else
    _internalAlertObject = nil;
#endif
}

///初始化
- (void)initializer
{
    if(RCAlertTypeActionSheet == self.internalAlertType)
    {
        [self actionSheetInitiailzer];
    }
    else
    {
        [self alertInitiailzer];
    }
}

///alert初始化
- (void)alertInitiailzer
{
    if(self.isAboveIOS_7)
    {
        self.internalAlertObject = [UIAlertController alertControllerWithTitle:self.internalTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        if(self.internalCancelBtnTitle)
        {
            //__weak __typeof(self) weakSelf = self;
            __strong __typeof(self) strongSelf = self;
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:self.internalCancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                //__strong __typeof(self) strongSelf = self;
                if([strongSelf.alertDelegate respondsToSelector:@selector(alert:didClickedIndex:)])
                {
                    [strongSelf.alertDelegate alert:strongSelf didClickedIndex:action.actionIndex];
                }
            }];
            
            cancel.actionIndex = 0;
            
            [self.internalAlertObject addAction:cancel];
        }
    }
    else
    {
        self.internalAlertObject = [[UIAlertView alloc] initWithTitle:self.internalTitle message:nil delegate:nil cancelButtonTitle:self.internalCancelBtnTitle otherButtonTitles:nil];
    }
}

///actionSheet初始化
- (void)actionSheetInitiailzer
{
    if(self.isAboveIOS_7)
    {
        self.internalAlertObject = [UIAlertController alertControllerWithTitle:self.internalTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if(self.internalCancelBtnTitle)
        {
            //__weak __typeof(self) weakSelf = self;
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:self.internalCancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                //__strong __typeof(weakSelf) strongSelf = weakSelf;
                if([self.alertDelegate respondsToSelector:@selector(alert:didClickedIndex:)])
                {
                    [self.alertDelegate alert:self didClickedIndex:action.actionIndex];
                }
            }];
            
            cancel.actionIndex = RC_CANCEL_DEFINDEX;
            
            [self.internalAlertObject addAction:cancel];
        }
        
        if(self.internalDestructiveBtnTitle)
        {
            //__weak __typeof(self) weakSelf = self;
            UIAlertAction *dectructive = [UIAlertAction actionWithTitle:self.internalDestructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                //__strong __typeof(self) strongSelf = self;
                if([self.alertDelegate respondsToSelector:@selector(alert:didClickedIndex:)])
                {
                    [self.alertDelegate alert:self didClickedIndex:action.actionIndex];
                }
            }];
            
            dectructive.actionIndex = RC_DESTRUCTIVE_DEFINDEX;
            
            [self.internalAlertObject addAction:dectructive];
        }
    }
    else
    {
        self.internalAlertObject = [[UIActionSheet alloc] initWithTitle:self.internalTitle delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    }
}

- (void)showInViewController:(UIViewController *)theViewController
{
    //NSAssert(theViewController, @"'theViewController' argument is nil.");//you can use this = =|||.
    
    if(theViewController)
    {
        if(RCAlertTypeActionSheet == self.internalAlertType)
        {
            if(self.isAboveIOS_7)
            {
                UIAlertController *ac = (UIAlertController *)self.internalAlertObject;
                
                if(!self.isAddedOtherButtons)
                {
                    [self addActionSheetMainButtonTitles];
                }
                
                [theViewController presentViewController:ac animated:YES completion:nil];
            }
            else
            {
                UIActionSheet *as = (UIActionSheet *)self.internalAlertObject;
                
                if(!self.isAddedOtherButtons)
                {
                    [self addActionSheetMainButtonTitles];
                }
                
                [as showInView:theViewController.view];
            }
        }
        else
        {
            if(self.isAboveIOS_7)
            {
                UIAlertController *ac = (UIAlertController *)self.internalAlertObject;
                [theViewController presentViewController:ac animated:YES completion:nil];
            }
            else
            {
                UIAlertView *av = (UIAlertView *)self.internalAlertObject;
                [av show];
            }
        }
    }
#if DEBUG
    else
    {
        NSLog(@"'theViewController' argument is nil.");
    }
#endif
}

- (void)addOtherButtonTitles:(NSArray *)titles
{
    if(!self.isAddedOtherButtons && titles && 0 != titles.count)
    {
        self.addedOtherButtons = YES;
        
        if(RCAlertTypeActionSheet == self.internalAlertType)
        {
            [self addActionSheetButtonTitles:titles];
        }
        else
        {
            [self addAlertOtherButtonTitles:titles];
        }
    }
}

///获取索引(默认只有两个按钮cancel(索引在最后) 和 destructive(索引在第一个))
static RCAlertIndexes ActionSheetIndexes(RCAlertObject *alert)
{
    RCAlertIndexes indexes;
    
    NSInteger cancelIdx = RC_CANCEL_DEFINDEX;
    NSInteger destructiveIdx = RC_DESTRUCTIVE_DEFINDEX;
    NSInteger succeedIdx = 0;
    
    if(alert.internalDestructiveBtnTitle && alert.internalCancelBtnTitle)
    {
        cancelIdx = 1;
        destructiveIdx = 0;
        succeedIdx = 1;
    }
    else if(alert.internalDestructiveBtnTitle && !alert.internalCancelBtnTitle)
    {
        destructiveIdx = 0;
        succeedIdx = 1;
    }
    else if(alert.internalCancelBtnTitle && !alert.internalDestructiveBtnTitle)
    {
        cancelIdx = 0;
        succeedIdx = 0;
    }
    
    indexes.cancelIndex = cancelIdx;
    indexes.destructiveIndex = destructiveIdx;
    indexes.succeedIndex = succeedIdx;
    
    return indexes;
}

///添加UIActionSheet主要的标题
- (void)addActionSheetMainButtonTitles
{
    RCAlertIndexes indexes = ActionSheetIndexes(self);
    NSInteger cancelIdx = indexes.cancelIndex;
    NSInteger destructiveIdx = indexes.destructiveIndex;
    
    if(self.isAboveIOS_7)
    {
        UIAlertController *av = (UIAlertController *)self.internalAlertObject;
        [av.actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIAlertAction *action = (UIAlertAction *)obj;
            if(RC_CANCEL_DEFINDEX == action.actionIndex)
            {
                action.actionIndex = cancelIdx;
            }
            else if(RC_DESTRUCTIVE_DEFINDEX == action.actionIndex)
            {
                action.actionIndex = destructiveIdx;
            }
        }];
    }
    else
    {
        UIActionSheet *as = (UIActionSheet *)self.internalAlertObject;
        if(self.internalDestructiveBtnTitle)
        {
            [as addButtonWithTitle:self.internalDestructiveBtnTitle];
            as.destructiveButtonIndex = destructiveIdx;
        }
        
        if(self.internalCancelBtnTitle)
        {
            [as addButtonWithTitle:self.internalCancelBtnTitle];
            as.cancelButtonIndex = cancelIdx;
        }
    }
}

/*!
 * @brief 添加Alert类型的其它标题
 */
- (void)addAlertOtherButtonTitles:(NSArray *)titles
{
    if(self.isAboveIOS_7)
    {
        UIAlertController *ac = (UIAlertController *)self.internalAlertObject;
        NSInteger index = self.internalCancelBtnTitle ? 1 : 0;
        
        for(NSString *title in titles)
        {
            //__weak __typeof(self) weakSelf = self;
            UIAlertAction *actions = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //__strong __typeof(weakSelf) strongSelf = weakSelf;
                if([self.alertDelegate respondsToSelector:@selector(alert:didClickedIndex:)])
                {
                    [self.alertDelegate alert:self didClickedIndex:action.actionIndex];
                }
            }];
            
            actions.actionIndex = index++;
            [ac addAction:actions];
        }
    }
    else
    {
        UIAlertView *av = (UIAlertView *)self.internalAlertObject;
        
        for(NSString *title in titles)
        {
            [av addButtonWithTitle:title];
        }
    }
}

/*!
 * @brief 添加ActionSheet类型的其它标题
 */
- (void)addActionSheetButtonTitles:(NSArray *)titles
{
    if(self.isAboveIOS_7)
    {
        UIAlertController *ac = (UIAlertController *)self.internalAlertObject;
        
        RCAlertIndexes indexes = ActionSheetIndexes(self);
        NSInteger cancelIdx = (RC_DESTRUCTIVE_DEFINDEX != indexes.destructiveIndex) ? titles.count + 1 : titles.count;
        NSInteger destructiveIdx = indexes.destructiveIndex;
        NSInteger index = indexes.succeedIndex;
        
        if(self.internalDestructiveBtnTitle || self.internalCancelBtnTitle)
        {
            [ac.actions enumerateObjectsUsingBlock:^(UIAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UIAlertAction *action = (UIAlertAction *)obj;
                if(RC_CANCEL_DEFINDEX == action.actionIndex)
                {
                    action.actionIndex = cancelIdx;
                }
                else if(RC_DESTRUCTIVE_DEFINDEX == action.actionIndex)
                {
                    action.actionIndex = destructiveIdx;
                }
            }];
        }
        
        for(NSString *title in titles)
        {
            //__weak __typeof(self) weakSelf = self;
            UIAlertAction *actions = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //__strong __typeof(weakSelf) strongSelf = weakSelf;
                if([self.alertDelegate respondsToSelector:@selector(alert:didClickedIndex:)])
                {
                    [self.alertDelegate alert:self didClickedIndex:action.actionIndex];
                }
            }];
            
            actions.actionIndex = index++;
            [ac addAction:actions];
        }
    }
    else
    {
        UIActionSheet *as = (UIActionSheet *)self.internalAlertObject;
        
        if(self.internalDestructiveBtnTitle)
        {
            [as addButtonWithTitle:self.internalDestructiveBtnTitle];
            as.destructiveButtonIndex = 0;
        }
        
        for(NSString *title in titles)
        {
            [as addButtonWithTitle:title];
        }
        
        if(self.internalCancelBtnTitle)
        {
            [as addButtonWithTitle:self.internalCancelBtnTitle];
            as.cancelButtonIndex = as.numberOfButtons - 1;
        }
    }
}

#pragma mark - Property

- (void)setTitle:(NSString *)title
{
    _title = title;
    if(RCAlertTypeActionSheet == self.internalAlertType)
    {
        if(self.isAboveIOS_7)
        {
            UIAlertController *ac = (UIAlertController *)self.internalAlertObject;
            ac.title = title;
        }
        else
        {
            UIActionSheet *as = (UIActionSheet *)self.internalAlertObject;
            as.title = title;
        }
    }
    else
    {
        if(self.isAboveIOS_7)
        {
            UIAlertController *ac = (UIAlertController *)self.internalAlertObject;
            ac.title = title;
        }
        else
        {
            UIAlertView *av = (UIAlertView *)self.internalAlertObject;
            av.title = title;
        }
    }
}

- (void)setMessage:(NSString *)message
{
    if(RCAlertTypeAlert == self.internalAlertType)
    {
        _message = message;
        if(self.isAboveIOS_7)
        {
            UIAlertController *ac = (UIAlertController *)self.internalAlertObject;
            ac.message = message;
        }
        else
        {
            UIAlertView *av = (UIAlertView *)self.internalAlertObject;
            av.message = message;
        }
    }
}

- (void)setAlertDelegate:(id<RCAlertObjectDelegate>)alertDelegate
{
    _alertDelegate = alertDelegate;
    if(alertDelegate)
    {
        if(!self.isAboveIOS_7)
        {
            if(RCAlertTypeActionSheet == self.internalAlertType)
            {
                UIActionSheet *as = (UIActionSheet *)self.internalAlertObject;
                as.delegate = (id<UIActionSheetDelegate>)alertDelegate;
            }
            else
            {
                UIAlertView *av = (UIAlertView *)self.internalAlertObject;
                av.delegate = (id)alertDelegate;
            }
        }
    }
}

- (RCAlertType)currentAlertType
{
    return self.internalAlertType;
}

@end
