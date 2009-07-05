Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbZGEWhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jul 2009 18:37:48 -0400
Date: Sun, 5 Jul 2009 19:37:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Message-ID: <20090705193743.0a8ca7d5@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following bug fixes:

   - v4l2 core: move V4L2_PIX_FMT_SGRBG8 to the proper place;
   - vivi: bug: don't assume that S_STD will be called before streaming;
   - ttpci: config TTPCI_EEPROM depends on I2C;
   - soc_camera: Fix debug output of supported formats count and fix 
	         missing clean up on error path;
   - tuner-xc2028: Fix 7 MHz DVB-T;
   - cx18: Update Yuan MPC-718 card entry with better information and guesses;
   - cx23885: allow rf input path switching on the HVR1275;
   - radio-si470x: fix lock imbalance;
   - em28xx, fix lock imbalance.

There's also a few changes at the dvb get firmware script:
   - get_dvb_firmware: Add Yuan MPC718 MT352 DVB-T "firmware" extraction
   - get_dvb_firmware: Correct errors in MPC718 firmware extraction logic

A trivial board addition to an existing driver:
   - cx18: Add DVB-T support for Yuan MPC-718 cards with an MT352 or ZL10353

And a new webcam sensor driver, with the corresponding fixes on em28xx, 
in order to properly support webcams:

   - Add a driver for mt9v011 sensor;
   - mt9v011: Some fixes at the register initialization table;
   - mt9v011: CodingStyle fixes;
   - mt9v011: properly calculate image resolution registers;
   - mt9v011: let's stick with datasheet values where it works;
   - em28xx: add support for Silvercrest Webcam;
   - em28xx: add other video formats;
   - em28xx: Fix tuning for Terratec Cinergy T XS USB (zl10353 version);
   - em28xx-video: fix VIDIOC_G_FMT and VIDIOC_ENUMFMT with webcams;
   - em28xx: fix webcam usage with different output formats;
   - em28xx: Add autodetection code for Silvercrest 1.3 mpix.

Cheers,
Mauro.

---

 Documentation/dvb/get_dvb_firmware          |   53 ++++-
 Documentation/video4linux/CARDLIST.em28xx   |    1 +
 drivers/media/common/tuners/tuner-xc2028.c  |   13 +-
 drivers/media/dvb/ttpci/Kconfig             |    1 +
 drivers/media/radio/radio-si470x.c          |    5 +-
 drivers/media/video/Kconfig                 |    8 +
 drivers/media/video/Makefile                |    1 +
 drivers/media/video/cx18/cx18-cards.c       |   34 ++-
 drivers/media/video/cx18/cx18-dvb.c         |  160 ++++++++++
 drivers/media/video/cx23885/cx23885-dvb.c   |   30 ++
 drivers/media/video/cx23885/cx23885.h       |    4 +
 drivers/media/video/em28xx/Kconfig          |    2 +
 drivers/media/video/em28xx/em28xx-cards.c   |   84 +++++-
 drivers/media/video/em28xx/em28xx-core.c    |   32 ++-
 drivers/media/video/em28xx/em28xx-dvb.c     |   28 ++-
 drivers/media/video/em28xx/em28xx-i2c.c     |    2 +-
 drivers/media/video/em28xx/em28xx-video.c   |   92 ++++--
 drivers/media/video/em28xx/em28xx.h         |    3 +
 drivers/media/video/gspca/stv06xx/stv06xx.h |    4 -
 drivers/media/video/mt9v011.c               |  431 +++++++++++++++++++++++++++
 drivers/media/video/mt9v011.h               |   35 +++
 drivers/media/video/soc_camera.c            |   12 +-
 drivers/media/video/vivi.c                  |   99 +++---
 include/linux/videodev2.h                   |    2 +
 include/media/v4l2-chip-ident.h             |    3 +
 25 files changed, 1027 insertions(+), 112 deletions(-)
 create mode 100644 drivers/media/video/mt9v011.c
 create mode 100644 drivers/media/video/mt9v011.h

Andy Walls (5):
      V4L/DVB (12167): tuner-xc2028: Fix 7 MHz DVB-T
      V4L/DVB (12180): cx18: Update Yuan MPC-718 card entry with better information and guesses
      V4L/DVB (12181): get_dvb_firmware: Add Yuan MPC718 MT352 DVB-T "firmware" extraction
      V4L/DVB (12182): cx18: Add DVB-T support for Yuan MPC-718 cards with an MT352 or ZL10353
      V4L/DVB (12206): get_dvb_firmware: Correct errors in MPC718 firmware extraction logic

Devin Heitmueller (1):
      V4L/DVB (12156): em28xx: Fix tuning for Terratec Cinergy T XS USB (zl10353 version)

Guennadi Liakhovetski (1):
      V4L/DVB (12160): soc-camera: fix missing clean up on error path

Hans Verkuil (1):
      V4L/DVB (12153): ttpci: config TTPCI_EEPROM depends on I2C

Jiri Slaby (2):
      V4L/DVB (12202): em28xx, fix lock imbalance
      V4L/DVB (12203): radio-si470x: fix lock imbalance

Mauro Carvalho Chehab (12):
      V4L/DVB (12134): vivi: bug: don't assume that S_STD will be called before streaming
      V4L/DVB (12148): move V4L2_PIX_FMT_SGRBG8 to the proper place
      V4L/DVB (12135): Add a driver for mt9v011 sensor
      V4L/DVB (12136): mt9v011: Some fixes at the register initialization table
      V4L/DVB (12137): mt9v011: CodingStyle fixes
      V4L/DVB (12173): mt9v011: properly calculate image resolution registers
      V4L/DVB (12174): mt9v011: let's stick with datasheet values where it works
      V4L/DVB (12138): em28xx: add support for Silvercrest Webcam
      V4L/DVB (12139): em28xx: add other video formats
      V4L/DVB (12169): em28xx-video: fix VIDIOC_G_FMT and VIDIOC_ENUMFMT with webcams
      V4L/DVB (12171): em28xx: fix webcam usage with different output formats
      V4L/DVB (12172): em28xx: Add autodetection code for Silvercrest 1.3 mpix

Michael Krufky (2):
      V4L/DVB (12165): cx23885: override set_frontend to allow rf input path switching on the HVR1275
      V4L/DVB (12166): cx23885: add FIXME comment above set_frontend override

Stefan Herbrechtsmeier (1):
      V4L/DVB (12159): soc_camera: Fix debug output of supported formats count

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
