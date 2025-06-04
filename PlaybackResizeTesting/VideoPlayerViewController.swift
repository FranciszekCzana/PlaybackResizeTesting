import AVKit
import AVFoundation
import Foundation

final class VideoPlayerViewController: UIViewController {
    var onActionButtonTapped: (() -> Void)?

    private lazy var backActionRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBackActionTap(gesture:)))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        return tapRecognizer
    }()

    private lazy var playerController: AVPlayerViewController = {
        let videoPlayer = AVPlayerViewController()

        videoPlayer.view.frame = view.frame
        videoPlayer.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoPlayer.player = player

        addChild(videoPlayer)
        view.addSubview(videoPlayer.view)

        return videoPlayer
    }()

    private lazy var player: AVPlayer = {
        let videoUrl = URL(string: "https://ireplay.tv/test/blender.m3u8")!
        let player = AVPlayer(url: videoUrl)
        return player
    }()

    func inject(onActionButtonTapped: @escaping () -> Void) {
        self.onActionButtonTapped = onActionButtonTapped
    }

    func play() {
        loadViewIfNeeded()

        view.addGestureRecognizer(backActionRecognizer)

        addTransportBarAction()
        player.currentItem?.externalMetadata = createMetadataItems()
        player.play()
    }

    func seek(value: Double) {

        guard
            let currentItem = player.currentItem,
            let lastRangeValue = currentItem.seekableTimeRanges.last
        else {
            return
        }

        let lastRange = lastRangeValue.timeRangeValue
        let liveEdgeTime = CMTimeRangeGetEnd(lastRange)

        let targetTime = CMTimeSubtract(
            liveEdgeTime,
            CMTime(seconds: value, preferredTimescale: liveEdgeTime.timescale))

        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    private func addTransportBarAction() {
        let action = UIAction(
            image: UIImage(systemName: "rectangle.on.rectangle")
        ) { [weak self] _ in
            self?.onActionButtonTapped?()
        }

        playerController.transportBarCustomMenuItems = [action]
//        playerController.showsPlaybackControls = false
        playerController.playbackControlsIncludeTransportBar = false
        playerController.playbackControlsIncludeInfoViews = false
    }

    private func createMetadataItems() -> [AVMetadataItem] {
        [
            AVMetadataIdentifier.commonIdentifierTitle: "Title",
            .iTunesMetadataTrackSubTitle: "Subtitle",
            .commonIdentifierDescription: "Description",
        ].map { createMetadataItem(for: $0, value: $1) }
    }

    private func createMetadataItem(
        for identifier: AVMetadataIdentifier,
        value: Any
    ) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }

    @objc private func handleBackActionTap(gesture: UITapGestureRecognizer) {
        guard gesture.state == UIGestureRecognizer.State.ended else { return }
        onActionButtonTapped?()
    }
}
