Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUC8N7O007770
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 07:08:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUC7f4s009981
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 07:07:58 -0500
Date: Tue, 30 Dec 2008 10:07:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20081230100720.43f897eb@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [GIT PATCHES for 2.6.29] V4L/DVB updates
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

For a large series of changes (579 patches), including those changes:
	- Improved V4L2 core, to better support media sub-drivers;
	- Improved DVB core, in order to support some new DVB-S2 frontends;
	- Dynamic DVB minor allocation on dvb core;
	- Added two new controls at V4L2 core, to support Zoom and 
	  Privacy controls on webcams;
	- A review on v4l2-compat32 to make it properly work;
	- new dvb frontends: cx24113, lgdt3304, s921, stb0899, stb6100, 
			     tda8261;
	- new webcam (gspca) drivers: ov534, stv06xx;
	- new driver for omap2 platform;
	- new webcam/video drivers: mt9t031, ov772x, tvp514x, tw9910;

As usual, several driver improvements, new board additions, lots of 
cleanups, fixes and optimizations.

Cheers,
Mauro.

---

 Documentation/dvb/technisat.txt                    |   69 +
 Documentation/video4linux/API.html                 |   43 +-
 Documentation/video4linux/CARDLIST.bttv            |    7 +-
 Documentation/video4linux/CARDLIST.cx23885         |    1 +
 Documentation/video4linux/CARDLIST.cx88            |    5 +-
 Documentation/video4linux/CARDLIST.em28xx          |    9 +-
 Documentation/video4linux/CARDLIST.saa7134         |    3 +-
 Documentation/video4linux/README.cx88              |    8 +-
 Documentation/video4linux/gspca.txt                |   19 +-
 Documentation/video4linux/v4l2-framework.txt       |  520 +++++
 drivers/media/common/ir-keymaps.c                  |   93 +
 drivers/media/common/saa7146_fops.c                |    2 +-
 drivers/media/common/saa7146_video.c               |   10 +-
 drivers/media/common/tuners/mxl5005s.c             |    6 +-
 drivers/media/common/tuners/tda827x.c              |   15 +-
 drivers/media/common/tuners/tda8290.c              |   63 +-
 drivers/media/common/tuners/tda9887.c              |    5 +-
 drivers/media/common/tuners/tuner-xc2028.c         |   35 +
 drivers/media/common/tuners/xc5000.c               |    7 -
 drivers/media/dvb/Kconfig                          |   13 +
 drivers/media/dvb/b2c2/Kconfig                     |    1 +
 drivers/media/dvb/dm1105/dm1105.c                  |    3 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   77 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |  134 ++-
 drivers/media/dvb/dvb-core/dvbdev.c                |   71 +-
 drivers/media/dvb/dvb-core/dvbdev.h                |    1 +
 drivers/media/dvb/dvb-usb/af9015.c                 |   33 +-
 drivers/media/dvb/dvb-usb/af9015.h                 |  140 ++
 drivers/media/dvb/dvb-usb/anysee.c                 |    2 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c         |    3 +-
 drivers/media/dvb/dvb-usb/cinergyT2.h              |   10 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |    1 +
 drivers/media/dvb/dvb-usb/dw2102.c                 |   15 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c              |  140 ++-
 drivers/media/dvb/dvb-usb/gp8psk.c                 |   16 +
 drivers/media/dvb/dvb-usb/gp8psk.h                 |    1 +
 drivers/media/dvb/dvb-usb/usb-urb.c                |    3 +-
 drivers/media/dvb/frontends/Kconfig                |   53 +
 drivers/media/dvb/frontends/Makefile               |   10 +
 drivers/media/dvb/frontends/af9013.c               |   14 +-
 drivers/media/dvb/frontends/cx24113.c              |  616 ++++++
 drivers/media/dvb/frontends/cx24113.h              |   11 +-
 drivers/media/dvb/frontends/cx24116.c              |   43 +-
 drivers/media/dvb/frontends/dib7000p.h             |    9 +-
 drivers/media/dvb/frontends/drx397xD.c             |   12 +-
 drivers/media/dvb/frontends/drx397xD_fw.h          |    4 +-
 drivers/media/dvb/frontends/dvb-pll.c              |    2 +-
 drivers/media/dvb/frontends/lgdt3304.c             |  378 ++++
 drivers/media/dvb/frontends/lgdt3304.h             |   45 +
 drivers/media/dvb/frontends/s5h1411.c              |    3 +
 drivers/media/dvb/frontends/s921_core.c            |  216 +++
 drivers/media/dvb/frontends/s921_core.h            |  114 ++
 drivers/media/dvb/frontends/s921_module.c          |  190 ++
 drivers/media/dvb/frontends/s921_module.h          |   49 +
 drivers/media/dvb/frontends/si21xx.c               |    1 -
 drivers/media/dvb/frontends/stb0899_algo.c         | 1519 +++++++++++++++
 drivers/media/dvb/frontends/stb0899_cfg.h          |  287 +++
 drivers/media/dvb/frontends/stb0899_drv.c          | 1684 ++++++++++++++++
 drivers/media/dvb/frontends/stb0899_drv.h          |  162 ++
 drivers/media/dvb/frontends/stb0899_priv.h         |  267 +++
 drivers/media/dvb/frontends/stb0899_reg.h          | 2027 ++++++++++++++++++++
 drivers/media/dvb/frontends/stb6100.c              |  545 ++++++
 drivers/media/dvb/frontends/stb6100.h              |  115 ++
 drivers/media/dvb/frontends/stb6100_cfg.h          |  108 ++
 drivers/media/dvb/frontends/tda8261.c              |  230 +++
 drivers/media/dvb/frontends/tda8261.h              |   55 +
 drivers/media/dvb/frontends/tda8261_cfg.h          |   84 +
 drivers/media/dvb/frontends/zl10353.c              |    3 +
 drivers/media/dvb/siano/sms-cards.c                |  110 ++
 drivers/media/dvb/siano/sms-cards.h                |   13 +
 drivers/media/dvb/siano/smscoreapi.c               |   78 +
 drivers/media/dvb/siano/smscoreapi.h               |   36 +-
 drivers/media/dvb/siano/smsdvb.c                   |   56 +-
 drivers/media/dvb/siano/smsusb.c                   |   45 +
 drivers/media/dvb/ttpci/Kconfig                    |    4 +
 drivers/media/dvb/ttpci/budget-av.c                |  298 +++
 drivers/media/dvb/ttpci/budget-ci.c                |  311 +++
 drivers/media/dvb/ttpci/budget.h                   |    1 +
 drivers/media/radio/dsbr100.c                      |  381 +++-
 drivers/media/radio/radio-aimslab.c                |    2 +-
 drivers/media/radio/radio-cadet.c                  |    2 +-
 drivers/media/radio/radio-gemtek.c                 |    2 +-
 drivers/media/radio/radio-mr800.c                  |  123 +-
 drivers/media/radio/radio-rtrack2.c                |    2 +-
 drivers/media/radio/radio-sf16fmi.c                |    2 +-
 drivers/media/video/Kconfig                        |   48 +-
 drivers/media/video/Makefile                       |   12 +-
 drivers/media/video/arv.c                          |    5 +-
 drivers/media/video/bt8xx/bt832.c                  |  274 ---
 drivers/media/video/bt8xx/bt832.h                  |  305 ---
 drivers/media/video/bt8xx/bttv-cards.c             |   72 +-
 drivers/media/video/bt8xx/bttv-gpio.c              |    7 +-
 drivers/media/video/bt8xx/bttv.h                   |   10 +-
 drivers/media/video/bt8xx/bttvp.h                  |    2 +-
 drivers/media/video/bw-qcam.c                      |    5 +-
 drivers/media/video/c-qcam.c                       |    7 +-
 drivers/media/video/cpia.c                         |    9 +-
 drivers/media/video/cpia2/cpia2_core.c             |    2 +-
 drivers/media/video/cpia2/cpia2_usb.c              |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |   15 +-
 drivers/media/video/cs5345.c                       |  227 ++-
 drivers/media/video/cs53l32a.c                     |  188 ++-
 drivers/media/video/cx18/cx18-av-audio.c           |  231 ++-
 drivers/media/video/cx18/cx18-av-core.c            |  106 +-
 drivers/media/video/cx18/cx18-av-core.h            |    5 +-
 drivers/media/video/cx18/cx18-av-firmware.c        |   28 +-
 drivers/media/video/cx18/cx18-av-vbi.c             |    5 +-
 drivers/media/video/cx18/cx18-cards.c              |    9 +-
 drivers/media/video/cx18/cx18-cards.h              |    6 +-
 drivers/media/video/cx18/cx18-controls.c           |    5 +-
 drivers/media/video/cx18/cx18-driver.c             |  284 +++-
 drivers/media/video/cx18/cx18-driver.h             |   78 +-
 drivers/media/video/cx18/cx18-dvb.c                |   59 +-
 drivers/media/video/cx18/cx18-dvb.h                |    1 -
 drivers/media/video/cx18/cx18-fileops.c            |   38 +-
 drivers/media/video/cx18/cx18-firmware.c           |  229 ++-
 drivers/media/video/cx18/cx18-gpio.c               |   21 +-
 drivers/media/video/cx18/cx18-gpio.h               |    1 +
 drivers/media/video/cx18/cx18-i2c.c                |   31 +-
 drivers/media/video/cx18/cx18-io.c                 |  198 +--
 drivers/media/video/cx18/cx18-io.h                 |  326 +---
 drivers/media/video/cx18/cx18-ioctl.c              |   12 +-
 drivers/media/video/cx18/cx18-ioctl.h              |    1 +
 drivers/media/video/cx18/cx18-irq.c                |  163 +--
 drivers/media/video/cx18/cx18-irq.h                |    4 +-
 drivers/media/video/cx18/cx18-mailbox.c            |  527 ++++-
 drivers/media/video/cx18/cx18-mailbox.h            |   29 +-
 drivers/media/video/cx18/cx18-queue.c              |  120 +-
 drivers/media/video/cx18/cx18-queue.h              |   22 +-
 drivers/media/video/cx18/cx18-scb.c                |    2 +-
 drivers/media/video/cx18/cx18-scb.h                |    9 +-
 drivers/media/video/cx18/cx18-streams.c            |  140 +-
 drivers/media/video/cx18/cx18-streams.h            |    5 +
 drivers/media/video/cx18/cx18-vbi.c                |    5 +-
 drivers/media/video/cx18/cx18-version.h            |    2 +-
 drivers/media/video/cx18/cx23418.h                 |    6 +
 drivers/media/video/cx23885/cx23885-417.c          |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   12 +
 drivers/media/video/cx23885/cx23885-dvb.c          |    1 +
 drivers/media/video/cx23885/cx23885.h              |    1 +
 drivers/media/video/cx25840/Kconfig                |    2 +-
 drivers/media/video/cx25840/cx25840-audio.c        |   14 +-
 drivers/media/video/cx25840/cx25840-core.c         |  447 +++--
 drivers/media/video/cx25840/cx25840-core.h         |    7 +
 drivers/media/video/cx25840/cx25840-firmware.c     |    2 +-
 drivers/media/video/cx25840/cx25840-vbi.c          |    2 +-
 drivers/media/video/cx88/cx88-alsa.c               |    3 +-
 drivers/media/video/cx88/cx88-blackbird.c          |   16 +-
 drivers/media/video/cx88/cx88-cards.c              |   86 +-
 drivers/media/video/cx88/cx88-core.c               |    3 +
 drivers/media/video/cx88/cx88-dvb.c                |  230 ++--
 drivers/media/video/cx88/cx88-mpeg.c               |    4 +-
 drivers/media/video/cx88/cx88.h                    |   14 +-
 drivers/media/video/em28xx/em28xx-audio.c          |   21 +-
 drivers/media/video/em28xx/em28xx-cards.c          | 1464 +++++++++-----
 drivers/media/video/em28xx/em28xx-core.c           |  628 +++++--
 drivers/media/video/em28xx/em28xx-dvb.c            |   14 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |   49 +-
 drivers/media/video/em28xx/em28xx-input.c          |  311 +++-
 drivers/media/video/em28xx/em28xx-reg.h            |  153 ++-
 drivers/media/video/em28xx/em28xx-video.c          |  851 +++------
 drivers/media/video/em28xx/em28xx.h                |  148 ++-
 drivers/media/video/et61x251/et61x251_core.c       |    2 +-
 drivers/media/video/gspca/Kconfig                  |   23 +-
 drivers/media/video/gspca/Makefile                 |    4 +-
 drivers/media/video/gspca/conex.c                  |    2 +-
 drivers/media/video/gspca/etoms.c                  |    4 +-
 drivers/media/video/gspca/finepix.c                |    5 +-
 drivers/media/video/gspca/gspca.c                  |  210 ++-
 drivers/media/video/gspca/gspca.h                  |   25 +-
 drivers/media/video/gspca/m5602/m5602_bridge.h     |  119 +-
 drivers/media/video/gspca/m5602/m5602_core.c       |  100 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.c    |  135 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.h    |   14 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |  316 ++--
 drivers/media/video/gspca/m5602/m5602_ov9650.h     |  195 ++-
 drivers/media/video/gspca/m5602/m5602_po1030.c     |  166 +--
 drivers/media/video/gspca/m5602/m5602_po1030.h     |   10 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |  235 +--
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h     |   47 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c     |  213 +--
 drivers/media/video/gspca/m5602/m5602_s5k83a.h     |   25 +-
 drivers/media/video/gspca/m5602/m5602_sensor.h     |   14 +-
 drivers/media/video/gspca/mars.c                   |    4 +-
 drivers/media/video/gspca/ov519.c                  |  172 +-
 drivers/media/video/gspca/ov534.c                  |  601 ++++++
 drivers/media/video/gspca/pac207.c                 |    8 +-
 drivers/media/video/gspca/pac7311.c                |    5 +-
 drivers/media/video/gspca/sonixb.c                 |   25 +-
 drivers/media/video/gspca/sonixj.c                 |  508 +++--
 drivers/media/video/gspca/spca500.c                |    8 +-
 drivers/media/video/gspca/spca501.c                |  148 +-
 drivers/media/video/gspca/spca505.c                |    2 +-
 drivers/media/video/gspca/spca506.c                |    2 +-
 drivers/media/video/gspca/spca508.c                |    2 +-
 drivers/media/video/gspca/spca561.c                |  522 +++---
 drivers/media/video/gspca/stk014.c                 |    8 +-
 drivers/media/video/gspca/stv06xx/Kconfig          |    9 +
 drivers/media/video/gspca/stv06xx/Makefile         |    9 +
 drivers/media/video/gspca/stv06xx/stv06xx.c        |  522 +++++
 drivers/media/video/gspca/stv06xx/stv06xx.h        |  107 +
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |  535 ++++++
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |  263 +++
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |  430 +++++
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h |  275 +++
 drivers/media/video/gspca/stv06xx/stv06xx_sensor.h |   92 +
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |  251 +++
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |  315 +++
 drivers/media/video/gspca/sunplus.c                |    6 +-
 drivers/media/video/gspca/t613.c                   |    4 +-
 drivers/media/video/gspca/tv8532.c                 |  142 +--
 drivers/media/video/gspca/vc032x.c                 |  819 ++++++++-
 drivers/media/video/gspca/zc3xx-reg.h              |    8 -
 drivers/media/video/gspca/zc3xx.c                  | 1012 +++++-----
 drivers/media/video/ir-kbd-i2c.c                   |    6 +-
 drivers/media/video/ivtv/ivtv-cards.c              |   16 +-
 drivers/media/video/ivtv/ivtv-controls.c           |   16 +-
 drivers/media/video/ivtv/ivtv-driver.c             |  214 +--
 drivers/media/video/ivtv/ivtv-driver.h             |   52 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |   44 +-
 drivers/media/video/ivtv/ivtv-gpio.c               |  324 ++--
 drivers/media/video/ivtv/ivtv-gpio.h               |    3 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |  314 +---
 drivers/media/video/ivtv/ivtv-i2c.h                |   13 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |   73 +-
 drivers/media/video/ivtv/ivtv-routing.c            |   12 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   15 +-
 drivers/media/video/ivtv/ivtv-vbi.c                |   17 +-
 drivers/media/video/ivtv/ivtvfb.c                  |   91 +-
 drivers/media/video/m52790.c                       |  176 ++-
 drivers/media/video/msp3400-driver.c               |  402 +++--
 drivers/media/video/msp3400-driver.h               |    7 +
 drivers/media/video/msp3400-kthreads.c             |   34 +-
 drivers/media/video/mt9m001.c                      |   60 +-
 drivers/media/video/mt9m111.c                      |  121 +-
 drivers/media/video/mt9t031.c                      |  736 +++++++
 drivers/media/video/mt9v022.c                      |   46 +-
 drivers/media/video/omap24xxcam-dma.c              |  601 ++++++
 drivers/media/video/omap24xxcam.c                  | 1908 ++++++++++++++++++
 drivers/media/video/omap24xxcam.h                  |  593 ++++++
 drivers/media/video/ov511.c                        |    5 +-
 drivers/media/video/ov772x.c                       | 1012 ++++++++++
 drivers/media/video/pms.c                          |    9 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |   13 +-
 drivers/media/video/pwc/pwc-if.c                   |    2 +-
 drivers/media/video/pwc/pwc-v4l.c                  |    3 +-
 drivers/media/video/pwc/pwc.h                      |    3 +-
 drivers/media/video/pxa_camera.c                   |  541 +++++-
 drivers/media/video/saa5246a.c                     |    7 +-
 drivers/media/video/saa5249.c                      |    7 +-
 drivers/media/video/saa7115.c                      |  763 ++++----
 drivers/media/video/saa7127.c                      |  421 +++--
 drivers/media/video/saa7134/saa7134-cards.c        |   52 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   24 +-
 drivers/media/video/saa7134/saa7134-input.c        |   14 +
 drivers/media/video/saa7134/saa7134-tvaudio.c      |    2 +-
 drivers/media/video/saa7134/saa7134.h              |    3 +-
 drivers/media/video/saa717x.c                      |  610 +++---
 drivers/media/video/se401.c                        |    5 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  309 +++-
 drivers/media/video/sn9c102/sn9c102_core.c         |    2 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    8 +
 drivers/media/video/soc_camera.c                   |  389 +++--
 drivers/media/video/soc_camera_platform.c          |   17 +-
 drivers/media/video/stk-webcam.c                   |   27 +-
 drivers/media/video/stv680.c                       |    5 +-
 drivers/media/video/tda7432.c                      |  252 ++--
 drivers/media/video/tda9840.c                      |  188 ++-
 drivers/media/video/tda9875.c                      |  348 ++--
 drivers/media/video/tea6415c.c                     |   49 +-
 drivers/media/video/tea6420.c                      |   49 +-
 drivers/media/video/tlv320aic23b.c                 |  141 +-
 drivers/media/video/tuner-core.c                   |  397 +++--
 drivers/media/video/tvaudio.c                      |  707 ++++----
 drivers/media/video/tvp514x.c                      | 1569 +++++++++++++++
 drivers/media/video/tvp514x_regs.h                 |  297 +++
 drivers/media/video/tvp5150.c                      |  827 ++++----
 drivers/media/video/tw9910.c                       |  951 +++++++++
 drivers/media/video/upd64031a.c                    |  193 ++-
 drivers/media/video/upd64083.c                     |  166 +-
 drivers/media/video/usbvideo/ibmcam.c              |    4 +-
 drivers/media/video/usbvideo/konicawc.c            |    4 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |    9 +-
 drivers/media/video/usbvideo/ultracam.c            |    4 +-
 drivers/media/video/usbvideo/usbvideo.c            |    7 +-
 drivers/media/video/usbvideo/vicam.c               |    3 +-
 drivers/media/video/usbvision/usbvision-video.c    |   11 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |  143 ++-
 drivers/media/video/uvc/uvc_driver.c               |  332 ++--
 drivers/media/video/uvc/uvc_queue.c                |   23 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |  115 +-
 drivers/media/video/uvc/uvc_video.c                |  214 ++-
 drivers/media/video/uvc/uvcvideo.h                 |   34 +-
 drivers/media/video/v4l2-common.c                  |  203 ++-
 .../{compat_ioctl32.c => v4l2-compat-ioctl32.c}    |  835 +++++----
 drivers/media/video/v4l2-dev.c                     |  365 +++-
 drivers/media/video/v4l2-device.c                  |   86 +
 drivers/media/video/v4l2-ioctl.c                   |   98 +-
 drivers/media/video/v4l2-subdev.c                  |  110 ++
 drivers/media/video/vino.c                         |    5 +-
 drivers/media/video/vp27smpx.c                     |  126 +-
 drivers/media/video/w9966.c                        |    5 +-
 drivers/media/video/wm8739.c                       |  188 +-
 drivers/media/video/wm8775.c                       |  221 ++-
 drivers/media/video/zc0301/zc0301_core.c           |    2 +-
 drivers/media/video/zoran/zoran_card.c             |    6 -
 drivers/media/video/zoran/zoran_driver.c           |    8 +-
 firmware/Makefile                                  |   16 +-
 include/linux/videodev2.h                          |   14 +-
 include/media/i2c-addr.h                           |    2 -
 include/media/ir-common.h                          |    2 +
 include/media/ov772x.h                             |   21 +
 include/media/saa7146_vv.h                         |    3 +-
 include/media/soc_camera.h                         |  111 +-
 include/media/tvp514x.h                            |  118 ++
 include/media/tw9910.h                             |   39 +
 include/media/v4l2-chip-ident.h                    |   10 +
 include/media/v4l2-common.h                        |   41 +
 include/media/v4l2-dev.h                           |   51 +-
 include/media/v4l2-device.h                        |  109 ++
 include/media/v4l2-int-device.h                    |    6 +
 include/media/v4l2-ioctl.h                         |   14 +-
 include/media/v4l2-subdev.h                        |  189 ++
 sound/i2c/other/tea575x-tuner.c                    |   22 +-
 326 files changed, 38106 insertions(+), 11077 deletions(-)
 create mode 100644 Documentation/dvb/technisat.txt
 create mode 100644 Documentation/video4linux/v4l2-framework.txt
 create mode 100644 drivers/media/dvb/frontends/cx24113.c
 create mode 100644 drivers/media/dvb/frontends/lgdt3304.c
 create mode 100644 drivers/media/dvb/frontends/lgdt3304.h
 create mode 100644 drivers/media/dvb/frontends/s921_core.c
 create mode 100644 drivers/media/dvb/frontends/s921_core.h
 create mode 100644 drivers/media/dvb/frontends/s921_module.c
 create mode 100644 drivers/media/dvb/frontends/s921_module.h
 create mode 100644 drivers/media/dvb/frontends/stb0899_algo.c
 create mode 100644 drivers/media/dvb/frontends/stb0899_cfg.h
 create mode 100644 drivers/media/dvb/frontends/stb0899_drv.c
 create mode 100644 drivers/media/dvb/frontends/stb0899_drv.h
 create mode 100644 drivers/media/dvb/frontends/stb0899_priv.h
 create mode 100644 drivers/media/dvb/frontends/stb0899_reg.h
 create mode 100644 drivers/media/dvb/frontends/stb6100.c
 create mode 100644 drivers/media/dvb/frontends/stb6100.h
 create mode 100644 drivers/media/dvb/frontends/stb6100_cfg.h
 create mode 100644 drivers/media/dvb/frontends/tda8261.c
 create mode 100644 drivers/media/dvb/frontends/tda8261.h
 create mode 100644 drivers/media/dvb/frontends/tda8261_cfg.h
 delete mode 100644 drivers/media/video/bt8xx/bt832.c
 delete mode 100644 drivers/media/video/bt8xx/bt832.h
 create mode 100644 drivers/media/video/gspca/ov534.c
 create mode 100644 drivers/media/video/gspca/stv06xx/Kconfig
 create mode 100644 drivers/media/video/gspca/stv06xx/Makefile
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx.c
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx.h
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
 create mode 100644 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
 create mode 100644 drivers/media/video/mt9t031.c
 create mode 100644 drivers/media/video/omap24xxcam-dma.c
 create mode 100644 drivers/media/video/omap24xxcam.c
 create mode 100644 drivers/media/video/omap24xxcam.h
 create mode 100644 drivers/media/video/ov772x.c
 create mode 100644 drivers/media/video/tvp514x.c
 create mode 100644 drivers/media/video/tvp514x_regs.h
 create mode 100644 drivers/media/video/tw9910.c
 rename drivers/media/video/{compat_ioctl32.c => v4l2-compat-ioctl32.c} (53%)
 create mode 100644 drivers/media/video/v4l2-device.c
 create mode 100644 drivers/media/video/v4l2-subdev.c
 create mode 100644 include/media/ov772x.h
 create mode 100644 include/media/tvp514x.h
 create mode 100644 include/media/tw9910.h
 create mode 100644 include/media/v4l2-device.h
 create mode 100644 include/media/v4l2-subdev.h

Alain Kalker (1):
      V4L/DVB (9665): af9015: Add support for the Digittrade DVB-T USB Stick remote

Alan Cox (1):
      V4L/DVB (9491): rationalise addresses to one common one

Alan McIvor (2):
      V4L/DVB (9522): Increase number of SAA7134 devices supported in a system
      V4L/DVB (9523): Increase number of BT8XX devices supported in a system

Alan Nisota (1):
      V4L/DVB (9928): Convert GP8PSK module to use S2API

Ales Jurik (1):
      V4L/DVB (9470): Disable PLL Loop while tuning

Alexey Klimov (13):
      V4L/DVB (9518): radio-mr800: remove warn, info and err messages
      V4L/DVB (9539): dsbr100: add suspend and resume
      V4L/DVB (9540): dsbr100: add disabled controls and fix version
      V4L/DVB (9655): radio-mr800: fix unplug
      V4L/DVB (10052): radio-mr800: correct unplug, fix to previous patch
      V4L/DVB (10053): radio-mr800: disable autosuspend support
      V4L/DVB (10054): dsbr100: fix unplug oops
      V4L/DVB (10057): dsbr100: place dev_warn instead of printk
      V4L/DVB (10058): dsbr100: fix codingstyle, add dev_err messages
      V4L/DVB (10059): dsbr100: dev_err instead of dev_warn
      V4L/DVB (10060): dsbr100: fix and add right comments
      V4L/DVB (10061): dsbr100: increase driver version
      V4L/DVB (10062): dsbr100: change return values in 3 functions

Andreas Oberritter (1):
      V4L/DVB (9361): Dynamic DVB minor allocation

Andy Walls (39):
      V4L/DVB (9474): cx18: Remove redundant block scope variable in cx18_probe() for sparse
      V4L/DVB (9512): cx18: Fix write retries for registers that always change - part 3.
      V4L/DVB (9514): cx18: Fix PLL freq computation for debug display
      V4L/DVB (9513): cx18: Reduce number of mmio read retries
      V4L/DVB (9592): cx18: Use default kernel work queue; fix streaming flag for work handler
      V4L/DVB (9593): cx18: Add outgoing mailbox mutexes and check for ack via waitq vs poll
      V4L/DVB (9594): cx18: Roll driver version number due to significant changes
      V4L/DVB (9595): cx18: Improve handling of outgoing mailboxes detected to be busy
      V4L/DVB (9596): cx18: Further changes to improve mailbox protocol integrity & performnce
      V4L/DVB (9597): cx18: Minor fixes to APU firmware load process
      V4L/DVB (9598): cx18: Prevent CX23418 from clearing it's outgoing ack interrupts to driver
      V4L/DVB (9599): cx18: Fix unitialized variable problem upon APU firmware file read failure
      V4L/DVB (9720): cx18: Major rewrite of interrupt handling for incoming mailbox processing
      V4L/DVB (9721): cx18: Change to singlethreaded global work queue thread for deferable work
      V4L/DVB (9722): cx18: Convert per stream queue spinlocks into mutexes
      V4L/DVB (9723): cx18: Propagate staleness of mailbox and mdl ack data to work handler
      V4L/DVB (9724): cx18: Streamline cx18-io[ch] wrappers and enforce MMIO retry strategy
      V4L/DVB (9725): cx18: Remove unnecessary MMIO accesses in time critical irq handling path
      V4L/DVB (9726): cx18: Restore buffers that have fallen out of the transfer rotation
      V4L/DVB (9727): cx18: Adjust outgoing mailbox timeouts and remove statistics logging
      V4L/DVB (9728): cx18: Copyright attribution update for files modified by awalls
      V4L/DVB (9729): cx18: Update version due to significant irq handling changes
      V4L/DVB (9730): cx18: Quiet a sometimes common warning that often has benign consequences
      V4L/DVB (9776): cx18: Change to per CX23418 device work queues for deferrable work handling
      V4L/DVB (9778): cx18: cx18_writel_expect() should not declare success on a PCI read error
      V4L/DVB (9800): cx18: Eliminate q_io from stream buffer handling
      V4L/DVB (9801): cx18: Allow more than 63 capture buffers in rotation per stream
      V4L/DVB (9802): cx18: Add module parameters for finer control over buffer allocations
      V4L/DVB (9803): cx18: Increment version number due to siginificant buffering changes
      V4L/DVB (9804): cx18: Avoid making firmware API calls with the queue lock held
      V4L/DVB (9805): cx18: Port fix for raw/sliced VBI mixup from ivtv and cx25840
      V4L/DVB (9806): cx18: Enable raw VBI capture
      V4L/DVB (9891): cx18 Replace magic number 63 with CX18_MAX_FW_MDLS_PER_STREAM
      V4L/DVB (9892): cx18: VBI comment corrections and comments about VBI issues
      V4L/DVB (9893): cx18: Convert some list manipulations to emphasize entries not lists
      V4L/DVB (9894): cx18: Use a known open task handle when setting stream CX2341x parameters
      V4L/DVB (9895): cx18: Refine the firmware load and firmware startup process
      V4L/DVB (9936): cx18: Disable locking of Video and Audio PLL for analog captures
      V4L/DVB (9937): cx18: Use a consistent crystal value for computing all PLL parameters

Antonio Ospite (7):
      V4L/DVB (9682): gspca: New subdriver parameter 'bulk_nurbs'.
      V4L/DVB (9712): gspca:Subdriver ov534 added.
      V4L/DVB (9855): gspca: Simplify frame rate setting and debug in ov534.
      V4L/DVB (9856): gspca: Use u8 values for USB control messages in ov534.
      V4L/DVB (9857): gspca: Use smaller chunks for urb buffer in ov534.
      V4L/DVB (9882): gspca - ov534: Fix typo.
      V4L/DVB (9883): gspca - ov534: Show sensor ID.

Antti Palosaari (1):
      V4L/DVB (9526): af9015: add support for KWorld USB DVB-T TV Stick II (VS-DVBT 395U)

Arvo Jarve (7):
      V4L/DVB (9345): Add event with changed status only
      V4L/DVB (9429): Add support for the Satelco Easywatch DVB-S2 PCI card
      V4L/DVB (9430): stb0899: avoid parameter overwriting
      V4L/DVB (9432): Increment the AGC1 and AGC2 gain respectively, improves sensitivity slightly
      V4L/DVB (9433): Limit bandwidth with a 3dB response fall
      V4L/DVB (9438): Bug! RTF is signed
      V4L/DVB (9440): Bug in previous commit

Darron Broad (8):
      V4L/DVB (9500): cx88-dvb: MFE attachment fix-up
      V4L/DVB (9576): cx88-dvb: MFE attachment clean-up for HVR-3000/4000
      V4L/DVB (9577): saa7134-dvb: MFE attachment clean-up for saa-7134 dvb
      V4L/DVB (9914): cx24116: bugfix: add missing delsys in FEC lookup
      V4L/DVB (9915): cx24116: fix retune regression introduced in 70ee86a7c630
      V4L/DVB (9916): dvb-core: don't add an event when in ONE SHOT mode for algo type HW
      V4L/DVB (9917): cx24116: change to ALGO_HW
      V4L/DVB (9918): cx88: advise/acquire clean-up for HVR-1300/3000/4000

Devin Heitmueller (30):
      V4L/DVB (9580): Add chip id for em2874 to list of known chips
      V4L/DVB (9581): Remove unused variable from em28xx-audio.c
      V4L/DVB (9582): Add a EM28XX_NODECODER option to the list of available decoders
      V4L/DVB (9583): Remember chip id of devices at initialization
      V4L/DVB (9584): Support different GPIO/GPO registers for newer devices
      V4L/DVB (9585): Skip reading eeprom in newer Empia devices
      V4L/DVB (9586): Fix possible null pointer dereference in info message
      V4L/DVB (9587): Handle changes to endpoint layout in em2874
      V4L/DVB (9588): Don't load em28xx audio module for digital-only devices
      V4L/DVB (9589): Properly support capture start on em2874
      V4L/DVB (9590): Add registration for Pinnacle 80e ATSC tuner
      V4L/DVB (9628): em28xx: refactor IR support
      V4L/DVB (9629): Add support for the ATI TV Wonder HD 600 USB Remote Control
      V4L/DVB (9633): Put s5h1411 into low power mode at end of attach() call
      V4L/DVB (9644): em28xx: add em2750 to the list of known em28xx chip ids
      V4L/DVB (9648): em28xx: get audio config from em28xx register
      V4L/DVB (9657): em28xx: add a functio to write on a single register
      V4L/DVB (9658): em28xx: use em28xx_write_reg() for i2c clock setup
      V4L/DVB (9744): em28xx: cleanup XCLK register usage
      V4L/DVB (9745): em28xx: Cleanup GPIO/GPO setup code
      V4L/DVB (9921): em28xx: add chip id for em2874
      V4L/DVB (9922): em28xx: don't assume every eb1a:2820 reference design is a Prolink PlayTV USB2
      V4L/DVB (9923): xc5000: remove init_fw option
      V4L/DVB (10119): em28xx: fix corrupted XCLK value
      V4L/DVB (10120): em28xx: remove redundant Pinnacle Dazzle DVC 100 profile
      V4L/DVB (10121): em28xx: remove worthless Pinnacle PCTV HD Mini 80e device profile
      V4L/DVB (10122): em28xx: don't load em28xx-alsa for em2870 based devices
      V4L/DVB (10123): em28xx: fix reversed definitions of I2S audio modes
      V4L/DVB (10124): em28xx: expand output formats available
      V4L/DVB (10125): em28xx: Don't do AC97 vendor detection for i2s audio devices

Dirk Heer (1):
      V4L/DVB (9677): bttv: fix some entries on Phytec boards and add missing ones

Douglas Schilling Landgraf (3):
      V4L/DVB (9793): em28xx: Add specific entry for WinTV-HVR 850
      V4L/DVB (10055): em28xx: Add entry for PixelView PlayTV Box 4
      V4L/DVB (10056): em28xx: Add snapshot button on Pixelview Prolink PlayTV USB 2.0

Eric Miao (1):
      V4L/DVB: pxa-camera: use memory mapped IO access for camera (QCI) registers

Erik Andren (1):
      V4L/DVB (10048): gspca - stv06xx: New subdriver.

Erik Andr�n (48):
      V4L/DVB (9693): Remove some unused defines
      V4L/DVB (9694): Indent the m5602 register definitions
      V4L/DVB (9696): Remove accidental typo
      V4L/DVB (9698): Add another vflip quirk for the s5k4aa
      V4L/DVB (9701): Add a minor comment to the sensor init
      V4L/DVB (9702): Move the ov9650 vflip table to avoid compilation warnings on older kernels
      V4L/DVB (9703): Move the s5k4aa vflip quirk table to the main sensor file in order to avoid compilation errors on older kernels
      V4L/DVB (10000): gspca - m5602: Add lost ampersand
      V4L/DVB (10001): gspca - m5602: Minor fixes
      V4L/DVB (10002): m5602: Simplify error handling in the mt9m111 sensor code
      V4L/DVB (10003): m5602: Simplify the error handling in the ov9650 sensor
      V4L/DVB (10004): m5602: Cleanup the po1030 sensor error handling
      V4L/DVB (10005): m5602: Cleanup the s5k4aa error handling, cull some comments
      V4L/DVB (10006): gspca - m5602: Align some defines
      V4L/DVB (10007): gspca - m5602: Refactor the error handling in the s5k83a
      V4L/DVB (10008): gspca - m5602: Checkpatch.pl fixes on m5602_ov9650.c
      V4L/DVB (10009): gspca - m5602: Convert some functions to be static
      V4L/DVB (10010): gspca - m5602: Add vflip quirk for the ASUS A6Ja
      V4L/DVB (10011): m5602: Remove the write and read sensor from the main struct
      V4L/DVB (10012): m5602: Start to unify read/write sensor functions
      V4L/DVB (10013): Convert all sensors to use the unified write sensor function
      V4L/DVB (10014): gspca - m5602: Remove all sensor specific write functions.
      V4L/DVB (10015): gspca - m5602: Add initial read sensor implementation
      V4L/DVB (10018): gspca - m5602 - ov9650: Use generic read_sensor function
      V4L/DVB (10019): m5602: Let the ov9650 use the common read sensor function
      V4L/DVB (10020): m5602: Remove the ov9650 implementation of the read sensor function
      V4L/DVB (10021): m5602: Let the po1030 use the common read_sensor function
      V4L/DVB (10022): m5602: Remove the po1030 read_sensor function
      V4L/DVB (10023): m5602: Convert the mt9m111 to use the common read_sensor function
      V4L/DVB (10024): m5602: Remove the mt9m111 implementation of the read_sensor function.
      V4L/DVB (10025): m5602: convert the s5k4aa sensor to use the common function
      V4L/DVB (10026): m5602: remove the s5k4aa implementation of the read_sensor
      V4L/DVB (10027): m5602: convert the s5k83a sensor to use the common function
      V4L/DVB (10028): mt5602: Remove the s5k83a specific read_sensor function
      V4L/DVB (10029): m5602: remove uneeded test on po1030
      V4L/DVB (10030): m5602: Use read/modify/write when toggling vflip on the po1030
      V4L/DVB (10031): m5602: correct the name of the Pascal Stangs library
      V4L/DVB (10032): m5602: add vflip quirk for Alienware m9700
      V4L/DVB (10033): m5602: add some comments
      V4L/DVB (10034): m5602: fixup offset in order to align image
      V4L/DVB (10035): m5602: add a start sending hook in the sensor struct
      V4L/DVB (10036): m5602 - ov9650: Prepare the sensor to set multiple resolutions
      V4L/DVB (10037): m5602: add QVGA mode for the ov9650 sensor
      V4L/DVB (10038): m5602: tweak the hsync. Remove redundant init sequence
      V4L/DVB (10039): m5602 - ov9650: Add CIF mode
      V4L/DVB (10040): m5602 - ov9650: Activate variopixel
      V4L/DVB (10041): m5602 - rework parts of the resolution initialization
      V4L/DVB (10127): stv06xx: Avoid having y unitialized

FUJITA Tomonori (1):
      V4L/DVB (9472): dm1105: fix the misuse of pci_dma_mapping_error

Fabio Rossi (1):
      V4L/DVB (9999): gspca - zc3xx: Webcam 046d:089d added.

Frederic CAND (1):
      V4L/DVB (9497): tda9887/cx88: Adds SECAM/BGH standards

Frederic Cand (2):
      V4L/DVB (9548): gspca: Properly indent Kconfig
      V4L/DVB (9548): gspca: Fix Kconfig CodingStyle

Guennadi Liakhovetski (17):
      V4L/DVB (9785): soc-camera: merge .try_bus_param() into .try_fmt_cap()
      V4L/DVB (9786): soc-camera: formatting fixes
      V4L/DVB (9787): soc-camera: let camera host drivers decide upon pixel format
      V4L/DVB (9788): soc-camera: simplify naming
      V4L/DVB (9789): soc-camera: add a per-camera device host private data pointer
      V4L/DVB (9790): soc-camera: pixel format negotiation - core support
      V4L/DVB (10066): mt9m001 mt9v022: fix bus-width switch GPIO availability test
      V4L/DVB (10072): soc-camera: Add signal inversion flags to be used by camera drivers
      V4L/DVB (10074): soc-camera: add camera sense data
      V4L/DVB (10075): pxa-camera: setup the FIFO inactivity time-out register
      V4L/DVB (10080): soc-camera: readability improvements, more strict operations checks
      V4L/DVB (10081): pxa-camera: call try_fmt() camera device method with correct pixel format
      V4L/DVB (10083): soc-camera: unify locking, play nicer with videobuf locking
      V4L/DVB (10090): soc-camera: let drivers decide upon supported field values
      V4L/DVB (10091): mt9m001 mt9v022: simplify pointer derefernces
      V4L/DVB (10093): soc-camera: add new bus width and signal polarity flags
      V4L/DVB (10099): soc-camera: add support for MT9T031 CMOS camera sensor from Micron

Hans Verkuil (47):
      V4L/DVB (9484): v4l: rename compat_ioctl32.c to v4l2-compat-ioctl32.c
      V4L/DVB (9502): ov772x: CodingStyle improvements
      V4L/DVB (9503): v4l: remove inode argument from video_usercopy
      V4L/DVB (9504): dvbdev: fix typo causing 2.6.28 compile error
      V4L/DVB (9507): v4l: remove EXPERIMENTAL from several drivers
      V4L/DVB (9508): ivtv: enable tuner support for Yuan PG600-2
      V4L/DVB (9678): af9015: Cleanup switch for usb ID
      V4L/DVB (9820): v4l2: add v4l2_device and v4l2_subdev structs to the v4l2 framework.
      V4L/DVB (9821): v4l2-common: add i2c helper functions
      V4L/DVB (9822): cs53l32a: convert to v4l2_subdev.
      V4L/DVB (9823): cx25840: convert to v4l2_subdev.
      V4L/DVB (9824): m52790: convert to v4l2_subdev.
      V4L/DVB (9825): msp3400: convert to v4l2_subdev.
      V4L/DVB (9826): saa7115: convert to v4l2_subdev.
      V4L/DVB (9827): saa7127: convert to v4l2_subdev.
      V4L/DVB (9828): saa717x: convert to v4l2_subdev.
      V4L/DVB (9829): tuner: convert to v4l2_subdev.
      V4L/DVB (9830): upd64031a: convert to v4l2_subdev.
      V4L/DVB (9831): upd64083: convert to v4l2_subdev.
      V4L/DVB (9832): vp27smpx: convert to v4l2_subdev.
      V4L/DVB (9833): wm8739: convert to v4l2_subdev.
      V4L/DVB (9834): wm8775: convert to v4l2_subdev.
      V4L/DVB (9835): ivtv/ivtvfb: convert to v4l2_device/v4l2_subdev.
      V4L/DVB (9904): v4l: fix compile warning.
      V4L/DVB (9905): v4l2-compat32: add missing newline after kernel message
      V4L/DVB (9932): v4l2-compat32: fix 32-64 compatibility module
      V4L/DVB (9934): v4l2-compat32: add two additional #ifdef __OLD_VIDIOC_ lines
      V4L/DVB (9939): tuner: fix tuner_ioctl compile error if V4L1 ioctls are disabled.
      V4L/DVB (9940): bt832: remove this driver
      V4L/DVB (9941): cx24113: fix compile warnings
      V4L/DVB (9942): v4l2-dev: check for parent device in get_index.
      V4L/DVB (9943): v4l2: document video_device.
      V4L/DVB (9944): videodev2.h: fix typo.
      V4L/DVB (9957): v4l2-subdev: add g_sliced_vbi_cap and add NULL pointer checks
      V4L/DVB (9958): tvp5150: convert to v4l2_subdev.
      V4L/DVB (9959): tvaudio: convert to v4l2_subdev.
      V4L/DVB (9960): v4l2-subdev: ioctl ops should use unsigned for cmd arg.
      V4L/DVB (9961): tea6415c: convert to v4l2_subdev.
      V4L/DVB (9962): tea6420: convert to v4l2_subdev.
      V4L/DVB (9963): tlv320aic23b: convert to v4l2_subdev.
      V4L/DVB (9964): tda7432: convert to v4l2_subdev.
      V4L/DVB (9965): tda9840: convert to v4l2_subdev.
      V4L/DVB (9966): tda9875: convert to v4l2_subdev.
      V4L/DVB (9967): cs5345: convert to v4l2_subdev and fix broken s_ctrl.
      V4L/DVB (9973): v4l2-dev: use the release callback from device instead of cdev
      V4L/DVB (9974): v4l2-dev: allow drivers to pass v4l2_device as parent
      V4L/DVB (9975): ivtv: set v4l2_dev instead of parent.

Hans de Goede (10):
      V4L/DVB (9543): gspca: Adjust autoexpo values for cams with a vga sensor in sonixb.
      V4L/DVB (9685): gspca: Correct restart of webcams in spca501.
      V4L/DVB (9686): gspca: Don't return the control values from the webcams in spca501.
      V4L/DVB (9687): gspca: Split brightness and red and blue balance in spca501.
      V4L/DVB (9706): gspca: Use the ref counting of v4l2 for disconnection.
      V4L/DVB (9707): gspca: Remove the event counter and simplify the frame wait.
      V4L/DVB (9878): gspca - vc032x: Fix frame overflow errors with vc0321.
      V4L/DVB (9982): gspca - pac207: Update my email address.
      V4L/DVB (9992): gspca - pac207: Webcam 093a:2461 added.
      V4L/DVB (10044): gspca - pac7311: Webcam 093a:2620 added.

Harvey Harrison (2):
      V4L/DVB (9636): dvb: cinergyt2 annotate struct endianness, remove unused variable, add static
      V4L/DVB (9637): usb vendor_ids/product_ids are __le16

Hermann Pitton (1):
      V4L/DVB (9798): saa7134: add analog and DVB-T support for Medion/Creatix CTX946

Huang Weiyi (2):
      V4L/DVB: remove unused #include <version.h>
      V4L/DVB: remove unused #include <version.h>

Igor M. Liplianin (7):
      V4L/DVB (9520): stb0899 Remove double .read_status assignment
      V4L/DVB (9533): cx88: Add support for TurboSight TBS8910 DVB-S PCI card
      V4L/DVB (9534): cx88: Add support for Prof 6200 DVB-S PCI card
      V4L/DVB (9535): cx88-dvb: Remove usage core->prev_set_voltage from cx24116 based cards.
      V4L/DVB (9537): Add TerraTec Cinergy S USB support
      V4L/DVB (9795): Add Compro VideoMate E650F (DVB-T part only).
      V4L/DVB (9797): Fix stv0299 support in dw2102 USB DVB-S/S2 driver

Jaime Velasco Juan (1):
      V4L/DVB (9978): stkwebcam: Implement VIDIOC_ENUM_FRAMESIZES ioctl

Jean-Francois Moine (62):
      V4L/DVB (9691): gspca: Some cleanups at device register
      V4L/DVB (9541): gspca: Add infrared control for sonixj - mi0360.
      V4L/DVB (9544): gspca: Clear the bulk endpoint at starting time when bulk transfer.
      V4L/DVB (9545): gspca: Add a flag for empty ISOC packets.
      V4L/DVB (9546): gspca: Bad scanning of ISOC packets in tv8532.
      V4L/DVB (9547): gspca: Version change.
      V4L/DVB (9552): gspca: Simplify the ISOC packet scanning in tv8532.
      V4L/DVB (9553): gspca: Webcam 145f:013a added in pac207.
      V4L/DVB (9561): gspca: Cleanup the source of ov519.
      V4L/DVB (9562): gspca: Set the default frame rate to 30 fps for sensor ov764x in ov519.
      V4L/DVB (9565): gspca: Remove empty lines in traces.
      V4L/DVB (9560): gspca: Let gspca handle the webcam 0c45:602c instead of sn9c102.
      V4L/DVB (9563): gspca: Let gspca handle the webcam 0471:0328 instead of sn9c102.
      V4L/DVB (9680): gspca: Let gspca handle the webcam 0c45:613a instead of sn9c102.
      V4L/DVB (9681): gspca: Rewrite the exchanges with the sensor ov7648 of sonixj.
      V4L/DVB (9688): gspca: Reset the bulk URB status before resubmitting at irq level.
      V4L/DVB (9708): gspca: Do the sn9c105 - ov7660 work again in sonixj.
      V4L/DVB (9709): gspca: Fix typos and name errors in Kconfig.
      V4L/DVB (9711): gspca: Let gspca handle the webcams 045e:00f5 & 00f7 instead of sn9c102.
      V4L/DVB (9713): gspca: Add the ov534 webcams in the gspca documentation.
      V4L/DVB (9558): gspca: Add the light frequency control for the sensor HV7131B in zc3xx
      V4L/DVB (9710): gspca: Remove some unuseful core in main.
      V4L/DVB (9837): gspca: Simplify the brightness/contrast for ov76xx sensors in sonixj.
      V4L/DVB (9838): gspca: Delay when trying an other altsetting on streaming start.
      V4L/DVB (9840): gspca: Simplify the pkt_scan of stk014.
      V4L/DVB (9841): gspca: Use msleep instead of mdelay.
      V4L/DVB (9842): gspca: Center the brightness in sonixj.
      V4L/DVB (9843): gspca: Change the colors and add the red and blue controls in sonixj.
      V4L/DVB (9845): gspca: Add sensor mi0360 in vc032x.
      V4L/DVB (9846): gspca: Do the webcam microphone work when present.
      V4L/DVB (9847): gspca: Align the 640x480 and 320x240 init of tas5130 in zc3xx.
      V4L/DVB (9848): gspca: Webcam 06f8:3004 added in sonixj.
      V4L/DVB (9849): gspca: Add the webcam 0c45:613a in the gspca documentation.
      V4L/DVB (9850): gspca: Bad color control in sonixj.
      V4L/DVB (9852): gspca: Fix image problem at low resolutions with ov7660 in sonixj.
      V4L/DVB (9853): gspca: Webcam 093a:2622 added in pac7311.
      V4L/DVB (9854): gspca: Add the webcam 0c45:60fe in the gspca documentation.
      V4L/DVB (9861): gspca - ov534: Accept many simultaneous webcams.
      V4L/DVB (9863): gspca - sonixj: Cleanup / simplify code.
      V4L/DVB (9865): gspca - vc032x: Bad check of the sensor mi0360.
      V4L/DVB (9866): gspca - vc032x: V and H flips added for sensors ov7660 and 7670.
      V4L/DVB (9867): gspca - vc032x: Remove the autogain control.
      V4L/DVB (9868): gspca - zc3xx: Remove the duplicated register names
      V4L/DVB (9869): gspca - zc3xx: Change the USB exchanges for the sensor pas202b.
      V4L/DVB (9870): gspca - vc032x: Webcam 15b8:6002 and sensor po1200 added.
      V4L/DVB (9871): gspca - vc032x: Bad detection of sensor mi0360.
      V4L/DVB (9879): gspca - vc032x: Remove the unused quality/qindex.
      V4L/DVB (9880): gspca - vc032x: Add V&H flips and sharpness controls for sensor po1200.
      V4L/DVB (9884): gspca - ov534: Fix a warning when compilation without GSPCA_DEBUG.
      V4L/DVB (9984): gspca - pac7311: Webcam 093a:262c added.
      V4L/DVB (9985): gspca - spca561: Cleanup source.
      V4L/DVB (9986): gspca - spca561: Don't get the control values from the webcam.
      V4L/DVB (9987): gspca - spca561: Control changes for Rev72a.
      V4L/DVB (9988): gspca - spca561: Separate the bridge and sensor tables of Rev72a
      V4L/DVB (9990): gspca - main: Remove useless tests of the buffer type.
      V4L/DVB (9991): gspca - main: Check if a buffer has been queued on streamon.
      V4L/DVB (9995): gspca - ov534 and m5602: Set static some functions/variables.
      V4L/DVB (9997): gspca - main: Don't lock the kernel on ioctl.
      V4L/DVB (10045): gspca - ov534: Remove empty line in trace.
      V4L/DVB (10046): gspca - ov534: Use the gspca usb buf for usb control messages.
      V4L/DVB (10049): gspca - many subdrivers: Set 'const' the pixel format table.
      V4L/DVB (10050): gspca - vc032x: Webcam 046d:0897 added.

Jelle Foks (1):
      V4L/DVB (9654): new email address

Jim Paris (7):
      V4L/DVB (9858): gspca - ov534: Initialization cleanup.
      V4L/DVB (9859): gspca - ov534: Fix frame size so we don't miss the last pixel.
      V4L/DVB (9860): gspca - ov534: Frame transfer improvements.
      V4L/DVB (9873): gspca - ov534: Improve payload handling.
      V4L/DVB (9874): gspca - ov534: Explicitly initialize frame format.
      V4L/DVB (9876): gspca - main: Allow subdrivers to handle v4l2_streamparm requests.
      V4L/DVB (9877): gspca - ov534: Add framerate support.

Jiri Slaby (1):
      V4L/DVB (9972): v4l: usbvideo, fix module ref count check

Jose Alberto Reguero (1):
      V4L/DVB (9525): af9015: add support for AverMedia Volar X remote.

Julia Lawall (3):
      V4L/DVB (9638): drivers/media: use ARRAY_SIZE
      V4L/DVB (9796): drivers/media/video/cx88/cx88-alsa.c: Adjust error-handling code
      V4L/DVB (10130): use USB API functions rather than constants

Kay Sievers (2):
      V4L/DVB (9473): add DVB_DEVICE_NUM and DVB_ADAPTER_NUM to uevent
      V4L/DVB (9521): V4L: struct device - replace bus_id with dev_name(), dev_set_name()

Kuninori Morimoto (15):
      V4L/DVB (9488): Add ov772x driver
      V4L/DVB (9783): Change power on/off sequence on ov772x
      V4L/DVB (9784): Register name fix for ov772x driver
      V4L/DVB (10067): Remove ov772x_default_regs from ov772x driver
      V4L/DVB (10068): Change device ID selection method on ov772x driver
      V4L/DVB (10069): Add ov7725 support to ov772x driver
      V4L/DVB (10086): Add new set_std function on soc_camera
      V4L/DVB (10087): Add new enum_input function on soc_camera
      V4L/DVB (10089): Add interlace support to sh_mobile_ceu_camera.c
      V4L/DVB (10092): Change V4L2 field to ANY from NONE on sh_mobile_ceu_camera.c
      V4L/DVB (10094): Add tw9910 driver
      V4L/DVB (10095): The failure of set_fmt is solved in tw9910
      V4L/DVB (10096): ov772x: change dev_info to dev_dbg
      V4L/DVB (10097): ov772x: clear i2c client data on error and remove
      V4L/DVB (10098): ov772x: fix try_fmt calculation method

Laurent Pinchart (17):
      V4L/DVB (9567): uvcvideo: Add support for Samsung Q310 integrated webcam
      V4L/DVB (9568): uvcvideo: Add support for Lenovo Thinkpad SL500 integrated webcam
      V4L/DVB (9569): uvcvideo: Sort the frame descriptors during parsing
      V4L/DVB (9570): uvcvideo: Handle failed video GET_{MIN|MAX|DEF} requests more gracefully
      V4L/DVB (9659): uvcvideo: Use {get|set}_unaligned_le32 macros
      V4L/DVB (9661): uvcvideo: Commit streaming parameters when enabling the video stream
      V4L/DVB (9662): uvcvideo: Fix printk badness when printing ioctl names
      V4L/DVB (9809): uvcvideo: Add nodrop module parameter to turn incomplete frame drop off.
      V4L/DVB (9810): uvcvideo: Add a device quirk to prune bogus controls.
      V4L/DVB (9897): v4l2: Add camera zoom controls
      V4L/DVB (9898): v4l2: Add privacy control
      V4L/DVB (9899): v4l2: Add missing control names
      V4L/DVB (9902): uvcvideo: V4L2 privacy control support
      V4L/DVB (9903): uvcvideo: V4L2 zoom controls support
      V4L/DVB (10101): uvcvideo: Fix bulk URB processing when the header is erroneous
      V4L/DVB (10102): uvcvideo: Ignore interrupt endpoint for built-in iSight webcams.
      V4L/DVB (10104): uvcvideo: Add support for video output devices

Magnus Damm (5):
      V4L/DVB (10078): video: add NV16 and NV61 pixel formats
      V4L/DVB (10079): sh_mobile_ceu: use new pixel format translation code
      V4L/DVB (10084): sh_mobile_ceu: add NV12 and NV21 support
      V4L/DVB (10085): sh_mobile_ceu: add NV16 and NV61 support
      V4L/DVB (10088): video: sh_mobile_ceu cleanups and comments

Manu Abraham (79):
      V4L/DVB (9344): DVB-Core update
      V4L/DVB (9478): Fix: parameters not supplied in the search process
      V4L/DVB (9375): Add STB0899 support
      V4L/DVB (9376): Add STB0899 to build
      V4L/DVB (9377): Add STB6100 Support
      V4L/DVB (9378): Add STB6100 Support
      V4L/DVB (9379): FIX: fix a bug in the charge pump setting
      V4L/DVB (9380): FIX: a possible division by zero
      V4L/DVB (9381): On the KNC1 cards the CLOCK is clamped to a maximum limit of 90MHz, eventhough
      V4L/DVB (9382): Use a delay for tracking acquisition status
      V4L/DVB (9383): Let's neither sleep nor wakeup for now
      V4L/DVB (9384): FIX: register value is not reset to 0 after write
      V4L/DVB (9386): FIX: Add in missing inversion (should be ideally in the config struct)
      V4L/DVB (9387): FIX: Write to the correct register
      V4L/DVB (9392): initial go at TDA8261 tuner
      V4L/DVB (9393): Add TDA8261 to build
      V4L/DVB (9394): cache last successful state
      V4L/DVB (9395): Add initial support for two KNC1 DVB-S2 boards
      V4L/DVB (9396): Fix clocks at stb0899
      V4L/DVB (9397): fix some bugs at tda8261
      V4L/DVB (9399): some cleanups at budget-ci
      V4L/DVB (9400): stb6100: Code Simplification
      V4L/DVB (9401): Code Simplification
      V4L/DVB (9402): TT S2 3200 shouldn't need Inversion ON and Inversion AUTO at the same time
      V4L/DVB (9403): Fix the CA module not working issue
      V4L/DVB (9404): the KNC1 and clones also don't have the I/Q inputs swapped
      V4L/DVB (9405): Practical tests show that the TT S2 3200 has I/Q inputs inverted, similar to the KNC1.
      V4L/DVB (9407): Optimizations Reduce capture range from 10MHz to 3Mhz
      V4L/DVB (9408): tda8261: check status to avoid lock loss
      V4L/DVB (9409): Bug! inverted logic
      V4L/DVB (9410): Bug: Missing reference clock definition
      V4L/DVB (9411): Bug! Timing recovery was calculated for 99MHz not 90 MHz
      V4L/DVB (9412): Fix tuner name and comment
      V4L/DVB (9413): Bug: Set Auxilliary Clock Register correctly
      V4L/DVB (9414): Initialize DiSEqC
      V4L/DVB (9416): Hmmph, a proper calculation broke the working behaviour.
      V4L/DVB (9417): DVB_ATTACH for STB0899, STB6100, TDA8261
      V4L/DVB (9418): DVB_ATTACH for STB0899, STB6100, TDA8261
      V4L/DVB (9419): Bug: unnecessary large current causes large phasor errors
      V4L/DVB (9420): return -EINVAL for invalid parameters
      V4L/DVB (9421): We must wait for the PLL to stabilize
      V4L/DVB (9422): Bug: Fix a typo
      V4L/DVB (9423): Though insignificant, removes an unnecessary read of the LOCK_LOSS register,
      V4L/DVB (9424): Deviation from the reference, pullup is 12k instead
      V4L/DVB (9425): Initialize at 90MHz itself
      V4L/DVB (9426): Add a missing break
      V4L/DVB (9427): Code simplification: Sleep only for the required time interval.
      V4L/DVB (9431): Bug ID #19: Diseqc works properly at 90MHz only on Cut 1.1 and 2.0
      V4L/DVB (9434): Limit initial RF AGC gain
      V4L/DVB (9435): Add post process interfaces
      V4L/DVB (9436): Fix a typo in the previous commit
      V4L/DVB (9437): Disable Symbol rate auto scan feature
      V4L/DVB (9439): Bug! SFRL nibble got swapped
      V4L/DVB (9441): Code simplification: clock is already initialized, no need to initialize again.
      V4L/DVB (9442): Revert back previous change to 90MHz
      V4L/DVB (9443): Bug: Bandwidth calculation
      V4L/DVB (9444): Initialize post process events to NULL
      V4L/DVB (9450): Code Review: #4 Consolidate configurations
      V4L/DVB (9451): Bug! F/3 Clock domain was incorrectly used
      V4L/DVB (9452): Fix invalid GCT mode
      V4L/DVB (9453): stb0899: fix compilation warnings
      V4L/DVB (9454): Fix a compile warning
      V4L/DVB (9455): Cleanup: remove some superfluous stuff and dead commented out code
      V4L/DVB (9456): Select STB0899, STB6100, TDA8261 for budget_ci and budget_av respectively.
      V4L/DVB (9457): Optimization, Fix a Bug
      V4L/DVB (9458): Bugfix: gate control needs to be handled
      V4L/DVB (9459): We can now reduce the debug levels, just need to look at errors only.
      V4L/DVB (9460): Code Simplification
      V4L/DVB (9461): Initialize SYSREG register
      V4L/DVB (9462): Allow specifying clock per device
      V4L/DVB (9463): Make delivery system standalone.
      V4L/DVB (9464): Remove unreferenced delivery
      V4L/DVB (9465): Fix incorrect IF_AGC Bitfield definition
      V4L/DVB (9466): Bug: Fix incorrect Register definitions
      V4L/DVB (9469): Port STB0899 and STB6100
      V4L/DVB (9479): Wait for a maximum of 100mS
      V4L/DVB (9425): Initialize at 90MHz itself
      V4L/DVB (9431): Bug ID #19: Diseqc works properly at 90MHz only on Cut 1.1 and 2.0
      V4L/DVB (9442): Revert back previous change to 90MHz

Marco Schluessler (1):
      V4L/DVB (9480): Fix frontend DVBFE_ALGO_CUSTOM Search

Marko Schluessler (7):
      V4L/DVB (9388): Reference Clock is in kHz
      V4L/DVB (9389): Use kzalloc instead of kmalloc
      V4L/DVB (9390): Offset Freq has been set in reg
      V4L/DVB (9391): Register definition bugs
      V4L/DVB (9398): Initial support for the Technotrend TT S2 3200
      V4L/DVB (9406): Really silly bug, setting bandwidth into frequency
      V4L/DVB (9428): Fix: assignment of wrong values

Markus Rechberger (4):
      V4L/DVB (9362): zl10353: add new register configuration for zl10353/especially 6mhz taiwan.
      V4L/DVB (9363): tvp5150: add support to enable raw vbi
      V4L/DVB (9364): adding sharp s921 ISDB-T driver
      V4L/DVB (9365): adding lgdt3304 based driver

Matthias Schwarzott (1):
      V4L/DVB (9477): Fix: Commit 9344 breaks tning of cx24123

Mauro Carvalho Chehab (79):
      V4L/DVB (9366): Move S921 driver to the proper place and allow it to compile
      V4L/DVB (9367): Move lgdt3304 driver to the proper place and allow it to compile
      V4L/DVB (9370): Update README.cx88 with the current status
      V4L/DVB (9498): Simplify video standards enumeration
      V4L/DVB (9532): Properly handle error messages during alsa registering
      V4L/DVB (9572): Whitespace cleanup
      V4L/DVB (9572a): Whitespace cleanup
      V4L/DVB (9578): v4l core: add support for enumerating frame sizes and intervals
      V4L/DVB (9579): v4l core: a few get ioctls were lacking memory clean
      V4L/DVB (9591): v4l core: fix debug printk for enumberating framerates
      V4L/DVB (9607): em28xx: Properly implement poll support for IR's
      V4L/DVB (9611): em28xx: experimental support for HVR-950 IR
      V4L/DVB (9612): Fix key repetition with HVR-950 IR
      V4L/DVB (9630): Some boards need to specify tuner address
      V4L/DVB (9641): Add chip ID's for em2820 and em2840
      V4L/DVB (9642): Add AC97 registers found on em28xx devices
      V4L/DVB (9643): em28xx: remove the previous register names
      V4L/DVB (9649): em28xx: remove two amux entries used only on one card
      V4L/DVB (9650): em28xx: replace magic numbers to something more meaningful
      V4L/DVB (9651): em28xx: Improve audio handling
      V4L/DVB (9652): em28xx: merge AC97 vendor id's into a single var
      V4L/DVB (9653): em28xx: improve AC97 handling
      V4L/DVB (9669): em28xx: Fix a stupid cut-and-paste error
      V4L/DVB (9670): em28xx: allow specifying audio output
      V4L/DVB (9671): em28xx: Add detection of Sigmatel Stac97xx series of AC97 devices
      V4L/DVB (9672): Allow opening more than one output at the same time
      V4L/DVB (9673): em28xx: fix Pixelview PlayTV board entry
      V4L/DVB (9675): em28xx: devices with xc2028/3028 don't have tda9887
      V4L/DVB (9676): em28xx: fix a regression caused by 22c90ec6a5e07173ee670dc2ca75e0df0a7772c0
      V4L/DVB (9717): em28xx: improve message probing logs
      V4L/DVB (9747): em28xx: Properly handles XCLK and I2C speed
      V4L/DVB (9751): em28xx: card description cleanups
      V4L/DVB (9752): Remove duplicated fields on em28xx_board and em28xx structs
      V4L/DVB (9753): em28xx: cleanup: saa7115 module auto-detects saa711x type
      V4L/DVB (9754): em28xx: improve debug messages
      V4L/DVB (9755): em28xx: cleanup: We need just one tuner callback
      V4L/DVB (9758): em28xx: replace some magic by register descriptions where known
      V4L/DVB (9759): em28xx: move gpio tables to the top of em28xx-cards
      V4L/DVB (9760): em28xx: move gpio lines into board table description
      V4L/DVB (9761): em28xx: replace magic numbers for mux aliases
      V4L/DVB (9762): em28xx: fix tuner absent entries
      V4L/DVB (9763): em28xx: fix gpio settings
      V4L/DVB (9764): em28xx: Add support for suspend the device when not used
      V4L/DVB (9765): em28xx: move tuner gpio's to the cards struct
      V4L/DVB (9766): em28xx: improve probe messages
      V4L/DVB (9767): em28xx: improve board description messages
      V4L/DVB (9756): em28xx: Improve register log format
      V4L/DVB (9769): tuner-xc2028: powers device of when not used
      V4L/DVB (9770): em28xx: turn off tuner when not used
      V4L/DVB (9771): tuner-xc2028: fix a small warning
      V4L/DVB (9772): saa7134: Add support for Kworld Plus TV Analog Lite PCI
      V4L/DVB (9773): tda827x: fix printk message when in FM mode
      V4L/DVB (9774): tda827x: fix returned frequency
      V4L/DVB (9775): tda8290: fix FM radio
      V4L/DVB (9799): em28xx: fix Kworld Hybrid 330 (A316) support
      V4L/DVB (9909): em28xx: move dev->lock from res_free to the caller routines
      V4L/DVB (9910): em28xx: move res_get locks to the caller routines
      V4L/DVB (9911): em28xx: vidioc_try_fmt_vid_cap() doesn't need any lock
      V4L/DVB (9912): em28xx: fix/improve em28xx locking schema
      V4L/DVB (9913): tuner-xc2028: allow printing stack trace as debug on sleep code
      V4L/DVB (9925): tuner-core: add debug msg's when asking tuner to sleep
      V4L/DVB (9926): em28xx: Fix a bug that were putting xc2028/3028 tuner to sleep
      V4L/DVB (9927): em28xx: use a more standard way to specify video formats
      V4L/DVB (9930): em28xx: Fix bad locks on error condition
      V4L/DVB (9931): em28xx: de-obfuscate vidioc_g_ctrl logic
      V4L/DVB (9953): em28xx: Add suport for debugging AC97 anciliary chips
      V4L/DVB (9969): tvp5150: add support for VIDIOC_G_CHIP_IDENT ioctl
      V4L/DVB (9970): em28xx: Allow get/set registers for debug on i2c slave chips
      V4L/DVB (9977): Kbuild: fix compilation when dib7000p is not defined
      V4L/DVB (9979): em28xx: move usb probe code to a proper place
      V4L/DVB (9980): em28xx: simplify analog logic
      V4L/DVB (10106): gscpa - stv06xx: Fix compilation with kernel tree
      V4L/DVB (10107): More than one driver defines the same var name (dump_bridge). Add
      V4L/DVB (10109): anysee: Fix usage of an unitialized function
      V4L/DVB (10110): v4l2-ioctl: Fix warnings when using .unlocked_ioctl = __video_ioctl2
      V4L/DVB (10111): quickcam_messenger.c: fix a warning
      V4L/DVB (10111a): usbvideo.h: remove an useless blank line
      V4L/DVB (10116): af9013: Fix gcc false warnings
      V4L/DVB (10118): zoran: fix warning for a variable not used

Michael Hennerich (1):
      V4L/DVB (9660): uvcvideo: Fix unaligned memory access.

Michael Krufky (7):
      V4L/DVB (9734): sms1xxx: add functions to configure and set gpio
      V4L/DVB (9733): sms1xxx: add autodetection support for Hauppauge WinTV MiniCard
      V4L/DVB (9735): sms1xxx: turn off LEDs after initialization of Hauppauge WinTV MiniStick
      V4L/DVB (9736): sms1xxx: enable power LED on Hauppauge WinTV MiniStick
      V4L/DVB (9738): sms1xxx: fix invalid unc readings
      V4L/DVB (9739): sms1xxx: enable signal quality indicator LEDs on Hauppauge WinTV MiniStick
      V4L/DVB (9737): sms1xxx: enable LNA control on Hauppauge WinTV MiniCard

Mike Rapoport (2):
      V4L/DVB (10076): v4l: add chip ID for MT9M112 camera sensor from Micron
      V4L/DVB (10077): mt9m111: add support for mt9m112 since sensors seem identical

Németh Márton (1):
      V4L/DVB (10128): modify V4L documentation to be a valid XHTML

Oldrich Jedlicka (1):
      V4L/DVB (9667): Fixed typo in sizeof() causing NULL pointer OOPS

Patrice Levesque (1):
      V4L/DVB (9529): cx88: add a second PCI ID for ATI TV Wonder Pro

Patrick Boettcher (4):
      V4L/DVB (9811): Add support for the CX24113 DVB-S tuner driver
      V4L/DVB (9812): [PATCH] short help for Technisat cards to select the right configuration
      V4L/DVB (9887): Minor fixes for cx24113-driver (codingstyle)
      V4L/DVB (9889): CX24113: Fixed more typos

Reinhard Nissl (7):
      V4L/DVB (9445): Bug: Bandwidth calculation at upper and lower boundaries
      V4L/DVB (9446): Bug Fix an overflow in bandwidth calculation
      V4L/DVB (9447): stb6100: improve rounding
      V4L/DVB (9448): Bug: fix array size
      V4L/DVB (9449): Code Simplification: use do_div() instead
      V4L/DVB (9467): Fix runtime verbosity
      V4L/DVB (9468): Miscellaneous fixes

Robert Jarzmik (4):
      V4L/DVB (9530): Add new pixel format VYUY 16 bits wide.
      V4L/DVB (9791): pxa-camera: pixel format negotiation
      V4L/DVB (10065): mt9m111: add all yuv format combinations.
      V4L/DVB (10073): mt9m111: Add automatic white balance control

Roel Kluin (1):
      V4L/DVB (9994): gspca: t613: Bad loop in om6802 reset.

Romain Beauxis (1):
      V4L/DVB (9864): gspca - ov519: Change copyright information.

Sakari Ailus (1):
      V4L/DVB (9815): omap2: add OMAP2 camera driver.

Stephen Rothwell (1):
      V4L/DVB (9490): linux-next: v4l-dvb tree build failure

Steven Rostedt (1):
      V4L/DVB (10129): dvb: remove deprecated use of RW_LOCK_UNLOCKED in frontends

Thomas Reitmayr (1):
      V4L/DVB (9981): [PATCH] usb-urb.c: Fix initialization of URB list.

Uri Shkolnik (1):
      V4L/DVB (9740): sms1xxx: add USB suspend and hibernation support

Uwe Bugla (1):
      V4L/DVB (9888): Patch: fix a typo in cx24113.c

Vaibhav Hiremath (2):
      V4L/DVB (9816): v4l2-int-if: add three new ioctls for std handling and routing
      V4L/DVB (9817): v4l: add new tvp514x I2C video decoder driver

Vincent Pelletier (1):
      V4L/DVB (9536): WinFast DTV2000 H: add support for missing analog inputs

roel kluin (1):
      V4L/DVB (10064): mt9m111: mt9m111_get_global_gain() - unsigned >= 0 is always true

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
