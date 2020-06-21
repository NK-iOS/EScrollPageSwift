//
//  ViewController.swift
//  EScrollPageSwift
//
//  Created by 聂宽 on 2020/5/14.
//  Copyright © 2020 聂宽. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableview = UITableView.init(frame: self.view.bounds,
                                         style: UITableView.Style.plain)
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ScrollPage"
        view.addSubview(tableView)
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifierStr = "UITableViewID"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifierStr)
        if cell == nil
        {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifierStr)
        }
        switch indexPath.row
        {
        case 0:
            cell?.textLabel?.text = "分页1"
        case 1:
            cell?.textLabel?.text = "分页2"
        case 2:
            cell?.textLabel?.text = "嵌套滚动1"
        case 3:
            cell?.textLabel?.text = "嵌套滚动2"
        default:
            cell?.textLabel?.text = nil
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
        case 0:
            let vc: ScrollPage1ViewController = ScrollPage1ViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

