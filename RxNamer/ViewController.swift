//
//  ViewController.swift
//  RxNamer
//
//  Created by IceApinan on 12/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var namesLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    let disposeBag = DisposeBag()
    var namesArray: Variable<[String]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        namesLabel.text = ""
        bindTextField()
        bindSubmitButton()
    }

    // Capture the text(property) of textfields then bind it to the label
    func bindTextField() {
        nameEntryTextField.rx.text
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map {
                if $0 == "" {
                    return "Type your name below."
                }
                else {
                    return "Hello, \($0 ?? "")."
                }
        }
            .bind(to: helloLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    func bindSubmitButton() {
        submitButton.rx.tap.subscribe(onNext: {
            if self.nameEntryTextField.text != "" {
                self.namesArray.value.append(self.nameEntryTextField.text!)
                self.namesLabel.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                self.nameEntryTextField.rx.text.onNext("")
                self.helloLabel.rx.text.onNext("Type your name below.")
            }
        }).addDisposableTo(disposeBag)
    }
}

