Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbZKGQiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 11:38:00 -0500
Date: Sat, 7 Nov 2009 14:37:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.32] V4L/DVB fixes
Message-ID: <20091107143757.5a9453dc@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For a couple of fixes:

   - v4l-core: fix use-after-free Oops;
   - Build system: fix build dependency for dib0700 and pt1;
   - Some fixes for panic and oops conditions, on dib0700 and em28xx;
   - An old, hard to notice frame order error at bttv driver (noticed only with certain
     de-interlacing algorithms);
   - Several fixes on drivers (tda18271, gspca, sh_mobile_ceu_camera, pxa_camera, bttv,
	smsusb, s2255, firedtv, pxa-camera, ce6230, uvcvideo and saa7134).

Cheers,
Mauro.

---

 drivers/media/common/tuners/tda18271-fe.c      |    8 ++--
 drivers/media/dvb/dvb-usb/Kconfig              |    2 +-
 drivers/media/dvb/dvb-usb/ce6230.c             |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c    |   15 ++++-----
 drivers/media/dvb/firewire/firedtv-avc.c       |   38 ++++++++++++-----------
 drivers/media/dvb/firewire/firedtv-fe.c        |    8 +----
 drivers/media/dvb/frontends/dib0070.h          |    7 ++++-
 drivers/media/dvb/frontends/dib7000p.c         |    5 +++
 drivers/media/dvb/pt1/pt1.c                    |    1 +
 drivers/media/dvb/siano/smsusb.c               |    6 ++++
 drivers/media/video/bt8xx/bttv-driver.c        |   33 +++++++++++++++++---
 drivers/media/video/em28xx/em28xx-audio.c      |    5 +++
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |   20 ++++++++++++
 drivers/media/video/gspca/mr97310a.c           |    2 +-
 drivers/media/video/gspca/ov519.c              |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c    |    3 +-
 drivers/media/video/pxa_camera.c               |    5 ++-
 drivers/media/video/s2255drv.c                 |    5 ---
 drivers/media/video/saa7134/saa7134-cards.c    |    1 +
 drivers/media/video/saa7134/saa7134-ts.c       |    6 ++-
 drivers/media/video/saa7134/saa7134.h          |    1 +
 drivers/media/video/saa7164/saa7164-cmd.c      |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c     |    4 +-
 drivers/media/video/soc_camera.c               |   16 +++++----
 drivers/media/video/uvc/uvc_ctrl.c             |    2 +-
 drivers/media/video/uvc/uvc_video.c            |    3 +-
 26 files changed, 133 insertions(+), 69 deletions(-)

Devin Heitmueller (1):
      V4L/DVB (13190): em28xx: fix panic that can occur when starting audio streaming

Erik Andrén (3):
      V4L/DVB (13255): gspca - m5602-s5k4aa: Add vflip quirk for the Bruneinit laptop
      V4L/DVB (13256): gspca - m5602-s5k4aa: Add another MSI GX700 vflip quirk
      V4L/DVB (13257): gspca - m5602-s5k4aa: Add vflip for Fujitsu Amilo Xi 2528

Guennadi Liakhovetski (3):
      V4L/DVB (13129): sh_mobile_ceu_camera: fix cropping for scaling clients
      V4L/DVB (13131): pxa_camera: fix camera pixel format configuration
      V4L/DVB (13132): fix use-after-free Oops, resulting from a driver-core API change

HIRANO Takahito (1):
      V4L/DVB (13167): pt1: Fix a compile error on arm

Hans de Goede (1):
      V4L/DVB (13122): gscpa - stv06xx + ov518: dont discard every other frame

Henrik Kurelid (1):
      V4L/DVB (13237): firedtv: length field corrupt in ca2host if length>127

Jean Delvare (1):
      V4L/DVB (13287): ce6230 - saa7164-cmd: Fix wrong sizeof

Jonathan Cameron (1):
      V4L/DVB (13286): pxa-camera: Fix missing sched.h

Laurent Pinchart (2):
      V4L/DVB (13309): uvcvideo: Ignore the FIX_BANDWIDTH for compressed video
      V4L/DVB (13311): uvcvideo: Fix compilation warning with 2.6.32 due to type mismatch with abs()

Martin Samek (1):
      V4L/DVB (13079): dib0700: fixed xc2028 firmware loading kernel oops

Michael Krufky (5):
      V4L/DVB (13048): dib0070: fix build dependency when driver is disabled
      V4L/DVB (13107): tda18271: fix overflow in FM radio frequency calculation
      V4L/DVB (13202): smsusb: add autodetection support for three additional Hauppauge USB IDs
      V4L/DVB (13313): saa7134: add support for FORCE_TS_VALID mode for mpeg ts input
      V4L/DVB (13314): saa7134: set ts_force_val for the Hauppauge WinTV HVR-1150

Mike Isely (3):
      V4L/DVB (13169): bttv: Fix potential out-of-order field processing
      V4L/DVB (13170): bttv: Fix reversed polarity error when switching video standard
      V4L/DVB (13230): s2255drv: Don't conditionalize video buffer completion on waiting processes

Patrick Boettcher (1):
      V4L/DVB (13050): DIB0700: fix-up USB device ID for Terratec/Leadtek

Seth Barry (1):
      V4L/DVB (13109): tda18271: fix signedness issue in tda18271_rf_tracking_filters_init

Stefan Richter (1):
      V4L/DVB (13240): firedtv: fix regression: tuning fails due to bogus error return

Theodore Kilgore (1):
      V4L/DVB (13264): gspca_mr97310a: Change vstart for CIF sensor type 1 cams

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
