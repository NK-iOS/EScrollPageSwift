//
//  ScrollPage1ViewController.swift
//  EScrollPageSwift
//
//  Created by 聂宽 on 2020/5/15.
//  Copyright © 2020 聂宽. All rights reserved.
//

import UIKit

class ScrollPage1ViewController: UIViewController {
    
    lazy var pageView: EScrollPageView = {
        let statusBarH: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 44.0
//        let pageRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - statusBarH - 44)
        let page1: ScrollTablePageItemView = ScrollTablePageItemView.init(frame: CGRect.zero,
                                                                          title: "个人")
        let page2: ScrollTablePageItemView = ScrollTablePageItemView.init(frame: CGRect.zero,
                                                                          title: "国家")
        let page3: ScrollTablePageItemView = ScrollTablePageItemView.init(frame: CGRect.zero,
                                                                          title: "地球")
        let page4: ScrollTablePageItemView = ScrollTablePageItemView.init(frame: CGRect.zero,
                                                                          title: "宇宙")
        let page5: ScrollTablePageItemView = ScrollTablePageItemView.init(frame: CGRect.zero,
                                                                          title: "mine")
        let pages = [page1, page2, page3, page4, page5]
        let param: EScrollPageParam = EScrollPageParam.defaultParam()
        let pageView = EScrollPageView.init(frame: CGRect(x: 0,
                                                          y: statusBarH,
                                                          width: self.view.frame.size.width,
                                                          height: self.view.frame.size.height - statusBarH),
                                            pageViews: pages,
                                            param: param)
        return pageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        view.addSubview(self.pageView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ScrollTablePageItemView: EScrollpageItemBaseView, UITableViewDataSource, UITableViewDelegate
{
    lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView.init(frame: self.bounds,
                                                      style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PageItemCell")
        return tableView
    }()
    
    override init(frame: CGRect, title: String) {
        super.init(frame: frame, title: title)
        self.addSubview(self.tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAppeared() {
        tableView.frame = self.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageItemCell")
        cell?.textLabel?.text = "\(String(title!)) --> \(indexPath.row)"
        return cell!
        
    }
    
}
