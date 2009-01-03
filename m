Return-path: <video4linux-list-bounces@redhat.com>
Date: Sat, 3 Jan 2009 11:51:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20090103115109.329b126f@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.29] V4L/DVB updates and fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following:

   - a few more improvements at v4l2 core:
	- v4l2 file operations are now handled at core;
	- don't build v4l2-compat32 when not needed;
	- some minor fixes and docs updates;
   - dvb core:
	- Add an extra flag to indicate that a driver is capable of handling DVB-S2;
	- add DVB_DEVICE_TYPE= to uevent
   - add radio driver for tea5764;
   - Kbuild fix for cx24116 and ttusb;
   - some driver fixes, board additions and improvements on gp8psk, cx23885, zl10353, saa7134,
     em28xx, tuner-simple, dsbr100, sms1xxx and bttv;

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.saa7134      |    1 +
 Documentation/video4linux/si470x.txt            |    1 +
 Documentation/video4linux/v4l2-framework.txt    |   19 +-
 drivers/media/common/saa7146_fops.c             |   21 +-
 drivers/media/common/saa7146_video.c            |    5 +-
 drivers/media/common/tuners/tuner-simple.c      |   16 +-
 drivers/media/dvb/dvb-core/dvbdev.c             |    3 +-
 drivers/media/dvb/dvb-usb/gp8psk.c              |    2 +-
 drivers/media/dvb/frontends/cx24116.c           |    1 +
 drivers/media/dvb/frontends/cx24116.h           |    3 +-
 drivers/media/dvb/frontends/stb0899_drv.c       |    1 +
 drivers/media/dvb/frontends/zl10353.c           |    7 +
 drivers/media/dvb/siano/sms-cards.c             |   19 +-
 drivers/media/dvb/ttpci/av7110_v4l.c            |    4 +-
 drivers/media/dvb/ttpci/budget-av.c             |    2 +-
 drivers/media/dvb/ttusb-budget/Kconfig          |    2 +-
 drivers/media/dvb/ttusb-dec/Kconfig             |    2 +-
 drivers/media/radio/Kconfig                     |   19 +
 drivers/media/radio/Makefile                    |    1 +
 drivers/media/radio/dsbr100.c                   |   14 +-
 drivers/media/radio/radio-aimslab.c             |   10 +-
 drivers/media/radio/radio-aztech.c              |   10 +-
 drivers/media/radio/radio-cadet.c               |   10 +-
 drivers/media/radio/radio-gemtek-pci.c          |   10 +-
 drivers/media/radio/radio-gemtek.c              |   10 +-
 drivers/media/radio/radio-maestro.c             |   10 +-
 drivers/media/radio/radio-maxiradio.c           |   10 +-
 drivers/media/radio/radio-mr800.c               |   14 +-
 drivers/media/radio/radio-rtrack2.c             |   10 +-
 drivers/media/radio/radio-sf16fmi.c             |   10 +-
 drivers/media/radio/radio-sf16fmr2.c            |   10 +-
 drivers/media/radio/radio-si470x.c              |   14 +-
 drivers/media/radio/radio-tea5764.c             |  634 +++++++++++++++++++++++
 drivers/media/radio/radio-terratec.c            |   10 +-
 drivers/media/radio/radio-trust.c               |   10 +-
 drivers/media/radio/radio-typhoon.c             |   10 +-
 drivers/media/radio/radio-zoltrix.c             |   10 +-
 drivers/media/video/Makefile                    |    5 +-
 drivers/media/video/arv.c                       |   14 +-
 drivers/media/video/bt8xx/bttv-driver.c         |   30 +-
 drivers/media/video/bw-qcam.c                   |   14 +-
 drivers/media/video/c-qcam.c                    |   14 +-
 drivers/media/video/cafe_ccic.c                 |   16 +-
 drivers/media/video/cpia.c                      |   14 +-
 drivers/media/video/cpia2/cpia2_v4l.c           |   16 +-
 drivers/media/video/cs5345.c                    |   13 +-
 drivers/media/video/cs53l32a.c                  |    2 +-
 drivers/media/video/cx18/cx18-fileops.c         |    6 +-
 drivers/media/video/cx18/cx18-fileops.h         |    4 +-
 drivers/media/video/cx18/cx18-i2c.c             |   28 +-
 drivers/media/video/cx18/cx18-i2c.h             |    1 -
 drivers/media/video/cx18/cx18-ioctl.c           |   49 +--
 drivers/media/video/cx18/cx18-ioctl.h           |    2 +-
 drivers/media/video/cx18/cx18-streams.c         |   13 +-
 drivers/media/video/cx23885/cx23885-417.c       |   15 +-
 drivers/media/video/cx23885/cx23885-video.c     |   22 +-
 drivers/media/video/cx25840/cx25840-core.c      |   13 +-
 drivers/media/video/cx88/cx88-blackbird.c       |   13 +-
 drivers/media/video/cx88/cx88-mpeg.c            |    3 +-
 drivers/media/video/cx88/cx88-video.c           |   27 +-
 drivers/media/video/cx88/cx88.h                 |    2 +-
 drivers/media/video/em28xx/em28xx-audio.c       |   91 ++--
 drivers/media/video/em28xx/em28xx-core.c        |    3 +-
 drivers/media/video/em28xx/em28xx-reg.h         |    2 +-
 drivers/media/video/em28xx/em28xx-video.c       |   44 +-
 drivers/media/video/em28xx/em28xx.h             |    4 +-
 drivers/media/video/et61x251/et61x251_core.c    |   20 +-
 drivers/media/video/gspca/gspca.c               |   12 +-
 drivers/media/video/hexium_gemini.c             |    2 +-
 drivers/media/video/hexium_orion.c              |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c          |    7 +-
 drivers/media/video/ivtv/ivtv-fileops.c         |    4 +-
 drivers/media/video/ivtv/ivtv-fileops.h         |    4 +-
 drivers/media/video/ivtv/ivtv-ioctl.c           |   25 +-
 drivers/media/video/ivtv/ivtv-streams.c         |    8 +-
 drivers/media/video/m52790.c                    |   13 +-
 drivers/media/video/meye.c                      |   12 +-
 drivers/media/video/msp3400-driver.c            |    4 +-
 drivers/media/video/mt9m001.c                   |   19 +-
 drivers/media/video/mt9m111.c                   |   19 +-
 drivers/media/video/mt9t031.c                   |   18 +-
 drivers/media/video/mt9v022.c                   |   19 +-
 drivers/media/video/mxb.c                       |    2 +-
 drivers/media/video/omap24xxcam.c               |    9 +-
 drivers/media/video/ov511.c                     |   16 +-
 drivers/media/video/ov7670.c                    |    2 +-
 drivers/media/video/ov772x.c                    |    7 +-
 drivers/media/video/pms.c                       |   14 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c       |   11 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h       |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c      |   29 +-
 drivers/media/video/pwc/pwc-ctrl.c              |    4 +-
 drivers/media/video/pwc/pwc-if.c                |   20 +-
 drivers/media/video/pwc/pwc-v4l.c               |    2 +-
 drivers/media/video/pwc/pwc.h                   |    4 +-
 drivers/media/video/s2255drv.c                  |   12 +-
 drivers/media/video/saa5246a.c                  |   13 +-
 drivers/media/video/saa5249.c                   |   16 +-
 drivers/media/video/saa7115.c                   |   13 +-
 drivers/media/video/saa7127.c                   |   13 +-
 drivers/media/video/saa7134/saa6752hs.c         |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c     |   44 ++-
 drivers/media/video/saa7134/saa7134-dvb.c       |   18 +
 drivers/media/video/saa7134/saa7134-empress.c   |   23 +-
 drivers/media/video/saa7134/saa7134-input.c     |    1 +
 drivers/media/video/saa7134/saa7134-video.c     |   23 +-
 drivers/media/video/saa7134/saa7134.h           |    1 +
 drivers/media/video/saa717x.c                   |    9 +-
 drivers/media/video/se401.c                     |   14 +-
 drivers/media/video/sn9c102/sn9c102_core.c      |   18 +-
 drivers/media/video/soc_camera.c                |   13 +-
 drivers/media/video/stk-webcam.c                |   10 +-
 drivers/media/video/stradis.c                   |   12 +-
 drivers/media/video/stv680.c                    |   14 +-
 drivers/media/video/tda9840.c                   |    2 +-
 drivers/media/video/tea6415c.c                  |    2 +-
 drivers/media/video/tea6420.c                   |    2 +-
 drivers/media/video/tuner-core.c                |    2 +-
 drivers/media/video/tvaudio.c                   |    2 +-
 drivers/media/video/tvp5150.c                   |   13 +-
 drivers/media/video/tw9910.c                    |    6 +-
 drivers/media/video/upd64031a.c                 |   13 +-
 drivers/media/video/upd64083.c                  |   13 +-
 drivers/media/video/usbvideo/usbvideo.c         |   20 +-
 drivers/media/video/usbvideo/vicam.c            |   16 +-
 drivers/media/video/usbvision/usbvision-video.c |   37 +-
 drivers/media/video/uvc/uvc_v4l2.c              |   14 +-
 drivers/media/video/uvc/uvcvideo.h              |    2 +-
 drivers/media/video/v4l1-compat.c               |  164 +++---
 drivers/media/video/v4l2-common.c               |   29 +-
 drivers/media/video/v4l2-compat-ioctl32.c       |   27 +-
 drivers/media/video/v4l2-dev.c                  |   25 +-
 drivers/media/video/v4l2-ioctl.c                |   36 +-
 drivers/media/video/v4l2-subdev.c               |    2 +-
 drivers/media/video/vino.c                      |   13 +-
 drivers/media/video/vivi.c                      |   12 +-
 drivers/media/video/vp27smpx.c                  |    2 +-
 drivers/media/video/w9966.c                     |   16 +-
 drivers/media/video/w9968cf.c                   |   36 +-
 drivers/media/video/wm8739.c                    |    2 +-
 drivers/media/video/wm8775.c                    |    2 +-
 drivers/media/video/zc0301/zc0301_core.c        |   18 +-
 drivers/media/video/zoran/zoran_driver.c        |   25 +-
 drivers/media/video/zr364xx.c                   |    8 +-
 include/linux/dvb/frontend.h                    |   27 +-
 include/linux/videodev2.h                       |   51 ++-
 include/media/saa7146_vv.h                      |    6 +-
 include/media/soc_camera.h                      |    6 +-
 include/media/v4l2-chip-ident.h                 |    4 +-
 include/media/v4l2-common.h                     |    6 +-
 include/media/v4l2-dev.h                        |   15 +-
 include/media/v4l2-device.h                     |    2 +-
 include/media/v4l2-int-device.h                 |    2 +-
 include/media/v4l2-ioctl.h                      |   31 +-
 include/media/v4l2-subdev.h                     |    8 +-
 include/sound/tea575x-tuner.h                   |    2 +-
 sound/i2c/other/tea575x-tuner.c                 |    6 +-
 157 files changed, 1628 insertions(+), 1105 deletions(-)
 create mode 100644 drivers/media/radio/radio-tea5764.c

Cyrill Gorcunov (1):
      V4L/DVB (10144): cx24116: build fix

Dmitri Belimov (3):
      V4L/DVB (10151): Fix I2C bridge error in zl10353
      V4L/DVB (10152): Change configuration of the Beholder H6 card
      V4L/DVB (10153): Add the Beholder H6 card to DVB-T part of sources.

Fabio Belavenuto (1):
      V4L/DVB (10155): Add TEA5764 radio driver

Hans Verkuil (10):
      V4L/DVB (10132): v4l2-compat-ioctl32: remove dependency on videodev.
      V4L/DVB (10133): v4l2-framework: use correct comment style.
      V4L/DVB (10134): v4l2 doc: set v4l2_dev instead of parent.
      V4L/DVB (10135): v4l2: introduce v4l2_file_operations.
      V4L/DVB (10136): v4l2 doc: update v4l2-framework.txt
      V4L/DVB (10137): v4l2-compat32: only build if needed
      V4L/DVB (10138): v4l2-ioctl: change to long return type to match unlocked_ioctl.
      V4L/DVB (10139): v4l: rename v4l_compat_ioctl32 to v4l2_compat_ioctl32
      V4L/DVB (10140): gp8psk: fix incorrect return code (EINVAL instead of -EINVAL)
      V4L/DVB (10141): v4l2: debugging API changed to match against driver name instead of ID.

Julia Lawall (1):
      V4L/DVB (10171): Use usb_set_intfdata

Kay Sievers (1):
      V4L/DVB (10172): add DVB_DEVICE_TYPE= to uevent

Klaus Schmidinger (2):
      V4L/DVB (10164): Add missing S2 caps flag to S2API
      V4L/DVB (10165): Add FE_CAN_2G_MODULATION flag to frontends that support DVB-S2

Mark Lord (1):
      V4L/DVB (10157): Add USB ID for the Sil4701 radio from DealExtreme

Mauro Carvalho Chehab (5):
      V4L/DVB (10154): saa7134: fix a merge conflict on Behold H6 board
      V4L/DVB (10160): em28xx: update chip id for em2710
      V4L/DVB (10162): tuner-simple: Fix tuner type set message
      V4L/DVB (10163): em28xx: allocate adev together with struct em28xx dev
      V4L/DVB (10166): dvb frontend: stop using non-C99 compliant comments

Michael Krufky (3):
      V4L/DVB (10167): sms1xxx: add support for inverted gpio
      V4L/DVB (10168): sms1xxx: fix inverted gpio for lna control on tiger r2
      V4L/DVB (10170): tuner-simple: prevent possible OOPS caused by divide by zero error

Mike Frysinger (2):
      V4L/DVB (10149): ttusb-budget: make it depend on PCI
      V4L/DVB (10150): ttusb-dec: make it depend on PCI

Pham Thanh Nam (2):
      V4L/DVB (10156): saa7134: Add support for Avermedia AVer TV GO 007 FM Plus
      V4L/DVB (10161): saa7134: fix autodetection for AVer TV GO 007 FM Plus

Udo Steinberg (1):
      V4L/DVB (10173): Missing v4l2_prio_close in radio_release

roel kluin (1):
      V4L/DVB (10148): cx23885: unsigned cx23417_mailbox cannot be negative

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
