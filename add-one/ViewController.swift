//
//  ViewController.swift
//  add-one
//
//  Created by Ueta, Lucas T on 12/6/23.
//

import UIKit

class ViewController: UIViewController {
    
    let scoreLabel = UILabel(), timeLabel = UILabel(), promptLabel = UILabel(), input = UITextField(), message = UILabel(), playAgain = UIButton(), content = UIStackView(), stack = UIStackView()
    
    var game = Game(), timer = Timer()
    
    var time = 60 { didSet {
        guard time < 60 else {
            timeLabel.text = "1:00"
            return
        }
        guard time < 10 else {
            timeLabel.text = "0:\(time)"
            return
        }
        timeLabel.text = "0:0\(time)"
    }}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemCyan
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // stack
        stack.axis = .vertical
        stack.alignment = .center
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // header
        let header = UIStackView()
        header.axis = .horizontal
        header.alignment = .center
        stack.addArrangedSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            header.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
        
        // score
        let scoreView = UIView()
        header.addArrangedSubview(scoreView)
        
        // score image background
        let scoreImage = UIImageView(image: UIImage(named: "score"))
        scoreView.addSubview(scoreImage)
        
        // score number
        scoreLabel.frame = CGRect(origin: scoreView.anchorPoint, size: .init(width: 20, height: 20))
        scoreLabel.font = UIFont(name: "HVDComicSerifPro", size: 22)
        scoreLabel.textColor = .white
        scoreView.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: scoreImage.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreImage.centerYAnchor)
        ])
        
        // time
        let timeView = UIView()
        header.addArrangedSubview(timeView)
        
        // time image background
        let timeImage = UIImageView(image: UIImage(named: "time"))
        timeImage.translatesAutoresizingMaskIntoConstraints = false
        timeView.addSubview(timeImage)
        NSLayoutConstraint.activate([ timeImage.rightAnchor.constraint(equalTo: timeView.rightAnchor) ])
        
        // time number
        timeLabel.frame = CGRect(origin: timeView.anchorPoint, size: .init(width: 20, height: 20))
        timeLabel.font = UIFont(name: "HVDComicSerifPro", size: 22)
        timeLabel.textColor = .white
        timeView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: timeImage.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timeImage.centerYAnchor)
        ])
        
        // main part of screen
        content.axis = .vertical
        content.alignment = .center
        content.spacing = 40
        stack.addArrangedSubview(content)
        
        // game over message (hidden)
        message.text = "GAME OVER"
        message.font = UIFont(name: "HVDComicSerifPro", size: 52)
        message.textColor = .white
        message.isHidden = true
        content.addArrangedSubview(message)
        
        // prompt for randomly generated number
        let promptView = UIView()
        content.addArrangedSubview(promptView)
        promptView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            promptView.widthAnchor.constraint(equalToConstant: 300),
            promptView.heightAnchor.constraint(equalToConstant: 122)
        ])
        
        // background image of prompt
        let promptImage = UIImageView(image: UIImage(named: "number"))
        promptView.addSubview(promptImage)
        promptImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ promptImage.centerXAnchor.constraint(equalTo: promptView.centerXAnchor) ])
        
        // number on prompt
        promptLabel.frame = CGRect(origin: promptImage.anchorPoint, size: .init(width: 300, height: 100))
        promptLabel.font = UIFont(name: "HVDComicSerifPro", size: 70)
        promptLabel.textColor = .brown
        promptView.addSubview(promptLabel)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            promptLabel.centerXAnchor.constraint(equalTo: promptImage.centerXAnchor),
            promptLabel.centerYAnchor.constraint(equalTo: promptImage.centerYAnchor)
        ])
        
        // input
        input.font = UIFont(name: "HVDComicSerifPro", size: 70)
        input.layer.cornerRadius = 36
        input.layer.borderColor = UIColor.white.cgColor
        input.layer.borderWidth = 2
        input.backgroundColor = .clear
        input.keyboardType = .numberPad
        input.textAlignment = .center
        input.addTarget(self, action: #selector(handleChange(_:)), for: .editingChanged)
        content.addArrangedSubview(input)
        input.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            input.widthAnchor.constraint(equalToConstant: 300),
            input.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // play again button (hidden)
        playAgain.setTitle("Play again", for: .normal)
        playAgain.titleLabel?.font = UIFont(name: "HVDComicSerifPro", size: 22)
        playAgain.setTitleColor(.white, for: .normal)
        playAgain.addTarget(self, action: #selector(reset), for: .touchUpInside)
        content.addArrangedSubview(playAgain)
        
        if view.frame.width > view.frame.height {
            content.axis = .horizontal
            stack.spacing = 120
        }
        else {
            content.axis = .vertical
            stack.spacing = 200
        }
        timer.invalidate()
        reset()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                self.content.axis = .horizontal
                self.stack.spacing = 120
            }
            else {
                self.content.axis = .vertical
                self.stack.spacing = 200
    }})}
    
    @objc func handleChange(_ sender: UITextField) {
        if time >= 60 && !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }
        guard let stringAnswer: String = sender.text else { return }

        guard stringAnswer.count == 4 else { return }

        guard let answer: Int = Int(stringAnswer) else { return }

        game.checkAnswer(answer)
        promptLabel.text = formatDigits(game.prompt)
        input.text = ""
        scoreLabel.text = String(game.score)
    }
    
    @objc func tick() {
        guard time > 1 else {
            timer.invalidate()
            time = 0
            gameOver()
            return
        }
        time -= 1
    }
    
    func formatDigits(_ number: Int) -> String {
        guard number > 9 else { return "000\(number)" }
        guard number > 99 else { return "00\(number)" }
        guard number > 999 else { return "0\(number)" }
        return String(number)
    }
    
    func gameOver() {
        promptLabel.text = String(game.score)
        input.text = ""

        input.isHidden = true

        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.message.isHidden = false
            self.playAgain.isHidden = false
        })
    }
    
    @objc func reset() {
        game = Game()
        time = 60
        scoreLabel.text = "0"
        promptLabel.text = formatDigits(game.prompt)
        
        playAgain.isHidden = true

        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.message.isHidden = true
            self.input.isHidden = false
        })
    }
}

