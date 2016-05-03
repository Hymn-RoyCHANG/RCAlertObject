//
//  RCAlertObject.h
//  ImagePicker
//
//  Created by Roy on 16/4/28.
//  Copyright © 2016年 Roy CHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RCAlertObject;

/*!
 * 弹框样式
 */
typedef NS_ENUM(NSUInteger, RCAlertType)
{
    ///提示弹框样式,  e.g. UIAlertView
    RCAlertTypeAlert        = 0,
    ///活动单元样式,  e.g. UIActionSheet
    RCAlertTypeActionSheet  = 1
};

///代理委托
@protocol RCAlertObjectDelegate <NSObject>

/*!
 * @brief 点击了按钮
 * @param alert 弹框实例
 * @param index 点击索引
 * @note 如果是iOS7及以下请使用 ’UIAlertVIiewDelegate‘或’UIActionSheetDelegate‘代理的相关方法!!
 * <p>索引顺序是没有变的(可以实际使用时测试一下看看＝。＝|||)</p>
 *
 * @see 'RCAlertTypeAlert'类型使用'UIAlertVIiewDelegate'的委托方法:
        <p>-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex</p>
 *
 * @see 'RCAlertTypeActionSheet'类型使用'UIActionSheetDelegate'的委托方法:
        <p>-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex</p>
 */
- (void)alert:(RCAlertObject *)alert didClickedIndex:(NSInteger)buttonIndex;

@end


/*!
 * @brief 弹框统一化对象的简单封装(6.0倒是不是什么限制...)
 * @author Roy CHANG
 */
NS_CLASS_AVAILABLE_IOS(6_0) @interface RCAlertObject : NSObject

/*!
 * @brief 初始化‘弹框’(用这个初始化,否则默认'RCAlertTypeAlert'样式)
 * @param alertType 弹框样式
 * @param title 标题
 * @param cancelButtonTitle 取消按钮标题
 * @param destructiveButtonTitle ‘销毁’性的标题(红色按钮),'alertType' == 'RCAlertTypeActionSheet'有效
 */
- (instancetype)initWithAlertType:(RCAlertType)alertType title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle;

/*!
 * @brief 代理
 */
@property (nonatomic, weak) id<RCAlertObjectDelegate> alertDelegate;

/*!
 * @brief 当前'弹框'样式
 */
@property (nonatomic, readonly) RCAlertType currentAlertType;

/*!
 * @brief 标题
 */
@property (nonatomic, strong) NSString *title;

/*!
 * @brief 消息体.指定了‘RCAlertTypeAlert’样式有效.
 */
@property (nonatomic, strong) NSString *message;

/*!
 * @brief 显示弹框
 * @param theView 在指定的控制器中显示,如果是空则不显示.
 */
- (void)showInViewController:(UIViewController *)theViewController;

/*!
 * @brief 添加其它按钮
 * @param buttonTitles 按钮标题集合
 * @note 你只有一次添加其它按钮的机会!!
 */
- (void)addOtherButtonTitles:(NSArray *)buttonTitles;

@end
