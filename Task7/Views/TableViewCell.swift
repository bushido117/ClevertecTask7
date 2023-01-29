//
//  TableViewCell.swift
//  Task7
//
//  Created by Вадим Сайко on 24.01.23.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.masksToBounds = true
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(5)
            make.width.equalTo(100)
        }
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(5)
        }
    }
    
    func setProperties(data: Field) {
        titleLabel.text = data.name
        switch data.type {
//        так как всего три статичных типа, то отслеживаем по тэгу
//        так как имена полей могут быть абсолютно разными устанавливаем их в плейсхолдер и отслеживаем по плейсхолдеру
        case .text:
            textField.placeholder = data.name
            textField.tag = data.type.tag
        case .numeric:
            textField.placeholder = data.name
            textField.tag = data.type.tag
        case .list:
            textField.placeholder = data.name
            textField.tag = data.type.tag
        }
    }
}
