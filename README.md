# touch-manga-mpv
mpv script intended to be used alongside https://github.com/Dudemanguy/mpv-manga-reader

# Install
1. Download touch.lua from above
2. Add to your `scripts` directory (create one if it doesn't exist)
3. Add this to your `mpv.conf` (create one if it doesn't exist)
```
[Manga]
profile-desc="Read Manga"
profile-cond=filename and filename:match('%.cbz$') or filename:match('%.cbr$') or filename:match('%.zip$') or filename:match('%.rar$') ~= nil
no-osc
no-window-dragging
native-touch=yes
```
# Gestures
- Tap left - prev page
- Tap right - next page
- Swipe up - first page (of file)
- Swipe down - last page (of file)
- Two finger swipe up - increase black level
- Two finger swipe down - decrease black level
- 2x Two finger swipe down (rapid) - exit mpv
