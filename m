Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1CL3N3k005667
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 16:03:24 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1CL2khJ013442
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 16:02:52 -0500
Date: Tue, 12 Feb 2008 19:02:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080212190235.4e86baf8@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org,
	Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
master

For the following fixes:

   - bug #9699: radio-sf16fmr2: fix request_region() validation;
   - bug #9833 when building V4L without I2C;
   - bug #9887: tda10086: make the 22kHz tone for DISEQC a config option;
   - Warning fix: Remove sound/driver.h;
   - zr364xx: trivial board additions and fix at docs;
   - saa7134: trivial board addition and detection, fix for md2819;
   - tcm825x: - fix logical typo error;
   - stkwebcam and radio-si470x (newer drivers for 2.6.25): some fixes and 
     cleanups;
   - radio-sf16fmi: fix request_region();
   - saa7134-dvb: add missing dvb_attach call (for tda10046_attach);
   - frontends/tda18271-common.c: fix off-by-one;
   - tuner-core.c:make tuner_list static;
   - budget-av: trival board additions;
   - dvb-ttpci: Improved display of still pictures;
   - videobuf: lock fixes;
   - saa7134-empress: Remove wrong lock;
   - em28xx: trivial board addition, audio fixes and other misc fixes;
   - videobuf-vmalloc: fix typo on a function name;
   - tveeprom: Add proper tuner mapping for hauppauge eeprom id 133
   - cx88-mpeg: Allow concurrent access to cx88-mpeg devices;

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.em28xx     |    2 +-
 Documentation/video4linux/CARDLIST.saa7134    |    6 +-
 Documentation/video4linux/zr364xx.txt         |    4 +-
 drivers/media/Kconfig                         |   16 +-
 drivers/media/common/Kconfig                  |    2 +-
 drivers/media/common/ir-keymaps.c             |   46 ++
 drivers/media/common/saa7146_vbi.c            |    1 -
 drivers/media/common/saa7146_video.c          |    2 -
 drivers/media/dvb/bt8xx/bt878.c               |   23 +-
 drivers/media/dvb/dvb-usb/ttusb2.c            |    1 +
 drivers/media/dvb/frontends/tda10086.c        |   28 +-
 drivers/media/dvb/frontends/tda10086.h        |    3 +
 drivers/media/dvb/frontends/tda18271-common.c |    2 +-
 drivers/media/dvb/ttpci/av7110_av.c           |   15 +-
 drivers/media/dvb/ttpci/budget-av.c           |    8 +
 drivers/media/dvb/ttpci/budget.c              |    1 +
 drivers/media/radio/Kconfig                   |    4 +-
 drivers/media/radio/radio-sf16fmi.c           |    1 +
 drivers/media/radio/radio-sf16fmr2.c          |    5 +-
 drivers/media/radio/radio-si470x.c            |  597 +++++++++++++++----------
 drivers/media/video/Kconfig                   |    4 +-
 drivers/media/video/Makefile                  |    5 +-
 drivers/media/video/bt8xx/bttv-driver.c       |   50 +--
 drivers/media/video/bt8xx/bttv-vbi.c          |    4 +-
 drivers/media/video/cx88/cx88-mpeg.c          |   16 +-
 drivers/media/video/cx88/cx88.h               |    1 +
 drivers/media/video/em28xx/em28xx-audio.c     |    6 +-
 drivers/media/video/em28xx/em28xx-cards.c     |    8 +-
 drivers/media/video/em28xx/em28xx-core.c      |  111 +++--
 drivers/media/video/em28xx/em28xx-video.c     |   79 +++-
 drivers/media/video/em28xx/em28xx.h           |    5 +-
 drivers/media/video/saa7134/saa7134-cards.c   |  123 +++++-
 drivers/media/video/saa7134/saa7134-dvb.c     |   28 +-
 drivers/media/video/saa7134/saa7134-empress.c |    6 +-
 drivers/media/video/saa7134/saa7134-input.c   |    6 +
 drivers/media/video/saa7134/saa7134-video.c   |   20 +-
 drivers/media/video/saa7134/saa7134.h         |    2 +
 drivers/media/video/stk-sensor.c              |   23 +-
 drivers/media/video/stk-webcam.c              |  104 ++++-
 drivers/media/video/stk-webcam.h              |    3 +-
 drivers/media/video/tcm825x.c                 |    2 +-
 drivers/media/video/tuner-core.c              |    2 +-
 drivers/media/video/tvaudio.c                 |   10 +-
 drivers/media/video/tveeprom.c                |    2 +-
 drivers/media/video/v4l2-common.c             |  393 ++---------------
 drivers/media/video/videobuf-core.c           |   78 ++--
 drivers/media/video/videobuf-dma-sg.c         |    4 +-
 drivers/media/video/videobuf-vmalloc.c        |   20 +-
 drivers/media/video/videodev.c                |  444 ++++++++++++++++---
 drivers/media/video/zr364xx.c                 |    2 +
 include/media/ir-common.h                     |    1 +
 include/media/v4l2-common.h                   |    2 -
 include/media/v4l2-dev.h                      |    2 +
 include/media/videobuf-core.h                 |    2 +-
 include/media/videobuf-vmalloc.h              |    2 +-
 55 files changed, 1430 insertions(+), 907 deletions(-)

Adrian Bunk (5):
      V4L/DVB (7100): frontends/tda18271-common.c: fix off-by-one
      V4L/DVB (7102): make tuner-core.c:tuner_list static
      V4L/DVB (7103): make stk_camera_cleanup() static
      V4L/DVB (7104): stk-sensor.c: make 2 functions static
      V4L/DVB (7106): em28xx/: make 2 functions static

Adrian Pardini (1):
      V4L/DVB (7192): Adds support for Genius TVGo A11MCE

Akinobu Mita (1):
      V4L/DVB (7076): bt878: include KERN_ facility level

Andrew Morton (1):
      V4L/DVB (7156): em28xx/em28xx-core.c: fix use of potentially
uninitialized variable

Antoine Jacquet (3):
      V4L/DVB (7079): zr364xx: fix typo in documentation
      V4L/DVB (7080): zr364xx: add support for Pentax Optio 50
      V4L/DVB (7081): zr364xx: add support for Creative DiVi CAM 516

Brandon Philips (1):
      V4L/DVB (7150): [v4l] convert videbuf_vmalloc_memory to
videobuf_vmalloc_memory

Cyrill Gorcunov (1):
      V4L/DVB (7086): driver: tcm825x - fix logical typo error

Douglas Schilling Landgraf (1):
      V4L/DVB (7092): radio-sf16fmr2: fix request_region() validation [bugzilla
9699]

Hartmut Hackmann (1):
      V4L/DVB (7186): tda10086: make the 22kHz tone for DISEQC a config option

Hermann Pitton (4):
      V4L/DVB (7082): support for Twinhan Hybrid DTV-DVB 3056 PCI
      V4L/DVB (7083): saa7134: enable radio and external analog audio-in on the
md2819 V4L/DVB (7084): saa7134: add support for the Medion / Creatix CTX948 card
      V4L/DVB (7085): saa7134: detect the LifeView FlyDVB-T Hybrid Mini PCI

Jaime Velasco Juan (3):
      V4L/DVB (7088): V4L: stkwebcam: Add support for YUYV format
      V4L/DVB (7089): V4L: stkwebcam: Power management support
      V4L/DVB (7090): V4L: stkwebcam: use v4l_compat_ioctl32

Kim Sandberg (1):
      V4L/DVB (7117): budget-av: Add support for Satelco EasyWatch PCI DVB-T

Luc Saillard (1):
      V4L/DVB (7132): Add USB ID for a newer variant of Hauppauge WinTV-HVR 900

Matthias Schwarzott (1):
      V4L/DVB (7097): saa7134-dvb: add missing dvb_attach call (for
tda10046_attach)

Mauro Carvalho Chehab (16):
      V4L/DVB (7115): Fix bug #9833: regression when compiling V4L without I2C
      V4L/DVB (7119): Remove obsolete code from v4l2-common
      V4L/DVB (7133): Fix Kconfig dependencies
      V4L/DVB (7049): Remove sound/driver.h
      V4L/DVB (7093): radio-sf16fmi: fix request_region()
      V4L/DVB (7120): videobuf lock is already initialized at videobuf-core.c
      V4L/DVB (7121): Renames videobuf lock to vb_lock
      V4L/DVB (7122): saa7134-empress: Remove back lock
      V4L/DVB (7158): Fix em28xx audio initialization
      V4L/DVB (7160): em28xx: Allow register dump/setting for debug
      V4L/DVB (7161): em28xx: Fix printing debug values higher than 127
      V4L/DVB (7162): em28xx: Fix endian and returns the correct values
      V4L/DVB (7163): em28xx: makes audio settings more stable
      V4L/DVB (7164): em28xx-alsa: Add a missing mutex
      V4L/DVB (7179): Allow more than one em28xx board
      V4L/DVB (7180): em28xx: add URB_NO_TRANSFER_DMA_MAP, since
urb->transfer_dma is set

Michael Krufky (1):
      V4L/DVB (7183): radio-si470x: fix build warning

Oliver Endriss (2):
      V4L/DVB (7116): budget-av: Add support for KNC TV Station Plus X4
      V4L/DVB (7118): dvb-ttpci: Improved display of still pictures

Ricardo Cerqueira (1):
      V4L/DVB (7193): tveeprom: Add proper tuner mapping for hauppauge eeprom
id 133

Roel Kluin (1):
      V4L/DVB (7139): add parentheses

Roland Stoll (1):
      V4L/DVB (7194): cx88-mpeg: Allow concurrent access to cx88-mpeg devices

Tobias Lorenz (5):
      V4L/DVB (7091): radio-si470x improvements and seldom problem fixed in
tuning functions V4L/DVB (7108): radio-si470x.c: check-after-use
      V4L/DVB (7110): Trivial printf warning fix (radio-si470)
      V4L/DVB (7188): radio-si470x version 1.0.6
      V4L/DVB (7189): autosuspend support

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
