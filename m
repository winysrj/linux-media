Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5TABTCx026416
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 06:11:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5TABGTT006924
	for <video4linux-list@redhat.com>; Sun, 29 Jun 2008 06:11:16 -0400
Date: Sun, 29 Jun 2008 07:11:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080629071104.13d8fa0f@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.26] V4L/DVB fixes
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
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For a number of small fixes on drivers:

   - one Kconfig fix;
   - Several fixes at the new drivers for 2.6.26 (cx18, gl861, au0828 and 
     au8522);
   - Driver fixes on em28xx, saa7134, tda18271, pxa-camera, soc-camera, 
     umt-010, tda1004x, tda10023, av7110, stv0299 and xc5000;

And one change at V4L core:
   - A regression fix at videodev standard enumeration: some userspace apps 
     like mplayer weren't capable of support certain video standard 
     variations. We needed to use a different algorithm for std enumeration;

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.au0828     |    2 +-
 drivers/media/common/ir-keymaps.c             |   38 ++++
 drivers/media/common/tuners/tda18271-common.c |   10 +-
 drivers/media/common/tuners/tda18271-fe.c     |   53 ++++--
 drivers/media/common/tuners/xc5000.c          |   30 +++-
 drivers/media/common/tuners/xc5000_priv.h     |    1 -
 drivers/media/dvb/dvb-usb/gl861.c             |   27 +--
 drivers/media/dvb/dvb-usb/umt-010.c           |    2 +-
 drivers/media/dvb/frontends/au8522.c          |   29 +++-
 drivers/media/dvb/frontends/stv0299.c         |   15 +-
 drivers/media/dvb/frontends/tda10023.c        |   20 ++-
 drivers/media/dvb/frontends/tda1004x.c        |   29 +++-
 drivers/media/dvb/ttpci/Kconfig               |    1 +
 drivers/media/dvb/ttpci/av7110_hw.c           |    5 +-
 drivers/media/video/au0828/au0828-cards.c     |   18 ++
 drivers/media/video/cx18/Kconfig              |    4 +-
 drivers/media/video/cx18/cx18-av-core.c       |   73 +++++++-
 drivers/media/video/cx18/cx18-av-core.h       |   16 ++-
 drivers/media/video/cx18/cx18-cards.c         |   84 +++++----
 drivers/media/video/cx18/cx18-cards.h         |   50 +----
 drivers/media/video/cx18/cx18-dvb.c           |   17 ++-
 drivers/media/video/cx18/cx18-gpio.c          |   26 +++-
 drivers/media/video/cx18/cx18-gpio.h          |    1 +
 drivers/media/video/cx18/cx18-i2c.c           |    2 +
 drivers/media/video/cx25840/cx25840-core.c    |    2 +-
 drivers/media/video/cx88/cx88-alsa.c          |    6 +
 drivers/media/video/em28xx/em28xx-audio.c     |   18 ++
 drivers/media/video/em28xx/em28xx-cards.c     |    4 +
 drivers/media/video/em28xx/em28xx-dvb.c       |   10 +
 drivers/media/video/em28xx/em28xx-reg.h       |    1 +
 drivers/media/video/em28xx/em28xx-video.c     |   24 +--
 drivers/media/video/pxa_camera.c              |    4 +-
 drivers/media/video/saa7134/saa7134-alsa.c    |    8 +-
 drivers/media/video/saa7134/saa7134-cards.c   |   56 ++++---
 drivers/media/video/saa7134/saa7134-dvb.c     |   43 ++---
 drivers/media/video/saa7134/saa7134-empress.c |   37 ++--
 drivers/media/video/saa7134/saa7134-input.c   |    9 +
 drivers/media/video/soc_camera.c              |   16 --
 drivers/media/video/videodev.c                |  245 +++++++------------------
 drivers/media/video/vivi.c                    |    7 +-
 include/media/cx25840.h                       |    6 +-
 include/media/ir-common.h                     |    1 +
 include/media/v4l2-dev.h                      |    4 +-
 43 files changed, 608 insertions(+), 446 deletions(-)

Andy Walls (5):
      V4L/DVB (8063): cx18: Fix unintended auto configurations in cx18-av-core
      V4L/DVB (8066): cx18: Fix audio mux input definitions for HVR-1600 Line In 2 and FM radio
      V4L/DVB (8067): cx18: Fix firmware load for case when digital capture happens first
      V4L/DVB (8068): cx18: Add I2C slave reset via GPIO upon initialization
      V4L/DVB (8069): cx18: Fix S-Video and Compsite inputs for the Yuan MPC718 and enable card entry

Antti Palosaari (3):
      V4L/DVB (8012): gl861: sleep a little to avoid I2C errors
      V4L/DVB (8013): gl861: remove useless identify_state
      V4L/DVB (8015): gl861: replace non critical msleep(0) with msleep(1) to be on the safe side

Arjan van de Ven (1):
      V4L/DVB (8108): Fix open/close race in saa7134

Austin Lund (1):
      V4L/DVB (8042): DVB-USB UMT-010 channel scan oops

Devin Heitmueller (4):
      V4L/DVB (8010): em28xx: Properly register extensions for already attached devices
      V4L/DVB (8011): em28xx: enable DVB for HVR-900
      V4L/DVB (8017): Ensure em28xx extensions only get run against devs that support them
      V4L/DVB (8018): Add em2860 chip ID

Dmitri Belimov (1):
      V4L/DVB (8020): Fix callbacks functions of saa7134_empress

Guennadi Liakhovetski (2):
      V4L/DVB (8039): pxa-camera: fix platform_get_irq() error handling.
      V4L/DVB (8040): soc-camera: remove soc_camera_host_class class

Hans Verkuil (3):
      V4L/DVB (8007): cx18/cx25840: the S-Video LUMA input can use all In1-In8 inputs
      V4L/DVB (8008): cx18: remove duplicate audio and video input enums
      V4L/DVB (8092): videodev: simplify and fix standard enumeration

Marcin Slusarz (2):
      V4L/DVB (8022): saa7134: fix race between opening and closing the device
      V4L/DVB (8100): V4L/vivi: fix possible memory leak in vivi_fillbuff

Matthias Schwarzott (1):
      V4L/DVB (8027): saa7134: Avermedia A700: only s-video and composite input are working

Mauro Carvalho Chehab (5):
      V4L/DVB (8004): Fix INPUT dependency at budget-ci
      V4L/DVB (8005): Fix OOPS if frontend is null
      V4L/DVB (8026): Avoids an OOPS if dev struct can't be successfully recovered
      V4L/DVB (8028): Improve error messages for tda1004x attach
      V4L/DVB (8029): Improve error message at tda1004x_attach

Michael Krufky (7):
      V4L/DVB (8034): tda18271: fix IF notch frequency handling
      V4L/DVB (8035): tda18271: dont touch EB14 if rf_cal lookup is out of range
      V4L/DVB (8036): tda18271: toggle rf agc speed mode on TDA18271HD/C2 only
      V4L/DVB (8037): tda18271: ensure that the thermometer is off during channel configuration
      V4L/DVB (8043): au0828: add support for additional USB device id's
      V4L/DVB (8044): au8522: tuning optimizations
      V4L/DVB (8061): cx18: only select tuner / frontend modules if !DVB_FE_CUSTOMISE

Oliver Endriss (4):
      V4L/DVB (8071): tda10023: Fix possible kernel oops during initialisation
      V4L/DVB (8073): av7110: Catch another type of ARM crash
      V4L/DVB (8074): av7110: OSD transfers should not be interrupted
      V4L/DVB (8075): stv0299: Uncorrected block count and bit error rate fixed

Steven Toth (2):
      V4L/DVB (8096): au8522: prevent false-positive lock status
      V4L/DVB (8097): xc5000: check device hardware state to determine if firmware download is needed

Tim Farrington (1):
      V4L/DVB (8048): saa7134: Fix entries for Avermedia A16d and Avermedia E506

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
