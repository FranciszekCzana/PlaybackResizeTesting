# PlaybackResizeTesting
Small project showing the behavior of application after Live stream being resized.

## Reproduce steps
- Wait for video to be started
- Click on one of buttons, player should resize to the fullscreen
- Use transport bar to seek on to the some moment in the past (Just not to the head - LIVE badge should be grey)
- Use customMenuItem on transportBar to resize player to the window
- Try to change focus on bottom buttons, app is barely likely to respond

## Notes
- We were not able to reproduce issue while LIVE stream is on its head (with LIVE badge red on the top-left corner)
- The sample LIVE Stream I've just found over the Internet but from time to time it has problems with loading.
- This is not every time that above steps will make the hangs and app freeze but it's quite often
  
## Application Content
It contains only a couple of elements:

`VideoPlayerViewController` - contains `AVPlayerViewController` and handles action on `transportBarCustomMenuItems`.
On given action player goes back to the "window" mode.

`ViewController` contains VideoPlayerViewController and a simple StackView with three UIButtons.
Each UIButton's action does the same - resizing player to the full screen.
There are three of them to determine whenever after resize UI is responsive or hangs were occurred.

## Attachments
`PlaybackResizeTesting Sample.mp4` - video showing the app behavior. From 0:18 app is barely likely to respond due to hangs
`PlaybackResizeTesting TimeProfiler.trace` - TimeProfiler using the instruments showing the hangs where we've spotted that the most time cosnuming call is `layoutSubviews()` on `AVNowPlayingTransportBar`
