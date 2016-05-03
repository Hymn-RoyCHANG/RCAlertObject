# RCAlertObject
## 对UIAlertView／UIActionSheet／UIAlertController的简单的统一的封装，能力有限.

对于代理的回调问题：iOS7及以下请用UIAlertView或者UIActionSheet自身的代理，详见头文件.

## 如何使用

```Objective-C
    // code in ViewController.m
    RCAlertObject *alertObj = [[RCAlertObject alloc] initWithAlertType:RCAlertTypeAlert title:@"Unity Alert" cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Destructive"];
    alertObj.message = @"My Message";
    alertObj.alertDelegate = (id<RCAlertObjectDelegate>)self;
    [alertObj addOtherButtonTitles:@[@"Button1", @"Button2", @"Button3"]];
    [alertObj showInViewController:self];
    
// iOS 8.0+ Alert/ActionSheet 回调这个方法
- (void)alert:(RCAlertObject *)alert didClickedIndex:(NSInteger)index
{
    NSLog(@"\n[%@] clicked (%d) index.", NSStringFromClass(alert.class), (int)index);
}

// iOS 7.0及以下 回调是系统的方法

// iOS 7.0及以下 Alert 回调这个方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"\n[%@] clicked (%d) index.", NSStringFromClass(alertView.class), (int)buttonIndex);
}

// iOS 7.0及以下 ActionSheet 回调这个方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"\n[%@] clicked (%d) index.", NSStringFromClass(actionSheet.class), (int)buttonIndex);
}
```

![Demo](https://github.com/Hymn-RoyCHANG/RCAlertObject/raw/master/Images/rcalert_1.png "Demo和系统控件一毛一样")
![ActionSheet样式](https://github.com/Hymn-RoyCHANG/RCAlertObject/raw/master/Images/rcalert_2.png "ActionSheet样式")
![Alert样式](https://github.com/Hymn-RoyCHANG/RCAlertObject/raw/master/Images/rcalert_3.png "Alert样式")

# MIT License

Copyright (c) 2016 Roy CHANG

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
