Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43426 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877AbZFWGmu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 02:42:50 -0400
Date: Tue, 23 Jun 2009 03:42:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.31] V4L/DVB updates
Message-ID: <20090623034212.2f9183c6@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For yet another series of improvements. 

Probably one of the most more visible to the users is the support 
for Logitech cameras based on stv06xx chipset. This also removes the 
driver need for merging a few out-of-tree driver for those cameras.

With the improvements on gspca, we'll get rid of two V4L1 only drivers 
on some future version. I'll later update the 
Documentation/feature-removal-schedule.txt to reflect those changes.

The rest of the series are bug fixes, a few api improvements for 
embedded, and usual new board additions. The full log is enclosed.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.cx88            |    6 +-
 Documentation/video4linux/CARDLIST.em28xx          |    1 +
 Documentation/video4linux/v4l2-framework.txt       |   24 +
 drivers/media/common/ir-keymaps.c                  |   23 +
 drivers/media/dvb/frontends/stv0900.h              |    7 +-
 drivers/media/dvb/frontends/stv0900_core.c         |  100 ++-
 drivers/media/dvb/frontends/stv0900_priv.h         |    2 +
 drivers/media/dvb/frontends/stv090x.c              |   11 +-
 drivers/media/dvb/frontends/tda10048.c             |    1 +
 drivers/media/dvb/siano/smscoreapi.c               |    4 +-
 drivers/media/radio/radio-tea5764.c                |    4 +-
 drivers/media/video/Kconfig                        |    6 +-
 drivers/media/video/cx18/cx18-controls.c           |    2 +
 drivers/media/video/cx231xx/cx231xx-avcore.c       |   19 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |   26 +-
 drivers/media/video/cx231xx/cx231xx.h              |    3 -
 drivers/media/video/cx2341x.c                      |    2 +
 drivers/media/video/cx23885/cx23885-dvb.c          |   33 +-
 drivers/media/video/cx23885/cx23885-video.c        |   11 +-
 drivers/media/video/cx88/cx88-cards.c              |   94 ++-
 drivers/media/video/cx88/cx88-video.c              |   11 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   56 ++
 drivers/media/video/em28xx/em28xx-dvb.c            |    1 +
 drivers/media/video/em28xx/em28xx-video.c          |   38 +-
 drivers/media/video/em28xx/em28xx.h                |    1 +
 drivers/media/video/gspca/gspca.c                  |    8 +-
 drivers/media/video/gspca/ov519.c                  |  981 ++++++++++++++++++--
 drivers/media/video/gspca/sonixj.c                 |  181 +++-
 drivers/media/video/gspca/stv06xx/Makefile         |    3 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   53 +-
 drivers/media/video/gspca/stv06xx/stv06xx.h        |   11 +
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |   10 +-
 drivers/media/video/gspca/stv06xx/stv06xx_sensor.h |    3 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |  453 +++++++++
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.h |   59 ++
 drivers/media/video/ivtv/ivtv-controls.c           |    2 +
 drivers/media/video/mt9m001.c                      |   12 +-
 drivers/media/video/mt9t031.c                      |   14 +-
 drivers/media/video/mt9v022.c                      |   12 +-
 drivers/media/video/ov511.c                        |    2 -
 drivers/media/video/pvrusb2/pvrusb2-audio.c        |   14 +-
 drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c     |   24 +-
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c  |   37 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   60 +-
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c    |   35 +-
 drivers/media/video/pxa_camera.c                   |   34 +-
 drivers/media/video/saa7134/saa7134-video.c        |   11 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   12 +-
 drivers/media/video/tcm825x.c                      |    4 +-
 drivers/media/video/usbvideo/Kconfig               |    5 +-
 drivers/media/video/v4l2-common.c                  |  181 ++++-
 drivers/media/video/vivi.c                         |   11 +-
 drivers/media/video/w9968cf.c                      |   35 +-
 drivers/media/video/zoran/zoran_driver.c           |   14 +-
 include/linux/videodev2.h                          |    4 +-
 include/media/ir-common.h                          |    2 +
 include/media/v4l2-common.h                        |   26 +
 include/media/v4l2-i2c-drv.h                       |    5 +-
 include/media/v4l2-subdev.h                        |    7 +-
 59 files changed, 2322 insertions(+), 489 deletions(-)
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_st6422.h

Abylay Ospan (2):
      V4L/DVB (12096): Bug fix: stv0900 register read must using i2c in one transaction
      V4L/DVB (12097): Implement reading uncorrected blocks for stv0900

Devin Heitmueller (3):
      V4L/DVB (12100): em28xx: make sure the analog GPIOs are set if we used a card hint
      V4L/DVB (12101): em28xx: add support for EVGA inDtube
      V4L/DVB (12102): em28xx: add Remote control support for EVGA inDtube

Hans Verkuil (8):
      V4L/DVB (12104): ivtv/cx18: fix regression: class controls are no longer seen
      V4L/DVB (12107): smscoreapi: fix compile warning
      V4L/DVB (12108): v4l2-i2c-drv.h: add comment describing when not to use this header.
      V4L/DVB (12109): radio-tea5764: fix incorrect rxsubchans value
      V4L/DVB (12111): tcm825x: remove incorrect __exit_p wrapper
      V4L/DVB (12112): cx231xx: fix uninitialized variable.
      V4L/DVB (12125): v4l2: add new s_config subdev ops and v4l2_i2c_new_subdev_cfg/board calls
      V4L/DVB (12128): v4l2: update framework documentation.

Hans de Goede (23):
      V4L/DVB (12071): gspca: fix NULL pointer deref in query_ctrl
      V4L/DVB (12072): gspca-ov519: add extra controls
      V4L/DVB (12073): gspca_ov519: limit ov6630 qvif uv swap fix to ov66308AF
      V4L/DVB (12074): gspca_ov519: Add 320x240 and 160x120 support for cif sensor cams
      V4L/DVB (12075): gspca_ov519: check ov518 packet numbers
      V4L/DVB (12076): gspca_ov519: Fix led inversion with some cams
      V4L/DVB (12077): gspca_ov519: Fix 320x240 with ov7660 sensor
      V4L/DVB (12078): gspca_ov519: Better default contrast for ov6630
      V4L/DVB (12079): gspca_ov519: add support for the ov511 bridge
      V4L/DVB (12080): gspca_ov519: Fix ov518+ with OV7620AE (Trust spacecam 320)
      V4L/DVB (12081): gspca_ov519: Cleanup some sensor special cases
      V4L/DVB (12082): gspca_stv06xx: Add support for st6422 bridge and sensor
      V4L/DVB (12083): ov511: remove ov518 usb id's from the driver
      V4L/DVB (12084): ov511: mark as deprecated
      V4L/DVB (12085): gspca_ov519: constify ov518 inititial register value tables
      V4L/DVB (12086): gspca_sonixj: Fix control index numbering
      V4L/DVB (12087): gspca_sonixj: enable support for 0c45:613e camera
      V4L/DVB (12088): Mark the v4l1 uvcvideo quickcam messenger driver as deprecated
      V4L/DVB (12089): gspca_sonixj: increase 640x480 frame-buffersize
      V4L/DVB (12090): gspca_sonixj: enable autogain control for the ov7620
      V4L/DVB (12091): gspca_sonixj: Add light frequency control
      V4L/DVB (12092): gspca_sonixj + ov7630: invert vflip control instead of changing default
      V4L/DVB (12093): gspca_sonixj: Name saturation control saturation, not color

Igor M. Liplianin (2):
      V4L/DVB (12095): Change lnbh24 configure bits for NetUP card.
      V4L/DVB (12098): Create table for customize stv0900 ts registers.

Manu Abraham (2):
      V4L/DVB (12130): Fix a redundant compiler warning
      V4L/DVB (12131): BUGFIX: An incorrect Carrier Recovery Loop optimization table was being

Mauro Carvalho Chehab (1):
      V4L/DVB (12010): cx88: Properly support Leadtek TV2000 XP Global

Michael Krufky (2):
      V4L/DVB (12115): tda10048: add missing entry to pll_tab for 3.8 MHz IF
      V4L/DVB (12116): cx23885: ensure correct IF freq is used on HVR1200 & HVR1700

Mike Isely (5):
      V4L/DVB (12118): pvrusb2: Fix hardware scaling when used with cx25840
      V4L/DVB (12119): pvrusb2: Re-fix hardware scaling on video standard change
      V4L/DVB (12120): pvrusb2: Change initial default frequency setting
      V4L/DVB (12121): pvrusb2: Improve handling of routing schemes
      V4L/DVB (12122): pvrusb2: De-obfuscate code which handles routing schemes

Trent Piepho (14):
      V4L/DVB (11901): v4l2: Create helper function for bounding and aligning images
      V4L/DVB (11902): pxa-camera: Use v4l bounding/alignment function
      V4L/DVB (11903): sh_mobile_ceu_camera: Use v4l bounding/alignment function
      V4L/DVB (11904): zoran: Use v4l bounding/alignment functiob
      V4L/DVB (11905): vivi: Use v4l bounding/alignment function
      V4L/DVB (11906): saa7134: Use v4l bounding/alignment function
      V4L/DVB (11907): cx88: Use v4l bounding/alignment function
      V4L/DVB (11908): w8968cf: Use v4l bounding/alignment function
      V4L/DVB (11909): cx23885: Use v4l bounding/alignment function
      V4L/DVB (11910): mt9: Use v4l bounding/alignment function
      V4L/DVB (11911): cx231xx: Use v4l bounding/alignment function
      V4L/DVB (11912): em28xx: Use v4l bounding/alignment function
      V4L/DVB (11913): cx231xx: TRY_FMT should not actually set anything
      V4L/DVB (12003): v4l2: Move bounding code outside I2C ifdef block

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
