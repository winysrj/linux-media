Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DIDApm022638
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 14:13:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DICJaF023395
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 14:12:19 -0400
Date: Mon, 13 Oct 2008 15:10:56 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20081013151056.3ac41739@pedra.chehab.org>
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

It is becoming harder every day to summarize the changes at the 
subsystem. I'll probably forget something on this series of 313 commits.

Basically, the main changes are:

   - Driver removal of a few very obsolete hardware (dpc7146 
     demonstration board, a very uncommon tuner - tuner-3036, a teletext 
     only decoder - saa5246a);
   - a few v4l2 API additions to suport some MPEG audio standards;
   - DVB API additions to support DVB-S2 boards;
   - Three new drivers for DVB-S2 frontends were added:
	- cx24116, si21xx, stv0288;
   - Due to DVB API additions, dm1105 dvb bridge could finally be 
     merged;
   - Several new tuners used on DVB-S2 boards could finally be merged:
	- stb6000, dw2102, eds1547;
   - Added DVB-S2 support on several existing drivers: cx88 and dw2102;
   - Added a new frontend driver (lgs8gl5) for DMB-T and DMB-H support;
   - Added support at cxusb for boards with lgs8gl5;
   - New drivers to add support for:
	- ALPS TDHD1-204A tuners;
	- Avermedia MR800 FM radio;
	- Finepix webcams;
	- m5602 webcams;
	- mt9m111 webcams;
	- af9013 dvb boards;
	- af9015 dvb boards;
   - As usual, tons of cleanups and improvements at the existing 
     drivers.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.bttv            |    1 +
 Documentation/video4linux/CARDLIST.cx23885         |    2 +
 Documentation/video4linux/CARDLIST.cx88            |    8 +
 Documentation/video4linux/CARDLIST.em28xx          |    4 +-
 Documentation/video4linux/CARDLIST.saa7134         |    8 +-
 Documentation/video4linux/CARDLIST.tuner           |    1 +
 Documentation/video4linux/gspca.txt                |   28 +-
 Documentation/video4linux/m5602.txt                |   12 +
 Documentation/video4linux/soc-camera.txt           |  120 ++
 arch/arm/mach-pxa/include/mach/camera.h            |    2 -
 drivers/media/common/ir-keymaps.c                  |  280 ++++-
 drivers/media/common/saa7146_core.c                |    2 +-
 drivers/media/common/saa7146_fops.c                |    2 +-
 drivers/media/common/tuners/mt2060.c               |   38 +-
 drivers/media/common/tuners/mxl5007t.c             |    1 -
 drivers/media/common/tuners/tda18271-fe.c          |    1 -
 drivers/media/common/tuners/tda827x.c              |   12 +-
 drivers/media/common/tuners/tda827x.h              |    1 -
 drivers/media/common/tuners/tda8290.c              |    4 +-
 drivers/media/common/tuners/tda8290.h              |    1 -
 drivers/media/common/tuners/tda9887.c              |    1 -
 drivers/media/common/tuners/tuner-simple.c         |    3 +-
 drivers/media/common/tuners/tuner-types.c          |   22 +
 drivers/media/common/tuners/tuner-xc2028.c         |   74 +-
 drivers/media/common/tuners/tuner-xc2028.h         |   10 +-
 drivers/media/common/tuners/xc5000.c               |  109 +-
 drivers/media/common/tuners/xc5000.h               |    8 +-
 drivers/media/common/tuners/xc5000_priv.h          |   37 -
 drivers/media/dvb/Kconfig                          |    5 +-
 drivers/media/dvb/Makefile                         |    2 +-
 drivers/media/dvb/b2c2/flexcop-dma.c               |    2 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    2 +-
 drivers/media/dvb/cinergyT2/Kconfig                |   85 -
 drivers/media/dvb/cinergyT2/Makefile               |    3 -
 drivers/media/dvb/cinergyT2/cinergyT2.c            | 1105 -------------
 drivers/media/dvb/dm1105/Kconfig                   |   18 +
 drivers/media/dvb/dm1105/Makefile                  |    3 +
 drivers/media/dvb/dm1105/dm1105.c                  |  911 +++++++++++
 drivers/media/dvb/dvb-core/dvb_frontend.c          |  666 ++++++++-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |   32 +
 drivers/media/dvb/dvb-usb/Kconfig                  |   42 +-
 drivers/media/dvb/dvb-usb/Makefile                 |   10 +
 drivers/media/dvb/dvb-usb/af9005-remote.c          |    2 +-
 drivers/media/dvb/dvb-usb/af9005-script.h          |    2 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |   23 +-
 drivers/media/dvb/dvb-usb/af9015.c                 | 1474 +++++++++++++++++
 drivers/media/dvb/dvb-usb/af9015.h                 |  524 ++++++
 drivers/media/dvb/dvb-usb/anysee.c                 |   30 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c         |  268 ++++
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c           |  351 ++++
 drivers/media/dvb/dvb-usb/cinergyT2.h              |   95 ++
 drivers/media/dvb/dvb-usb/cxusb.c                  |  504 ++++++-
 drivers/media/dvb/dvb-usb/dib0700.h                |    4 +
 drivers/media/dvb/dvb-usb/dib0700_core.c           |  115 ++-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  195 +++-
 drivers/media/dvb/dvb-usb/dtv5100.c                |  240 +++
 drivers/media/dvb/dvb-usb/dtv5100.h                |   51 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |   29 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |  572 ++++++--
 drivers/media/dvb/dvb-usb/dw2102.h                 |    1 -
 drivers/media/dvb/frontends/Kconfig                |   47 +
 drivers/media/dvb/frontends/Makefile               |    7 +
 drivers/media/dvb/frontends/af9013.c               | 1685 ++++++++++++++++++++
 drivers/media/dvb/frontends/af9013.h               |  107 ++
 drivers/media/dvb/frontends/af9013_priv.h          |  869 ++++++++++
 drivers/media/dvb/frontends/au8522.c               |  133 ++
 drivers/media/dvb/frontends/au8522.h               |   17 +
 drivers/media/dvb/frontends/cx24110.h              |   15 +-
 drivers/media/dvb/frontends/cx24116.c              | 1423 +++++++++++++++++
 drivers/media/dvb/frontends/cx24116.h              |   53 +
 drivers/media/dvb/frontends/dib0070.h              |    8 +-
 drivers/media/dvb/frontends/dib7000m.c             |    6 +-
 drivers/media/dvb/frontends/dib7000p.c             |    3 +-
 drivers/media/dvb/frontends/dib7000p.h             |   41 +-
 drivers/media/dvb/frontends/drx397xD.c             |  288 ++--
 drivers/media/dvb/frontends/drx397xD.h             |    6 +-
 drivers/media/dvb/frontends/dvb_dummy_fe.c         |   11 +-
 drivers/media/dvb/frontends/eds1547.h              |  133 ++
 drivers/media/dvb/frontends/lgs8gl5.c              |  454 ++++++
 drivers/media/dvb/frontends/lgs8gl5.h              |   45 +
 drivers/media/dvb/frontends/nxt200x.c              |    4 +-
 drivers/media/dvb/frontends/or51211.c              |    2 +-
 drivers/media/dvb/frontends/si21xx.c               |  974 +++++++++++
 drivers/media/dvb/frontends/si21xx.h               |   37 +
 drivers/media/dvb/frontends/sp887x.c               |    3 +-
 drivers/media/dvb/frontends/stb6000.c              |  255 +++
 drivers/media/dvb/frontends/stb6000.h              |   51 +
 drivers/media/dvb/frontends/stv0288.c              |  618 +++++++
 drivers/media/dvb/frontends/stv0288.h              |   67 +
 drivers/media/dvb/frontends/stv0299.c              |    2 +
 drivers/media/dvb/frontends/stv0299.h              |   13 +-
 drivers/media/dvb/frontends/tdhd1.h                |   73 +
 drivers/media/dvb/ttpci/Kconfig                    |    1 +
 drivers/media/dvb/ttpci/av7110.c                   |  127 ++-
 drivers/media/dvb/ttpci/av7110.h                   |    1 +
 drivers/media/dvb/ttpci/av7110_av.c                |    3 +
 drivers/media/dvb/ttpci/budget-av.c                |    8 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    7 +-
 drivers/media/dvb/ttpci/budget-core.c              |    6 +-
 drivers/media/dvb/ttpci/budget-patch.c             |    9 +-
 drivers/media/dvb/ttpci/budget.c                   |   25 +-
 drivers/media/dvb/ttpci/budget.h                   |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |    2 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c            |    2 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c           |   16 +-
 drivers/media/radio/Kconfig                        |   12 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/dsbr100.c                      |   28 +-
 drivers/media/radio/radio-aimslab.c                |   34 +-
 drivers/media/radio/radio-aztech.c                 |   40 +-
 drivers/media/radio/radio-cadet.c                  |    1 +
 drivers/media/radio/radio-gemtek-pci.c             |   42 +-
 drivers/media/radio/radio-gemtek.c                 |   37 +-
 drivers/media/radio/radio-maestro.c                |   34 +-
 drivers/media/radio/radio-maxiradio.c              |   40 +-
 drivers/media/radio/radio-mr800.c                  |  628 ++++++++
 drivers/media/radio/radio-rtrack2.c                |   34 +-
 drivers/media/radio/radio-sf16fmi.c                |   34 +-
 drivers/media/radio/radio-sf16fmr2.c               |   34 +-
 drivers/media/radio/radio-si470x.c                 |   24 +-
 drivers/media/radio/radio-terratec.c               |   34 +-
 drivers/media/radio/radio-trust.c                  |   17 +-
 drivers/media/radio/radio-typhoon.c                |   35 +-
 drivers/media/radio/radio-zoltrix.c                |   51 +-
 drivers/media/video/Kconfig                        |  235 +--
 drivers/media/video/Makefile                       |    9 +-
 drivers/media/video/arv.c                          |   29 +-
 drivers/media/video/au0828/au0828-cards.c          |    2 +-
 drivers/media/video/au0828/au0828-dvb.c            |   47 +-
 drivers/media/video/au0828/au0828.h                |    3 +-
 drivers/media/video/bt856.c                        |    8 +-
 drivers/media/video/bt8xx/bttv-cards.c             |   27 +-
 drivers/media/video/bt8xx/bttv-driver.c            |   66 +-
 drivers/media/video/bt8xx/bttv-input.c             |   62 +-
 drivers/media/video/bt8xx/bttv.h                   |    2 +-
 drivers/media/video/btcx-risc.c                    |    2 +-
 drivers/media/video/bw-qcam.c                      |   26 +-
 drivers/media/video/bw-qcam.h                      |    1 +
 drivers/media/video/c-qcam.c                       |   23 +-
 drivers/media/video/cafe_ccic.c                    |    6 +-
 drivers/media/video/cpia.c                         |   15 +-
 drivers/media/video/cpia2/cpia2_core.c             |   10 +-
 drivers/media/video/cpia2/cpia2_usb.c              |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |   16 +-
 drivers/media/video/cx18/Makefile                  |    2 +-
 drivers/media/video/cx18/cx18-audio.c              |    5 +-
 drivers/media/video/cx18/cx18-av-core.c            |   23 +-
 drivers/media/video/cx18/cx18-av-core.h            |    2 +
 drivers/media/video/cx18/cx18-av-firmware.c        |   25 +-
 drivers/media/video/cx18/cx18-cards.c              |   99 ++
 drivers/media/video/cx18/cx18-driver.c             |   51 +-
 drivers/media/video/cx18/cx18-driver.h             |   71 +-
 drivers/media/video/cx18/cx18-dvb.c                |    5 +-
 drivers/media/video/cx18/cx18-fileops.c            |   47 +-
 drivers/media/video/cx18/cx18-firmware.c           |  140 +-
 drivers/media/video/cx18/cx18-gpio.c               |   17 +-
 drivers/media/video/cx18/cx18-gpio.h               |    2 +-
 drivers/media/video/cx18/cx18-i2c.c                |   49 +-
 drivers/media/video/cx18/cx18-io.c                 |  254 +++
 drivers/media/video/cx18/cx18-io.h                 |  378 +++++
 drivers/media/video/cx18/cx18-ioctl.c              |   34 +-
 drivers/media/video/cx18/cx18-irq.c                |   47 +-
 drivers/media/video/cx18/cx18-mailbox.c            |   45 +-
 drivers/media/video/cx18/cx18-queue.c              |   18 +-
 drivers/media/video/cx18/cx18-scb.c                |  131 +-
 drivers/media/video/cx18/cx18-streams.c            |   70 +-
 drivers/media/video/cx18/cx18-version.h            |    2 +-
 drivers/media/video/cx18/cx23418.h                 |    2 +-
 drivers/media/video/cx2341x.c                      |    5 +-
 drivers/media/video/cx23885/Kconfig                |    1 +
 drivers/media/video/cx23885/cx23885-417.c          |   13 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   86 +-
 drivers/media/video/cx23885/cx23885-core.c         |    2 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |  105 +-
 drivers/media/video/cx23885/cx23885-vbi.c          |   12 +-
 drivers/media/video/cx23885/cx23885-video.c        |   39 +-
 drivers/media/video/cx23885/cx23885.h              |    4 +-
 drivers/media/video/cx25840/cx25840-vbi.c          |    5 +-
 drivers/media/video/cx88/Kconfig                   |    4 +
 drivers/media/video/cx88/cx88-blackbird.c          |    9 +-
 drivers/media/video/cx88/cx88-cards.c              |  306 ++++-
 drivers/media/video/cx88/cx88-dvb.c                |  198 ++-
 drivers/media/video/cx88/cx88-i2c.c                |   16 +
 drivers/media/video/cx88/cx88-input.c              |   33 +-
 drivers/media/video/cx88/cx88-video.c              |   15 +-
 drivers/media/video/cx88/cx88.h                    |   11 +-
 drivers/media/video/dabusb.c                       |    3 +-
 drivers/media/video/dpc7146.c                      |  408 -----
 drivers/media/video/em28xx/em28xx-cards.c          |    4 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   25 +-
 drivers/media/video/em28xx/em28xx-i2c.c            |   35 +-
 drivers/media/video/em28xx/em28xx-video.c          |   60 +-
 drivers/media/video/em28xx/em28xx.h                |    6 +-
 drivers/media/video/et61x251/et61x251_core.c       |   14 +-
 drivers/media/video/gspca/Kconfig                  |  215 +++-
 drivers/media/video/gspca/Makefile                 |   75 +-
 drivers/media/video/gspca/conex.c                  |    3 +-
 drivers/media/video/gspca/etoms.c                  |    3 +-
 drivers/media/video/gspca/finepix.c                |  466 ++++++
 drivers/media/video/gspca/gspca.c                  |  245 ++-
 drivers/media/video/gspca/gspca.h                  |   21 +-
 drivers/media/video/gspca/m5602/Kconfig            |   11 +
 drivers/media/video/gspca/m5602/Makefile           |   11 +
 drivers/media/video/gspca/m5602/m5602_bridge.h     |  170 ++
 drivers/media/video/gspca/m5602/m5602_core.c       |  313 ++++
 drivers/media/video/gspca/m5602/m5602_mt9m111.c    |  345 ++++
 drivers/media/video/gspca/m5602/m5602_mt9m111.h    | 1020 ++++++++++++
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |  546 +++++++
 drivers/media/video/gspca/m5602/m5602_ov9650.h     |  503 ++++++
 drivers/media/video/gspca/m5602/m5602_po1030.c     |  336 ++++
 drivers/media/video/gspca/m5602/m5602_po1030.h     |  478 ++++++
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |  463 ++++++
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h     |  370 +++++
 drivers/media/video/gspca/m5602/m5602_s5k83a.c     |  423 +++++
 drivers/media/video/gspca/m5602/m5602_s5k83a.h     |  484 ++++++
 drivers/media/video/gspca/m5602/m5602_sensor.h     |   76 +
 drivers/media/video/gspca/mars.c                   |   20 +-
 drivers/media/video/gspca/ov519.c                  |    5 +-
 drivers/media/video/gspca/pac207.c                 |    4 +-
 drivers/media/video/gspca/pac7311.c                |    3 +-
 drivers/media/video/gspca/sonixb.c                 |    5 +-
 drivers/media/video/gspca/sonixj.c                 |   89 +-
 drivers/media/video/gspca/spca500.c                |    3 +-
 drivers/media/video/gspca/spca501.c                |    3 +-
 drivers/media/video/gspca/spca505.c                |    3 +-
 drivers/media/video/gspca/spca506.c                |    3 +-
 drivers/media/video/gspca/spca508.c                |    3 +-
 drivers/media/video/gspca/spca561.c                |   10 +-
 drivers/media/video/gspca/stk014.c                 |    5 +-
 drivers/media/video/gspca/sunplus.c                |    3 +-
 drivers/media/video/gspca/t613.c                   |  591 ++++---
 drivers/media/video/gspca/tv8532.c                 |    3 +-
 drivers/media/video/gspca/vc032x.c                 |    6 +-
 drivers/media/video/gspca/zc3xx.c                  |    3 +-
 drivers/media/video/ir-kbd-i2c.c                   |   64 +-
 drivers/media/video/ivtv/ivtv-cards.h              |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   12 +-
 drivers/media/video/ivtv/ivtv-driver.h             |    9 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    8 +-
 drivers/media/video/ivtv/ivtv-fileops.h            |    5 -
 drivers/media/video/ivtv/ivtv-gpio.c               |    2 +-
 drivers/media/video/ivtv/ivtv-gpio.h               |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    2 -
 drivers/media/video/ivtv/ivtv-ioctl.c              |   60 +-
 drivers/media/video/ivtv/ivtv-irq.c                |    9 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   42 +-
 drivers/media/video/ivtv/ivtv-vbi.c                |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c                |    1 +
 drivers/media/video/ivtv/ivtvfb.c                  |   78 +-
 drivers/media/video/meye.c                         |   13 +-
 drivers/media/video/meye.h                         |    1 +
 drivers/media/video/mt9m001.c                      |   55 +-
 drivers/media/video/mt9m111.c                      |  973 +++++++++++
 drivers/media/video/mt9v022.c                      |   52 +-
 drivers/media/video/mxb.c                          |  469 ++----
 drivers/media/video/ov511.c                        |  105 +-
 drivers/media/video/ov511.h                        |    3 +-
 drivers/media/video/ovcamchip/ovcamchip_core.c     |    6 -
 drivers/media/video/ovcamchip/ovcamchip_priv.h     |    6 +
 drivers/media/video/pms.c                          |   23 +-
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |    8 +-
 drivers/media/video/pvrusb2/pvrusb2-ctrl.h         |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    9 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |  340 ++++-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |   13 +
 .../media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c   |    7 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c |   46 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h |    1 +
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |   42 +-
 drivers/media/video/pvrusb2/pvrusb2-main.c         |    8 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   23 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |   94 ++-
 drivers/media/video/pwc/pwc-ctrl.c                 |    1 -
 drivers/media/video/pwc/pwc-if.c                   |   12 +-
 drivers/media/video/pwc/pwc-v4l.c                  |    2 +-
 drivers/media/video/pxa_camera.c                   |   48 +-
 drivers/media/video/s2255drv.c                     |  572 ++++---
 drivers/media/video/saa5246a.c                     |  568 +++++--
 drivers/media/video/saa5246a.h                     |  359 -----
 drivers/media/video/saa5249.c                      |  704 ++++-----
 drivers/media/video/saa7115.c                      |   42 +-
 drivers/media/video/saa7134/saa6752hs.c            |  440 +++---
 drivers/media/video/saa7134/saa7134-cards.c        |  261 +++-
 drivers/media/video/saa7134/saa7134-core.c         |   62 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   52 +-
 drivers/media/video/saa7134/saa7134-empress.c      |   65 +-
 drivers/media/video/saa7134/saa7134-i2c.c          |   11 +
 drivers/media/video/saa7134/saa7134-input.c        |  210 +++-
 drivers/media/video/saa7134/saa7134-ts.c           |   56 +-
 drivers/media/video/saa7134/saa7134-video.c        |   63 +-
 drivers/media/video/saa7134/saa7134.h              |   19 +-
 drivers/media/video/se401.c                        |   44 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |    5 -
 drivers/media/video/sn9c102/sn9c102_core.c         |   34 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h     |   20 -
 drivers/media/video/sn9c102/sn9c102_hv7131d.c      |    1 +
 drivers/media/video/sn9c102/sn9c102_hv7131r.c      |    1 +
 drivers/media/video/sn9c102/sn9c102_mi0343.c       |    1 +
 drivers/media/video/sn9c102/sn9c102_mi0360.c       |    1 +
 drivers/media/video/sn9c102/sn9c102_mt9v111.c      |    1 +
 drivers/media/video/sn9c102/sn9c102_ov7630.c       |    1 +
 drivers/media/video/sn9c102/sn9c102_ov7660.c       |    1 +
 drivers/media/video/sn9c102/sn9c102_pas106b.c      |    1 +
 drivers/media/video/sn9c102/sn9c102_pas202bcb.c    |    1 +
 drivers/media/video/sn9c102/sn9c102_tas5110c1b.c   |    1 +
 drivers/media/video/sn9c102/sn9c102_tas5110d.c     |    1 +
 drivers/media/video/sn9c102/sn9c102_tas5130d1b.c   |    1 +
 drivers/media/video/stk-webcam.c                   |   90 +-
 drivers/media/video/stk-webcam.h                   |    2 -
 drivers/media/video/stradis.c                      |    7 +-
 drivers/media/video/stv680.c                       |    8 +-
 drivers/media/video/tda9840.c                      |  260 ++--
 drivers/media/video/tda9840.h                      |   21 -
 drivers/media/video/tea6415c.c                     |  131 +--
 drivers/media/video/tea6420.c                      |  147 +--
 drivers/media/video/tuner-3036.c                   |  214 ---
 drivers/media/video/tuner-core.c                   |   13 +-
 drivers/media/video/usbvideo/ibmcam.c              |   78 +-
 drivers/media/video/usbvideo/konicawc.c            |   17 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |    3 +-
 drivers/media/video/usbvideo/ultracam.c            |   29 +-
 drivers/media/video/usbvideo/usbvideo.c            |  166 ++-
 drivers/media/video/usbvideo/vicam.c               |   17 +-
 drivers/media/video/usbvision/usbvision-core.c     |    3 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |    3 +-
 drivers/media/video/usbvision/usbvision-video.c    |  127 +--
 drivers/media/video/uvc/uvc_ctrl.c                 |  185 ++-
 drivers/media/video/uvc/uvc_driver.c               |   51 +-
 drivers/media/video/uvc/uvc_status.c               |   11 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   17 +-
 drivers/media/video/uvc/uvc_video.c                |   12 +-
 drivers/media/video/uvc/uvcvideo.h                 |    4 +-
 drivers/media/video/v4l2-common.c                  |  183 ++-
 drivers/media/video/v4l2-dev.c                     |  300 ++--
 drivers/media/video/v4l2-ioctl.c                   |   12 -
 drivers/media/video/vino.c                         |   25 +-
 drivers/media/video/vivi.c                         |    7 +-
 drivers/media/video/vpx3220.c                      |    2 -
 drivers/media/video/w9966.c                        |   29 +-
 drivers/media/video/zc0301/zc0301_core.c           |   14 +-
 drivers/media/video/zoran/Kconfig                  |   73 +
 drivers/media/video/zoran/Makefile                 |    6 +
 drivers/media/video/{ => zoran}/videocodec.c       |    0 
 drivers/media/video/{ => zoran}/videocodec.h       |    0 
 drivers/media/video/{ => zoran}/zoran.h            |    0 
 drivers/media/video/{ => zoran}/zoran_card.c       |    0 
 drivers/media/video/{ => zoran}/zoran_card.h       |    0 
 drivers/media/video/{ => zoran}/zoran_device.c     |    6 +-
 drivers/media/video/{ => zoran}/zoran_device.h     |    8 +
 drivers/media/video/{ => zoran}/zoran_driver.c     |   13 +-
 drivers/media/video/{ => zoran}/zoran_procfs.c     |    0 
 drivers/media/video/{ => zoran}/zoran_procfs.h     |    0 
 drivers/media/video/{ => zoran}/zr36016.c          |    0 
 drivers/media/video/{ => zoran}/zr36016.h          |    0 
 drivers/media/video/{ => zoran}/zr36050.c          |    0 
 drivers/media/video/{ => zoran}/zr36050.h          |    0 
 drivers/media/video/{ => zoran}/zr36057.h          |    0 
 drivers/media/video/{ => zoran}/zr36060.c          |    0 
 drivers/media/video/{ => zoran}/zr36060.h          |    0 
 drivers/media/video/zr364xx.c                      |   87 +-
 include/linux/dvb/frontend.h                       |  110 ++-
 include/linux/dvb/version.h                        |    4 +-
 include/linux/i2c-id.h                             |    1 -
 include/linux/ivtv.h                               |    1 +
 include/linux/videodev2.h                          |   30 +-
 include/media/ir-common.h                          |   11 +-
 include/media/saa7115.h                            |   19 +-
 include/media/saa7146.h                            |    2 +-
 include/media/sh_mobile_ceu.h                      |    2 -
 include/media/soc_camera.h                         |    3 +
 include/media/tuner.h                              |    3 +-
 include/media/v4l2-chip-ident.h                    |    5 +
 include/media/v4l2-common.h                        |   15 +-
 include/media/v4l2-dev.h                           |   75 +-
 include/media/v4l2-ioctl.h                         |    5 -
 include/sound/tea575x-tuner.h                      |    1 +
 sound/i2c/other/tea575x-tuner.c                    |   23 +-
 377 files changed, 29921 insertions(+), 6874 deletions(-)
 create mode 100644 Documentation/video4linux/m5602.txt
 create mode 100644 Documentation/video4linux/soc-camera.txt
 delete mode 100644 drivers/media/common/tuners/xc5000_priv.h
 delete mode 100644 drivers/media/dvb/cinergyT2/Kconfig
 delete mode 100644 drivers/media/dvb/cinergyT2/Makefile
 delete mode 100644 drivers/media/dvb/cinergyT2/cinergyT2.c
 create mode 100644 drivers/media/dvb/dm1105/Kconfig
 create mode 100644 drivers/media/dvb/dm1105/Makefile
 create mode 100644 drivers/media/dvb/dm1105/dm1105.c
 create mode 100644 drivers/media/dvb/dvb-usb/af9015.c
 create mode 100644 drivers/media/dvb/dvb-usb/af9015.h
 create mode 100644 drivers/media/dvb/dvb-usb/cinergyT2-core.c
 create mode 100644 drivers/media/dvb/dvb-usb/cinergyT2-fe.c
 create mode 100644 drivers/media/dvb/dvb-usb/cinergyT2.h
 create mode 100644 drivers/media/dvb/dvb-usb/dtv5100.c
 create mode 100644 drivers/media/dvb/dvb-usb/dtv5100.h
 create mode 100644 drivers/media/dvb/frontends/af9013.c
 create mode 100644 drivers/media/dvb/frontends/af9013.h
 create mode 100644 drivers/media/dvb/frontends/af9013_priv.h
 create mode 100644 drivers/media/dvb/frontends/cx24116.c
 create mode 100644 drivers/media/dvb/frontends/cx24116.h
 create mode 100644 drivers/media/dvb/frontends/eds1547.h
 create mode 100644 drivers/media/dvb/frontends/lgs8gl5.c
 create mode 100644 drivers/media/dvb/frontends/lgs8gl5.h
 create mode 100644 drivers/media/dvb/frontends/si21xx.c
 create mode 100644 drivers/media/dvb/frontends/si21xx.h
 create mode 100644 drivers/media/dvb/frontends/stb6000.c
 create mode 100644 drivers/media/dvb/frontends/stb6000.h
 create mode 100644 drivers/media/dvb/frontends/stv0288.c
 create mode 100644 drivers/media/dvb/frontends/stv0288.h
 create mode 100644 drivers/media/dvb/frontends/tdhd1.h
 create mode 100644 drivers/media/radio/radio-mr800.c
 create mode 100644 drivers/media/video/cx18/cx18-io.c
 create mode 100644 drivers/media/video/cx18/cx18-io.h
 delete mode 100644 drivers/media/video/dpc7146.c
 create mode 100644 drivers/media/video/gspca/finepix.c
 create mode 100644 drivers/media/video/gspca/m5602/Kconfig
 create mode 100644 drivers/media/video/gspca/m5602/Makefile
 create mode 100644 drivers/media/video/gspca/m5602/m5602_bridge.h
 create mode 100644 drivers/media/video/gspca/m5602/m5602_core.c
 create mode 100644 drivers/media/video/gspca/m5602/m5602_mt9m111.c
 create mode 100644 drivers/media/video/gspca/m5602/m5602_mt9m111.h
 create mode 100644 drivers/media/video/gspca/m5602/m5602_ov9650.c
 create mode 100644 drivers/media/video/gspca/m5602/m5602_ov9650.h
 create mode 100644 drivers/media/video/gspca/m5602/m5602_po1030.c
 create mode 100644 drivers/media/video/gspca/m5602/m5602_po1030.h
 create mode 100644 drivers/media/video/gspca/m5602/m5602_s5k4aa.c
 create mode 100644 drivers/media/video/gspca/m5602/m5602_s5k4aa.h
 create mode 100644 drivers/media/video/gspca/m5602/m5602_s5k83a.c
 create mode 100644 drivers/media/video/gspca/m5602/m5602_s5k83a.h
 create mode 100644 drivers/media/video/gspca/m5602/m5602_sensor.h
 create mode 100644 drivers/media/video/mt9m111.c
 delete mode 100644 drivers/media/video/saa5246a.h
 delete mode 100644 drivers/media/video/tuner-3036.c
 create mode 100644 drivers/media/video/zoran/Kconfig
 create mode 100644 drivers/media/video/zoran/Makefile
 rename drivers/media/video/{ => zoran}/videocodec.c (100%)
 rename drivers/media/video/{ => zoran}/videocodec.h (100%)
 rename drivers/media/video/{ => zoran}/zoran.h (100%)
 rename drivers/media/video/{ => zoran}/zoran_card.c (100%)
 rename drivers/media/video/{ => zoran}/zoran_card.h (100%)
 rename drivers/media/video/{ => zoran}/zoran_device.c (99%)
 rename drivers/media/video/{ => zoran}/zoran_device.h (94%)
 rename drivers/media/video/{ => zoran}/zoran_driver.c (99%)
 rename drivers/media/video/{ => zoran}/zoran_procfs.c (100%)
 rename drivers/media/video/{ => zoran}/zoran_procfs.h (100%)
 rename drivers/media/video/{ => zoran}/zr36016.c (100%)
 rename drivers/media/video/{ => zoran}/zr36016.h (100%)
 rename drivers/media/video/{ => zoran}/zr36050.c (100%)
 rename drivers/media/video/{ => zoran}/zr36050.h (100%)
 rename drivers/media/video/{ => zoran}/zr36057.h (100%)
 rename drivers/media/video/{ => zoran}/zr36060.c (100%)
 rename drivers/media/video/{ => zoran}/zr36060.h (100%)

Adam Glover (1):
      V4L/DVB (9063): Add ADS Tech Instant HDTV PCI support

Adrian Bunk (1):
      V4L/DVB (8561): make ivtv_claim_stream() static

Albert Comerma (1):
      V4L/DVB (9042): Add support for Asus My Cinema U3000 Hybrid

Alexander Beregalov (3):
      V4L/DVB (8560): replace __FUNCTION__ with __func__
      V4L/DVB (8680): saa7134-core.c: fix warning
      V4L/DVB (8559): replace __FUNCTION__ with __func__

Alexey Klimov (3):
      V4L/DVB (9101): radio-mr800: Add driver for AverMedia MR 800 USB FM radio devices
      V4L/DVB (9151): dsbr100: Add returns and fix codingstyle for vidioc_s_ctrl
      V4L/DVB (9152): radio-zoltrix: Add checking for frequency

Andrew Morton (1):
      V4L/DVB (9033): drivers/media/video/tda9840.c: unbreak

Andy Walls (14):
      V4L/DVB (8770): cx18: get rid of ununsed buffers stolen field
      V4L/DVB (8771): cx18: Remove redundant struct cx18_queue length member.
      V4L/DVB (8772): cx18: Convert cx18_queue buffers member to atomic_t
      V4L/DVB (8773): cx18: Fix cx18_find_handle() and add error checking
      V4L/DVB (8774): cx18: Have CX23418 release buffers at end of capture.
      V4L/DVB (8912): cx18: Correct CX23418 PCI configuration settings.
      V4L/DVB (8913): cx18: Create cx18_ specific wrappers for all pci mmio accessesors.
      V4L/DVB (8914): cx18: Throttle mmio to/from the CX23418 so boards work in older systems
      V4L/DVB (8915): cx18: Increment u8 pointers not void pointers.
      V4L/DVB (8924): cx18: Set mmio throttling delay default to 0 nsec.
      V4L/DVB (9110): cx18: Add default behavior of checking and retrying PCI MMIO accesses
      V4L/DVB (9111): cx18: Up the version to 1.0.1
      V4L/DVB (9131): cx18: Add entries for the Leadtek PVR2100 and Toshiba Qosmio DVB-T/Analog
      V4L/DVB (9132): cx18: Fix warning message for DMA done notification for inactive stream.

Antoine Jacquet (7):
      V4L/DVB (8731): zr364xx: remove BKL
      V4L/DVB (8732): zr364xx: handle video exclusive open internaly
      V4L/DVB (8734): Initial support for AME DTV-5100 USB2.0 DVB-T
      V4L/DVB (8735): dtv5100: replace dummy frontend by zl10353
      V4L/DVB (8736): dtv5100: CodingStyle cleanups
      V4L/DVB (8738): dtv5100: remove old definition from header
      V4L/DVB (8739): dtv5100: remove prohibited space...

Anton Blanchard (1):
      V4L/DVB (8654): cxusb: add support for DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)

Antti Palosaari (12):
      V4L/DVB (8970): mt2060: implement I2C-gate control
      V4L/DVB (8971): initial driver for af9013 demodulator
      V4L/DVB (8972): initial driver for af9015 chipset
      V4L/DVB (8973): af9013: fix compile error coming from u64 div
      V4L/DVB (8975): af9015: cleanup
      V4L/DVB (8976): af9015: Add USB ID for AVerMedia A309
      V4L/DVB (9140): anysee: unlock I2C-mutex in error case
      V4L/DVB (9141): anysee: support for Anysee E30 Combo Plus
      V4L/DVB (9143): af9015: fix wrong GPIO
      V4L/DVB (9144): af9015: enable Maxlinear mxl5005s tuner RSSI
      V4L/DVB (9145): af901x: clean-up
      V4L/DVB (9146): af901x: fix some compiler errors and warnings

Bjorn Helgaas (1):
      V4L/DVB: follow lspci device/vendor style

Brandon Philips (1):
      V4L/DVB (9179): S2API: frontend.h cleanup

Brian Rogers (1):
      V4L/DVB (9168): Add support for MSI TV@nywhere Plus remote

Chris Rankin (1):
      V4L/DVB (9047): [PATCH] Add remote control support to Nova-TD (52009)

Daniel Oliveira Nascimento (1):
      V4L/DVB (9041): Add support YUAN High-Tech STK7700D (1164:1f08)

Darron Broad (9):
      V4L/DVB (9011): S2API: A number of cleanusp from the last 24 months.
      V4L/DVB (9013): S2API: cx24116 Rolloff changes, sysctls cleanup, isl power changes.
      V4L/DVB (9015): S2API: cx24116 register description fixes.
      V4L/DVB (9016): HVR3000/4000 Hauppauge related IR cleanups
      V4L/DVB (9069): cx88: Bugfix: all client disconnects put the frontend to sleep.
      V4L/DVB (9170): cx24116: Sanity checking to data input via S2API to the cx24116 demod.
      V4L/DVB (9171): S2API: Stop an OOPS if illegal commands are dumped in S2API.
      V4L/DVB (9172): S2API: Bugfix related to DVB-S / DVB-S2 tuning for the legacy API.
      V4L/DVB (9185): S2API: Ensure we have a reasonable ROLLOFF default

David Bentham (1):
      V4L/DVB (9057): saa7134: Hauppauge HVR-1110, support for radio and analog audio in

David Ellingsworth (1):
      V4L/DVB (9034): With the recent patch to v4l2 titled "v4l2: use register_chrdev_region

David Howells (1):
      V4L/DVB (8838): CRED: Wrap task credential accesses in video input drivers

Dean Anderson (2):
      V4L/DVB (8752): s2255drv: firmware improvement patch
      V4L/DVB (8845): s2255drv: adds JPEG compression quality control

Devin Heitmueller (5):
      V4L/DVB (9039): Add support for new i2c API provided in firmware version 1.20
      V4L/DVB (9044): Add support for Pinnacle PCTV HD Pro 801e (ATSC only)
      V4L/DVB (9045): Add Pinnacle 801e dependencies to KConfig
      V4L/DVB (9046): Add support for Non-Pro version of Pinnacle PCTV HD USB Stick
      V4L/DVB (9114): dib0700: fix bad assignment of dib0700_xc5000_tuner_callback after return call

Dmitri Belimov (1):
      V4L/DVB (9065): saa7134: fix I2C remote controls on saa7134

Dmitry Belimov (3):
      V4L/DVB (8795): saa7134-empress: insert leading null bytes for Beholder M6 empress cards
      V4L/DVB (8796): saa7134-empress: remove incorrect IRQ defines for TS
      V4L/DVB (8797): A simple state machine was added to saa7134_ts.

Douglas Schilling Landgraf (2):
      V4L/DVB (8936): em28xx-cards: Add vendor/product id for EM2820_BOARD_PROLINK_PLAYTV_USB2
      V4L/DVB (8937): em28xx: Fix and add some validations

Erik Andren (6):
      V4L/DVB (9091): gspca: Subdriver m5602 (ALi) added.
      V4L/DVB (9093): gspca: Cleanup code and small changes.
      V4L/DVB (9094): gspca: Frame counter in ALi m5602.
      V4L/DVB (9095): gspca: Moves some sensor initialization to each sensor in m5602.
      V4L/DVB (9096): gspca: Subdriver selection at config time.
      V4L/DVB (9123): gspca: Add some lost controls to the s5k83a sensor.

Felipe Balbi (1):
      V4L/DVB (8724): dvb: drx397xD: checkpatch.pl cleanups

Finn Thain (1):
      V4L/DVB (9038): Add support for the Gigabyte R8000-HT USB DVB-T adapter.

Frank Zago (6):
      V4L/DVB (9077): gspca: Set the right V4L2_DEBUG values in the main driver.
      V4L/DVB (9084): gspca: Fixed a few typos in comments.
      V4L/DVB (9085): gspca: URB_NO_TRANSFER_DMA_MAP is required for isoc and bulk transfers.
      V4L/DVB (9086): gspca: Use a kref to avoid potentialy blocking forever in disconnect.
      V4L/DVB (9088): gspca: New subdriver 'finepix' added.
      V4L/DVB (9090): gspca: Restart the state machine when no frame buffer in finepix.

Greg Kroah-Hartman (1):
      V4L/DVB (9116): USB: remove info() macro from usb media drivers

Guennadi Liakhovetski (3):
      V4L/DVB (8685): mt9m001, mt9v022: Simplify return code checking
      V4L/DVB (8686): mt9m111: style cleanup
      V4L/DVB (8799): soc-camera: add API documentation

Hans Verkuil (51):
      V4L/DVB (8613): v4l: move BKL down to the driver level.
      V4L/DVB (8630): First mxb cleanup phase
      V4L/DVB (8635): v4l: add AC-3 audio support to the MPEG Encoding API
      V4L/DVB (8636): v4l2: add v4l2_ctrl_get_name control support function.
      V4L/DVB (8637): v4l2: add v4l2_ctrl_query_menu_valid_items support function
      V4L/DVB (8639): saa6752hs: cleanup and add AC-3 support
      V4L/DVB (8640): saa6752hs: add PMT table for AC3
      V4L/DVB (8641): arv: fix compilation errors/warnings
      V4L/DVB (8649): v4l2: add AAC bitrate control
      V4L/DVB (8689): dpc7146: remove dpc7146 demonstration board driver
      V4L/DVB (8690): tuner-3036: remove driver
      V4L/DVB (8691): i2c-id: remove obsolete SAB3036 driver ID
      V4L/DVB (8695): usbvideo: add proper error check and add release function
      V4L/DVB (8745): v4l2: fix a bunch of compile warnings.
      V4L/DVB (8746): v4l-dvb: fix compile warnings.
      V4L/DVB (8776): radio: replace video_exclusive_open/release
      V4L/DVB (8777): tea575x-tuner: replace video_exclusive_open/release
      V4L/DVB (8780): v4l: replace the last uses of video_exclusive_open/release
      V4L/DVB (8781): v4l2-dev: remove obsolete video_exclusive_open/release
      V4L/DVB (8782): v4l2-dev: add video_device_release_empty
      V4L/DVB (8783): v4l: add all missing video_device release callbacks
      V4L/DVB (8784): v4l2-dev: make the video_device's release callback mandatory
      V4L/DVB (8785): v4l2: add __must_check to v4l2_dev.h
      V4L/DVB (8786): v4l2: remove the priv field, use dev_get_drvdata instead
      V4L/DVB (8787): v4l2-dev: cleanups and add video_drvdata helper function
      V4L/DVB (8788): v4l: replace video_get_drvdata(video_devdata(filp)) with video_drvdata(filp)
      V4L/DVB (8791): v4l2-dev: do not clear the driver_data field
      V4L/DVB (8850): bt856: fix define conflict
      V4L/DVB (8852): v4l2: use register_chrdev_region instead of register_chrdev
      V4L/DVB (8856): v4l: fix assorted compile warnings/errors
      V4L/DVB (8857): v4l2-dev: replace panic with BUG
      V4L/DVB (8906): v4l-dvb: fix assorted sparse warnings
      V4L/DVB (8917): saa7134-empress: fix changing the capture standard for non-tuner inputs
      V4L/DVB (8918): saa6752hs: simplify writing to registers
      V4L/DVB (8920): cx18/ivtv: fix check of window boundaries for VIDIOC_S_FMT
      V4L/DVB (8921): ivtv: fix incorrect capability and assorted sliced vbi and video out fmt fixes
      V4L/DVB (8939): cx18: fix sparse warnings
      V4L/DVB (8940): saa7115: fix saa7111(a) support
      V4L/DVB (8941): mxb/tda9840: cleanups, use module saa7115 instead of saa7111.
      V4L/DVB (8942): mxb: coding style cleanups
      V4L/DVB (8943): saa5246a: convert i2c driver for new i2c API
      V4L/DVB (8944): saa5249: convert i2c driver for new i2c API
      V4L/DVB (8945): mxb: use unique i2c adapter name
      V4L/DVB (8946): dib7000m: fix powerpc build error
      V4L/DVB (8904): cx88: add missing unlock_kernel
      V4L/DVB (9133): v4l: disconnect kernel number from minor
      V4L/DVB (9129): zoran: move zoran sources into a zoran subdirectory
      V4L/DVB (9157): cx18/ivtv: add 'PCI:' prefix to bus_info.
      V4L/DVB (9159): saa5249: fix compile errors
      V4L/DVB (9160): v4l: remove vidioc_enum_fmt_vbi_cap
      V4L/DVB (9162): ivtv: fix raw/sliced VBI mixup

Harvey Harrison (3):
      V4L/DVB (8725): drx397xD.c sparse annotations
      V4L/DVB (8742): pvrusb2: use proper byteorder interface
      V4L/DVB (8800): [v4l-dvb-maintainer] [PATCH] v4l: mt9m111.c make function static

Henrik Kretzschmar (2):
      V4L/DVB (8748): V4L: fix return value of meye probe callback
      V4L/DVB (8750): V4L: check inval in video_register_device_index()

Herbert Graeber (1):
      V4L/DVB (9147): af9015: Add USB ID for MSI DIGIVOX mini III

Hermann Pitton (1):
      V4L/DVB (9113): saa7134: fixes for the Asus Tiger Revision 1.00

Huang Weiyi (2):
      V4L/DVB: remove unused #include <version.h>
      V4L/DVB: v4l2-dev: remove duplicated #include

Ian Armstrong (4):
      V4L/DVB (9163): ivtvfb: fix sparse warnings and improve write function
      V4L/DVB (9164): ivtvfb: a small cosmetic change
      V4L/DVB (9165): ivtv: V4L2_FBUF_FLAG_OVERLAY status fix
      V4L/DVB (9166): ivtv - Fix potential race condition in yuv handler

Igor M. Liplianin (17):
      V4L/DVB (8989): Added support for TeVii S460 DVB-S/S2 card
      V4L/DVB (8991): Added support for DVBWorld 2104 and TeVii S650 USB DVB-S2 cards
      V4L/DVB (8992): Kconfig corrections for DVBWorld 2104 and TeVii S650 USB DVB-S2 cards
      V4L/DVB (8993): cx24116: Fix lock for high (above 30000 kSyms) symbol rates
      V4L/DVB (8994): Adjust MPEG initialization in cx24116
      V4L/DVB (9005): Bug fix: ioctl FE_SET_PROPERTY/FE_GET_PROPERTY always return error
      V4L/DVB (9010): Add support for SDMC DM1105 PCI chip
      V4L/DVB (9012): Add support for DvbWorld 2004 DVB-S2 PCI adapter
      V4L/DVB (9014): History update: MPEG initialization in cx24116.
      V4L/DVB (9017): Add support for Silicon Laboratories SI2109/2110 demodulators.
      V4L/DVB (9018): Add support for USB card modification with SI2109/2110 demodulator.
      V4L/DVB (9026): Add support for ST STV0288 demodulator and cards with it.
      V4L/DVB (9067): Kconfig correction for USB card modification with SI2109/2110 demodulator.
      V4L/DVB (9068): Kconfig dependency fix for DW2002 card with ST STV0288 demodulator.
      V4L/DVB (9174): Allow custom inittab for ST STV0288 demodulator.
      V4L/DVB (9175): Remove NULL pointer in stb6000 driver.
      V4L/DVB (9176): Add support for DvbWorld USB cards with STV0288 demodulator.

Janne Grunau (3):
      V4L/DVB (8634): v4l2: extend MPEG Encoding API with AVC and AAC
      V4L/DVB (8964): dvb/budget: push adapter_nr mod option down to individual drivers
      V4L/DVB (9105): correct Makefile symbol for stv0288 frontend

Jean Delvare (3):
      V4L/DVB (8879): bttv: Don't unmask VPRES interrupt
      V4L/DVB (8956): bttv: Turn video_nr, vbi_nr and radio_nr into arrays
      V4L/DVB (8962): zr36067: VIDIOC_S_FMT returns the colorspace value

Jean-Francois Moine (23):
      V4L/DVB (8910): gspca: Add support of image transfer by bulk and minor change.
      V4L/DVB (8927): gspca: PAC 207 webcam 093a:2476 added.
      V4L/DVB (8928): gspca: Version change to 2.3.0.
      V4L/DVB (8929): gspca: sonixj webcam 0458:702e added.
      V4L/DVB (8930): gspca: The image transfer by bulk is started by the subdrivers.
      V4L/DVB (8931): gspca: Vflip added for sonixj - ov7630.
      V4L/DVB (9074): gspca: sonixj webcam 0c45:60fe added.
      V4L/DVB (9078): gspca: New exported function to retrieve the current frame buffer.
      V4L/DVB (9079): gspca: Return error code from stream start functions.
      V4L/DVB (9081): gspca: Bad webcam name of 046d:092f in documentation.
      V4L/DVB (9082): gspca: Vertical flip the image by default in sonixj.
      V4L/DVB (9083): gspca: URB_NO_TRANSFER_DMA_MAP is not useful for isoc transfers.
      V4L/DVB (9087): gspca: Image transfer by bulk uses altsetting 0 with any buffer size.
      V4L/DVB (9089): gspca: Remove the duplicated EOF (ff d9) in t613.
      V4L/DVB (9097): gspca: Adjust control values and restore compilation of sonixj.
      V4L/DVB (9118): gspca: Set the vertical flip at streamon time in sonixj.
      V4L/DVB (9119): gspca: Don't destroy the URBs on disconnect.
      V4L/DVB (9120): gspca: sd_desc->start returns a value and static functions in m5602.
      V4L/DVB (9121): gspca: Add the subdriver finepix in Kconfig and Makefile.
      V4L/DVB (9122): gspca: Bad name of the sunplus subdriver in Kconfig.
      V4L/DVB (9124): gspca: Bad name of the tv8532 subdriver in Kconfig.
      V4L/DVB (9125): gspca: Big rewrite of t613 driver
      V4L/DVB (9126): gspca: Fix some compilation warnings in m5602.

Julia Lawall (2):
      V4L/DVB (8729): Use DIV_ROUND_UP
      V4L/DVB (8954): common/tuners: Drop code after return or goto

Kirill A. Shutemov (1):
      V4L/DVB (8959): include <linux/videodev2.h> into linux/ivtv.h

Laurent Pinchart (8):
      V4L/DVB (8754): uvcvideo: Implement the USB power management reset_resume method.
      V4L/DVB (8846): uvcvideo: Supress spurious "EOF in empty payload" trace message
      V4L/DVB (8847): uvcvideo: Add support for a Bison Electronics webcam found in the Fujitsu Amilo SI2636.
      V4L/DVB (9030): uvcvideo : Add support for Advent 4211 integrated webcam
      V4L/DVB (9031): uvcvideo: Fix incomplete frame drop when switching to a variable size format.
      V4L/DVB (9035): uvcvideo: Declare missing camera and processing unit controls.
      V4L/DVB (9036): uvcvideo: Fix control cache access when setting composite auto-update controls
      V4L/DVB (9169): uvcvideo: Support two new Bison Electronics webcams.

Mauro Carvalho Chehab (14):
      V4L/DVB (8553): media/video/Kconfig: get rid of a select
      V4L/DVB (8554): media/video/Kconfig: cosmetic changes and convert select into depends on
      V4L/DVB (8625): saa7134: Add NEC prococol IR decoding capability
      V4L/DVB (8626): Add support for TCL tuner MF02GIP-5N-E
      V4L/DVB (8627): Fix mute on bttv driver
      V4L/DVB (8628a): Remove duplicated include
      V4L/DVB (8628): bttv: Add support for Encore ENLTV2-FM
      V4L/DVB (8730): drx397xD: fix compilation error caused by changeset 71046dfb0853
      V4L/DVB (9055): tuner-xc2028: Do a better job selecting firmware type
      V4L/DVB (9059): saa7134: Add support for Encore version 5.3 board
      V4L/DVB (9060): saa7134: Add support for Avermedia PCI pure analog (M135A)
      V4L/DVB (9061): saa7134: Add support for Real Audio 220
      V4L/DVB (9062): Add support for Prolink Pixelview Global Extreme
      V4L/DVB (9098): Whitespace cleanups

Michael Krufky (12):
      V4L/DVB (8655): cxusb: fix checkpatch warnings & errors
      V4L/DVB (8656): fix DVB_FE_CUSTOMISE for DVB_DIB7000P and DVB_TUNER_DIB0070 with dvb-usb-cxusb
      V4L/DVB (8658): lgs8gl5: fix build warnings
      V4L/DVB (8948): xc5000: kill xc5000_priv.h
      V4L/DVB (8949): xc5000: allow multiple driver instances for the same hardware to share state
      V4L/DVB (8950): xc5000: prevent an OOPS if analog driver is unloaded while digital is in use
      V4L/DVB (8951): xc5000: dont pass devptr in xc5000_attach()
      V4L/DVB (8968): replace xc3028 firmware filenames with defined default firmware names
      V4L/DVB (9048): add a general-purpose callback pointer to struct dvb_frontend
      V4L/DVB (9049): convert tuner drivers to use dvb_frontend->callback
      V4L/DVB (9051): dib0700: use dvb_frontend->callback for xc5000 gpio reset
      V4L/DVB (9149): hvr950q: led feedback based on snr

Mike Isely (9):
      V4L/DVB (8893): pvrusb2: Add comment elaborating on direct use of swab32()
      V4L/DVB (8894): pvrusb2: Remove BKL
      V4L/DVB (8895): pvrusb2: Fail gracefully if an alien USB ID is used
      V4L/DVB (8897): pvrusb2: Mark crop window size change as being disruptive to the encoder
      V4L/DVB (8898): pvrusb2: Be able to programmatically retrieve a control's default value
      V4L/DVB (8899): pvrusb2: Implement default value retrieval in sysfs interface
      V4L/DVB (8900): pvrusb2: Implement cropping pass through
      V4L/DVB (8901): pvrusb2: Disable virtual IR device when not needed.
      V4L/DVB (8902): pvrusb2: Remove comment lines which refer to checkpatch's behavior

Mikko Ohtamaa (1):
      V4L/DVB (8974): af9015: Add USB ID for Telestar Starstick 2

Ming Lei (1):
      V4L/DVB:usbvideo:don't use part of buffer for USB transfer #4

Oleg Roitburd (3):
      V4L/DVB (9019): Added support for Omicom SS4 DVB-S/S2 card
      V4L/DVB (9020): Added support for TBS 8920 DVB-S/S2 card
      V4L/DVB (9186): Added support for Prof 7300 DVB-S/S2 cards

Oliver Endriss (3):
      V4L/DVB (8888): budget: Support Activy DVB-T with TDHD1 tuner
      V4L/DVB (8889): dvb-ttpci: Support full-ts hardware modification
      V4L/DVB (8890): budget: Add callback to load firmware for the TDHD1 tuner

Patrick Boettcher (1):
      V4L/DVB (8866): Add dummy FE to the Kconfig-file and fix it

Peter Beutner (1):
      V4L/DVB (9040): TTUSB-DEC DVB-S: claim to have lock

Robert Jarzmik (2):
      V4L/DVB (8683): Add Micron mt9m111 chip ID in V4L2 identifiers
      V4L/DVB (8684): Add support for Micron MT9M111 camera.

Shane (2):
      V4L/DVB (9058): spca561: while balance -> white balance typo
      V4L/DVB (9076): gspca: USB direction lacking in spca561.

Stefan Herbrechtsmeier (1):
      V4L/DVB (8687): soc-camera: Move .power and .reset from soc_camera host to sensor driver

Steven Toth (41):
      V4L/DVB (8642): cx23885: Factor out common cx23885 tuner callback
      V4L/DVB (8643): Switch Hauppauge HVR1400 and HVR1500 to common cx23885 tuner callback
      V4L/DVB (8644): Add support for DViCO FusionHDTV DVB-T Dual Express
      V4L/DVB (8645): Support IR remote on FusionHDTV DVB-T Dual Express
      V4L/DVB (8646): cx23885: Convert framework to use a single tuner callback function.
      V4L/DVB (8807): Add DVB support for the Leadtek Winfast PxDVR3200 H
      V4L/DVB (8985): S2API: Added dvb frontend changes to support a newer tuning API
      V4L/DVB (8986): cx24116: Adding DVB-S2 demodulator support
      V4L/DVB (8987): cx88: Add support for the Hauppauge HVR4000 and HVR4000-LITE (S2) boards
      V4L/DVB (8988): S2API: Allow the properties to call legacy ioctls
      V4L/DVB (8990): S2API: DVB-S/S2 voltage selection bug fix
      V4L/DVB (8995): S2API: tv_ / TV_ to dtv_ / DTV_ namespace changes
      V4L/DVB (8996): S2API: typedefs replaced, _SEQ_'s removed, fixed 16 command arrays replaced
      V4L/DVB (8997): S2API: Cleanup SYMBOLRATE, INNERFEC -> SYMBOL_RATE, INNER_FEC
      V4L/DVB (8998): s2api: restore DTV_UNDEFINED
      V4L/DVB (8999): S2API: Reduce demod driver complexity by using a cache sync
      V4L/DVB (9000): S2API: Cleanup code that prepares tuning structures.
      V4L/DVB (9001): S2API: ISDBT_SEGMENT_NUM -> ISDBT_SEGMENT_IDX
      V4L/DVB (9002): S2API: Ensure cache->delivery_system is set at all times.
      V4L/DVB (9003): S2API: Remove the DTV_SET_ and DTV_GET_ prefixes
      V4L/DVB (9004): S2API: Implement GET/SET handing to the demods
      V4L/DVB (9006): S2API: Allow reliable use of old and new api on the same frontend, regardless.
      V4L/DVB (9007): S2API: Changed bandwidth to be expressed in HZ
      V4L/DVB (9008): S2API: Bugfix related to syncing the cache when used with the old API.
      V4L/DVB (9009): Nova-se2 / Nova-s-plus Intersil6421 power fix to support switches.
      V4L/DVB (9021): S2API: Add Kconf dependency
      V4L/DVB (9022): cx88: Enable TDA9887 on HVR1300 / 3000 / 4000
      V4L/DVB (9023): cx88: HVR3000 / 4000 GPIO related changes
      V4L/DVB (9024): S2API: Cleanup dtv_property remove unwanted fields.
      V4L/DVB (9025): S2API: Deactivate the ISDB-T definitions
      V4L/DVB (9070): S2API: Removed the typedef for the commands, used defines instead.
      V4L/DVB (9071): S2API: Implement result codes for individual commands
      V4L/DVB (9072): S2API: Add DTV_API_VERSION command
      V4L/DVB (9173): S2API: Remove the hardcoded command limit during validation
      V4L/DVB (9177): S2API: Change _8PSK / _16APSK to PSK_8 and APSK_16
      V4L/DVB (9178): cx24116: Add module parameter to return SNR as ESNO.
      V4L/DVB (9180): S2API: Added support for DTV_CODE_RATE_HP/LP
      V4L/DVB (9181): S2API: Add support fot DTV_GUARD_INTERVAL and DTV_TRANSMISSION_MODE
      V4L/DVB (9182): S2API: Added support for DTV_HIERARCHY
      V4L/DVB (9183): S2API: Return error of the caller provides 0 commands.
      V4L/DVB (9184): cx24116: Change the default SNR units back to percentage by default.

Stéphane Voltz (1):
      V4L/DVB (9066): Pinnacle Hybrid PCTV Pro (pctv310c) DVB-T support

Thierry MERLE (2):
      V4L/DVB (9108): cinergyT2: add remote key repeat feature
      V4L/DVB (9155): em28xx-dvb: dvb_init() code factorization

Tim Farrington (1):
      V4L/DVB (9135): cx88 Dvico FusionHDTV Pro

Timothy Lee (1):
      V4L/DVB (8657): cxusb: add lgs8gl5 and support for Magic-Pro DMB-TH usb stick

Tomi Orava (1):
      V4L/DVB (9107): Alternative version of Terratec Cinergy T2 driver

hermann pitton (1):
      V4L/DVB (9028): saa7134: add support for the triple Asus Tiger 3in1

roel kluin (1):
      V4L/DVB: pxa-camera: Unsigned dma_chans[] cannot be negative

vdb128@picaros.org (1):
      V4L/DVB (8896): pvrusb2: Implement crop support

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
