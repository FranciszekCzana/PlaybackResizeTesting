# PlaybackResizeTesting
Small project showing the behavior of application after Live stream being resized.

## Reproduce steps
- Wait for video to be started
- Click on SEEK BACK 10s button, player should go back behind 10 seconds of its LIVE state
- Click on FULL SCREEN button, player should resize to the fullscreen
- Press Menu/Back gesture on remote, player should resize back to minimized window
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
First button resizes player to the full screen.
Second button seeks back player's by 10 seconds from its live state.
Third button brings player up to its live state.

## Attachments
`PlaybackResizeTesting Sample.mp4` - video showing the app behavior. From 0:18 app is barely likely to respond due to hangs

`PlaybackResizeTesting TimeProfiler.trace` - TimeProfiler using the instruments showing the hangs where we've spotted that the most time cosnuming call is `layoutSubviews()` on `AVNowPlayingTransportBar`
