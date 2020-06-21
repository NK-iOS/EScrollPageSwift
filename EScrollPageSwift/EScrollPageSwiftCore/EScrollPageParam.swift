//
//  EScrollPageParam.swift
//  EScrollPageSwift
//
//  Created by 聂宽 on 2020/5/15.
//  Copyright © 2020 聂宽. All rights reserved.
//

import UIKit

enum EPageContentType :Int
{
    /// 从左到右依次排列
    case left = 1
    /// 从左到右依次排列，适应模式，根据内容计算item宽度
    case leftFit = 2
    /// 平均排列一屏
    case between
}

class EScrollPageParam: NSObject
{
    /// 头部切换栏高度
    var headerHeight: CGFloat = 44
    
    /// 头部配置参数
    var segmentParam = EPageSegmentParam.defaultParam()
    
    /// 默认配置
    class func defaultParam() -> EScrollPageParam
    {
        return EScrollPageParam.init()
    }
}

class EPageSegmentParam: NSObject
{
    /// 排列类型
    var type: EPageContentType = .between
    
    /// 左右边缘间距
    var margin_spacing: CGFloat = 5.0
    
    /// 中间间距
    var spacing: CGFloat = 5.0
    
    /// 16进制选中的颜色
    var textSelectedColor = 0xFF0000
    
    /// 16进制正常的颜色
    var textNormalColor = 0x000000
    
    /// 显示底部线
    var showLine = true
    
    /// 底部线宽
    var lineWidth: CGFloat = -1.0
    
    /// 底部线颜色
    var lineColor: UIColor = UIColor.red
    
    /// 字体大小
    var fontNormalSize: CGFloat = 15.0
    
    /// 选择字体大小
    var fontSelectedSize: CGFloat = 15.0
    
    /// 初始选中的index
    var startIndex: NSInteger = 0
    
    /// 16进制背景颜色
    var bgColor = 0xfcfcfc
    
    /// 16进制背景颜色
    var topLineColor = 0xcdcdcd
    
    /// 16进制背景颜色
    var botLineColor = 0xcdcdcd
    
    /// 宽度
    var itemWidth: CGFloat = 80.0
    
    /// 默认配置
    class func defaultParam() -> EPageSegmentParam
    {
        return EPageSegmentParam.init()
    }
}
