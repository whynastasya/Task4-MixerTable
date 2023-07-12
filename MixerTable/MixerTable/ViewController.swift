//
//  ViewController.swift
//  MixerTable
//
//  Created by nastasya on 11.05.2023.
//

import UIKit

class ViewController: UIViewController {

    var mixerTableView = UITableView()
    let id = "MixerTable"
    var dataSource: UITableViewDiffableDataSource<Section, CellContent>!
    var cellsContent = [CellContent]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Task 4"
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleTableViewCell))
        view.backgroundColor = .white
        
        mixerTableView = UITableView(frame: view.bounds, style: .insetGrouped)
        mixerTableView.register(MyCell.self, forCellReuseIdentifier: id)
        mixerTableView.delegate = self
        
        mixerTableView.allowsMultipleSelection = true
        view.addSubview(mixerTableView)
        setupDataSource()
        mixerTableView.dataSource = dataSource
        
        for i in 0...30 {
            cellsContent.append(CellContent(title: "\(i)", isSelected: false))
            setupSnapshot()
        }
    }
    
    @objc func shuffleTableViewCell() {
        cellsContent.shuffle()
        setupSnapshot()
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, CellContent>(
            tableView: mixerTableView
        ) { tableView, indexPath, cellContent -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.id, for: indexPath)
            
            cell.textLabel?.text = cellContent.title
            cell.accessoryType = self.cellsContent[indexPath.row].isSelected ? .checkmark : .none
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellContent>()
        snapshot.appendSections([.first])
        snapshot.appendItems(cellsContent)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if cellsContent[indexPath.row].isSelected == true {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.selectionStyle = .none
            cell?.accessoryType = .none
            cellsContent[indexPath.row].isSelected = false
            setupSnapshot()
        } else {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.selectionStyle = .none
            cellsContent[indexPath.row].isSelected = true
            cell?.accessoryType = .checkmark
            let elementToReplace = cellsContent.remove(at: indexPath.row)
            cellsContent.insert(elementToReplace, at: 0)
            setupSnapshot()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}

