Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OIHff0004371
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:17:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OIHSSF005454
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:17:28 -0400
Date: Thu, 24 Apr 2008 15:17:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080424151702.42cde05b@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates for 2.6.26
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

For the following:

   - several improvements at core, especially at hybrid tuner support;
   - new DVB/ATSC frontends: au8522, isl6405, itd1000, s5h1420, tda10048;
   - new video drivers: saa717x;
   - analog support for cx23885;
   - new camera drivers: soc_camera, pxa_camera, saa717x, mt9m001, mt9v022;
   - new DVB drivers: au0828, em28xx-dvb, pvrusb2-dvb;
   - several lock fixes on videobuf;
   - em28xx were converted to use videobuf;
   - videobuf-dma-sg now uses the generic DMA support, instead of the PCI one;
   - add support for lots of boards based on xc2028/3028, on several
     bridge drivers;
   - several CodingStyle and other cleanups;
   - several fixes;
   - several new board additions and improved support on existing drivers.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.au0828          |    4 +
 Documentation/video4linux/CARDLIST.bttv            |    2 +
 Documentation/video4linux/CARDLIST.cx23885         |    3 +
 Documentation/video4linux/CARDLIST.cx88            |    9 +
 Documentation/video4linux/CARDLIST.saa7134         |   13 +-
 Documentation/video4linux/extract_xc3028.pl        |   46 +-
 drivers/media/Kconfig                              |   11 +-
 drivers/media/common/ir-functions.c                |    2 +-
 drivers/media/common/ir-keymaps.c                  |  172 ++-
 drivers/media/common/saa7146_core.c                |    8 +-
 drivers/media/common/saa7146_i2c.c                 |    6 +-
 drivers/media/common/saa7146_vbi.c                 |    4 +-
 drivers/media/common/saa7146_video.c               |    4 +-
 drivers/media/dvb/b2c2/Kconfig                     |    5 +
 drivers/media/dvb/b2c2/Makefile                    |    2 +
 drivers/media/dvb/b2c2/flexcop-common.h            |   17 +-
 drivers/media/dvb/b2c2/flexcop-dma.c               |    4 +-
 drivers/media/dvb/b2c2/flexcop-eeprom.c            |    9 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c          |  211 ++-
 drivers/media/dvb/b2c2/flexcop-i2c.c               |  180 ++-
 drivers/media/dvb/b2c2/flexcop-misc.c              |    2 +
 drivers/media/dvb/b2c2/flexcop-pci.c               |    2 +-
 drivers/media/dvb/b2c2/flexcop-reg.h               |    2 +
 drivers/media/dvb/b2c2/flexcop-sram.c              |   28 +-
 drivers/media/dvb/b2c2/flexcop-usb.c               |   17 +-
 drivers/media/dvb/b2c2/flexcop.c                   |   18 +-
 drivers/media/dvb/bt8xx/Kconfig                    |    2 +-
 drivers/media/dvb/bt8xx/Makefile                   |    5 +-
 drivers/media/dvb/bt8xx/dst.c                      |    2 +-
 drivers/media/dvb/bt8xx/dst_ca.c                   |   10 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |   23 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.h                |    2 +-
 drivers/media/dvb/cinergyT2/cinergyT2.c            |    9 +-
 drivers/media/dvb/dvb-core/demux.h                 |    2 +
 drivers/media/dvb/dvb-core/dmxdev.c                |   87 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |   36 +-
 drivers/media/dvb/dvb-core/dvb_demux.c             |    6 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |   30 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |   32 +-
 drivers/media/dvb/dvb-core/dvb_ringbuffer.c        |    6 +-
 drivers/media/dvb/dvb-core/dvb_ringbuffer.h        |    8 +
 drivers/media/dvb/dvb-core/dvbdev.c                |   47 +-
 drivers/media/dvb/dvb-core/dvbdev.h                |   13 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    1 +
 drivers/media/dvb/dvb-usb/a800.c                   |    6 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |    5 +-
 drivers/media/dvb/dvb-usb/au6610.c                 |    6 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |   51 +-
 drivers/media/dvb/dvb-usb/dib0700.h                |    4 +
 drivers/media/dvb/dvb-usb/dib0700_core.c           |    9 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  325 ++++-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |   14 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c              |    5 +-
 drivers/media/dvb/dvb-usb/digitv.c                 |    8 +-
 drivers/media/dvb/dvb-usb/dtt200u.c                |   17 +-
 drivers/media/dvb/dvb-usb/dvb-usb-common.h         |    3 +-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c            |    9 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |   13 +-
 drivers/media/dvb/dvb-usb/dvb-usb-init.c           |   16 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    5 +-
 drivers/media/dvb/dvb-usb/gl861.c                  |    6 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c              |    4 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                 |    5 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |   34 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c            |    5 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |    8 +-
 drivers/media/dvb/dvb-usb/ttusb2.c                 |   67 +-
 drivers/media/dvb/dvb-usb/umt-010.c                |    5 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c              |   18 +-
 drivers/media/dvb/dvb-usb/vp702x.c                 |    5 +-
 drivers/media/dvb/dvb-usb/vp7045.c                 |    6 +-
 drivers/media/dvb/frontends/Kconfig                |   28 +
 drivers/media/dvb/frontends/Makefile               |    4 +
 drivers/media/dvb/frontends/au8522.c               |  692 ++++++++
 drivers/media/dvb/frontends/au8522.h               |   56 +
 drivers/media/dvb/frontends/bcm3510.c              |    4 +-
 drivers/media/dvb/frontends/bcm3510.h              |    2 +-
 drivers/media/dvb/frontends/bsbe1.h                |   58 +-
 drivers/media/dvb/frontends/bsru6.h                |    2 +-
 drivers/media/dvb/frontends/cx22700.c              |   12 +-
 drivers/media/dvb/frontends/cx22700.h              |    2 +-
 drivers/media/dvb/frontends/cx22702.c              |   26 +-
 drivers/media/dvb/frontends/cx22702.h              |    2 +-
 drivers/media/dvb/frontends/cx24110.c              |    6 +-
 drivers/media/dvb/frontends/cx24110.h              |    2 +-
 drivers/media/dvb/frontends/cx24113.h              |   48 +
 drivers/media/dvb/frontends/cx24123.c              |  304 +++--
 drivers/media/dvb/frontends/cx24123.h              |   21 +-
 drivers/media/dvb/frontends/dib3000.h              |    2 +-
 drivers/media/dvb/frontends/dib3000mc.h            |    2 +-
 drivers/media/dvb/frontends/dib7000p.c             |    8 +-
 drivers/media/dvb/frontends/dib7000p.h             |    2 +
 drivers/media/dvb/frontends/dvb-pll.c              |  260 +---
 drivers/media/dvb/frontends/dvb-pll.h              |   33 +-
 drivers/media/dvb/frontends/isl6405.c              |  164 ++
 drivers/media/dvb/frontends/isl6405.h              |   74 +
 drivers/media/dvb/frontends/isl6421.h              |    2 +-
 drivers/media/dvb/frontends/itd1000.c              |  400 +++++
 drivers/media/dvb/frontends/itd1000.h              |   42 +
 drivers/media/dvb/frontends/itd1000_priv.h         |   88 +
 drivers/media/dvb/frontends/l64781.c               |    2 +-
 drivers/media/dvb/frontends/l64781.h               |    2 +-
 drivers/media/dvb/frontends/lgdt330x.c             |   40 +-
 drivers/media/dvb/frontends/lgdt330x.h             |    2 +-
 drivers/media/dvb/frontends/lnbp21.h               |    2 +-
 drivers/media/dvb/frontends/mt2060.h               |    2 +-
 drivers/media/dvb/frontends/mt2131.c               |   14 +-
 drivers/media/dvb/frontends/mt2131.h               |    2 +-
 drivers/media/dvb/frontends/mt2266.h               |    2 +-
 drivers/media/dvb/frontends/mt312.c                |  151 ++-
 drivers/media/dvb/frontends/mt312.h                |    5 +-
 drivers/media/dvb/frontends/mt312_priv.h           |    5 +-
 drivers/media/dvb/frontends/mt352.c                |    8 +-
 drivers/media/dvb/frontends/mt352.h                |    2 +-
 drivers/media/dvb/frontends/nxt200x.c              |   26 +-
 drivers/media/dvb/frontends/nxt200x.h              |    2 +-
 drivers/media/dvb/frontends/nxt6000.c              |    2 +-
 drivers/media/dvb/frontends/nxt6000.h              |    2 +-
 drivers/media/dvb/frontends/or51132.c              |    6 +-
 drivers/media/dvb/frontends/or51132.h              |    2 +-
 drivers/media/dvb/frontends/or51211.c              |    6 +-
 drivers/media/dvb/frontends/or51211.h              |    2 +-
 drivers/media/dvb/frontends/qt1010.h               |    2 +-
 drivers/media/dvb/frontends/s5h1409.c              |   50 +-
 drivers/media/dvb/frontends/s5h1409.h              |    2 +-
 drivers/media/dvb/frontends/s5h1420.c              |  523 ++++---
 drivers/media/dvb/frontends/s5h1420.h              |   64 +-
 drivers/media/dvb/frontends/s5h1420_priv.h         |  102 ++
 drivers/media/dvb/frontends/sp8870.c               |   38 +-
 drivers/media/dvb/frontends/sp8870.h               |    2 +-
 drivers/media/dvb/frontends/sp887x.c               |   18 +-
 drivers/media/dvb/frontends/sp887x.h               |    2 +-
 drivers/media/dvb/frontends/stv0297.c              |   14 +-
 drivers/media/dvb/frontends/stv0297.h              |    2 +-
 drivers/media/dvb/frontends/stv0299.c              |   85 +-
 drivers/media/dvb/frontends/stv0299.h              |   13 +-
 drivers/media/dvb/frontends/tda10021.c             |    4 +-
 drivers/media/dvb/frontends/tda10023.c             |    4 +-
 drivers/media/dvb/frontends/tda1002x.h             |    4 +-
 drivers/media/dvb/frontends/tda10048.c             |  841 ++++++++++
 drivers/media/dvb/frontends/tda10048.h             |   63 +
 drivers/media/dvb/frontends/tda1004x.c             |   56 +-
 drivers/media/dvb/frontends/tda1004x.h             |    5 +-
 drivers/media/dvb/frontends/tda10086.c             |  147 +-
 drivers/media/dvb/frontends/tda10086.h             |   14 +-
 drivers/media/dvb/frontends/tda18271-common.c      |   57 +-
 drivers/media/dvb/frontends/tda18271-fe.c          |  418 ++---
 drivers/media/dvb/frontends/tda18271-priv.h        |   18 +-
 drivers/media/dvb/frontends/tda18271-tables.c      |   84 +-
 drivers/media/dvb/frontends/tda18271.h             |   25 +-
 drivers/media/dvb/frontends/tda8083.c              |    4 +-
 drivers/media/dvb/frontends/tda8083.h              |    2 +-
 drivers/media/dvb/frontends/tda826x.c              |   25 +-
 drivers/media/dvb/frontends/tda826x.h              |    2 +-
 drivers/media/dvb/frontends/tda827x.c              |  167 +-
 drivers/media/dvb/frontends/tda827x.h              |    6 +-
 drivers/media/dvb/frontends/tua6100.c              |    2 +-
 drivers/media/dvb/frontends/tua6100.h              |    2 +-
 drivers/media/dvb/frontends/ves1820.c              |    4 +-
 drivers/media/dvb/frontends/ves1820.h              |    2 +-
 drivers/media/dvb/frontends/ves1x93.c              |    8 +-
 drivers/media/dvb/frontends/ves1x93.h              |    2 +-
 drivers/media/dvb/frontends/xc5000.c               |   46 +-
 drivers/media/dvb/frontends/xc5000.h               |    2 +-
 drivers/media/dvb/frontends/zl10353.c              |    8 +-
 drivers/media/dvb/frontends/zl10353.h              |    2 +-
 drivers/media/dvb/pluto2/pluto2.c                  |    5 +-
 drivers/media/dvb/ttpci/av7110.c                   |   16 +-
 drivers/media/dvb/ttpci/av7110.h                   |    2 +-
 drivers/media/dvb/ttpci/av7110_hw.c                |   42 +-
 drivers/media/dvb/ttpci/av7110_ir.c                |    6 +-
 drivers/media/dvb/ttpci/av7110_v4l.c               |    4 +-
 drivers/media/dvb/ttpci/budget-av.c                |   16 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    6 +-
 drivers/media/dvb/ttpci/budget-core.c              |    9 +-
 drivers/media/dvb/ttpci/budget.c                   |  111 ++-
 drivers/media/dvb/ttpci/budget.h                   |    3 +-
 drivers/media/dvb/ttpci/ttpci-eeprom.c             |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |   58 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c            |  112 +-
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c           |    4 +-
 drivers/media/radio/dsbr100.c                      |    2 +
 drivers/media/radio/miropcm20-radio.c              |    2 +
 drivers/media/radio/miropcm20-rds.c                |    2 +-
 drivers/media/radio/radio-aimslab.c                |    2 +
 drivers/media/radio/radio-aztech.c                 |    2 +
 drivers/media/radio/radio-cadet.c                  |   12 +-
 drivers/media/radio/radio-gemtek-pci.c             |    2 +
 drivers/media/radio/radio-gemtek.c                 |    2 +
 drivers/media/radio/radio-maestro.c                |    2 +
 drivers/media/radio/radio-maxiradio.c              |    2 +
 drivers/media/radio/radio-rtrack2.c                |    2 +
 drivers/media/radio/radio-sf16fmi.c                |    2 +
 drivers/media/radio/radio-sf16fmr2.c               |  104 +-
 drivers/media/radio/radio-si470x.c                 |   59 +-
 drivers/media/radio/radio-terratec.c               |    2 +
 drivers/media/radio/radio-trust.c                  |    2 +
 drivers/media/radio/radio-typhoon.c                |   44 +-
 drivers/media/radio/radio-zoltrix.c                |    2 +
 drivers/media/video/Kconfig                        |   56 +
 drivers/media/video/Makefile                       |   12 +-
 drivers/media/video/adv7170.c                      |    2 +-
 drivers/media/video/adv7175.c                      |    2 +-
 drivers/media/video/arv.c                          |    6 +-
 drivers/media/video/au0828/Kconfig                 |   12 +
 drivers/media/video/au0828/Makefile                |    9 +
 drivers/media/video/au0828/au0828-cards.c          |  182 ++
 drivers/media/video/au0828/au0828-cards.h          |   25 +
 drivers/media/video/au0828/au0828-core.c           |  270 +++
 drivers/media/video/au0828/au0828-dvb.c            |  373 +++++
 drivers/media/video/au0828/au0828-i2c.c            |  385 +++++
 drivers/media/video/au0828/au0828-reg.h            |   38 +
 drivers/media/video/au0828/au0828.h                |  128 ++
 drivers/media/video/bt819.c                        |    2 +-
 drivers/media/video/bt856.c                        |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c             |   55 +-
 drivers/media/video/bt8xx/bttv-driver.c            |   36 +-
 drivers/media/video/bt8xx/bttv-input.c             |    6 +
 drivers/media/video/bt8xx/bttv-vbi.c               |    2 +-
 drivers/media/video/bt8xx/bttv.h                   |    3 +
 drivers/media/video/bt8xx/bttvp.h                  |    1 -
 drivers/media/video/bw-qcam.c                      |    6 +-
 drivers/media/video/c-qcam.c                       |   13 +-
 drivers/media/video/cafe_ccic.c                    |    4 +-
 drivers/media/video/cpia.c                         |    2 +
 drivers/media/video/cpia.h                         |    4 +-
 drivers/media/video/cpia2/cpia2_core.c             |   16 +-
 drivers/media/video/cpia2/cpia2_usb.c              |    2 +-
 drivers/media/video/cpia2/cpia2_v4l.c              |    2 +
 drivers/media/video/cpia_usb.c                     |    2 +-
 drivers/media/video/cx23885/Kconfig                |    2 +
 drivers/media/video/cx23885/Makefile               |    2 +-
 drivers/media/video/cx23885/cx23885-417.c          | 1764 ++++++++++++++++++++
 drivers/media/video/cx23885/cx23885-cards.c        |  116 ++-
 drivers/media/video/cx23885/cx23885-core.c         |  310 +++-
 drivers/media/video/cx23885/cx23885-dvb.c          |  172 ++-
 drivers/media/video/cx23885/cx23885-i2c.c          |   46 +-
 drivers/media/video/cx23885/cx23885-video.c        |   58 +-
 drivers/media/video/cx23885/cx23885.h              |   27 +
 drivers/media/video/cx25840/cx25840-core.c         |   97 +-
 drivers/media/video/cx25840/cx25840-core.h         |    2 +-
 drivers/media/video/cx25840/cx25840-firmware.c     |   11 +-
 drivers/media/video/cx25840/cx25840-vbi.c          |    6 +-
 drivers/media/video/cx88/Kconfig                   |    1 +
 drivers/media/video/cx88/cx88-alsa.c               |   10 +-
 drivers/media/video/cx88/cx88-blackbird.c          |   18 +-
 drivers/media/video/cx88/cx88-cards.c              |  585 ++++++-
 drivers/media/video/cx88/cx88-core.c               |   17 +-
 drivers/media/video/cx88/cx88-dvb.c                |  260 +++-
 drivers/media/video/cx88/cx88-i2c.c                |    4 +-
 drivers/media/video/cx88/cx88-input.c              |   15 +-
 drivers/media/video/cx88/cx88-mpeg.c               |   20 +-
 drivers/media/video/cx88/cx88-tvaudio.c            |   30 +-
 drivers/media/video/cx88/cx88-vbi.c                |    2 +-
 drivers/media/video/cx88/cx88-video.c              |   63 +-
 drivers/media/video/cx88/cx88.h                    |   14 +-
 drivers/media/video/dabfirmware.h                  |    7 +
 drivers/media/video/dabusb.c                       |    8 +-
 drivers/media/video/dpc7146.c                      |    4 +-
 drivers/media/video/em28xx/Kconfig                 |   14 +-
 drivers/media/video/em28xx/Makefile                |    1 +
 drivers/media/video/em28xx/em28xx-audio.c          |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c          |  207 ++-
 drivers/media/video/em28xx/em28xx-core.c           |  776 ++++-----
 drivers/media/video/em28xx/em28xx-dvb.c            |  474 ++++++
 drivers/media/video/em28xx/em28xx-i2c.c            |  160 +-
 drivers/media/video/em28xx/em28xx-input.c          |   26 +-
 drivers/media/video/em28xx/em28xx-reg.h            |   88 +
 drivers/media/video/em28xx/em28xx-video.c          | 1078 ++++++------
 drivers/media/video/em28xx/em28xx.h                |  318 ++--
 drivers/media/video/et61x251/et61x251.h            |    6 +-
 drivers/media/video/et61x251/et61x251_core.c       |    4 +-
 drivers/media/video/hexium_gemini.c                |    4 +-
 drivers/media/video/hexium_orion.c                 |    4 +-
 drivers/media/video/ir-kbd-i2c.c                   |   28 +-
 drivers/media/video/ivtv/Kconfig                   |    1 +
 drivers/media/video/ivtv/ivtv-cards.c              |    7 +-
 drivers/media/video/ivtv/ivtv-cards.h              |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c             |   46 +-
 drivers/media/video/ivtv/ivtv-driver.h             |    2 +
 drivers/media/video/ivtv/ivtv-fileops.c            |    6 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |   12 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |   42 +-
 drivers/media/video/ivtv/ivtv-irq.c                |   25 +-
 drivers/media/video/ivtv/ivtv-mailbox.c            |   11 +-
 drivers/media/video/ivtv/ivtv-queue.c              |    4 +-
 drivers/media/video/ivtv/ivtv-streams.c            |    3 +-
 drivers/media/video/ivtv/ivtv-yuv.c                |   38 +-
 drivers/media/video/meye.c                         | 1361 ++++++++--------
 drivers/media/video/msp3400-driver.c               |    4 +-
 drivers/media/video/msp3400-kthreads.c             |   15 +-
 drivers/media/video/mt20xx.c                       |    7 +-
 drivers/media/video/mt20xx.h                       |    2 +-
 drivers/media/video/mt9m001.c                      |  722 ++++++++
 drivers/media/video/mt9v022.c                      |  844 ++++++++++
 drivers/media/video/mxb.c                          |    4 +-
 drivers/media/video/ov511.c                        |    4 +-
 drivers/media/video/ov511.h                        |    2 +-
 drivers/media/video/ovcamchip/ovcamchip_priv.h     |    4 +-
 drivers/media/video/pms.c                          |    6 +-
 drivers/media/video/pvrusb2/Kconfig                |   24 +
 drivers/media/video/pvrusb2/Makefile               |    6 +
 drivers/media/video/pvrusb2/pvrusb2-context.c      |  306 +++-
 drivers/media/video/pvrusb2/pvrusb2-context.h      |   16 +-
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |   19 +-
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c  |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-debug.h        |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c     |   24 +
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |  270 +++-
 drivers/media/video/pvrusb2/pvrusb2-devattr.h      |   72 +-
 drivers/media/video/pvrusb2/pvrusb2-dvb.c          |  425 +++++
 drivers/media/video/pvrusb2/pvrusb2-dvb.h          |   41 +
 drivers/media/video/pvrusb2/pvrusb2-encoder.c      |   19 +-
 drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h      |   43 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |   26 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |  903 ++++++++--
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |   39 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-io.c           |   30 +
 drivers/media/video/pvrusb2/pvrusb2-io.h           |   12 +
 drivers/media/video/pvrusb2/pvrusb2-main.c         |   16 +
 drivers/media/video/pvrusb2/pvrusb2-std.c          |    9 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   53 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |  195 ++-
 drivers/media/video/pwc/pwc-if.c                   |   16 +-
 drivers/media/video/pwc/pwc-v4l.c                  |    4 +-
 drivers/media/video/pxa_camera.c                   | 1206 +++++++++++++
 drivers/media/video/saa5249.c                      |    2 +
 drivers/media/video/saa6588.c                      |    8 +-
 drivers/media/video/saa7110.c                      |    2 +-
 drivers/media/video/saa7111.c                      |    2 +-
 drivers/media/video/saa7114.c                      |    2 +-
 drivers/media/video/saa7115.c                      |    4 +-
 drivers/media/video/saa711x.c                      |    2 +-
 drivers/media/video/saa7134/Kconfig                |    1 +
 drivers/media/video/saa7134/saa7134-alsa.c         |   12 +-
 drivers/media/video/saa7134/saa7134-cards.c        |  507 ++++++-
 drivers/media/video/saa7134/saa7134-core.c         |   52 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |  434 ++++--
 drivers/media/video/saa7134/saa7134-empress.c      |   10 +-
 drivers/media/video/saa7134/saa7134-i2c.c          |    6 +-
 drivers/media/video/saa7134/saa7134-input.c        |   19 +-
 drivers/media/video/saa7134/saa7134-reg.h          |    3 +
 drivers/media/video/saa7134/saa7134-ts.c           |    2 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c      |   21 +-
 drivers/media/video/saa7134/saa7134-vbi.c          |    2 +-
 drivers/media/video/saa7134/saa7134-video.c        |   17 +-
 drivers/media/video/saa7134/saa7134.h              |   22 +-
 drivers/media/video/saa717x.c                      | 1516 +++++++++++++++++
 drivers/media/video/saa7185.c                      |    2 +-
 drivers/media/video/se401.c                        |   12 +-
 drivers/media/video/sn9c102/sn9c102.h              |    6 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |   12 +-
 drivers/media/video/sn9c102/sn9c102_sensor.h       |    3 -
 drivers/media/video/soc_camera.c                   | 1031 ++++++++++++
 drivers/media/video/stk-webcam.c                   |    6 +-
 drivers/media/video/stradis.c                      |    6 +-
 drivers/media/video/stv680.c                       |   13 +-
 drivers/media/video/tcm825x.c                      |    2 +-
 drivers/media/video/tda8290.c                      |   18 +-
 drivers/media/video/tda8290.h                      |    6 +-
 drivers/media/video/tda9840.c                      |    4 +-
 drivers/media/video/tda9887.c                      |   42 +-
 drivers/media/video/tda9887.h                      |    2 +-
 drivers/media/video/tea5761.c                      |   22 +-
 drivers/media/video/tea5761.h                      |    4 +-
 drivers/media/video/tea5767.c                      |   39 +-
 drivers/media/video/tea5767.h                      |    4 +-
 drivers/media/video/tea6415c.c                     |    4 +-
 drivers/media/video/tea6420.c                      |    4 +-
 drivers/media/video/tuner-core.c                   |   55 +-
 drivers/media/video/tuner-i2c.h                    |  118 ++-
 drivers/media/video/tuner-simple.c                 |  861 ++++++++---
 drivers/media/video/tuner-simple.h                 |   13 +-
 drivers/media/video/tuner-types.c                  |  188 ++-
 drivers/media/video/tuner-xc2028-types.h           |   23 +-
 drivers/media/video/tuner-xc2028.c                 |  165 +-
 drivers/media/video/tuner-xc2028.h                 |    6 +-
 drivers/media/video/tvaudio.c                      |    8 +-
 drivers/media/video/tveeprom.c                     |  103 --
 drivers/media/video/tvp5150.c                      |    2 +-
 drivers/media/video/usbvideo/ibmcam.c              |   64 +-
 drivers/media/video/usbvideo/konicawc.c            |    4 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |    4 +-
 drivers/media/video/usbvideo/ultracam.c            |    4 +-
 drivers/media/video/usbvideo/usbvideo.c            |  148 +-
 drivers/media/video/usbvideo/vicam.c               |    4 +-
 drivers/media/video/usbvision/usbvision-core.c     |   45 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |    8 +-
 drivers/media/video/usbvision/usbvision-video.c    |   46 +-
 drivers/media/video/v4l1-compat.c                  | 1735 +++++++++++---------
 drivers/media/video/videobuf-core.c                |  209 ++-
 drivers/media/video/videobuf-dma-sg.c              |  156 +-
 drivers/media/video/videobuf-dvb.c                 |   18 +-
 drivers/media/video/videobuf-vmalloc.c             |  211 ++-
 drivers/media/video/videocodec.c                   |  115 +--
 drivers/media/video/videodev.c                     |   74 +-
 drivers/media/video/vino.c                         |   10 +-
 drivers/media/video/vivi.c                         |  350 ++---
 drivers/media/video/vpx3220.c                      |    2 +-
 drivers/media/video/w9966.c                        |    8 +-
 drivers/media/video/w9968cf.c                      |    4 +-
 drivers/media/video/w9968cf.h                      |    6 +-
 drivers/media/video/zc0301/zc0301.h                |    6 +-
 drivers/media/video/zc0301/zc0301_core.c           |    4 +-
 drivers/media/video/zoran.h                        |   16 -
 drivers/media/video/zoran_card.c                   |    6 +-
 drivers/media/video/zoran_card.h                   |    2 +
 drivers/media/video/zoran_device.c                 |   12 +-
 drivers/media/video/zoran_driver.c                 |   26 +-
 drivers/media/video/zr36016.c                      |    5 +-
 drivers/media/video/zr36050.c                      |    5 +-
 drivers/media/video/zr36060.c                      |    6 +-
 drivers/media/video/zr364xx.c                      |    4 +-
 include/linux/dvb/dmx.h                            |    3 +-
 include/linux/i2c-id.h                             |    1 +
 include/linux/meye.h                               |    2 +-
 include/linux/videodev2.h                          |   55 +-
 include/media/ir-common.h                          |    3 +
 include/media/soc_camera.h                         |  179 ++
 include/media/tuner-types.h                        |   17 +-
 include/media/tuner.h                              |    2 +-
 include/media/v4l2-chip-ident.h                    |    6 +
 include/media/v4l2-dev.h                           |    4 +
 include/media/videobuf-core.h                      |   24 +-
 include/media/videobuf-dma-sg.h                    |   17 +-
 include/media/videobuf-dvb.h                       |    3 +-
 include/media/videobuf-vmalloc.h                   |    4 +
 428 files changed, 25132 insertions(+), 7388 deletions(-)
 create mode 100644 Documentation/video4linux/CARDLIST.au0828
 create mode 100644 drivers/media/dvb/frontends/au8522.c
 create mode 100644 drivers/media/dvb/frontends/au8522.h
 create mode 100644 drivers/media/dvb/frontends/cx24113.h
 create mode 100644 drivers/media/dvb/frontends/isl6405.c
 create mode 100644 drivers/media/dvb/frontends/isl6405.h
 create mode 100644 drivers/media/dvb/frontends/itd1000.c
 create mode 100644 drivers/media/dvb/frontends/itd1000.h
 create mode 100644 drivers/media/dvb/frontends/itd1000_priv.h
 create mode 100644 drivers/media/dvb/frontends/s5h1420_priv.h
 create mode 100644 drivers/media/dvb/frontends/tda10048.c
 create mode 100644 drivers/media/dvb/frontends/tda10048.h
 create mode 100644 drivers/media/video/au0828/Kconfig
 create mode 100644 drivers/media/video/au0828/Makefile
 create mode 100644 drivers/media/video/au0828/au0828-cards.c
 create mode 100644 drivers/media/video/au0828/au0828-cards.h
 create mode 100644 drivers/media/video/au0828/au0828-core.c
 create mode 100644 drivers/media/video/au0828/au0828-dvb.c
 create mode 100644 drivers/media/video/au0828/au0828-i2c.c
 create mode 100644 drivers/media/video/au0828/au0828-reg.h
 create mode 100644 drivers/media/video/au0828/au0828.h
 create mode 100644 drivers/media/video/cx23885/cx23885-417.c
 create mode 100644 drivers/media/video/em28xx/em28xx-dvb.c
 create mode 100644 drivers/media/video/em28xx/em28xx-reg.h
 create mode 100644 drivers/media/video/mt9m001.c
 create mode 100644 drivers/media/video/mt9v022.c
 create mode 100644 drivers/media/video/pvrusb2/pvrusb2-dvb.c
 create mode 100644 drivers/media/video/pvrusb2/pvrusb2-dvb.h
 create mode 100644 drivers/media/video/pxa_camera.c
 create mode 100644 drivers/media/video/saa717x.c
 create mode 100644 drivers/media/video/soc_camera.c
 create mode 100644 include/media/soc_camera.h

Adrian Bunk (7):
      V4L/DVB (7105): ivtv-yuv.c: make 3 functions static
      V4L/DVB (7107): frontends/xc5000.c: make a struct static
      V4L/DVB (7114): tuner-xc2028.c: make a function static
      V4L/DVB (7238): make stk_camera_{suspend,resume}() static
      V4L/DVB (7479): proper prototype for zoran_device.c:zr36016_write()
      V4L/DVB (7480): make sn9c102_i2c_try_write() static
      V4L/DVB (7716): pvrusb2: clean up global functions

Aidan Thornton (7):
      V4L/DVB (7541): em28xx: Some fixes to videobuf
      V4L/DVB (7548): Various fixes for the em28xx videobuf code
      V4L/DVB (7556): em28xx: fix locking on vidioc_s_fmt_cap
      V4L/DVB (7565): em28xx: fix buffer underrun handling
      V4L/DVB (7601): em28xx-dvb: add support for the HVR-900
      V4L/DVB (7602): em28xx: generalise URB setup code
      V4L/DVB (7603): em28xx-dvb: don't use videobuf-dvb

Alan Cox (1):
      V4L/DVB (7729): Fix VIDIOCGAP corruption in ivtv

Alan McIvor (1):
      V4L/DVB (7394): saa7134: add number of devices check

Albert Comerma (1):
      V4L/DVB (7473): PATCH for various Dibcom based devices

Alexander Simon (1):
      V4L/DVB (7475): Added support for Terratec Cinergy T USB XXS

Alexey Dobriyan (2):
      V4L/DVB (7580): Fix concurrent read from /proc/videocodecs
      V4L/DVB (7582): proc: switch /proc/driver/radio-typhoon to seq_file interface

Andre Weidemann (1):
      V4L/DVB (7472):  reworked patch to support TT connect S-2400

Andrea Odetti (2):
      V4L/DVB (7658): dvb-core: Fix DMX_SET_BUFFER_SIZE in case the buffer shrinks
      V4L/DVB (7659): dvb-core: Implement DMX_SET_BUFFER_SIZE for dvr

Andreas Oberritter (1):
      V4L/DVB (7329): add flag to allow software demux to recognize the output type

Andrew Morton (4):
      V4L/DVB (7335): usb-video: checkpatch fixes
      V4L/DVB (7369): drivers/media/video/soc_camera.c: reads return size_t
      V4L/DVB (7389): git-dvb: drivers/media/video/bt8xx/bttv-cards.c: fix warnings
      V4L/DVB (7650): git-dvb: Kconfig fix

Brandon Philips (13):
      V4L/DVB (7166): [v4l] Add new user class controls and deprecate others
      V4L/DVB (7167): [v4l] Add camera class control definitions
      V4L/DVB (7204): remove V4L2_CID_SHARPNESS from meye.h and report private control as DISABLED
      V4L/DVB (7281): v4l: Deadlock in videobuf-core for DQBUF waiting on QBUF
      V4L/DVB (7487): videobuf: Wakeup queues after changing the state to ERROR
      V4L/DVB (7488): videobuf: Simplify videobuf_waiton logic and possibly avoid missed wakeup
      V4L/DVB (7489): videobuf-vmalloc.c: Remove buf_release from videobuf_vm_close
      V4L/DVB (7491): vivi: make vivi openable only once
      V4L/DVB (7492): vivi: Simplify the vivi driver and avoid deadlocks
      V4L/DVB (7493): videobuf: Avoid deadlock with QBUF and bring up to spec for empty queue
      V4L/DVB (7494): videobuf-dma-sg.c: Avoid NULL dereference and add comment about backwards compatibility
      V4L/DVB (7550): em28xx: Fix a possible memory leak
      V4L/DVB (7562): videobuf: Require spinlocks for all videobuf users

Chris Pascoe (2):
      V4L/DVB (7258): Support DVB-T tuning on the DViCO FusionHDTV DVB-T Pro
      V4L/DVB (7259): FusionHDTV DVB-T Pro tuning problem fixes

Christoph Pfister (2):
      V4L/DVB (7530): budget-av: Fix support for certain cams
      V4L/DVB (7531): budget-av: Fix CI interface on (some) KNC1 DVBS cards

Darryl Green (1):
      V4L/DVB (7476): New USB ID for Leadtek DVB-T USB

David Hilvert (1):
      V4L/DVB (7589): ibmcam: improve support for the IBM PC Camera Pro

Devin Heitmueller (5):
      V4L/DVB (7598): em28xx: several fixes on gpio programming
      V4L/DVB (7608): em28xx-dvb: Some cleanups and fixes
      V4L/DVB (7609): em28xx-core: speed-up firmware load
      V4L/DVB (7652): em28xx: Drop the severity level of the "urb resubmit failed"
      V4L/DVB (7653): tuner-xc2028: drop the severity of version reporting

Dmitry Belimov (3):
      V4L/DVB (7675): tea5767 autodetection is not working on some saa7134 boards
      V4L/DVB (7676): saa7134: fix: Properly handle busy states on i2c bus
      V4L/DVB (7677): saa7134: Add/fix Beholder entries

Douglas Schilling Landgraf (7):
      V4L/DVB (7094):  static memory
      V4L/DVB (7283): videobuf-dma-sg: Remove unused variable
      V4L/DVB (7402):  add macro validation for v4l_compat_ioctl32
      V4L/DVB (7404): saa7134.h: Remove unnecessary validation
      V4L/DVB (7607): CodingStyle fixes
      V4L/DVB (7665): videodev: Add default vidioc handler
      V4L/DVB (7666): meye: Replace meye_do_ioctl to use video_ioctl2

DÃ¢niel Fraga (2):
      V4L/DVB (7505): Powercolor Real Angel 330 (fixes gpio references)
      V4L/DVB (7506): Powercolor Real Angel 330 (remote control support)

Ernesto HernÃ¡ndez-Novich (1):
      V4L/DVB (7366): Support for a 16-channel bt878 card

Frej Drejhammar (6):
      V4L/DVB (7450): v4l2-api: Define a standard control for chroma AGC
      V4L/DVB (7451): cx88: Add user control for chroma AGC
      V4L/DVB (7452): cx88: Enable chroma AGC by default for all non-SECAM modes
      V4L/DVB (7453): v4l2-api: Define a standard control for color killer functionality
      V4L/DVB (7454): cx88: Add user control for color killer
      V4L/DVB (7463): cx88: Enable color killer by default

Guennadi Liakhovetski (22):
      V4L/DVB (7169): Add chip IDs for Micron mt9m001 and mt9v022 CMOS cameras
      V4L/DVB (7170): soc_camera V4L2 driver for directly-connected SoC-based cameras
      V4L/DVB (7578a): V4L: V4L2 soc_camera driver for PXA270
      V4L/DVB (7173): Add support for the MT9M001 camera
      V4L/DVB (7174): Add support for the MT9V022 camera
      V4L/DVB (7196): Lift videobuf-dma-sg's PCI dependency, until it is fixed
      V4L/DVB (7217): Replace NO_GPIO with gpio_is_valid()
      V4L/DVB (7218): Fix breakage in mt9m001 and mt9v022 driver if "CONFIG_GENERIC_GPIO is not set"
      V4L/DVB (7237): Convert videobuf-dma-sg to generic DMA API
      V4L/DVB (7249): Fix advertised pixel formats in mt9m001 and mt9v022
      V4L/DVB (7250): Clean up pxa-camera driver, remove non-functional and never tested pm-support
      V4L/DVB (7276): soc-camera: deactivate cameras when not used
      V4L/DVB (7336): soc-camera: streamline hardware parameter negotiation
      V4L/DVB (7374): Fix left-overs from the videobuf-dma-sg.c conversion to generic DMA
      V4L/DVB (7376): Improve compile-time type-checking in videobuf
      V4L/DVB (7378): cleanup variable initialization
      V4L/DVB (7406): soc-camera: improve separation between soc_camera_ops and soc_camera_device
      V4L/DVB (7500): soc-camera: extract function pointers from host object into operations
      V4L/DVB (7501): soc-camera: use a spinlock for videobuffer queue
      V4L/DVB (7668): soc-camera: Remove redundant return
      V4L/DVB (7670): pxa-camera: handle FIFO overruns
      V4L/DVB (7671): pxa-camera: fix DMA sg-list coalescing for more than 2 buffers

Hans Verkuil (13):
      V4L/DVB (7240): tveeprom: remove obsolete i2c driver code
      V4L/DVB (7244): ivtv: CROP is not supported for video capture
      V4L/DVB (7245): ivtv: start timer for each DMA transfer
      V4L/DVB (7337): ivtv: fix polling bug
      V4L/DVB (7338): ivtv: improve pal/secam module options, add tunerhz module option
      V4L/DVB (7339): ivtv: add support for Japanese variant of the Adaptec AVC-2410
      V4L/DVB (7340): ivtv: fix tunerhz bug: PAL-N(c) is 50 Hz, not 60
      V4L/DVB (7341): ivtv: rename tunerhz to tunertype
      V4L/DVB (7342): saa7115: fix PAL-Nc handling
      V4L/DVB (7343): msp3400: fix SECAM D/K handling
      V4L/DVB (7344): cx25840: better PAL-M and NTSC-KR handling
      V4L/DVB (7534): ivtv: the upd* modules have to be probed to properly autodetect some cards
      V4L/DVB (7535): saa717x: add new audio/video decoder i2c driver

Hartmut Hackmann (13):
      V4L/DVB (7223): Add support for the ISL6405 dual LNB supply chip
      V4L/DVB (7224): Initial DVB-S support for MD8800 /CTX948
      V4L/DVB (7226): saa7134: add support for the NXP Snake DVB-S reference design
      V4L/DVB (7227): saa7134: fixed DVB-S support for Medion/Creatix CTX948
      V4L/DVB (7390): saa7134: clear audio DSP interface after access error
      V4L/DVB (7391): saa7134: Add DVB-S support for the MD 1734 cards with 2 saa7134
      V4L/DVB (7392): saa7134: support 2nd DVB-S section of the MD8800
      V4L/DVB (7393): tda827x: fixed support of tuners with LNA
      V4L/DVB (7395): saa7134: start 2nd LND supply of Medion cards only if needed
      V4L/DVB (7396): saa7134: fixed pointer in tuner callback
      V4L/DVB (7654): tda10086: make the xtal frequency a configuration option
      V4L/DVB (7655): tda10086 coding stlye fixes
      V4L/DVB (7656): tda826x: Calculate cut off fequency from symbol rate

Harvey Harrison (25):
      V4L/DVB (7273): suppress compound statement warning in dvb-bt8xx.c
      V4L/DVB (7274): dabusb: fix shadowed variable warning in dabusb.c
      V4L/DVB (7502): v4l: video/usbvision replace	remaining __FUNCTION__	occurrences
      V4L/DVB (7508): media/common/ replace remaining __FUNCTION__ occurrences
      V4L/DVB (7509): media/dvb/b2c2 replace remaining __FUNCTION__ occurrences
      V4L/DVB (7510): media/dvb/bt8xx replace remaining __FUNCTION__ occurrences
      V4L/DVB (7511): media/dvb/cinergyT2 replace remaining __FUNCTION__ occurrences
      V4L/DVB (7512): media/dvb/dvb-core replace remaining __FUNCTION__ occurrences
      V4L/DVB (7513): media/dvb/dvb-usb replace remaining __FUNCTION__ occurrences
      V4L/DVB (7514): media/dvb/frontends replace remaining __FUNCTION__ occurrences
      V4L/DVB (7515): media/dvb/ttpci replace remaining __FUNCTION__ occurrences
      V4L/DVB (7516): media/dvb/ttusb-budget replace remaining __FUNCTION__ occurrences
      V4L/DVB (7517): media/dvb/ttusb-dec replace remaining __FUNCTION__ occurrences
      V4L/DVB (7518): media/video/ replace remaining __FUNCTION__ occurrences
      V4L/DVB (7519): media/video/cpia2 replace remaining __FUNCTION__ occurrences
      V4L/DVB (7520): media/video/cx23885 replace remaining __FUNCTION__ occurrences
      V4L/DVB (7521): media/video/cx88 replace remaining __FUNCTION__ occurrences
      V4L/DVB (7522): media/video/em28xx replace remaining __FUNCTION__ occurrences
      V4L/DVB (7523): media/video/et61x251 replace remaining __FUNCTION__ occurrences
      V4L/DVB (7524): media/video/ovcamchip replace remaining __FUNCTION__ occurrences
      V4L/DVB (7525): media/video/pwc replace remaining __FUNCTION__ occurrences
      V4L/DVB (7526): media/video/saa7134 replace remaining __FUNCTION__ occurrences
      V4L/DVB (7527): media/video/sn9c102 replace remaining __FUNCTION__ occurrences
      V4L/DVB (7528): media/video/usbvideo replace remaining __FUNCTION__ occurrences
      V4L/DVB (7529): media/video/zc0301 replace remaining __FUNCTION__ occurrences

Hermann Pitton (1):
      V4L/DVB (7229): saa7134: add support for the Creatix CTX953_V.1.4.3 Hybrid

Ian Armstrong (1):
      V4L/DVB (7243): ivtv: yuv framebuffer tracking

Ivan Bobyr (1):
      V4L/DVB (7590): ir-common: Adds 3 missing IR keys for FlyVIdeo2000

Jan Engelhardt (1):
      V4L/DVB (7140): constify function pointer tables

Janne Grunau (1):
      V4L/DVB (7538): Adds selectable adapter numbers as per module option

Jean Delvare (1):
      V4L/DVB (7332): ir-kbd-i2c: Minor optimization in ir_probe

Julia Lawall (1):
      V4L/DVB (7591): drivers/media/video: use time_before, time_before_eq, etc

Kay Sievers (1):
      V4L/DVB (7641): V4L: ov511 - use usb_interface as parent, not usb_device

Marcin Slusarz (4):
      V4L/DVB (7286): limit stack usage of ir-kbd-i2c.c
      V4L/DVB (7363): fix coding style violations in v4l1-compat.c
      V4L/DVB (7364): reduce stack usage of v4l_compat_translate_ioctl
      V4L/DVB (7365): reduce stack usage of v4l1_compat_sync

Marton Balint (1):
      V4L/DVB (7449): cx88: fix oops on module removal caused by IR worker

Matthias Schwarzott (6):
      V4L/DVB (7507): saa7134: add analog support for Avermedia A700 cards
      V4L/DVB (7571): mt312: Cleanup buffer variables of read/write functions
      V4L/DVB (7572): mt312: Fix diseqc
      V4L/DVB (7573): mt312: Supports different xtal frequencies
      V4L/DVB (7574): mt312: Add support for zl10313 demod
      V4L/DVB (7575): mt312: add attach-time setting to invert lnb-voltage

Mauro Carvalho Chehab (81):
      V4L/DVB (7235): tuner-simple: fix a buffer overflow
      V4L/DVB (7256): cx88: Add support for tuner-xc3028
      V4L/DVB (7257): cx88: Add xc2028/3028 boards
      V4L/DVB (7260): tuner-xc3028: Don't check return code for clock reset
      V4L/DVB (7261): Use the same callback argument as xc3028 and xc5000
      V4L/DVB (7262): Add support for xc3028-based boards
      V4L/DVB (7263): Some cleanups at cx88 callback methods
      V4L/DVB (7264): cx88-cards: always use a level on printk messages
      V4L/DVB (7265): cx88: prints an info when xc2028 is set or is attached
      V4L/DVB (7266): cx88-dvb: convert attach_xc3028 into a function
      V4L/DVB (7269): cx88: Powercolor Angel works only with firmware version 2.5
      V4L/DVB (7270): cx88-dvb: Renames pci_nano callback
      V4L/DVB (7271): cx88-cards: Fix powerangel gpio1
      V4L/DVB (7325): cx88-dvb: fix an OOPS for xc3028 devices, when dvb_attach fails
      V4L/DVB (7326): Fix bad whitespaces
      V4L/DVB (7327): cx88: Fix memset for tuner-xc3028 control
      V4L/DVB (7370): Add basic support for Prolink Pixelview MPEG 8000GT
      V4L/DVB (7371): cx88: Fix audio on Prolink Pixelview Mpeg 8000GT
      V4L/DVB (7372): cx88: Add IR support for Pixelview MPEG 8000GT
      V4L/DVB (7375): cx88/saa7134: fix magic number for xc3028 reusage detection
      V4L/DVB (7377): radio-sf16fmr2.c: fix volume handling
      V4L/DVB (7387): saa7134: Fix xc3028 entries
      V4L/DVB (7388): saa7134: fix radio entry for xc2028/3028 boards
      V4L/DVB (7398): Adds an error if priv argument of tuner_callback is NULL
      V4L/DVB (7399): Removes video_dev from tuner-xc2028 config struct
      V4L/DVB (7439): tuner-xc2028: Adds an option to allow forcing to load an specific firmware name
      V4L/DVB (7448): Add support for Kworld ATSC 120
      V4L/DVB (7455): cx88_dvb: qam doesn't apply on Kword ATSC 120
      V4L/DVB (7456): vivi: Add 32bit compatibility to the module
      V4L/DVB (7458): saa7134: Adds analog support for Avermedia A16D
      V4L/DVB (7462): bttv: Fix some API non-compliances for some audio/input V4L2 calls
      V4L/DVB (7537): cx88/saa7134: Fix: avoid OOPS on module unload
      V4L/DVB (7540): em28xx: convert to use videobuf-vmalloc
      V4L/DVB (7542): em28xx: Fix some warnings
      V4L/DVB (7543): Fix capture start/stop and timeout
      V4L/DVB (7544): em28xx: Fix timeout code
      V4L/DVB (7545): em28xx: Fix CodingStyle errors and most warnings introduced by videobuf
      V4L/DVB (7547): em28xx: Fix a broken lock
      V4L/DVB (7549): em28xx: some small cleanups
      V4L/DVB (7551): vivi: Add a missing \n
      V4L/DVB (7552): videbuf-vmalloc: Corrects mmap code
      V4L/DVB (7553): videobuf-vmalloc: fix STREAMOFF/STREAMON
      V4L/DVB (7554): videobuf-dma-sg: Remove unused flag
      V4L/DVB (7555): em28xx: remove timeout
      V4L/DVB (7557): em28xx: honour video_debug modprobe parameter
      V4L/DVB (7558): videobuf: Improve command output for debug purposes
      V4L/DVB (7559): em28xx: Fills the entire buffer, before getting another one
      V4L/DVB (7560): videodev: Some printk fixes
      V4L/DVB (7561): videobuf-vmalloc: stop streaming before unmap
      V4L/DVB (7563): em28xx: Add missing checks
      V4L/DVB (7564): em28xx: Some fixes to display logic
      V4L/DVB (7566): videobuf-dvb: allow its usage with videobuf-vmalloc
      V4L/DVB (7567): em28xx: Some cleanups
      V4L/DVB (7575a): Revert changeset 4c3b01f71181a52ab7735a7c52b1aa2232826075
      V4L/DVB (7584): Fix build that occurs when CONFIG_VIDEO_PMS=y and VIDEO_V4L2_COMMON=m
      V4L/DVB (7593): em28xx: add a module to handle dvb
      V4L/DVB (7594): em28xx: Fix Kconfig
      V4L/DVB (7595): Improve generic support for setting gpio values
      V4L/DVB (7596): em28xx-dvb: Add support for HVR950
      V4L/DVB (7597): em28xx: share the same xc3028 setup for analog and digital modes
      V4L/DVB (7599): em28xx-dvb: videobuf callbacks are waiting for em28xx_fh
      V4L/DVB (7600): em28xx: Sets frequency when changing to analog mode
      V4L/DVB (7604): em28xx-dvb: Fix analog mode
      V4L/DVB (7605): tuner-xc3028: Avoids too much firmware reloads
      V4L/DVB (7606): em28xx-dvb: Program GPO as well
      V4L/DVB (7610): em28xx: Select reg wait time based on chip ID
      V4L/DVB (7611): em28xx: Move registers to a separate file
      V4L/DVB (7612): em28xx-cards: use register names for GPIO/GPO
      V4L/DVB (7613): em28xx: rename registers
      V4L/DVB (7614): em28xx-core: fix some debug printk's that wrongly received KERN_INFO
      V4L/DVB (7615): em28xx: Provide the proper support for switching between analog/digital
      V4L/DVB (7616): em28xx-dvb: Properly selects digital mode at the right place
      V4L/DVB (7617): Removes a manual mode setup
      V4L/DVB (7618): em28xx: make some symbols static
      V4L/DVB (7619): em28xx: adds proper demod IF for HVR-900
      V4L/DVB (7638): CodingStyle fixes for au8522 and au0828
      V4L/DVB (7639): au8522: fix a small bug introduced by Checkpatch cleanup
      V4L/DVB (7651): tuner-xc2028: Several fixes to SCODE
      V4L/DVB (7728): tea5761: bugzilla #10462: tea5761 autodetection code were broken
      V4L/DVB (7730): tuner-xc2028: Fix SCODE load for MTS firmwares
      V4L/DVB (7731): tuner-xc2028: fix signal strength calculus

Mauro Lacy (1):
      V4L/DVB (7368): bttv: added support for Kozumi KTV-01C card

Michael Krufky (94):
      V4L/DVB (7087): tuner-simple: whitespace / comments / codingstyle cleanups
      V4L/DVB (7123): tuner-simple: create separate t_params and ranges lookup functions
      V4L/DVB (7124): tuner-simple: display frequency in MHz
      V4L/DVB (7125): tuner: build tuner-types independently of tuner-core
      V4L/DVB (7126): tuner: move tuner type ID check to simple_tuner_attach
      V4L/DVB (7127): tuner: remove dependency of tuner-core on tuner-types
      V4L/DVB (7128): tuner: properly handle failed calls to simple_tuner_attach
      V4L/DVB (7129): tuner-simple: move device-specific code into three separate functions
      V4L/DVB (7130): tuner: remove emacs c-basic-offset override block
      V4L/DVB (7134): tuner: create a macro for sharing state between hybrid tuner instances
      V4L/DVB (7135): remove PREFIX from users of tuner_foo printk macros
      V4L/DVB (7136): tda18271: use hybrid_tuner_request_state to manage tuner instances
      V4L/DVB (7137): tuner: return number of instances remaining after hybrid_tuner_release_state
      V4L/DVB (7184): make hybrid_tuner_request_state tolerant of devices without i2c adapters
      V4L/DVB (7211): tda18271: remove duplicated channel configuration code from tda18271c1_tune
      V4L/DVB (7212): tda18271: move rf calibration code from tda18271c1_tune into a new function
      V4L/DVB (7213): tda18271: consolidate tune functions
      V4L/DVB (7214): tda18271: move init functions to directly above tda18271_tune
      V4L/DVB (7254): cx88: fix FusionHDTV 5 PCI nano name and enable IR support
      V4L/DVB (7288): cx88: fix GPIO for FusionHDTV 7 Gold input selection
      V4L/DVB (7289): cx88: enable IR receiver and real time clock on FusionHDTV7 Gold
      V4L/DVB (7304): pvrusb2: add function pvr2_hdw_cmd_powerdown
      V4L/DVB (7323): pvrusb2: set default video standard to NTSC for OnAir HDTV / Creator
      V4L/DVB (7346): tda9887: allow multiple driver instances for the same hardware to share state
      V4L/DVB (7347): tuner-simple: add basic support for digital tuning of hybrid devices
      V4L/DVB (7348): tuner-simple: do not send i2c commands if there is no i2c adapter
      V4L/DVB (7349): tuner-simple: enable digital tuning support for LG TDVS-H06xF
      V4L/DVB (7350): tuner-simple: enable digital tuning support for Thomson DTT 761X
      V4L/DVB (7351): tuner-simple: add init and sleep methods
      V4L/DVB (7352): tuner-simple: enable digital tuning support for Philips FMD1216ME
      V4L/DVB (7353): tuner-simple: enable digital tuning support for Philips TUV1236D
      V4L/DVB (7354): tuner-simple: enable digital tuning support for Philips FCV1236D
      V4L/DVB (7355): tuner-simple: use separate inputs for vsb and qam on tuv1236d & fcv1236d
      V4L/DVB (7356): tuner-simple: enable digital tuning support for Thomson DTT 7610
      V4L/DVB (7357): tuner-simple: enable digital tuning support for Microtune 4042 FI5
      V4L/DVB (7358): tuner-simple: enable digital tuning support for Philips TD1316
      V4L/DVB (7359): tuner-simple: enable digital tuning support for Thomson FE6600
      V4L/DVB (7360): tuner-simple: fix return value of simple_dvb_configure
      V4L/DVB (7379): tuner: prevent instance sharing if i2c adapter is NULL
      V4L/DVB (7380): tuner-simple: warn if tuner can't be probed during attach
      V4L/DVB (7381): tuner: rename TUNER_PHILIPS_ATSC to TUNER_PHILIPS_FCV1236D
      V4L/DVB (7383): tda18271: add attach-time parameter to limit i2c transfer size
      V4L/DVB (7384): tda18271: store FM_RFn setting in struct tda18271_std_map_item
      V4L/DVB (7385): tda18271: store agc_mode configuration independently of std_bits
      V4L/DVB (7407): tuner-simple: add module options to specify rf input
      V4L/DVB (7408): use tuner-simple for Thomson DTT 761X digital tuning support
      V4L/DVB (7409): use tuner-simple for Microtune 4042 FI5 digital tuning support
      V4L/DVB (7410): use tuner-simple for Thomson FE6600 digital tuning support
      V4L/DVB (7411): use tuner-simple for Philips FCV1236D digital tuning support
      V4L/DVB (7412): use tuner-simple for LG TDVS-H06xF digital tuning support
      V4L/DVB (7413): use tuner-simple for Philips FMD1216ME digital tuning support
      V4L/DVB (7414): use tuner-simple for Philips TD1316 digital tuning support
      V4L/DVB (7415): use tuner-simple for Philips TUV1236D digital tuning support
      V4L/DVB (7416): dvb-pll: remove support for Thomson dtt7610
      V4L/DVB (7417): dvb-pll: remove support for Thomson dtt761x
      V4L/DVB (7418): dvb-pll: remove support for Microtune 4042 FI5
      V4L/DVB (7419): dvb-pll: remove support for Thomson FE6600
      V4L/DVB (7420): dvb-pll: remove support for Philips FCV1236D
      V4L/DVB (7421): dvb-pll: remove support for LG TDVS-H06xF
      V4L/DVB (7422): dvb-pll: remove support for Philips FMD1216ME
      V4L/DVB (7423): dvb-pll: remove support for Philips TD1316
      V4L/DVB (7424): dvb-pll: remove support for Philips TUV1236D
      V4L/DVB (7425): dvb-pll: remove dead code
      V4L/DVB (7426): dvb-pll: renumber remaining description id's
      V4L/DVB (7427): dvb-pll: remove rf input module options
      V4L/DVB (7429): tda18271: write EP3 thru MD3 for image rejection low band initialization
      V4L/DVB (7430): tda18271: fix typo in tda18271_calibrate_rf
      V4L/DVB (7431): tda18271: allow device-specific configuration of IF level
      V4L/DVB (7432): tda18271: allow device-specific configuration of rf agc top
      V4L/DVB (7433): tda18271: fix comparison bug in tda18271_powerscan
      V4L/DVB (7434): tda18271: set rfagc modes during channel configuration
      V4L/DVB (7435): tda18271: add function tda18271_charge_pump_source
      V4L/DVB (7436): tda18271: add basic support for slave tuner configurations
      V4L/DVB (7437): tda18271: increment module version minor
      V4L/DVB (7440): dvb-bt8xx: fix build error
      V4L/DVB (7441): kconfig fixes for tuner-simple
      V4L/DVB (7481): tda18271: fix standard map debug
      V4L/DVB (7483): tuner-simple: fix broken build dependency
      V4L/DVB (7626): Kconfig: VIDEO_AU0828 should select DVB_AU8522 and DVB_TUNER_XC5000
      V4L/DVB (7627): au0828: replace __FUNCTION__ with __func__
      V4L/DVB (7628): au8522: codingstyle cleanups
      V4L/DVB (7629): au8522: replace __FUNCTION__ with __func__
      V4L/DVB (7630): au8522: fix au8522_read_ucblocks for qam
      V4L/DVB (7631): au8522: add function au8522_read_mse
      V4L/DVB (7633): au8522: consolidate mse2snr_lookup functions
      V4L/DVB (7679): pvrusb2: add DVB API framework
      V4L/DVB (7680): pvrusb2-dvb: add pvr2_dvb_bus_ctrl to allow frontends to negotiate bus access
      V4L/DVB (7681): pvrusb2-dvb: start working on streaming / buffer handling code
      V4L/DVB (7683): pvrusb2-dvb: set to DTV mode before attaching frontend
      V4L/DVB (7705): pvrusb2: Enable OnAir digital operation
      V4L/DVB (7706): pvrusb2: create a separate pvr2_device_desc structure for 751xx models
      V4L/DVB (7707): pvrusb2-dvb: add atsc/qam support for Hauppauge pvrusb2 model 750xx
      V4L/DVB (7717): pvrusb2-dvb: add DVB-T support for Hauppauge pvrusb2 model 73xxx
      V4L/DVB (7718): pvrusb2-dvb: update Kbuild selections

Mike Isely (63):
      V4L/DVB (7295): pvrusb2: add device attributes for fm radio and digital tuner
      V4L/DVB (7296): pvrusb2: Define device attributes for all input modes
      V4L/DVB (7297): pvrusb2: Dynamically control range of input selections
      V4L/DVB (7298): pvrusb2: Account for dtv choice (a bit) in v4l2 implementation
      V4L/DVB (7299): pvrusb2: Improve logic which handles input choice availability
      V4L/DVB (7300): pvrusb2: v4l2 implementation fixes for input selection
      V4L/DVB (7301): pvrusb2: Implement addition sysfs tracing
      V4L/DVB (7302): pvrusb2: Improve control validation for enumerations
      V4L/DVB (7303): pvrusb2: Ensure that default input selection is actually valid
      V4L/DVB (7305): pvrusb2: whitespace fixup
      V4L/DVB (7306): pvrusb2: Fix oops possible when claiming a NULL stream
      V4L/DVB (7307): pvrusb2: New functions for additional FX2 digital-related commands
      V4L/DVB (7308): pvrusb2: Define digital control scheme device attributes
      V4L/DVB (7309): pvrusb2: Enhance core logic to also control digital streaming
      V4L/DVB (7310): pvrusb2: trace print cosmetic cleanup / improvements
      V4L/DVB (7311): pvrusb2: Allow digital streaming without encoder firmware
      V4L/DVB (7312): pvrusb2: Indicate streaming status via LED
      V4L/DVB (7313): pvrusb2: Make LED control into a device-specific attribute
      V4L/DVB (7314): pvrusb2: Make device attribute structure more compact
      V4L/DVB (7315): pvrusb2: Add Gotview USB 2.0 DVD Deluxe to supported devices
      V4L/DVB (7316): pvrusb2: Handle ATSC video standard bits
      V4L/DVB (7317): pvrusb2: Increase buffer size for printing video standard strings
      V4L/DVB (7318): pvrusb2: Remove dead code
      V4L/DVB (7319): pvrusb2: Close potential race condition during initialization
      V4L/DVB (7320): pvrusb2: Eliminate timer race during tear-down
      V4L/DVB (7321): pvrusb2: Rework context handling and initialization
      V4L/DVB (7447): pvrusb2: Fix compilation warning
      V4L/DVB (7678): pvrusb2: Fix stupid string typo that has been reproducing wildly
      V4L/DVB (7682): pvrusb2-dvb: finish up stream & buffer handling
      V4L/DVB (7684): pvrusb2: Add VIDEO_PVRUSB2_DVB config variable
      V4L/DVB (7685): pvrusb2: Fix really bad typo if DVB config option description
      V4L/DVB (7686): pvrusb2: Fix broken debug interface build
      V4L/DVB (7687): pvrusb2: Fix oops in pvrusb2-dvb
      V4L/DVB (7688): pvrusb2: Clean up dvb streaming start/stop
      V4L/DVB (7689): pvrusb2-dvb: Rework module tear-down
      V4L/DVB (7690): pvrusb2-dvb: Remove digital_up flag
      V4L/DVB (7691): pvrusb2-dvb: Don't initialize if device lacks a digital side
      V4L/DVB (7692): pvrusb2-dvb: Further clean up dvb init/tear-down
      V4L/DVB (7693): pvrusb2-dvb: Change usage of 0 --> NULL
      V4L/DVB (7694): pvrusb2: Fix compilation goof when CONFIG_VIDEO_PVRUSB2_DVB is off
      V4L/DVB (7695): pvrusb2: Make associativity of == and && explicit (cosmetic)
      V4L/DVB (7696): pvrusb2: state control tweak
      V4L/DVB (7697): pvrusb2: Fix misleading bit of debug output (trivial)
      V4L/DVB (7698): pvrusb2: Remove never-reached break statements (trivial)
      V4L/DVB (7699): pvrusb2: Implement statistics for USB I/O performance / tracking
      V4L/DVB (7700): pvrusb2: Make FX2 command codes unsigned constants
      V4L/DVB (7701): pvrusb2: Centralize handling of simple FX2 commands
      V4L/DVB (7702): pvrusb2: Rework USB streaming start/stop execution
      V4L/DVB (7703): pvrusb2: Fix minor problem involving ARRAY_SIZE confusion
      V4L/DVB (7704): pvrusb2: Fix slop involving use of struct which might not be defined
      V4L/DVB (7708): pvrusb2-dvb: Fix stuck thread on streaming abort
      V4L/DVB (7709): pvrusb2: New device attribute for encoder usage in digital mode
      V4L/DVB (7710): pvrusb2: Implement critical digital streaming quirk for onair devices
      V4L/DVB (7711): pvrusb2: Fix race on module unload
      V4L/DVB (7712): pvrusb2: Close connect/disconnect race
      V4L/DVB (7713): pvrusb2: Implement cleaner DVB kernel thread shutdown
      V4L/DVB (7714): pvrusb2: Fix hang on module removal
      V4L/DVB (7715): pvrusb2: Clean out all use of __FUNCTION__
      V4L/DVB (7719): pvrusb2: Implement input selection enforcement
      V4L/DVB (7720): pvrusb2: Fix bad error code on cx23416 firmware load failure
      V4L/DVB (7721): pvrusb2: Restructure cx23416 firmware loading to have a common exit point
      V4L/DVB (7722): pvrusb2: Implement FM radio support for Gotview USB2.0 DVD 2
      V4L/DVB (7723): pvrusb2: Clean up input selection list generation in V4L interface

Mike Rapoport (1):
      V4L/DVB (7669): pxa_camera: Add support for YUV modes

Oliver Endriss (5):
      V4L/DVB (7532): budget: Add support for Fujitsu Siemens DVB-T Activy Budget
      V4L/DVB (7660): bsbe1: Use settings recommended by the manufacturer
      V4L/DVB (7661): stv0299: Add flag to turn off OP0 output
      V4L/DVB (7662): stv0299: Fixed some typos
      V4L/DVB (7663): budget: Support for Activy budget card with BSBE1 tuner

Patrick Boettcher (6):
      V4L/DVB (7469): Preparation for supporting new devices, cleanup and saneness
      V4L/DVB (7470): CX24123: preparing support for CX24113 tuner
      V4L/DVB (7474):  support key repeat with dib0700 ir receiver
      V4L/DVB (7568): Support for DVB-S demod PN1010 (clone of S5H1420) added
      V4L/DVB (7471): SkyStar2: preparing support for the rev2.8
      V4L/DVB (7569): Added support for SkyStar2 rev2.7 and ITD1000 DVB-S tuner

Peter Hartley (1):
      V4L/DVB (7293): DMX_OUT_TSDEMUX_TAP: record two streams from same mux, resend

Robert Fitzsimons (1):
      V4L/DVB (7579): bttv: Fix memory leak in radio_release

Roel Kluin (3):
      V4L/DVB (7220): drivers/media/video/sn9c102/sn9c102_core.c Fix Unlikely(x) == y
      V4L/DVB (7373): logical-bitwise & confusion in se401_init()
      V4L/DVB (7459): Test cmd, not definition in decoder_command(), drivers/media/video/zoran_device.c

Russell Kliese (1):
      V4L/DVB (7230): saa7134: add support for the MSI TV@nywhere A/D v1.1 card

Sascha Sommer (1):
      V4L/DVB (7331): Fix em2800 altsetting selection

Steven Toth (24):
      V4L/DVB (7252): cx88: Add support for the Dvico PCI Nano
      V4L/DVB (7287): cx88: add analog support for DVICO FusionHDTV7 Gold
      V4L/DVB (7620): Adding support for a new i2c bridge type
      V4L/DVB (7621): Add support for Hauppauge HVR950Q/HVR850/FusioHDTV7-USB
      V4L/DVB (7622): HVR950Q Hauppauge eeprom support
      V4L/DVB (7623): Scripts to maintain the CARDLIST file
      V4L/DVB (7624): Avoid an oops if the board is not fully defined
      V4L/DVB (7625): au0828: Cleanup
      V4L/DVB (7632): au8522: Added SNR support and basic cleanup
      V4L/DVB (7634): au0828: Cleanup
      V4L/DVB (7635): au8522: Cleanup
      V4L/DVB (7636): au0828: Add HVR850 model number
      V4L/DVB (7637): au0828: Typo
      V4L/DVB (7642): cx88: enable radio GPIO correctly
      V4L/DVB (7644): Adding support for the NXP TDA10048HN DVB OFDM demodulator
      V4L/DVB (7645): Add support for the Hauppauge HVR-1200
      V4L/DVB (7646): cx25840: Ensure GPIO2 is correctly set for cx23885/7/8 based products
      V4L/DVB (7647): Add support for the Hauppauge HVR-1700 digital mode
      V4L/DVB (7648): cx23885: Load any module dependencies accordingly
      V4L/DVB (7672): dib7000p: Add output mode param to the attach struct
      V4L/DVB (7673): cx23885: Add support for the Hauppauge HVR1400
      V4L/DVB (7674): tda10048: Adding an SNR table
      V4L/DVB (7725): cx23885: Add generic cx23417 hardware encoder support
      V4L/DVB (7726): cx23885: Enable cx23417 support on the HVR1800

Steven Whitehouse (1):
      V4L/DVB (7178): Add two new fourcc codes for 16bpp formats

Thierry MERLE (1):
      V4L/DVB (7503): usbvision: rename __PRETTY_FUNCTION__ occurrences

Tobias Klauser (1):
      V4L/DVB (7322): pvrusb2: Fix storage-class as per C99 spec

Tobias Lorenz (1):
      V4L/DVB (7401): radio-si470x: unplugging fixed

Tyler Trafford (1):
      V4L/DVB (7241): cx25840: code cleanup

Wojciech Migda (1):
      V4L/DVB (7294): : tuner and radio addresses are missing for the PixelView PlayTV card

maximilian attems (1):
      V4L/DVB (7248): dabfirmware.h add missing license

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
