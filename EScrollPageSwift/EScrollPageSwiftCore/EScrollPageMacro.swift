//
//  EScrollPageMacro.swift
//  EScrollPageSwift
//
//  Created by 聂宽 on 2020/5/18.
//  Copyright © 2020 聂宽. All rights reserved.
//

import Foundation
import UIKit


/// 16进制颜色转换
@inlinable
func kEPage_RGBColorFromHex(rgbValue: Int) -> (UIColor)
{
    let color = UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                        green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                        blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                        alpha: 1.0)
    return color
}

/// 计算文本的size
@inlinable
func ePage_sizeWithText(text: String, font: UIFont, size: CGSize) -> CGSize
{
    if text.count < 1
    {
        return .zero
    }
    
    let attributes = [NSAttributedString.Key.font: font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect:CGRect = text.boundingRect(with: size,
                                        options: option,
                                        attributes: attributes,
                                        context: nil)
    return rect.size;
}
