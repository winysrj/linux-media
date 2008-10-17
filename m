Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9HLKp5k004645
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 17:20:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9HLKcgr018535
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 17:20:38 -0400
Date: Fri, 17 Oct 2008 18:20:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20081017182020.35933ebe@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.28] V4L/DVB updates
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
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

This series brings two DVB API additions, in order to support some 
newer devices and standards:
   - Add DVB API support for DSS Standard and DVB-S2 32APSK;
   - Improvements of DVB API to support devices with multiple frontends (MFE);

It also contains several fixes and a few improvements:
   - Small fixes/improvements at drivers: ivtv, stk-webcam, si470x, vivi, 
     saa7127, soc_camera, au0828, sms1xxx, tuner, cx24116, gspca, mxl5005s;
   - zoran: conversion of the driver and several I2C subdrivers used 
     there to work also with the new i2c API;
   - cx88 and cx23885: add support for devices with MFE;

Besides those, there are several cosmetical changes, fixing issues 
pointed by checkpatch.pl on several places. This is the largest part, in 
terms of the number of changed lines.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.au0828       |    2 +-
 Documentation/video4linux/CARDLIST.tuner        |    1 +
 drivers/media/common/tuners/mxl5005s.c          |   10 +-
 drivers/media/common/tuners/tuner-simple.c      |    2 +
 drivers/media/common/tuners/tuner-types.c       |   33 ++-
 drivers/media/common/tuners/xc5000.c            |   73 ++--
 drivers/media/common/tuners/xc5000.h            |    8 +-
 drivers/media/dvb/dm1105/dm1105.c               |   12 +
 drivers/media/dvb/dvb-core/dvb_frontend.c       |  134 ++++--
 drivers/media/dvb/dvb-core/dvb_frontend.h       |    1 +
 drivers/media/dvb/dvb-core/dvbdev.c             |    3 +
 drivers/media/dvb/dvb-core/dvbdev.h             |    4 +
 drivers/media/dvb/dvb-usb/dw2102.c              |   12 +
 drivers/media/dvb/frontends/cx22702.c           |  506 ++++++++++++--------
 drivers/media/dvb/frontends/cx22702.h           |   20 +-
 drivers/media/dvb/frontends/cx24116.c           |  589 ++++++++++++-----------
 drivers/media/dvb/frontends/cx24116.h           |   21 +-
 drivers/media/dvb/frontends/cx24123.c           |  228 +++++----
 drivers/media/dvb/frontends/cx24123.h           |   10 +-
 drivers/media/dvb/frontends/s5h1409.c           |  138 +++---
 drivers/media/dvb/frontends/s5h1409.h           |   15 +-
 drivers/media/dvb/frontends/s5h1411.c           |    8 +-
 drivers/media/dvb/frontends/tda10048.c          |  100 +++-
 drivers/media/dvb/frontends/z0194a.h            |   16 +-
 drivers/media/dvb/siano/sms-cards.c             |    4 +
 drivers/media/radio/Kconfig                     |    2 +-
 drivers/media/radio/radio-si470x.c              |  234 ++++------
 drivers/media/video/adv7170.c                   |  251 +++--------
 drivers/media/video/adv7175.c                   |  243 +++-------
 drivers/media/video/au0828/au0828-cards.c       |    5 +-
 drivers/media/video/au0828/au0828-core.c        |    3 +-
 drivers/media/video/au0828/au0828-dvb.c         |    3 +-
 drivers/media/video/bt819.c                     |  321 ++++---------
 drivers/media/video/bt856.c                     |  218 ++-------
 drivers/media/video/bt866.c                     |  255 ++++-------
 drivers/media/video/cx23885/cx23885-cards.c     |  152 ++++---
 drivers/media/video/cx23885/cx23885-core.c      |  276 ++++++-----
 drivers/media/video/cx23885/cx23885-dvb.c       |  190 +++++---
 drivers/media/video/cx23885/cx23885-i2c.c       |   47 +-
 drivers/media/video/cx23885/cx23885-video.c     |   25 +-
 drivers/media/video/cx23885/cx23885.h           |   26 +-
 drivers/media/video/cx88/cx88-cards.c           |   58 ++-
 drivers/media/video/cx88/cx88-core.c            |    3 +-
 drivers/media/video/cx88/cx88-dvb.c             |  405 +++++++++++-----
 drivers/media/video/cx88/cx88-i2c.c             |   17 +-
 drivers/media/video/cx88/cx88-mpeg.c            |   22 +-
 drivers/media/video/cx88/cx88-tvaudio.c         |   11 +
 drivers/media/video/cx88/cx88-video.c           |   52 ++-
 drivers/media/video/cx88/cx88.h                 |    7 +-
 drivers/media/video/gspca/gspca.c               |    3 +-
 drivers/media/video/gspca/gspca.h               |    1 -
 drivers/media/video/gspca/m5602/m5602_bridge.h  |   29 +--
 drivers/media/video/gspca/m5602/m5602_core.c    |   46 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.c |   18 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.h |    7 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c  |   40 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.h  |    3 +-
 drivers/media/video/gspca/m5602/m5602_po1030.c  |   90 +++-
 drivers/media/video/gspca/m5602/m5602_po1030.h  |   46 ++-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c  |   22 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h  |    3 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c  |    6 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.h  |    4 +-
 drivers/media/video/gspca/m5602/m5602_sensor.h  |    2 +-
 drivers/media/video/gspca/t613.c                |  375 +++++++++------
 drivers/media/video/ivtv/ivtv-fileops.c         |   15 +-
 drivers/media/video/ivtv/ivtv-ioctl.c           |   18 +-
 drivers/media/video/ks0127.c                    |  476 ++++++++----------
 drivers/media/video/saa7110.c                   |  242 +++-------
 drivers/media/video/saa7111.c                   |  224 +++-------
 drivers/media/video/saa7114.c                   |  364 +++++----------
 drivers/media/video/saa7127.c                   |    2 +-
 drivers/media/video/saa7134/saa7134-dvb.c       |  216 +++++----
 drivers/media/video/saa7134/saa7134.h           |    2 +-
 drivers/media/video/saa7185.c                   |  210 ++------
 drivers/media/video/sh_mobile_ceu_camera.c      |   96 +++--
 drivers/media/video/soc_camera_platform.c       |   20 +-
 drivers/media/video/stk-webcam.c                |   27 +-
 drivers/media/video/stk-webcam.h                |    1 -
 drivers/media/video/tveeprom.c                  |    2 +-
 drivers/media/video/videobuf-dvb.c              |  201 +++++++--
 drivers/media/video/vivi.c                      |  278 ++++++++---
 drivers/media/video/vpx3220.c                   |  328 ++++---------
 drivers/media/video/zoran/zoran_card.c          |    1 +
 drivers/media/video/zoran/zoran_driver.c        |    1 -
 include/linux/dvb/frontend.h                    |    2 +
 include/linux/i2c-id.h                          |    2 +-
 include/media/soc_camera_platform.h             |   11 +
 include/media/tuner.h                           |    1 +
 include/media/v4l2-i2c-drv-legacy.h             |   11 +
 include/media/v4l2-i2c-drv.h                    |   11 +
 include/media/videobuf-dvb.h                    |   29 +-
 92 files changed, 4080 insertions(+), 4182 deletions(-)

Christophe Thommeret (1):
      V4L/DVB (9270): cx24116: optimise emulated auto-pilot

Darron Broad (14):
      V4L/DVB (9223): MFE: Fix a number of bugs and some tidying up
      V4L/DVB (9224): MFE: bugfix: add missing frontend allocation
      V4L/DVB (9225): MFE: Add configurable gate control
      V4L/DVB (9226): MFE: cx88: Reset cx22702 on hvr-3000/4000
      V4L/DVB (9227): MFE: Add multi-frontend mutual exclusion
      V4L/DVB (9228): cx88: Add audio routing for the hvr-3000/4000
      V4L/DVB (9229): cx88: Add intial config for FM radio support
      V4L/DVB (9264): MFE: bugfix: multi-frontend mutual exclusion parallel open
      V4L/DVB (9265): videobuf: data storage optimisation
      V4L/DVB (9266): videobuf: properly handle attachment failure
      V4L/DVB (9267): cx88: Update of audio routing config for FM radio
      V4L/DVB (9268): tuner: add FMD1216MEX tuner
      V4L/DVB (9269): cx88: add I2S-ADC tvaudio method
      V4L/DVB (9271): videobuf: data storage optimisation (2)

David Ellingsworth (2):
      V4L/DVB (9193): stk-webcam: minor cleanup
      V4L/DVB (9194): stk-webcam: fix crash on close after disconnect

Erik Andren (5):
      V4L/DVB (9277): gspca: propagate an error in m5602_start_transfer()
      V4L/DVB (9278): gspca: Remove the m5602_debug variable
      V4L/DVB (9279): gspca: Correct some copyright headers
      V4L/DVB (9280): gspca: Use the gspca debug macros
      V4L/DVB (9281): gspca: Add hflip and vflip to the po1030 sensor

Erik Andrén (2):
      V4L/DVB (9282): Properly iterate the urbs when destroying them.
      V4L/DVB (9283): Correct typo and enable setting the gain on the mt9m111 sensor

Geert Uytterhoeven (1):
      V4L/DVB (9275): dvb: input data pointer of cx24116_writeregN() should be const

Guennadi Liakhovetski (1):
      V4L/DVB (9241): soc-camera: move sensor power management to soc_camera_platform.c

Hans Verkuil (13):
      V4L/DVB (9191): ivtv: partially revert an earlier patch that checks the max image height
      V4L/DVB (9198): adv7170: convert i2c driver for new i2c API
      V4L/DVB (9199): adv7175: convert i2c driver for new i2c API
      V4L/DVB (9200): bt819: convert i2c driver for new i2c API
      V4L/DVB (9201): bt856: convert i2c driver for new i2c API
      V4L/DVB (9202): bt866: convert i2c driver for new i2c API
      V4L/DVB (9203): ks0127: convert i2c driver for new i2c API
      V4L/DVB (9204): saa7110: convert i2c driver for new i2c API
      V4L/DVB (9205): saa7111: convert i2c driver for new i2c API
      V4L/DVB (9206): saa7114: convert i2c driver for new i2c API
      V4L/DVB (9207): saa7185: convert i2c driver for new i2c API
      V4L/DVB (9208): vpx3220: convert i2c driver for new i2c API
      V4L/DVB (9209): v4l2: add comment to the v4l2-i2c-drv headers.

Ian Armstrong (1):
      V4L/DVB (9190): ivtv: yuv write() error handling tweak

Igor M. Liplianin (1):
      V4L/DVB (9296): Patch to remove warning message during cx88-dvb compilation

Jean Delvare (3):
      V4L/DVB (9197): zoran: set adapter class to I2C_CLASS_TV_ANALOG
      V4L/DVB (9234): zoran: Drop redundant printk
      V4L/DVB (9240): saa7127: Fix two typos

Jean-Francois Moine (8):
      V4L/DVB (9286): gspca: Compilation problem of gspca.c and the kernel version.
      V4L/DVB (9287): gspca: Change the name of the multi bytes write function in t613.
      V4L/DVB (9288): gspca: Write to the USB device and not USB interface in t613.
      V4L/DVB (9289): gspca: Other sensor identified as om6802 in t613.
      V4L/DVB (9290): gspca: Adjust the sensor init sequences in t613.
      V4L/DVB (9291): gspca: Do not set the white balance temperature by default in t613.
      V4L/DVB (9292): gspca: Call the control setting functions at init time in t613.
      V4L/DVB (9294): gspca: Add a stop sequence in t613.

Jose Alberto Reguero (1):
      V4L/DVB (9272): mxl5005s: Bug fix stopped DVB-T from working the second time around.

Leandro Costantino (1):
      V4L/DVB (9293): gspca: Separate and fix the sensor dependant sequences in t613.

Magnus Damm (9):
      V4L/DVB (9235): Precalculate vivi yuv values
      V4L/DVB (9236): Teach vivi about multiple pixel formats
      V4L/DVB (9237): Add uyvy pixel format support to vivi
      V4L/DVB (9238): Add support for rgb565 pixel formats to vivi
      V4L/DVB (9239): Add support for rgb555 pixel formats to vivi
      V4L/DVB (9242): video: add sh_mobile_ceu comments
      V4L/DVB (9243): video: add byte swap to sh_mobile_ceu driver
      V4L/DVB (9244): video: improve sh_mobile_ceu buffer handling
      V4L/DVB (9245): video: add header to soc_camera_platform include file

Manu Abraham (2):
      V4L/DVB (9195): Frontend API Fix: 32APSK is a valid modulation for the DVB-S2 delivery
      V4L/DVB (9196): Add support for DSS delivery

Mauro Carvalho Chehab (1):
      V4L/DVB (9276): videobuf-dvb: two functions are now static

Michael Krufky (2):
      V4L/DVB (9247): au0828: add support for another USB id for Hauppauge HVR950Q
      V4L/DVB (9248): sms1xxx: support two new revisions of the Hauppauge WinTV MiniStick

Steven Toth (20):
      V4L/DVB (9222): S2API: Add Multiple-frontend on a single adapter support.
      V4L/DVB (9230): cx23885: MFE related OOPS fix
      V4L/DVB (9231): cx23885: Define num_frontends as a function of the port
      V4L/DVB (9232): cx23885: Move the MFE frontend allocation into the correct place
      V4L/DVB (9250): cx88: Convert __FUNCTION__ to __func__
      V4L/DVB (9251): cx23885: Checkpatch compliance
      V4L/DVB (9252): au0828: Checkpatch compliance
      V4L/DVB (9253): cx24116: Checkpatch compliance
      V4L/DVB (9254): cx24116: Checkpatch compliance #2
      V4L/DVB (9255): tda10048: Checkpatch compliance
      V4L/DVB (9256): cx22702: Checkpatch compliance
      V4L/DVB (9257): cx24116: Checkpatch compliance #3
      V4L/DVB (9258): s5h1409: Checkpatch compliance
      V4L/DVB (9259): s5h1411: Checkpatch compliance
      V4L/DVB (9260): cx24123: Checkpatch compliance
      V4L/DVB (9261): xc5000: Checkpatch compliance
      V4L/DVB (9262): cx88: Change spurious buffer message into a debug only message
      V4L/DVB (9263): mxl5005s: Checkpatch compliance
      V4L/DVB (9273): MFE: videobuf-dvb.c checkpatch cleanup as part of MFE merge
      V4L/DVB (9274): Remove spurious messages and turn into debug.

Tobias Lorenz (7):
      V4L/DVB (9213): si470x: module_param access rights
      V4L/DVB (9214): si470x: improvement of module device support
      V4L/DVB (9215): si470x: improvement of unsupported base controls
      V4L/DVB (9216): si470x: tuner->type handling
      V4L/DVB (9217): si470x: correction of mono/stereo handling
      V4L/DVB (9218): si470x: removement of get/set input/audio
      V4L/DVB (9219): Kernel config comment corrected (radio-silabs -> radio-si470x)

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
