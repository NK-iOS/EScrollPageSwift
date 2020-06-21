//
//  EScrollPageView.swift
//  EScrollPageSwift
//
//  Created by 聂宽 on 2020/5/15.
//  Copyright © 2020 聂宽. All rights reserved.
//

import UIKit
import WebKit

// MARK: - ******************************************* EScrollPageView *****************************
class EScrollPageView: UIView
{
    /// 配置参数
    var param: EScrollPageParam = EScrollPageParam.defaultParam()
    
    /// page视图数组
    var pageViews: [Any]?
    
    /// 头部切换视图
    lazy var segmentCT: EPageSegmentCT = {
        let segmentCT = EPageSegmentCT.init(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: self.frame.size.width,
                                                          height: self.param.headerHeight),
                                            param: self.param.segmentParam)
        weak var weakSelf = self
        segmentCT.didSelectIndexBlock = {(indexSelect) -> () in
            let pageViewW: CGFloat = weakSelf?.scrollView.frame.size.width ?? 0
            let OffsetX: CGFloat = CGFloat(indexSelect) * pageViewW
            weakSelf?.scrollView.setContentOffset(CGPoint(x: OffsetX, y: 0), animated: true)
        }
        self.addSubview(segmentCT)
        
        return segmentCT
    }()
    
    /// 滚动视图
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect(x: 0,
                                                         y: self.param.headerHeight,
                                                         width: self.frame.size.width,
                                                         height: self.frame.size.height - self.param.headerHeight))
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        return scrollView
    }()
    
    /// 当前选中的index
    var currenIndex: NSInteger = 0
    
    
//    init(frame: CGRect, pageViews: [EScrollpageItemBaseView])
//    {
//        super.init(frame: frame)
//    }
//    
    init(frame: CGRect, pageViews: [EScrollpageItemBaseView], param: EScrollPageParam = EScrollPageParam.defaultParam())
    {
        super.init(frame: frame)
        
        /// 如果滚动视图为空直接返回
        if pageViews.count == 0
        {
            return
        }
        
        /// 参数配置
        self.param = param
        
        self.pageViews = pageViews
        
        if self.param.segmentParam.startIndex > pageViews.count
            || self.param.segmentParam.startIndex < 0
        {
            self.param.segmentParam.startIndex = 0
        }
        self.currenIndex = self.param.segmentParam.startIndex
        
        /// 标题数组
        let pageViewW: CGFloat = self.scrollView.frame.size.width
        let pageViewH: CGFloat = self.scrollView.frame.size.height
        let titles = NSMutableArray.init()
        for i in 0..<self.pageViews!.count
        {
            let pageView = self.pageViews![i] as! EScrollpageItemBaseView
            pageView.index = i
            
            titles.add(pageView.title ?? "\(i)")
            
            /// 添加视图
            let pageViewX: CGFloat = CGFloat(i) * pageViewW
            pageView.frame = CGRect(x: pageViewX,
                                    y: 0,
                                    width: pageViewW,
                                    height: pageViewH)
            self.scrollView .addSubview(pageView)
            if i == self.param.segmentParam.startIndex
            {
                pageView.didAppeared()
            }
        }
        
        /// 设置scrollView的contentSize
        let contentSizeW: CGFloat = CGFloat(self.pageViews!.count) * pageViewW
        self.scrollView.contentSize = CGSize(width: contentSizeW, height: pageViewH)
        
        /// 刷新titles
        self.segmentCT.updataDataArray(titles: titles as! [String])
        self.segmentCT.setAssociatedScroll()
        
        /// 滑动到对应位置
        if self.param.segmentParam.startIndex > 0
        {
            let OffsetX: CGFloat = CGFloat(self.param.segmentParam.startIndex) * pageViewW
            self.scrollView.setContentOffset(CGPoint(x: OffsetX, y: 0), animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIScrollViewDelegate
extension EScrollPageView : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if (segmentCT.associatedSscrollBlock != nil)
        {
            segmentCT.associatedSscrollBlock!(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        dealWithScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        dealWithScroll()
    }
    /// 私有方法
    private func dealWithScroll() -> Void
    {
        let index: NSInteger = NSInteger(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        
        let pageView = self.pageViews![index] as! EScrollpageItemBaseView
        pageView.didAppeared()
        
        /// 更新头部选中位置
        self.segmentCT.selectIndex(index: index, animated: true)
        self.currenIndex = index
    }
}

typealias EScrollPageDidAddScrollViewBlock = (UIScrollView, NSInteger) -> ()

// MARK: - ******************************************* EScrollpageItemBaseView *********************
class EScrollpageItemBaseView: UIView
{
    
    /// 标题
    var title: String? = ""
    
    /// 页面索引
    var index: NSInteger = 0
    
    var didAddScrollViewBlock: EScrollPageDidAddScrollViewBlock?
    
    
    init(frame: CGRect, title: String)
    {
        self.title = title
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: UIView)
    {
        super.didAddSubview(subview)
        
        if didAddScrollViewBlock != nil
        {
            if subview.isKind(of: UIScrollView.self)
            {
                didAddScrollViewBlock!(subview as! UIScrollView, index)
            }
            else if subview.isKind(of: WKWebView.self)
            {
                didAddScrollViewBlock!((subview as! WKWebView).scrollView, index)
            }
            else
            {
                for sview in subview.subviews {
                    if sview.isKind(of: UIScrollView.self)
                    {
                        didAddScrollViewBlock!(sview as! UIScrollView, index)
                    }
                }
            }

        }
    }
    
    /// 子类重写，该page显示出来的时候调用
    func didAppeared() -> Void
    {
    }
}
