Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51145 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbZFPXxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 19:53:13 -0400
Date: Tue, 16 Jun 2009 20:53:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.31] V4L/DVB updates
Message-ID: <20090616205305.75b46bc1@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For several changes including the following:

	- new DVB frontend drivers for isl6423, stv090x and stv6110x;
	- new i2c ancillary driver for adv7343 and ths7303 chips;
	- Siano is taking over the maintainership of the driver for their chips. A large
	  series of patches are there to improve Siano driver support and sync with their
	  internal trees;
	- improved audio standard detection on cx88;
	- added driver for ov7660 based m5602 webcams;
	- several driver improvements on drivers like gspca, em28xx, af9015,
	  uvcvideo, soc-camera, cx18, pxa_camera, ivtv, tda10048, pvrusb2, dvb-ttpci,
	  xc5000, au0820, dibcomm, uvcvideo, saa7134, tuner-xc2028, dsbr100, dw2102,
	  lgs8gxx;
	- ir-kbd-i2c converted to the new i2c binding model;
	- new board additions on several drivers;
	- several fixes;

Cheers,
Mauro.

---

 Documentation/dvb/get_dvb_firmware                 |    8 +-
 Documentation/video4linux/CARDLIST.cx23885         |    5 +
 Documentation/video4linux/CARDLIST.cx88            |    2 +
 Documentation/video4linux/CARDLIST.em28xx          |    6 +-
 Documentation/video4linux/CARDLIST.saa7134         |   22 +-
 Documentation/video4linux/CARDLIST.tuner           |    2 +
 Documentation/video4linux/gspca.txt                |   12 +-
 Documentation/video4linux/pxa_camera.txt           |   49 +
 Documentation/video4linux/v4l2-framework.txt       |    5 +
 arch/arm/mach-pxa/pcm990-baseboard.c               |   23 +-
 drivers/media/Kconfig                              |   10 +-
 drivers/media/common/tuners/tuner-simple.c         |   44 +-
 drivers/media/common/tuners/tuner-types.c          |   59 +
 drivers/media/common/tuners/tuner-xc2028.c         |   56 +-
 drivers/media/common/tuners/xc5000.c               |  264 +-
 drivers/media/dvb/b2c2/flexcop-common.h            |    8 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c          |  790 ++--
 drivers/media/dvb/b2c2/flexcop-i2c.c               |    2 +-
 drivers/media/dvb/b2c2/flexcop-misc.c              |   20 +-
 drivers/media/dvb/bt8xx/bt878.c                    |    8 +-
 drivers/media/dvb/dm1105/dm1105.c                  |  121 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |   14 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |   42 +
 drivers/media/dvb/dvb-core/dvb_demux.h             |    4 +
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    2 +
 drivers/media/dvb/dvb-usb/Kconfig                  |    1 +
 drivers/media/dvb/dvb-usb/af9015.c                 |   94 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |   31 +-
 drivers/media/dvb/dvb-usb/dibusb-common.c          |    7 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    8 +
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    2 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |  325 ++-
 drivers/media/dvb/dvb-usb/dw2102.h                 |    1 +
 drivers/media/dvb/dvb-usb/gp8psk.c                 |    8 +-
 drivers/media/dvb/firewire/firedtv-1394.c          |    4 +-
 drivers/media/dvb/firewire/firedtv-dvb.c           |    2 +-
 drivers/media/dvb/firewire/firedtv-rc.c            |    4 +-
 drivers/media/dvb/frontends/Kconfig                |   22 +
 drivers/media/dvb/frontends/Makefile               |    4 +-
 drivers/media/dvb/frontends/af9013.c               |    2 +-
 drivers/media/dvb/frontends/au8522_dig.c           |   98 +-
 drivers/media/dvb/frontends/cx24116.c              |    2 +-
 drivers/media/dvb/frontends/drx397xD.c             |    4 +-
 drivers/media/dvb/frontends/isl6423.c              |  308 ++
 drivers/media/dvb/frontends/isl6423.h              |   63 +
 drivers/media/dvb/frontends/lgdt3305.c             |   17 +-
 drivers/media/dvb/frontends/lgs8gxx.c              |   10 +-
 drivers/media/dvb/frontends/lnbp21.c               |    2 +-
 drivers/media/dvb/frontends/mt312.c                |    2 +-
 drivers/media/dvb/frontends/nxt200x.c              |    6 +-
 drivers/media/dvb/frontends/or51132.c              |    2 +-
 drivers/media/dvb/frontends/stv0900_priv.h         |    2 -
 drivers/media/dvb/frontends/stv090x.c              | 4299 ++++++++++++++++++++
 drivers/media/dvb/frontends/stv090x.h              |  106 +
 drivers/media/dvb/frontends/stv090x_priv.h         |  269 ++
 drivers/media/dvb/frontends/stv090x_reg.h          | 2373 +++++++++++
 drivers/media/dvb/frontends/stv6110x.c             |  373 ++
 drivers/media/dvb/frontends/stv6110x.h             |   71 +
 drivers/media/dvb/frontends/stv6110x_priv.h        |   75 +
 drivers/media/dvb/frontends/stv6110x_reg.h         |   82 +
 drivers/media/dvb/frontends/tda10048.c             |  312 ++-
 drivers/media/dvb/frontends/tda10048.h             |   21 +-
 drivers/media/dvb/siano/Makefile                   |    2 +-
 drivers/media/dvb/siano/sms-cards.c                |  188 +-
 drivers/media/dvb/siano/sms-cards.h                |   64 +
 drivers/media/dvb/siano/smscoreapi.c               |  468 ++-
 drivers/media/dvb/siano/smscoreapi.h               |  488 ++-
 drivers/media/dvb/siano/smsdvb.c                   |  372 ++-
 drivers/media/dvb/siano/smsendian.c                |  102 +
 drivers/media/dvb/siano/smsendian.h                |   32 +
 drivers/media/dvb/siano/smsir.c                    |  301 ++
 drivers/media/dvb/siano/smsir.h                    |   93 +
 drivers/media/dvb/siano/smssdio.c                  |  357 ++
 drivers/media/dvb/siano/smsusb.c                   |   75 +-
 drivers/media/dvb/ttpci/av7110_av.c                |  124 +-
 drivers/media/dvb/ttpci/av7110_hw.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_v4l.c               |    2 +-
 drivers/media/dvb/ttpci/budget-av.c                |    2 +-
 drivers/media/dvb/ttpci/budget.c                   |   85 +
 drivers/media/radio/dsbr100.c                      |  109 +-
 drivers/media/radio/radio-mr800.c                  |    1 +
 drivers/media/radio/radio-sf16fmi.c                |   16 +-
 drivers/media/radio/radio-sf16fmr2.c               |   22 +-
 drivers/media/radio/radio-si470x.c                 |    1 -
 drivers/media/video/Kconfig                        |   20 +-
 drivers/media/video/Makefile                       |   79 +-
 drivers/media/video/adv7343.c                      |  534 +++
 drivers/media/video/adv7343_regs.h                 |  185 +
 drivers/media/video/au0828/au0828-cards.c          |    4 +-
 drivers/media/video/au0828/au0828-core.c           |   17 +
 drivers/media/video/au0828/au0828-video.c          |    8 +-
 drivers/media/video/bt8xx/bttv-driver.c            |   14 +-
 drivers/media/video/bt8xx/bttv-i2c.c               |   21 +
 drivers/media/video/cpia2/cpia2_v4l.c              |    6 +-
 drivers/media/video/cx18/cx18-audio.c              |   44 +-
 drivers/media/video/cx18/cx18-av-core.c            |  374 ++-
 drivers/media/video/cx18/cx18-av-firmware.c        |   82 +-
 drivers/media/video/cx18/cx18-av-vbi.c             |    4 +-
 drivers/media/video/cx18/cx18-cards.c              |   63 +-
 drivers/media/video/cx18/cx18-controls.c           |    6 +-
 drivers/media/video/cx18/cx18-driver.c             |  100 +-
 drivers/media/video/cx18/cx18-driver.h             |   22 +-
 drivers/media/video/cx18/cx18-dvb.c                |   54 +-
 drivers/media/video/cx18/cx18-fileops.c            |    7 +-
 drivers/media/video/cx18/cx18-mailbox.c            |  114 +-
 drivers/media/video/cx18/cx18-mailbox.h            |    2 +-
 drivers/media/video/cx18/cx18-queue.c              |   85 +-
 drivers/media/video/cx18/cx18-streams.c            |   44 +-
 drivers/media/video/cx18/cx18-streams.h            |   20 +-
 drivers/media/video/cx18/cx18-version.h            |    2 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |    1 -
 drivers/media/video/cx231xx/cx231xx-cards.c        |    8 +-
 drivers/media/video/cx231xx/cx231xx-i2c.c          |   32 +-
 drivers/media/video/cx231xx/cx231xx-input.c        |    2 +-
 drivers/media/video/cx231xx/cx231xx-vbi.c          |    1 -
 drivers/media/video/cx231xx/cx231xx.h              |    2 +-
 drivers/media/video/cx23885/cimax2.c               |    2 +-
 drivers/media/video/cx23885/cx23885-417.c          |    1 -
 drivers/media/video/cx23885/cx23885-cards.c        |  121 +
 drivers/media/video/cx23885/cx23885-core.c         |   92 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |  123 +-
 drivers/media/video/cx23885/cx23885-i2c.c          |   12 +
 drivers/media/video/cx23885/cx23885-video.c        |   14 +-
 drivers/media/video/cx23885/cx23885.h              |   21 +
 drivers/media/video/cx88/Makefile                  |    2 +-
 drivers/media/video/cx88/cx88-alsa.c               |    7 +-
 drivers/media/video/cx88/cx88-cards.c              |  108 +-
 drivers/media/video/cx88/cx88-core.c               |   27 +-
 drivers/media/video/cx88/cx88-dsp.c                |  312 ++
 drivers/media/video/cx88/cx88-dvb.c                |    1 +
 drivers/media/video/cx88/cx88-i2c.c                |   13 +
 drivers/media/video/cx88/cx88-input.c              |    6 +
 drivers/media/video/cx88/cx88-tvaudio.c            |  115 +-
 drivers/media/video/cx88/cx88-video.c              |   16 +-
 drivers/media/video/cx88/cx88.h                    |   12 +
 drivers/media/video/em28xx/em28xx-audio.c          |    5 +
 drivers/media/video/em28xx/em28xx-cards.c          |  222 +-
 drivers/media/video/em28xx/em28xx-core.c           |   58 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   21 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |   25 +-
 drivers/media/video/em28xx/em28xx-input.c          |    8 +-
 drivers/media/video/em28xx/em28xx-reg.h            |   16 +
 drivers/media/video/em28xx/em28xx.h                |    9 +-
 drivers/media/video/gspca/finepix.c                |    1 +
 drivers/media/video/gspca/gspca.c                  |  199 +-
 drivers/media/video/gspca/gspca.h                  |    6 +-
 drivers/media/video/gspca/m5602/Makefile           |    3 +-
 drivers/media/video/gspca/m5602/m5602_bridge.h     |   26 +-
 drivers/media/video/gspca/m5602/m5602_core.c       |   44 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.c    |  400 ++-
 drivers/media/video/gspca/m5602/m5602_mt9m111.h    |  805 +----
 drivers/media/video/gspca/m5602/m5602_ov7660.c     |  227 +
 drivers/media/video/gspca/m5602/m5602_ov7660.h     |  279 ++
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |  222 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.h     |   57 +-
 drivers/media/video/gspca/m5602/m5602_po1030.c     |  494 ++-
 drivers/media/video/gspca/m5602/m5602_po1030.h     |  439 +--
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |  391 ++-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h     |   93 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c     |  473 ++-
 drivers/media/video/gspca/m5602/m5602_s5k83a.h     |  280 +--
 drivers/media/video/gspca/m5602/m5602_sensor.h     |    9 +-
 drivers/media/video/gspca/mr97310a.c               |    8 +-
 drivers/media/video/gspca/ov519.c                  |  520 +++-
 drivers/media/video/gspca/ov534.c                  |  277 +-
 drivers/media/video/gspca/sonixb.c                 |    2 +
 drivers/media/video/gspca/sonixj.c                 |   66 +-
 drivers/media/video/gspca/spca500.c                |   33 +-
 drivers/media/video/gspca/spca505.c                |   14 +-
 drivers/media/video/gspca/spca508.c                | 1934 ++++-----
 drivers/media/video/gspca/spca561.c                |  105 +-
 drivers/media/video/gspca/sq905.c                  |    1 +
 drivers/media/video/gspca/sq905c.c                 |    1 +
 drivers/media/video/gspca/stv06xx/stv06xx.c        |    2 -
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |   76 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |   10 +-
 drivers/media/video/gspca/sunplus.c                |   33 +-
 drivers/media/video/gspca/t613.c                   |    2 +-
 drivers/media/video/gspca/vc032x.c                 |   22 +-
 drivers/media/video/gspca/zc3xx.c                  |   22 +-
 drivers/media/video/hexium_gemini.c                |    2 +-
 drivers/media/video/hexium_orion.c                 |    2 +-
 drivers/media/video/ir-kbd-i2c.c                   |  222 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    9 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |   36 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |    2 +-
 drivers/media/video/mt9m001.c                      |  108 +-
 drivers/media/video/mt9m111.c                      |   73 +-
 drivers/media/video/mt9t031.c                      |  135 +-
 drivers/media/video/mt9v022.c                      |  138 +-
 drivers/media/video/mx1_camera.c                   |   50 +-
 drivers/media/video/mx3_camera.c                   |   46 +-
 drivers/media/video/mxb.c                          |    4 +-
 drivers/media/video/ov511.c                        |   45 +-
 drivers/media/video/ov511.h                        |    3 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |    6 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.h      |   23 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    3 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   74 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |   51 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   22 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    6 +-
 drivers/media/video/pwc/pwc-if.c                   |    6 +-
 drivers/media/video/pwc/pwc-v4l.c                  |    2 +-
 drivers/media/video/pxa_camera.c                   |  126 +-
 drivers/media/video/s2255drv.c                     |  110 +-
 drivers/media/video/saa7134/Kconfig                |    1 +
 drivers/media/video/saa7134/Makefile               |    3 +-
 drivers/media/video/saa7134/saa7134-cards.c        |  450 ++-
 drivers/media/video/saa7134/saa7134-core.c         |   18 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   26 +
 drivers/media/video/saa7134/saa7134-empress.c      |   14 +-
 drivers/media/video/saa7134/saa7134-i2c.c          |   33 +-
 drivers/media/video/saa7134/saa7134-input.c        |  118 +-
 drivers/media/video/saa7134/saa7134-ts.c           |  122 +-
 drivers/media/video/saa7134/saa7134-video.c        |   10 +-
 drivers/media/video/saa7134/saa7134.h              |   29 +-
 drivers/media/video/se401.c                        |  882 ++--
 drivers/media/video/se401.h                        |    7 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   27 +-
 drivers/media/video/soc_camera.c                   |  106 +-
 drivers/media/video/stk-webcam.c                   |    4 +-
 drivers/media/video/tda7432.c                      |   14 -
 drivers/media/video/tea6415c.c                     |    1 -
 drivers/media/video/tea6420.c                      |    1 -
 drivers/media/video/ths7303.c                      |  151 +
 drivers/media/video/tuner-core.c                   |   33 -
 drivers/media/video/tveeprom.c                     |    6 +-
 drivers/media/video/tvp514x.c                      |    2 +-
 drivers/media/video/usbvideo/konicawc.c            |    4 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |    4 +-
 drivers/media/video/usbvision/usbvision-core.c     |   14 +-
 drivers/media/video/usbvision/usbvision-video.c    |    4 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |   35 +-
 drivers/media/video/uvc/uvc_driver.c               |   68 +-
 drivers/media/video/uvc/uvc_queue.c                |   14 +
 drivers/media/video/uvc/uvc_status.c               |   21 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   39 +-
 drivers/media/video/uvc/uvc_video.c                |   17 +-
 drivers/media/video/uvc/uvcvideo.h                 |    5 +-
 drivers/media/video/v4l2-common.c                  |    4 +-
 drivers/media/video/v4l2-device.c                  |   31 +-
 drivers/media/video/videobuf-core.c                |    6 +-
 drivers/media/video/videobuf-dma-contig.c          |   14 -
 drivers/media/video/videobuf-dma-sg.c              |   19 +-
 drivers/media/video/vino.c                         |    6 +-
 drivers/media/video/zoran/zoran_card.c             |    4 +-
 drivers/media/video/zr364xx.c                      |    6 +-
 include/linux/mmc/sdio_ids.h                       |    8 +
 include/linux/videodev2.h                          |    3 +-
 include/media/adv7343.h                            |   23 +
 include/media/ir-kbd-i2c.h                         |   10 +-
 include/media/soc_camera.h                         |   10 +-
 include/media/tuner.h                              |    2 +
 include/media/v4l2-chip-ident.h                    |    6 +
 include/media/v4l2-device.h                        |   23 +-
 include/media/v4l2-subdev.h                        |    5 +
 257 files changed, 21727 insertions(+), 6438 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/isl6423.c
 create mode 100644 drivers/media/dvb/frontends/isl6423.h
 create mode 100644 drivers/media/dvb/frontends/stv090x.c
 create mode 100644 drivers/media/dvb/frontends/stv090x.h
 create mode 100644 drivers/media/dvb/frontends/stv090x_priv.h
 create mode 100644 drivers/media/dvb/frontends/stv090x_reg.h
 create mode 100644 drivers/media/dvb/frontends/stv6110x.c
 create mode 100644 drivers/media/dvb/frontends/stv6110x.h
 create mode 100644 drivers/media/dvb/frontends/stv6110x_priv.h
 create mode 100644 drivers/media/dvb/frontends/stv6110x_reg.h
 create mode 100644 drivers/media/dvb/siano/smsendian.c
 create mode 100644 drivers/media/dvb/siano/smsendian.h
 create mode 100644 drivers/media/dvb/siano/smsir.c
 create mode 100644 drivers/media/dvb/siano/smsir.h
 create mode 100644 drivers/media/dvb/siano/smssdio.c
 create mode 100644 drivers/media/video/adv7343.c
 create mode 100644 drivers/media/video/adv7343_regs.h
 create mode 100644 drivers/media/video/cx88/cx88-dsp.c
 create mode 100644 drivers/media/video/gspca/m5602/m5602_ov7660.c
 create mode 100644 drivers/media/video/gspca/m5602/m5602_ov7660.h
 create mode 100644 drivers/media/video/ths7303.c
 create mode 100644 include/media/adv7343.h

Abylay Ospan (1):
      V4L/DVB (11930): TS continuity check: show error message when discontinuity detected or TEI flag detected in header

Alan Cox (2):
      V4L/DVB (11959): se401: Fix unsafe use of sprintf with identical source/destination
      V4L/DVB (11998): se401: Fix coding style

Alan Nisota (1):
      V4L/DVB (11833): dvb-usb: Remove support for Genpix-CW3K (damages hardware)

Alessio Igor Bogani (1):
      V4L/DVB (11842): radio-mr800.c: missing mutex include

Alexey Klimov (7):
      V4L/DVB (11447): gspca - mr97310a: Return good error code in mod_init.
      V4L/DVB (11569): av7110_hw: fix compile warning
      V4L/DVB (11954): dsbr100: remove radio->users counter
      V4L/DVB (11955): dsbr100: remove usb_dsbr100_open/close calls
      V4L/DVB (11956): dsbr100: no need to pass curfreq value to dsbr100_setfreq()
      V4L/DVB (11957): dsbr100: change radio->muted to radio->status, update suspend/resume
      V4L/DVB (11997): gspca - stv06xx: remove needless if check and goto

Andreas Regel (14):
      V4L/DVB (11580): budget-ci: Fix incorrect default CLOCK setup
      V4L/DVB (11583): isl6423: Various fixes to use external modulation
      V4L/DVB (11584): stv090x: add tone burst control
      V4L/DVB (11585): stv090x: fix incorrectly used mode
      V4L/DVB (11592): stv6110x: Fix read bug
      V4L/DVB (11593): stv090x: Fix Rolloff
      V4L/DVB (11594): stv090x: Fix incorrect TSMODE usage
      V4L/DVB (11595): stv090x: fixes a few bugs
      V4L/DVB (11596): stv090x: fixes some register definitions
      V4L/DVB (11597): stv090x: fixes read_status to return 0 in case of no error
      V4L/DVB (11598): stv090x: fix missing wakeup in init
      V4L/DVB (11599): S2-1600: Use budget driver instead of budged-ci
      V4L/DVB (11600): budget: Use Continuous clock
      V4L/DVB (11601): stv090x: update demodulator capabilities

Andy Shevchenko (1):
      V4L/DVB (11442): saa7134: BZ#7524: Add AVerTV Studio 507UA support

Andy Walls (21):
      V4L/DVB (11615): cx18: Rename the work queue to "in_work_queue"
      V4L/DVB (11616): cx18: Add a work queue for deferring empty buffer handoffs to the firmware
      V4L/DVB (11617): cx18: Set up to wait for a one-shot response before sending a firmware cmd
      V4L/DVB (11618): cx18: Convert per stream mutex locks to per queue spin locks
      V4L/DVB (11619): cx18: Simplify the work handler for outgoing mailbox commands
      V4L/DVB (11620): cx18: Increment version due to significant buffer handling changes
      V4L/DVB (11622): cx18: Allow IVTV format VBI insertion in MPEG-2 SVCD and DVD streams
      V4L/DVB (11623): cx18: Verify cx18-av-core digitizer firmware loads correctly
      V4L/DVB (11624): cx18: Toggle the AI1 mux when changing the CX18_AUDIO_ENABLE register
      V4L/DVB (11703): cx18: Have audio decoder drive SIF gain control, and rework AFE config
      V4L/DVB (11752): cx18: Add missing newline to tuner detection error message
      V4L/DVB (11753): tveeprom: Point the TCL MNM05-4 tuner entry to an actual tuner definition
      V4L/DVB (11863): cx18: Initial attempt to get sliced VBI working for 625 line systems
      V4L/DVB (11864): cx18: Complete support for Sliced and Raw VBI for 625 line systems
      V4L/DVB (11865): cx18: Tweak color burst gate delay and initial color sub-carrier freq
      V4L/DVB (11898): cx18: Perform 64 bit divide so it works for 32 bit systems
      V4L/DVB (11931): lnbp21: Add missing newline
      V4L/DVB (11932): ivtv: Add missing newline
      V4L/DVB (11933): tuner-simple, tveeprom: Add Philips FQ1216LME MK3 analog tuner
      V4L/DVB (11950): cx18: Split LeadTek PVR2100 and DVR3100 H into 2 separate card entries
      V4L/DVB (11951): cx18: Add DVB-T support for the Leadtek WinFast DVR3100 H

Antti Palosaari (3):
      V4L/DVB (11490): af9015: add new dvb_usb_device_properties entry for upcoming USB IDs
      V4L/DVB (11491): af9015: support for AverMedia AVerTV Volar GPS 805 (A805)
      V4L/DVB (11915): af9015: support for Genius TVGo DVB-T03

Armin Schenker (1):
      V4L/DVB (11571): Add Elgato EyeTV DTT deluxe to dibcom driver

Barry Kitson (1):
      V4L/DVB (11996): saa7134: add support for AVerMedia M103 (f736)

Chaithrika U S (2):
      V4L/DVB (11742): TI THS7303 video amplifier driver code
      V4L/DVB (11743): Analog Devices ADV7343 video encoder driver

Cohen David.A (1):
      V4L/DVB (11840): change kmalloc to vmalloc for sglist allocation in videobuf_dma_map/unmap

David T.L. Wong (1):
      V4L/DVB (11803): xc5000: add support for DVB-T tuning

David Wong (3):
      V4L/DVB (11880): cx23885: support for card Mygica X8506 DMB-TH
      V4L/DVB (12000): lgs8gxx: lgs8913 fake signal strength option default on
      V4L/DVB (12001): lgs8gxx: update signal strength scale

Dean Anderson (3):
      V4L/DVB (11605): patch: s2255drv: code cleanup
      V4L/DVB (11851): patch: s2255drv: adding V4L2_MODE_HIGHQUALITY
      V4L/DVB (11738): patch: s2255drv: urb completion routine fixes

Devin Heitmueller (33):
      V4L/DVB (11786): xc5000: handle tuner reset failures properly
      V4L/DVB (11787): xc5000: cleanup i2c read routines
      V4L/DVB (11788): xc5000: cleanup i2c write routines
      V4L/DVB (11789): xc5000: check xc5000_readreg return value for XC_RESULT_SUCCESS
      V4L/DVB (11790): xc5000: restore sleep routine
      V4L/DVB (11791): xc5000: do not sleep after digital tuning
      V4L/DVB (11792): xc5000: switch to new version of Xceive firmware
      V4L/DVB (11793): xc5000: Properly support power down for newer firmware
      V4L/DVB (11794): au0828: reduce reset time for xc5000 to 10ms
      V4L/DVB (11795): xc5000: add build version to debug info
      V4L/DVB (11796): xc5000: start using the newer "finerfreq" tuning command
      V4L/DVB (11797): xc5000: cleanup firmware loading messages
      V4L/DVB (11798): xc5000: add "no_poweroff" module option
      V4L/DVB (11799): xc5000: don't load firmware until a tuning request is made
      V4L/DVB (11800): tuner-xc2028: show the proper module description for no_poweroff option
      V4L/DVB (11801): dib0700: reduce xc5000 sleep time for Pinnacle 801e to 10ms
      V4L/DVB (11802): xc5000: switch to new xc5000 firmware 1.6.114 with redistribution rights
      V4L/DVB (11804): xc5000: poll at 5ms interval for register write command completion
      V4L/DVB (11805): au0828: send command to power down tuner when done with analog
      V4L/DVB (11806): xc5000: add copyright line
      V4L/DVB (11807): cx88: remove xc5000 reset for Pinnacle 800i
      V4L/DVB (11808): au0828: get rid of debug printk that was causing compile failures
      V4L/DVB (11810): em28xx: properly set packet size based on the device's eeprom configuration.
      V4L/DVB (11923): em28xx: Don't let device work unless connected to a high speed USB port
      V4L/DVB (11924): au0828: Don't let device work unless connected to a high speed USB port
      V4L/DVB (11925): em28xx: Add support for the K-World 2800d
      V4L/DVB (11926): tuner-core: fix warning introduced when cleaning up xc5000 init routine
      V4L/DVB (11927): em28xx: provide module option to disable USB speed check
      V4L/DVB (11928): au0828: provide module option to disable USB speed check
      V4L/DVB (11979): em28xx: don't create audio device if not supported
      V4L/DVB (11784): cx88: Fix race condition between cx8800 startup and hald
      V4L/DVB (11785): dvb_frontend: fix race condition resulting in dropped tuning commands
      V4L/DVB (11875): dvb_frontend: fix case where fepriv->exit not reset

Dmitri Belimov (6):
      V4L/DVB (11604): saa7134: split Behold`s card entries to properly identify the model
      V4L/DVB (11733): increase MPEG encoder timout
      V4L/DVB (11734): remove hw reset of MPEG encoder when lost/found seq.
      V4L/DVB (11775): tuner: add support Philips MK5 tuner
      V4L/DVB (11934): Change order for FM tune
      V4L/DVB (11938): big rework of TS for saa7134

Douglas Schilling Landgraf (1):
      V4L/DVB (11486): em28xx: Add EmpireTV board support

Erik Andr?n (62):
      V4L/DVB (11450): gspca - m5602-mt9m111: Convert the mt9m111 to use a v4l2 ctrl cache
      V4L/DVB (11452): gspca - m5602-po1030: Convert to have a v4l2 ctrl cache
      V4L/DVB (11453): gspca - m5602-s5k4aa: Convert to use the v4l2 ctrl cache
      V4L/DVB (11454): gspca - m5602-mt9m111: Remove the unused power_down struct member
      V4L/DVB (11455): gspca - m5602-ov9650: Improve the vflip quirk handling.
      V4L/DVB (11456): gspca - m5602-po1030: Rename register defines, add missing ones.
      V4L/DVB (11457): gspca - m5602-po1030: Simplify register defines
      V4L/DVB (11458): gspca - m5602-po1030: Set all v4l2 controls at sensor init
      V4L/DVB (11459): gspca - m5602-po1030: Add auto white balancing control
      V4L/DVB (11460): gspca - m5602-po1030: Remove unnecessary error check
      V4L/DVB (11461): gspca - m5602-po1030: Probe read only register at probe time
      V4L/DVB (11462): gspca - m5602-po1030: Split up the init into init and start
      V4L/DVB (11463): gspca - m5602-po1030: Remove unneeded init sequences
      V4L/DVB (11464): gspca - m5602-mt9m111: Set the cached v4l2 ctrl values
      V4L/DVB (11465): gspca - m5602-s5k4aa: Set all v4l2 ctrls on sensor init.
      V4L/DVB (11466): gspca - m5602: Let all ctrls on all sensors be static
      V4L/DVB (11467): gspca - m5602: Move all dump_sensor to the init function
      V4L/DVB (11468): gspca - m5602-mt9m111: Remove redundant init sequences
      V4L/DVB (11469): gspca - m5602-mt9m111: More redundant init cleanup
      V4L/DVB (11470): gspca - m5602-mt9m111: Implement an auto white balancing control
      V4L/DVB (11471): gspca - m5602-mt9m111: Remove more redundant init
      V4L/DVB (11472): gspca - m5602-mt9m111: Remove lots of redundant init code
      V4L/DVB (11473): gspca - m5602-po1030: Release reset when init is done.
      V4L/DVB (11474): gspca - m5602-po1030: Fix sensor probing.
      V4L/DVB (11475): gspca - m5602-po1030: Lower the default blue and gain balance
      V4L/DVB (11476): gspca - m5602: Add some more register defines
      V4L/DVB (11477): gspca - m5602-po1030: Set the blue balance in the init not red balance twice
      V4L/DVB (11478): gspca - m5602-mt9m111: Replace various magic constants with defines
      V4L/DVB (11479): gspca - m5602-mt9m111: More magic constants replacement
      V4L/DVB (11480): gspca - m5602-mt9m111: Remove lots of redundant sensor reads
      V4L/DVB (11481): gspca - m5602-mt9m111: More constant replacement
      V4L/DVB (11482): gspca - m5602-mt9m111: Remove lots of redundant init code
      V4L/DVB (11520): gspca - m5602-po1030: Remove redundant init sequences
      V4L/DVB (11521): gspca - m5602-ov9650: Add auto exposure ctrl
      V4L/DVB (11522): gspca - m5602-po1030: Add auto exposure control
      V4L/DVB (11523): gspca - m5602-po1030: Add private green balance control
      V4L/DVB (11524): gspca - m5602-mt9m111: Add green balance ctrl
      V4L/DVB (11525): gspca - m5602-mt9m111: Add blue balance ctrl
      V4L/DVB (11526): gspca - m5602-mt9m111: Add red balance ctrl
      V4L/DVB (11527): gspca - m5602-s5k4aa: Try to use proper read-modify-write of the vflip/hflip
      V4L/DVB (11528): gspca - m5602-s5k4aa: Consolidate the gain settings, adjust row start
      V4L/DVB (11529): gspca - m5602-s5k4aa: Add noise suppression ctrl
      V4L/DVB (11530): gspca - m5602-s5k4aa: Add brightness v4l2 ctrl
      V4L/DVB (11531): gspca - m5602-po1030: Clean up some comments
      V4L/DVB (11532): gspca - m5602-po1030: Move some code from the start vector to the init vector
      V4L/DVB (11533): gspca - m5602-po1030: Setup window per resolution
      V4L/DVB (11534): gspca - m5602-po1030: Synthesize the hsync/vsync setup
      V4L/DVB (11535): gspca - m5602-po1030: Add experimental QVGA support
      V4L/DVB (11536): gspca - m5602-po1030: Impove the bridge vsync/hsync configuration
      V4L/DVB (11537): gspca - m5602-po1030: Clear subsampling flag when setting VGA mode
      V4L/DVB (11538): gscpa - m5602-ov9650: Add defines for some magic constants
      V4L/DVB (11539): gspca - m5602-ov9650: Be more strict during the hsync/vsync synthesis
      V4L/DVB (11540): gspca - m5602-mt9m111: Replace magic constants with defines
      V4L/DVB (11541): gspca - m5602-mt9m111: Add a start function
      V4L/DVB (11542): gspca - m5602-mt9m111: Synthesize the hsync/vsync setup
      V4L/DVB (11543): gspca - m5602-mt9m111: Setup VGA resolution
      V4L/DVB (11544): gspca - m5602-mt9m111: Add experimental QVGA support
      V4L/DVB (11545): gspca - m5602-mt9m111: Activate vflip/hflip by default
      V4L/DVB (11546): gspca - m5602-mt9m111: Endianness fixes.
      V4L/DVB (11547): gspca - m5602-s5k83a: Align the v4l2 ctrl definitions
      V4L/DVB (11548): gspca - m5602-s5k83a: No need to initialize some registers in init
      V4L/DVB (11549): gspca - m5602-s5k83a: Remove lots of useless init

Erik Andrén (34):
      V4L/DVB (11628): gspca - m5602-s5k83a: Remove more init
      V4L/DVB (11629): gspca - m5602-s5k83a: Move some init code around
      V4L/DVB (11630): gspca - s5k83a: Add resolution annotations
      V4L/DVB (11631): gspca - m5602: Remove useless error check
      V4L/DVB (11632): gspca - m5602-s5k83a: Reset the v4l2 ctrl cache upon sensor init
      V4L/DVB (11633): gspca - m5602-s5k83a: Move hsync/vsync setup to start function
      V4L/DVB (11635): gspca - m5602-ov7660: Initial checkin of sensor skeleton code
      V4L/DVB (11636): gspca - m5602-ov7660: Design probe function
      V4L/DVB (11637): gspca - m5602-ov7660: Design init function.
      V4L/DVB (11638): gspca - m5602-ov7660: Make an educated guess on the proper hsync/vsync
      V4L/DVB (11639): gspca - m5602-mt9m111: Correct the hflip/vflip semantics
      V4L/DVB (11640): gspca - m5602-s5k4aa: Flip hflip and vflip together
      V4L/DVB (11641): gspca - m5602-ov7660: Remove useless init data
      V4L/DVB (11642): gspca - m5602-ov7660: Add a gain ctrl
      V4L/DVB (11643): gspca - m5602: Add the ov7660 to the module parameter description.
      V4L/DVB (11644): gspca - m5602-s5k4aa: Remove some unneeded init code.
      V4L/DVB (11646): gspca - m5602-mt9m111: Disable QVGA until it has been verified to work
      V4L/DVB (11647): gspca - m5602-po1030: Disable QVGA for now
      V4L/DVB (11648): gspca - m5602: Remove some needless error checking and add comments
      V4L/DVB (11649): gspca - m5602: Probe the ov7660 sensor
      V4L/DVB (11650): gspca - m5602: Sort out macro conflict by adding a prefix
      V4L/DVB (11684): gspca - m5602-s5k4aa: Add experimental SXGA support
      V4L/DVB (11685): gspca - gspca-m5602: Constify parameters of two functions
      V4L/DVB (11686): gspca - m5602-s5k4aa: Disable SXGA resolution for now
      V4L/DVB (11687): gspca - m5602-ov9650: Add missing v4l2 ctrl ids
      V4L/DVB (11690): gspca - m5602-s5k4aa: Add vflip quirk for the MSI L735
      V4L/DVB (11691): gspca - m5602-ov9650: Add ASUS A6K vflip quirk
      V4L/DVB (11692): gspca - m5602: Checkpatch.pl fixes
      V4L/DVB (11693): gspca - stv06xx-vv6410: Add exposure ctrl
      V4L/DVB (11694): gspca - stv06xx-vv6410: No need to double set gain and exposure
      V4L/DVB (11695): gspca - stv06xx-vv6410: Set analog gain at init
      V4L/DVB (11940): gspca - m5602-s5k4aa: Add vflip quirk for the Lenovo Y300
      V4L/DVB (11941): gspca - m5602-ov9650: Add vflip quirk for the ASUS A6VA
      V4L/DVB (11942): gspca - m5602-ov9650: Reorder quirk list and add A7V quirk

FUJITA Tomonori (1):
      V4L/DVB (11937): vino: replace dma_sync_single with dma_sync_single_for_cpu

Figo.zhang (5):
      V4L/DVB (11953): videobuf-dma-sg: return -ENOMEM if vmalloc fails
      V4L/DVB (11958): usbvision-core.c: vfree does its own NULL check
      V4L/DVB (11991): buf-core.c: add pointer check
      V4L/DVB (11995): zr364xx.c: vfree does its own NULL check
      V4L/DVB (12004): poll method lose race condition

Filipe Rosset (3):
      V4L/DVB (11487): em28xx: fix typo em28xx_errdev message
      V4L/DVB (11838): uvcvideo: Add Lenovo Thinkpad SL400 to device list comments
      V4L/DVB (11895): bt8xx: remove always false if

Frank Dischner (1):
      V4L/DVB (11987): au8522: add support for QAM-64 modulation type

Franklin Meng (2):
      V4L/DVB (11976): em28xx: set up tda9887_conf in em28xx_card_setup()
      V4L/DVB (11977): em28xx: Add Kworld 315 entry

Greg Kroah-Hartman (1):
      V4L/DVB (11739): remove driver_data direct access of struct device

Grégory Lardière (2):
      V4L/DVB (11688): gspca - m5602-s5k4aa: Fixup SXGA resolution.
      V4L/DVB (11689): gspca - m5602-s5k4aa: Fixup the vflip/hflip

Guennadi Liakhovetski (6):
      V4L/DVB (11607): soc-camera: add a free_bus method to struct soc_camera_link
      V4L/DVB (11608): soc-camera: host-driver cleanup
      V4L/DVB (11609): soc-camera: remove an extra device generation from struct soc_camera_host
      V4L/DVB (11610): soc-camera: simplify register access routines in multiple sensor drivers
      V4L/DVB (11611): soc-camera: link host drivers after clients
      V4L/DVB (11705): soc-camera: prepare for the platform driver conversion

Hans Verkuil (7):
      V4L/DVB (11670): tuner: remove tuner_i2c_address_check
      V4L/DVB (11671): v4l2: add v4l2_device_set_name()
      V4L/DVB (11672): ivtv: use v4l2_device_set_name.
      V4L/DVB (11673): v4l2-device: unregister i2c_clients when unregistering the v4l2_device.
      V4L/DVB (11676): radio-fm16: cleanups
      V4L/DVB (11677): radio-fm16: fix g_tuner.
      V4L/DVB (11967): v4l: i2c modules must be linked before the v4l2 drivers

Hans de Goede (6):
      V4L/DVB (11448): gspca - main: Use usb interface as parent.
      V4L/DVB (11871): gspca - spca561: Change the Rev12a controls.
      V4L/DVB (11872): gspca - spca561: Rename the 'White Balance' control to 'Hue'.
      V4L/DVB (11970): gspca - ov519: Add support for the ov518 bridge.
      V4L/DVB (11972): gspca - main: Skip disabled controls.
      V4L/DVB (11870): gspca - main: VIDIOC_ENUM_FRAMESIZES ioctl added.

Huang Weiyi (1):
      V4L/DVB: cx231xx: remove unused #include <linux/version.h>'s

Igor M. Liplianin (4):
      V4L/DVB (11981): Remote control debugging for dw2102 driver based USB cards
      V4L/DVB (11982): Add keymaps for TeVii and TBS USB DVB-S/S2 cards
      V4L/DVB (11983): Add support for DVBWorld DVB-C USB Cable card.
      V4L/DVB (11984): Add support for yet another SDMC DM1105 based DVB-S card.

Jan Ceuleers (1):
      V4L/DVB (11962): dvb: Fix broken link in get_dvb_firmware for nxt2004 (A180)

Jan Nikitenko (1):
      V4L/DVB (11999): af9015: fix stack corruption bug

Jani Monoses (1):
      V4L/DVB (11720): gspca - sonixj: Webcam 06f8:3008 added

Jean Delvare (13):
      V4L/DVB (11564): tda7432: Delete old driver history
      V4L/DVB (11723): Link firmware to physical device
      V4L/DVB (11737): Drop stray references to i2c_probe
      V4L/DVB (11748): pvrusb2: Don't use the internal i2c client list
      V4L/DVB (11843): ir-kbd-i2c: Don't use i2c_client.name for our own needs
      V4L/DVB (11844): ir-kbd-i2c: Switch to the new-style device binding model
      V4L/DVB (11845): ir-kbd-i2c: Use initialization data
      V4L/DVB (11846): ir-kbd-i2c: Don't assume all IR receivers are supported
      V4L/DVB (11847): saa7134: Simplify handling of IR on MSI TV@nywhere Plus
      V4L/DVB (11848): saa7134: Simplify handling of IR on AVerMedia Cardbus E506R
      V4L/DVB (11849): ivtv: Probe more I2C addresses for IR devices
      V4L/DVB (11850): pvrusb2: Instantiate ir_video I2C device by default
      V4L/DVB (11992): Add missing __devexit_p()

Jean-Francois Moine (20):
      V4L/DVB (11446): gspca - t613: Do sensor reset only for sensor om6802.
      V4L/DVB (11449): gspca - zc3xx: Bad probe of many webcams since adcm2700 addition.
      V4L/DVB (11708): gspca - main: Version change.
      V4L/DVB (11709): gspca - zc3xx: Bad debug level in i2c_read
      V4L/DVB (11710): gspca - main: Webcams cannot do both isoc and bulk image transfers.
      V4L/DVB (11711): gspca - main: Fix a crash when no bandwidth available
      V4L/DVB (11712): gspca - main:  Set the current alternate setting only when needed
      V4L/DVB (11713): gspca - ov534: Don't discard the images when no UVC EOF
      V4L/DVB (11714): gspca - spca500 and sunplus: Change the 0x00 insertion mechanism.
      V4L/DVB (11715): gspca - main: Set the number of packets per ISOC message.
      V4L/DVB (11716): gspca - sonixj: Adjust some exchanges according to traces
      V4L/DVB (11717): gspca - sonixj: Webcams with bridge sn9c128 added
      V4L/DVB (11718): gspca - vc032x: Bad pixelformat for mi1320_soc
      V4L/DVB (11719): gspca - vc032x: mi1320_soc images are upside-down
      V4L/DVB (11867): gspca - spca508: Cleanup source and update copyright.
      V4L/DVB (11868): gspca - spca508: Optimize code.
      V4L/DVB (11869): gspca - ov534: JPEG 320x240 and 640x480 formats for ov965x.
      V4L/DVB (11969): gspca - spca505: Reinitialize the webcam at resume time.
      V4L/DVB (11971): gspca - doc: Add the 05a9:a518 webcam to the Documentation.
      V4L/DVB (11973): gspca - ov534: Do the ov772x work again.

Johannes Klug (1):
      V4L/DVB (11645): gspca - m5602-ov9650: Add image flip quirk for the ASUS A6VA

Joseba Goitia Gandiaga (1):
      V4L/DVB (11488): get_dvb_firmware: trivial url change

Kay Sievers (1):
      V4L/DVB (11517): v4l: remove driver-core BUS_ID_SIZE

Laurent Pinchart (8):
      V4L/DVB (11835): uvcvideo: Parse frame descriptors with non-continuous indexes.
      V4L/DVB (11836): uvcvideo: Add missing whitespaces to multi-line format strings.
      V4L/DVB (11837): uvcvideo: Start status polling on device open
      V4L/DVB (11944): uvcvideo: Add generic control blacklist.
      V4L/DVB (11945): uvcvideo: Don't accept to change the format when buffers are allocated.
      V4L/DVB (11946): uvcvideo: Add support for Aveo Technology webcams
      V4L/DVB (11947): uvcvideo: Add support for FSC V30S webcams
      V4L/DVB (11948): uvcvideo: Ignore non-UVC trailing interface descriptors.

Lennart Poettering (2):
      V4L/DVB (11960): v4l: generate KEY_CAMERA instead of BTN_0 key events on input devices
      V4L/DVB (11993): V4L/pwc - use usb_interface as parent, not usb_device

Luk?? Karas (1):
      V4L/DVB (11451): gspca - m5602-s5k83a: Add rotation, ctrl cache. Rename some ctrls.

Lukas Karas (1):
      V4L/DVB (11634): gspca - m5602-s5k83a: Set the sensor_settings pointer correctly

Magnus Damm (1):
      V4L/DVB (11731): buf-dma-contig: remove sync operation

Manu Abraham (10):
      V4L/DVB (11579): Initial go at TT S2-1600
      V4L/DVB (11581): stv090x and stv6110x: fix repeater level setup and ref clock
      V4L/DVB (11582): stv090x: fix Undocumented Registers
      V4L/DVB (11586): stv090x: switch i/p ADC as well during Power management
      V4L/DVB (11587): stv090x: set DiSEqC frequency to 22kHz
      V4L/DVB (11588): stv090x: support > 60MSPS, simplify Srate calculation
      V4L/DVB (11589): stv090x: code simplification
      V4L/DVB (11590): stv090x: code simplification
      V4L/DVB (11591): stv090x: code simplification
      V4L/DVB (11682): STV0900/STV0903: Add support for Silicon cut >= 3

Marcel Jueling (1):
      V4L/DVB (11492): af9015: support for Conceptronic USB2.0 DVB-T CTVDIGRCU V3.0

Mariusz Kozlowski (1):
      V4L/DVB (11566): remove broken macro from dvb stv0900_priv.h

Marton Balint (3):
      V4L/DVB (11394): cx88: Add support for stereo and sap detection for A2
      V4L/DVB (11395): cx88: audio thread: if stereo detection is hw supported don't do it manually
      V4L/DVB (11396): cx88: avoid reprogramming every audio register on A2 stereo/mono change

Matthias Schwarzott (2):
      V4L/DVB (11828): Reducing print-level of I2C error prints
      V4L/DVB (11894): flexcop-pci: dmesg visible names broken

Matthieu CASTET (1):
      V4L/DVB (11832): dibusb_mc: fix i2c to not corrupt eeprom in case of strange read pattern

Mauro Carvalho Chehab (10):
      V4L/DVB (11654a): Add a missing end of line at the end of gspca/m5602/Makefile
      V4L/DVB (11663): Fix a warning introduced by git commit ec5f5bf80501abfe2da2897cfcde8452b545aacb
      V4L/DVB (11825): em28xx: add Terratec Grabby
      V4L/DVB (11827): Add support for Terratec Grabster AV350
      V4L/DVB (11917): Fix firmware load for DVB-T @ 6MHz bandwidth for xc3028/xc3028L
      V4L/DVB (11918): tuner-xc2028: Fix offset frequencies for DVB @ 6MHz
      V4L/DVB (11922): tuner-xc2028: cleanup: better use tuner type defines
      V4L/DVB (11966): ov511: Fix unit_video parameter behavior
      V4L/DVB (11986): Kconfig: DVBWorld DVB-C USB Cable card needs tda1002x frontend
      V4L/DVB (11780): Siano: fix compilation error due to the lack of EXTERNAL_SYMBOL

Michael Krufky (11):
      V4L/DVB (11766): cx23885: mark functions encoder_on_port[bc] as static inline
      V4L/DVB (11768): cx23885: add ATSC/QAM tuning support for Hauppauge WinTV-HVR1270
      V4L/DVB (11769): cx23885: add ATSC/QAM tuning support for Hauppauge WinTV-HVR1275
      V4L/DVB (11770): cx23885: add ATSC/QAM tuning support for Hauppauge WinTV-HVR1255
      V4L/DVB (11771): cx23885: add DVB-T tuning support for Hauppauge WinTV-HVR1210
      V4L/DVB (11772): cx23885: update model matrix for "k2c2" retail boards
      V4L/DVB (11773): cx23885: clean up struct names for Hauppauge WinTV-HVR127X devices
      V4L/DVB (11858): cx23885: fix tda10048 IF frequencies for the Hauppauge WinTV-HVR1210
      V4L/DVB (11860): saa7134: fix quirk in saa7134_i2c_xfer for the saa7131 bridge
      V4L/DVB (11861): saa7134: enable digital tv support for Hauppauge WinTV-HVR1110r3
      V4L/DVB (11877): lgdt3305: fix 64bit division in function lgdt3305_set_if

Mike Isely (5):
      V4L/DVB (11744): pvrusb2: Select, track, and report IR scheme in use with the device
      V4L/DVB (11745): pvrusb2: Update to work with upcoming ir_video changes in v4l-dvb core
      V4L/DVB (11746): pvrusb2: Set ir_video autoloading to default disabled
      V4L/DVB (11747): pvrusb2: Bump up version advertised through v4l interface
      V4L/DVB (11750): pvrusb2: Allocate a routing ID for future support of Terratec Grabster AV400

Miroslav Sustek (2):
      V4L/DVB (11879): Adds support for Leadtek WinFast DTV-1800H
      V4L/DVB (11441): cx88-dsp: fixing 64bit math

Márton Németh (2):
      V4L/DVB (11573): uvcvideo: Prevent invormation loss with removing implicit casting
      V4L/DVB (11574): uvcvideo: fill reserved fields with zero of VIDIOC_QUERYMENU

Németh Márton (1):
      V4L/DVB (11736): videobuf: modify return value of VIDIOC_REQBUFS ioctl

Oldřich Jedlička (1):
      V4L/DVB (11567): saa7134: Added support for AVerMedia Cardbus Plus

Oliver Endriss (5):
      V4L/DVB (11759): dvb-ttpci: Add TS replay capability
      V4L/DVB (11760): dvb-ttpci: Check transport error indicator flag
      V4L/DVB (11761): dvb-ttpci: Fixed VIDEO_SLOWMOTION ioctl
      V4L/DVB (11762): dvb-ttpci: Fixed return code of av7110_av_start_play
      V4L/DVB (11763): dvb-ttpci: Some whitespace adjustments

Patrick Boettcher (2):
      V4L/DVB (11829): Rewrote frontend-attach mechanism to gain noise-less deactivation of submodules
      V4L/DVB (11831): dib0700: added USB IDs for Terratec T3 and T5

Pieter Van Schaik (1):
      V4L/DVB (11735): Enables the Winfast TV2000 XP Global TV IR

Randy Dunlap (4):
      V4L/DVB (11756): soc_camera: depends on I2C
      V4L/DVB (11758): 2: handle unregister for non-I2C builds
      V4L/DVB (11881): one kconfig controls them all
      V4L/DVB (11936): Fix v4l2-device usage of i2c_unregister_device()

Robert Jarzmik (1):
      V4L/DVB (11613): pxa_camera: Documentation of the FSM

Robert Krakora (2):
      V4L/DVB (11896): em28xx: Fix for Slow Memory Leak
      V4L/DVB (12002): uvc: Fix for no return value check of uvc_ctrl_set() which calls mutex_lock_interruptible()

Roel Kluin (4):
      V4L/DVB: cx23885/cymax2: binary/logical &/&& typo
      V4L/DVB: cleanup redundant tests on unsigned
      V4L/DVB (11741): zoran: Fix &&/|| typo
      V4L/DVB (11961): tvp514x: try_count off by one

Simon Arlott (1):
      V4L/DVB (11841): core: fix potential mutex_unlock without mutex_lock in dvb_dvr_read

Steven Toth (13):
      V4L/DVB (11665): cx88: Add support for the Hauppauge IROnly board.
      V4L/DVB (11666): cx23885: Don't assume GPIO interrupts are cam related.
      V4L/DVB (11697): tda10048: Add ability to select I/F at attach time.
      V4L/DVB (11698): cx23885: For tda10048 boards ensure we specify the I/F
      V4L/DVB (11699): pvrusb2: Ensure we specify the I/F at attach time
      V4L/DVB (11700): tda10048: Added option to block i2c gate control from other drivers.
      V4L/DVB (11701): pvrusb2: Ensure the PVRUSB2 disabled the i2c gate on the tda10048.
      V4L/DVB (11765): cx23885: Add generic functions for driving GPIO's
      V4L/DVB (11767): cx23885: Add preliminary support for the HVR1270
      V4L/DVB (11854): TDA10048: Ensure the I/F changes during DVB-T 6/7/8 bandwidth changes.
      V4L/DVB (11855): cx23885: Ensure we specify I/F's for all bandwidths
      V4L/DVB (11856): pvrusb2: Ensure we specify I/F's for all bandwidths
      V4L/DVB (11857): TDA10048: Missing two I/F's / Pll combinations from the PLL table

Theodore Kilgore (1):
      V4L/DVB (11483): gspca - mr97310a: Webcam 093a:010f added.

Tobias Klauser (2):
      V4L/DVB (11654): gspca - m5602: Storage class should be before const qualifier
      V4L/DVB (11724): firedtv: Storage class should be before const qualifier

Trent Piepho (1):
      V4L/DVB (11964): b2c2: Fix problems with frontend attachment

Uri Shkolnik (42):
      V4L/DVB (11812): Siano: smsusb - add big endian support
      V4L/DVB (11239): sdio: add cards ids for sms (Siano Mobile Silicon) MDTV receivers
      V4L/DVB (11240): siano: add high level SDIO interface driver for SMS based cards
      V4L/DVB (11552): Siano: SDIO interface driver - remove two redundant lines
      V4L/DVB (11554): Siano: core header - add definitions and structures
      V4L/DVB (11555): Siano: core - move and update the main core structure declaration
      V4L/DVB (11556): Siano: core header - indentation
      V4L/DVB (11559): Siano: add support for infra-red (IR) controllers
      V4L/DVB (11561): Siano: add messages handling for big-endian target
      V4L/DVB (11726): Modify the file license to match all other Siano's files
      V4L/DVB (11727): Siano: core header - update include files
      V4L/DVB (11728): Siano: smsdvb - modify license
      V4L/DVB (11729): Siano: smsdvb - remove redundent complete instruction
      V4L/DVB (11776): Siano: smsusb - update license
      V4L/DVB (11777): Siano: smsusb - handle byte ordering and big endianity
      V4L/DVB (11778): Siano: smsusb - lost buffers bug fix
      V4L/DVB (11779): Siano: Makefile - add smsendian to build
      V4L/DVB (11781): Siano: smsdvb - add big endian support
      V4L/DVB (11782): Siano: smsdvb - use 'push' status mechanism
      V4L/DVB (11783): Siano: smsdvb - small typo fix ad module author
      V4L/DVB (11813): Siano: move dvb-api headers' includes to dvb adapter
      V4L/DVB (11814): Siano: smscards - add gpio look-up table
      V4L/DVB (11815): Siano: bind infra-red component
      V4L/DVB (11816): Siano: USB - move the device id table to the cards module
      V4L/DVB (11817): Siano: smscards - fix wrong firmware assignment
      V4L/DVB (11818): Siano: smscards - assign gpio to HPG targets
      V4L/DVB (11819): Siano: smscore - fix get_common_buffer bug
      V4L/DVB (11820): Siano: smscore - fix byte ordering bug
      V4L/DVB (11821): Siano: smscore - fix isdb-t firmware name
      V4L/DVB (11822): Siano: smscore - bug fix at get_device_mode
      V4L/DVB (11823): Siano: smsusb - fix typo in module description
      V4L/DVB (11824): Siano: smsusb - change exit func debug msg
      V4L/DVB (11883): Siano: cards - add two additional (USB) devices
      V4L/DVB (11884): Siano: smssdio - revert to stand alone module
      V4L/DVB (11885): Siano: Add new GPIO management interface
      V4L/DVB (11886): Siano: smscore - fix some new GPIO definitions names
      V4L/DVB (11887): Siano: smscards - add board (target) events
      V4L/DVB (11888): Siano: smsusb - remove redundant ifdef
      V4L/DVB (11889): Siano: smsdvb - add DVB v3 events
      V4L/DVB (11890): Siano: smscore - remove redundant code
      V4L/DVB (11891): Siano: smscore - bind the GPIO SMS protocol
      V4L/DVB (11892): Siano: smsendian - declare function as extern

Wen-chien Jesse Sung (1):
      V4L/DVB (11730): af9015: support for KWorld MC810

figo.zhang (3):
      V4L/DVB (11852): saa7134-video.c: poll method lose race condition
      V4L/DVB (11853): minor have assigned value twice
      V4L/DVB (11990): saa7134-video.c: fix the block bug

hermann pitton (1):
      V4L/DVB (11732): saa7134: disable not yet existing IR and DVB support on the Compro T750

tomas petr (1):
      V4L/DVB (11830): dib0700: add support for Leadtek WinFast DTV Dongle H

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
