import UIKit

class ViewController: UIViewController {
    private var isFullScreen = false

    private lazy var videoPlayer: VideoPlayerViewController = {
        let videoPlayer = VideoPlayerViewController()
        videoPlayer.view.translatesAutoresizingMaskIntoConstraints = false
        videoPlayer.inject(onActionButtonTapped: switchScreen)
        return videoPlayer
    }()

    private lazy var playerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var windowConstraints: [NSLayoutConstraint] = [
        playerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
        playerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        playerContainerView.heightAnchor.constraint(equalToConstant: 405),
        playerContainerView.widthAnchor.constraint(equalToConstant: 720),
    ]

    private lazy var fullScreenConstraints: [NSLayoutConstraint] = [
        playerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
        playerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        playerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        playerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ]

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        isFullScreen ? [playerContainerView] : [stackView]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        play()
    }

    private func setupUI() {
        setupBackgroundView()
        addStackView()
        addPlayerContainerView()
    }

    private func play() {
        videoPlayer.play()
    }

    private func switchScreen() {
        isFullScreen.toggle()

        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            if isFullScreen {
                NSLayoutConstraint.deactivate(windowConstraints)
                NSLayoutConstraint.activate(fullScreenConstraints)
            } else {
                NSLayoutConstraint.deactivate(fullScreenConstraints)
                NSLayoutConstraint.activate(windowConstraints)
            }
            view.layoutIfNeeded()
        }, completion: { [unowned self] _ in
            view.setNeedsFocusUpdate()
            view.updateFocusIfNeeded()
        })
    }

    @objc private func buttonTapped() {
        switchScreen()
    }

    @objc private func seekButtonTapped() {
        videoPlayer.seek(value: 10)
    }
    
    @objc private func backToLiveButtonTapped() {
        videoPlayer.seek(value: 0)
    }
}

private extension ViewController {
    func setupBackgroundView() {
        view.backgroundColor = .gray
    }

    func addStackView() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 900),
            stackView.heightAnchor.constraint(equalToConstant: 100),
        ])

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("FULL SCREEN", for: .normal)
        button.setTitleColor(.black, for: .focused)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(buttonTapped), for: UIControl.Event.primaryActionTriggered)
        stackView.addArrangedSubview(button)

        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.setTitle("SEEK BACK 10s", for: .normal)
        button2.setTitleColor(.black, for: .focused)
        button2.backgroundColor = .darkGray
        button2.addTarget(self, action: #selector(seekButtonTapped), for: UIControl.Event.primaryActionTriggered)
        stackView.addArrangedSubview(button2)

        let button3 = UIButton()
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.setTitle("BACK TO LIVE", for: .normal)
        button3.setTitleColor(.black, for: .focused)
        button3.backgroundColor = .darkGray
        button3.addTarget(self, action: #selector(backToLiveButtonTapped), for: UIControl.Event.primaryActionTriggered)
        stackView.addArrangedSubview(button3)
    }

    func addPlayerContainerView() {
        view.addSubview(playerContainerView)
        NSLayoutConstraint.activate(windowConstraints)

        addChild(videoPlayer)
        videoPlayer.didMove(toParent: self)
        playerContainerView.addSubview(videoPlayer.view)

        NSLayoutConstraint.activate(
            [
                videoPlayer.view.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor),
                videoPlayer.view.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
                videoPlayer.view.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor),
                videoPlayer.view.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor),
            ]
        )
    }
}
