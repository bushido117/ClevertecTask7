//
//  ViewController.swift
//  Task7
//
//  Created by Вадим Сайко on 24.01.23.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    private var getModel: GetModel?
    private var formDictionary = [String: String]()
    private var listValues = [String]()
    private lazy var listTextField = UITextField()
    private lazy var backgroungImageView = UIImageView()
    private lazy var footer = FooterView()
    private lazy var activityIndicator = ActivityIndicatorView()
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "."
        loadData()
        footer.onDarkThemeButtonTapped = { [weak self] in
            self?.sendButtonTapped()
        }
    }
    
    private func loadData() {
        let group = DispatchGroup()
        setupActivityIndicator()
        group.enter()
        APIService.getData { [weak self] result in
            switch result {
            case .success( let model ):
                self?.getModel = model
                self?.allProperties()
                APIService.loadImage(url: model.image) { result in
                    switch result {
                    case .success( let image ):
                        self?.backgroungImageView.image = image
                    case .failure( let failure ):
                        print(failure)
                    }
                }
            case .failure( let failure ):
                print(failure)
            }
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.removeFromSuperview()
            self.title = self.getModel?.title
            self.backgroungImageView.contentMode = .scaleAspectFit
            self.view.addSubview(self.backgroungImageView)
            self.view.addSubview(self.tableView)
            self.view.addSubview(self.pickerView)
            self.pickerView.isHidden = true
            self.setupConstraints()
        }
    }
    
    private func setupConstraints() {
        backgroungImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        pickerView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    private func sendButtonTapped() {
        setupActivityIndicator()
        APIService.postData(PostModel(form: formDictionary)) { result in
            switch result {
            case .success(let resp):
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.removeFromSuperview()
                    self?.serverResponse(response: resp)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func allProperties() {
        guard let values = getModel?.fields[2].values else { return }
        let mirror = Mirror(reflecting: values)
        for (_, value) in mirror.children {
            guard let value = value as? String else { return }
            listValues.append(value)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footer
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getModel?.fields.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TableViewCell.self),
            for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        guard let fields = getModel?.fields else { return UITableViewCell() }
        cell.setProperties(data: (fields[indexPath.row]))
        cell.textField.delegate = self
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 2 {
            pickerView.isHidden = false
            tableView.isUserInteractionEnabled = false
            listTextField = textField
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: string)
        if textField.tag == 0 {
            let allowedEnCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let enCharactersSet = CharacterSet(charactersIn: allowedEnCharacters)
            let allowesRuCharacters = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя"
            let ruCharactersSet = CharacterSet(charactersIn: allowesRuCharacters)
            let digitsSet = CharacterSet.decimalDigits
            return enCharactersSet.isSuperset(of: characterSet)
            || ruCharactersSet.isSuperset(of: characterSet)
            || digitsSet.isSuperset(of: characterSet)
        } else if textField.tag == 1 {
            let allowedDigits = ".0123456789"
            let digitsSet = CharacterSet(charactersIn: allowedDigits)
            return digitsSet.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            formDictionary[textField.placeholder ?? ""] = textField.text ?? ""
        } else if textField.tag == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                if let textFieldNumber = Double(textField.text ?? "") {
                    if textFieldNumber > 1 && textFieldNumber < 1024 {
                        self?.formDictionary[textField.placeholder ?? ""] = textField.text ?? ""
                    } else {
                        self?.wrongNumber()
                    }
                } else {
                    self?.wrongNumber()
                }
            }
        }
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.isHidden = true
        tableView.isUserInteractionEnabled = true
        listTextField.text = listValues[row]
        formDictionary[listTextField.placeholder ?? ""] = listValues[row]
    }
}

extension ViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listValues.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
}
