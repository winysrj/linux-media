Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36030 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZGXRka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 13:40:30 -0400
Date: Fri, 24 Jul 2009 14:40:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Greg KH <gregkh@suse.de>
Subject: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Message-ID: <20090724144020.3f5a6bb7@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

This series adds a new gscpca sub-driver for sn9c20x webcams. There are several
popular webcam models supported by those Sonix/Microdia chips. 

Greg can remove some linuxdriverproject.org requests from the project Wiki
after this merge ;) Greg, for the USB ID details, you could take a look at
Documentation/video4linux/gspca.txt changes (32 USB ID's added) or at
http://linuxtv.org/wiki/index.php/Gspca. With this series, gspca alone supports
660 different webcam models.

It has also the following fixes:

   - gspca:
	main: Add support for vidioc_g_chip_ident and vidioc_g/s_register;
	stv06xx-hdcs: update the sensor state, fix a sensor sequence bug and 
		      correct the pixelformat;
	m5602-s5k4aa: Remove erroneous register writes;
	jpeg subdrivers: Check the result of kmalloc(jpeg header);
	sonixj: Bad sensor init of non ov76xx sensors.

   - em28xx:
	Fixes bugs where webcams are detected, but, since there weren't any
		sensor code, webcams failed to work;
	Auto-detect mt9v011 sensors;
	Added support and autodetection code for mt9m001 sensors;
	Fixed webcam scaling;
	make tuning work for Terratec Cinergy T XS USB (mt352 variant);
	fix typo in mt352 init sequence for Terratec Cinergy T XS USB;
	make support work for the Pinnacle Hybrid Pro (eb1a:2881);
	set GPIO properly for Pinnacle Hybrid Pro analog support;
	Make sure the tuner is initialized if generic empia USB id was used;
	set demod profile for Pinnacle Hybrid Pro 320e;
	fix tuning problem in HVR-900 (R1).

   - mt9v011 (new driver on 2.6.32 added on a previous merge):
	implement VIDIOC_QUERYCTRL, adds function to calculate fps and adjust
	the frequency of the used quartz cristal;

   - af9013: auto-detect parameters in case of garbage given by app;

   - b2c2-flexcop: regression fix (BZ#13709): properly compile with builtin
		   frontends;

   - bttv: fix regression: tvaudio must be loaded before tuner;

   - cx23885-417: fix broken IOCTL handling;

   - cx23885: check pointers before dereferencing in dprintk macro.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.em28xx        |    2 +-
 Documentation/video4linux/gspca.txt              |   32 +
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c        |   67 +-
 drivers/media/dvb/frontends/af9013.c             |   25 +-
 drivers/media/video/bt8xx/bttv-cards.c           |   92 +-
 drivers/media/video/bt8xx/bttv-driver.c          |    1 +
 drivers/media/video/bt8xx/bttv.h                 |    1 +
 drivers/media/video/cx23885/cx23885-417.c        |    4 +-
 drivers/media/video/em28xx/em28xx-cards.c        |  134 +-
 drivers/media/video/em28xx/em28xx-core.c         |   22 +-
 drivers/media/video/em28xx/em28xx-dvb.c          |   62 +-
 drivers/media/video/em28xx/em28xx-video.c        |   16 +-
 drivers/media/video/em28xx/em28xx.h              |   31 +-
 drivers/media/video/gspca/Kconfig                |   16 +
 drivers/media/video/gspca/Makefile               |    2 +
 drivers/media/video/gspca/conex.c                |    2 +
 drivers/media/video/gspca/gspca.c                |   73 +
 drivers/media/video/gspca/gspca.h                |    9 +
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c   |    6 -
 drivers/media/video/gspca/mars.c                 |    2 +
 drivers/media/video/gspca/sn9c20x.c              | 2434 ++++++++++++++++++++++
 drivers/media/video/gspca/sonixj.c               |    4 +
 drivers/media/video/gspca/spca500.c              |    2 +
 drivers/media/video/gspca/stk014.c               |    2 +
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c |   16 +-
 drivers/media/video/gspca/sunplus.c              |    2 +
 drivers/media/video/gspca/zc3xx.c                |    2 +
 drivers/media/video/mt9v011.c                    |   69 +-
 include/linux/videodev2.h                        |    1 +
 include/media/v4l2-chip-ident.h                  |   12 +
 30 files changed, 2973 insertions(+), 170 deletions(-)
 create mode 100644 drivers/media/video/gspca/sn9c20x.c

Antti Palosaari (1):
      V4L/DVB (12269): af9013: auto-detect parameters in case of garbage given by app

Brian Johnson (2):
      V4L/DVB (12282): gspca - main: Support for vidioc_g_chip_ident and vidioc_g/s_register.
      V4L/DVB (12283): gspca - sn9c20x: New subdriver for sn9c201 and sn9c202 bridges.

Devin Heitmueller (7):
      V4L/DVB (12257): em28xx: make tuning work for Terratec Cinergy T XS USB (mt352 variant)
      V4L/DVB (12258): em28xx: fix typo in mt352 init sequence for Terratec Cinergy T XS USB
      V4L/DVB (12260): em28xx: make support work for the Pinnacle Hybrid Pro (eb1a:2881)
      V4L/DVB (12261): em28xx: set GPIO properly for Pinnacle Hybrid Pro analog support
      V4L/DVB (12262): em28xx: Make sure the tuner is initialized if generic empia USB id was used
      V4L/DVB (12263): em28xx: set demod profile for Pinnacle Hybrid Pro 320e
      V4L/DVB (12265): em28xx: fix tuning problem in HVR-900 (R1)

Erik Andrén (4):
      V4L/DVB (12221): gspca - stv06xx-hdcs: Actually update the sensor state
      V4L/DVB (12222): gspca - stv06xx-hdcs: Fix sensor sequence bug
      V4L/DVB (12223): gspca - stv06xx-hdcs: Correct the pixelformat
      V4L/DVB (12224): gspca - m5602-s5k4aa: Remove erroneous register writes

Hans Verkuil (1):
      V4L/DVB (12300): bttv: fix regression: tvaudio must be loaded before tuner

Jean-Francois Moine (1):
      V4L/DVB (12267): gspca - sonixj: Bad sensor init of non ov76xx sensors.

Julia Lawall (1):
      V4L/DVB (12284): gspca - jpeg subdrivers: Check the result of kmalloc(jpeg header).

Mauro Carvalho Chehab (14):
      V4L/DVB (12233): em28xx: rename is_27xx to is_webcam
      V4L/DVB (12234): em28xx-cards: use is_webcam flag for devices that are known to be webcams
      V4L/DVB (12235): em28xx: detects sensors also with the generic em2750/2750 entry
      V4L/DVB (12236): em28xx: stop abusing of board->decoder for sensor information
      V4L/DVB (12237): mt9v011: implement VIDIOC_QUERYCTRL
      V4L/DVB (12238): em28xx: call sensor detection code for all webcam entries
      V4L/DVB (12239): em28xx: fix webcam scaling
      V4L/DVB (12240): mt9v011: add a function to calculate frames per second rate
      V4L/DVB (12241): mt9v011: Fix vstart
      V4L/DVB (12242): mt9v011: implement core->s_config to allow adjusting xtal frequency
      V4L/DVB (12243): em28xx: allow specifying sensor xtal frequency
      V4L/DVB (12244): em28xx: adjust vinmode/vinctl based on the stream input format
      V4L/DVB (12245): em28xx: add support for mt9m001 webcams
      V4L/DVB (12286): sn9c20x: reorder includes to be like other drivers

Michael Krufky (2):
      V4L/DVB (12302): cx23885-417: fix broken IOCTL handling
      V4L/DVB (12303): cx23885: check pointers before dereferencing in dprintk macro

Trent Piepho (1):
      V4L/DVB (12291): b2c2: fix frontends compiled into kernel

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
