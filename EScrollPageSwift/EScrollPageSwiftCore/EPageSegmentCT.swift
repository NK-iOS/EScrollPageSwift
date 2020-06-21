//
//  EPageSegmentCT.swift
//  EScrollPageSwift
//
//  Created by 聂宽 on 2020/5/15.
//  Copyright © 2020 聂宽. All rights reserved.
//

import UIKit

/// 头部切换block
typealias HeaderSelectIndexBlock = (NSInteger) -> ()
/// 关联滚动
typealias HeaderAssociatedSscrollBlock = (UIScrollView) -> ()

class EPageSegmentCT: UIView
{
    /// 当前选中
    var indexSelect: NSInteger = 0
    /// 参数设置
    var param: EPageSegmentParam? = EPageSegmentParam.defaultParam()
    /// 数据源
    var dataArray: [String] = []
    /// cell数组
    lazy var cellArray: NSMutableArray = {
        return NSMutableArray.init()
    }()
    
    
    /// 头部切换block
    var didSelectIndexBlock: HeaderSelectIndexBlock?
    /// 关联滚动
    var associatedSscrollBlock: HeaderAssociatedSscrollBlock?
    
    // MARk:- 视图控件
    lazy var collectionView: UICollectionView = {
        let headerH: CGFloat = self.frame.size.height
        let headerW: CGFloat = self.frame.size.width
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = param!.spacing
        layout.sectionInset = UIEdgeInsets.init(top: 0,
                                                left: param!.margin_spacing,
                                                bottom: 0,
                                                right: param!.margin_spacing)
        
        let collectionView = UICollectionView.init(frame: CGRect(x: 0,
                                                                 y: 0,
                                                                 width: headerW,
                                                                 height: headerH),
                                                   collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        /// 注册cell
        collectionView.register(EPageSegmentCell.self, forCellWithReuseIdentifier: EPageSegmentCellID)
        
        return collectionView
    }()
    /// 上边线
    lazy var topLineView: UIView = {
        let headerW: CGFloat = self.frame.size.width
        
        let topLineView = UIView.init(frame: CGRect(x: 0, y: 0, width: headerW, height: 0.5))
        topLineView.backgroundColor = kEPage_RGBColorFromHex(rgbValue: param!.topLineColor)
        
        return topLineView
    }()
    /// 下边线
    lazy var botLineView: UIView = {
        let headerW: CGFloat = self.frame.size.width
        let headerH: CGFloat = self.frame.size.height
        
        let botLineView = UIView.init(frame: CGRect(x: 0, y: headerH - 0.5, width: headerW, height: 0.5))
        botLineView.backgroundColor = kEPage_RGBColorFromHex(rgbValue: param!.botLineColor)
        
        return botLineView
    }()
    
    /// 底部滑块
    lazy var slideLineView: UIView = {
        let itemWidth = getItemWidth(indexItem: self.indexSelect)
        let headerH: CGFloat = self.frame.size.height
        let itemX: CGFloat = 0.0
        let itemH: CGFloat = 2
        
        let lineView = UIView.init(frame: CGRect(x: itemX, y: headerH - itemH, width: itemWidth, height: itemH))
        lineView.backgroundColor = param!.lineColor
        
        return lineView
    }()
    
    /*
    init
    */
    init(frame: CGRect, param: EPageSegmentParam)
    {
        self.param = param
        self.indexSelect = param.startIndex
        
        super.init(frame: frame)
        self.backgroundColor = kEPage_RGBColorFromHex(rgbValue: param.bgColor)
        
        /// 添加子视图
        self.addSubview(self.collectionView)
        self.addSubview(self.topLineView)
        self.addSubview(self.botLineView)
        self.collectionView.addSubview(self.slideLineView)
        
        self.collectionView.selectItem(at: IndexPath(item: self.indexSelect, section: 0),
                                       animated: false,
                                       scrollPosition: .centeredHorizontally)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 根据类型获取item的宽度
    func getItemWidth(indexItem: Int) -> CGFloat
    {
        var itemWidth: CGFloat = 0.0
        
        switch self.param?.type {
        case .left:
            itemWidth = self.param!.itemWidth
        case .leftFit:
            let titleStr = dataArray[indexItem]
            var titleFont = UIFont.systemFont(ofSize: self.param!.fontNormalSize)
            if indexItem == self.indexSelect
            {
                titleFont = UIFont.systemFont(ofSize: self.param!.fontSelectedSize)
            }
            let titleSize = ePage_sizeWithText(text: titleStr,
                                               font: titleFont,
                                               size: CGSize(width: CGFloat(MAXFLOAT),
                                                            height: CGFloat(44.0)))
            
            itemWidth = titleSize.width
        case .between:
            let headerW: CGFloat = self.frame.size.width
            let dataCount = CGFloat((self.dataArray.count))
            itemWidth = (headerW - 2 * self.param!.margin_spacing - (dataCount - 1) * self.param!.spacing) / dataCount
        default:
            break
        }
        return itemWidth
    }
    
    func setAssociatedScroll() -> Void
    {
        weak var weakSelf = self
        self.associatedSscrollBlock = { scrollView in
            if (weakSelf?.collectionView.contentSize.width)! <= CGFloat(0)
            {
                return
            }
            
            var page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            var dx: CGFloat = scrollView.contentOffset.x
            if dx < 0.0
            {
                dx = 0
                page = -1
            }
            if dx > scrollView.contentSize.width - scrollView.frame.size.width
            {
                dx = scrollView.contentSize.width - scrollView.frame.size.width
                page = -1
            }
            
            let dw: CGFloat = (weakSelf?.collectionView.contentSize.width)! - weakSelf!.param!.margin_spacing
            let lx: CGFloat = dx * dw / scrollView.contentSize.width
            let itemW = weakSelf!.getItemWidth(indexItem: page)
            
            
            weakSelf?.slideLineView.frame = CGRect(x: weakSelf!.param!.margin_spacing + lx,
                                                   y: weakSelf!.slideLineView.frame.origin.y,
                                                   width: itemW,
                                                   height: weakSelf!.slideLineView.frame.size.height)
            
            if page >= 0
            {
                let dspace: CGFloat = itemW + weakSelf!.param!.spacing
                for obj in weakSelf!.cellArray
                {
                    let cell = obj as! EPageSegmentCell
                    let scale: CGFloat = abs(cell.center.x - (weakSelf?.slideLineView.center.x)!)/dspace
                    
                    if scale <= 1.0
                    {
                        let fontSize: CGFloat = weakSelf!.param!.fontSelectedSize + (weakSelf!.param!.fontNormalSize - weakSelf!.param!.fontSelectedSize) * scale
                        cell.textLabel.font = UIFont.systemFont(ofSize: fontSize)
                        
                        let sr:CGFloat = ((CGFloat)(((weakSelf?.param!.textSelectedColor)! & 0xFF0000) >> 16))
                        let sg:CGFloat = ((CGFloat)(((weakSelf?.param!.textSelectedColor)! & 0xFF00) >> 8))
                        let sb:CGFloat = ((CGFloat)(((weakSelf?.param!.textSelectedColor)! & 0xFF)))
                        
                        let r:CGFloat = ((CGFloat)(((weakSelf?.param!.textNormalColor)! & 0xFF0000) >> 16))
                        let g:CGFloat = ((CGFloat)(((weakSelf?.param!.textNormalColor)! & 0xFF00) >> 8))
                        let b:CGFloat = ((CGFloat)(((weakSelf?.param!.textNormalColor)! & 0xFF)))
                        
                        let textR:CGFloat = (sr+(r-sr)*scale)/255.0
                        let textG:CGFloat = (sg+(g-sg)*scale)/255.0
                        let textB:CGFloat = (sb+(b-sb)*scale)/255.0
//                        print("sr---\(sr), sg---\(sg), sb---\(sb)")
                        print("textR---\(textR), textG---\(textG), textB---\(textB)")
                        cell.textLabel.textColor = UIColor(red: textR, green: textG, blue: textB, alpha: 1.0)
                    }
                    else
                    {
                        cell.textLabel.textColor = kEPage_RGBColorFromHex(rgbValue: (weakSelf?.param!.textNormalColor)!)
                        cell.textLabel.font = UIFont.systemFont(ofSize: (weakSelf?.param!.fontNormalSize)!)
                    }
                }
            }
        }
    }
    
    /// 刷新titles
    func updataDataArray(titles: [String]) -> Void
    {
        dataArray = titles
        self.collectionView.reloadData()
    }
    
    func selectIndex(index: NSInteger, animated: Bool) -> Void
    {
        self.indexSelect = index
        self.collectionView.selectItem(at: IndexPath(item: self.indexSelect, section: 0),
                                       animated: true,
                                       scrollPosition: .centeredHorizontally)
    }

}

extension EPageSegmentCT : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.dataArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:EPageSegmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: EPageSegmentCellID,
                                                                       for: indexPath) as! EPageSegmentCell
        
        cell.updateText(text: dataArray[indexPath.row], param: self.param!)
        cell.didSelected(selected: (indexPath.row == indexSelect))
        if !self.cellArray.contains(cell)
        {
            self.cellArray.add(cell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.associatedSscrollBlock == nil)
        {
            indexSelect = indexPath.row
            collectionView.reloadData()
        }
        
        if self.didSelectIndexBlock != nil
        {
            self.didSelectIndexBlock!(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let headerH: CGFloat = self.frame.size.height
        let itemWidth: CGFloat = getItemWidth(indexItem: indexPath.item)
        
        return CGSize.init(width: itemWidth, height: headerH)
    }
    
}

let EPageSegmentCellID = "EPageSegmentCell"
class EPageSegmentCell: UICollectionViewCell
{
    lazy var textLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = kEPage_RGBColorFromHex(rgbValue: param!.textNormalColor)
        label.font = UIFont.systemFont(ofSize: param!.fontNormalSize)
        label.textAlignment = .center
        return label
    }()
    
    var param: EPageSegmentParam? = EPageSegmentParam.defaultParam()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(text: String, param: EPageSegmentParam) -> Void
    {
        self.param = param
        self.textLabel.frame = self.contentView.bounds
        self.textLabel.text = text
    }
    
    func didSelected(selected:Bool) -> Void
    {
        if selected
        {
            self.textLabel.textColor = kEPage_RGBColorFromHex(rgbValue: param!.textSelectedColor)
            self.textLabel.font = UIFont.systemFont(ofSize: param!.fontSelectedSize)
        }
        else
        {
            self.textLabel.textColor = kEPage_RGBColorFromHex(rgbValue: param!.textNormalColor)
            self.textLabel.font = UIFont.systemFont(ofSize: param!.fontNormalSize)
        }
    }
}
