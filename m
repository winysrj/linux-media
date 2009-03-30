Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56724 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZC3QLE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 12:11:04 -0400
Date: Mon, 30 Mar 2009 13:09:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.30] V4L/DVB improvements for 2.6.30
Message-ID: <20090330130916.49e92f3c@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

This is a huge series of 707 patches. The change numbers are quite impressive:
 489 files changed, 48502 insertions(+), 27346 deletions(-)

Most of the series are due to v4l2 device/subdevice internal KABI conversion.

Those changes were requred due to the removal of the currently used I2C binding
methods scheduled to happen on 2.6.30.

I would prefer to have this change happening slowly, since I'm a little afraid
that we'll have more regressions than usual, but, anyway, the conversion is
almost done. There are just a few patches still missing, currently under tests.
I expect to submit those patches later this week.

This patch also adds several new drivers, improves v4l core, do several 
cleanups, board additions and miscelaneous improvements.

The number of changes are so big [1] that I won't risk on summarizing and 
forget something important.

The details can be seen by the bellow.

Cheers,
Mauro.

[1] Just this email mostly with change stats has about 85 Kb!

---

 Documentation/dvb/get_dvb_firmware                 |   85 +-
 Documentation/feature-removal-schedule.txt         |    8 +-
 Documentation/ioctl/ioctl-number.txt               |    2 -
 Documentation/video4linux/CARDLIST.bttv            |    6 +-
 Documentation/video4linux/CARDLIST.cx23885         |    4 +
 Documentation/video4linux/CARDLIST.cx88            |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |    9 +-
 Documentation/video4linux/CARDLIST.saa7134         |    2 +
 Documentation/video4linux/Zoran                    |    3 +-
 Documentation/video4linux/bttv/Insmod-options      |   10 -
 Documentation/video4linux/bttv/README              |    4 +-
 Documentation/video4linux/cx2341x/README.hm12      |    4 +
 Documentation/video4linux/gspca.txt                |    4 +
 Documentation/video4linux/si470x.txt               |   11 +-
 Documentation/video4linux/v4l2-framework.txt       |  187 +-
 Documentation/video4linux/v4lgrab.c                |    4 +-
 Documentation/video4linux/zr364xx.txt              |    1 +
 MAINTAINERS                                        |    2 -
 arch/arm/mach-pxa/pcm990-baseboard.c               |   53 +-
 arch/arm/plat-mxc/include/mach/mx3_camera.h        |   52 +
 arch/sh/boards/board-ap325rxa.c                    |    3 +-
 arch/sh/boards/mach-migor/setup.c                  |    5 +-
 drivers/media/Kconfig                              |    2 +-
 drivers/media/common/ir-keymaps.c                  |  146 +
 drivers/media/common/saa7146_core.c                |   15 +-
 drivers/media/common/saa7146_fops.c                |   48 +-
 drivers/media/common/saa7146_i2c.c                 |   29 +-
 drivers/media/common/saa7146_video.c               | 1268 +++---
 drivers/media/common/tuners/Kconfig                |   64 +-
 drivers/media/common/tuners/Makefile               |    1 +
 drivers/media/common/tuners/mc44s803.c             |  371 ++
 drivers/media/common/tuners/mc44s803.h             |   46 +
 drivers/media/common/tuners/mc44s803_priv.h        |  208 +
 drivers/media/common/tuners/mt2060.c               |    2 +-
 drivers/media/common/tuners/mt20xx.c               |    2 +-
 drivers/media/common/tuners/mxl5005s.c             |    7 +-
 drivers/media/common/tuners/mxl5007t.c             |  428 +--
 drivers/media/common/tuners/tda18271-common.c      |    6 +-
 drivers/media/common/tuners/tda18271-fe.c          |   37 +
 drivers/media/common/tuners/tda18271-priv.h        |    6 +-
 drivers/media/common/tuners/tda18271.h             |   10 +
 drivers/media/common/tuners/tda827x.c              |  237 +-
 drivers/media/common/tuners/tda8290.c              |    9 +-
 drivers/media/common/tuners/tea5761.c              |    2 +-
 drivers/media/common/tuners/tea5767.c              |    2 +-
 drivers/media/common/tuners/xc5000.c               |   14 +-
 drivers/media/dvb/b2c2/Kconfig                     |    2 +-
 drivers/media/dvb/b2c2/Makefile                    |    1 -
 drivers/media/dvb/b2c2/flexcop-common.h            |   64 +-
 drivers/media/dvb/b2c2/flexcop-dma.c               |   27 +-
 drivers/media/dvb/b2c2/flexcop-eeprom.c            |   47 +-
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c          |    6 +-
 drivers/media/dvb/b2c2/flexcop-hw-filter.c         |  171 +-
 drivers/media/dvb/b2c2/flexcop-i2c.c               |   61 +-
 drivers/media/dvb/b2c2/flexcop-misc.c              |   68 +-
 drivers/media/dvb/b2c2/flexcop-pci.c               |  165 +-
 drivers/media/dvb/b2c2/flexcop-reg.h               |   21 +-
 drivers/media/dvb/b2c2/flexcop-sram.c              |  112 +-
 drivers/media/dvb/b2c2/flexcop-usb.c               |  368 +-
 drivers/media/dvb/b2c2/flexcop-usb.h               |   62 +-
 drivers/media/dvb/b2c2/flexcop.c                   |   86 +-
 drivers/media/dvb/b2c2/flexcop.h                   |   20 +-
 drivers/media/dvb/b2c2/flexcop_ibi_value_be.h      |    7 +-
 drivers/media/dvb/b2c2/flexcop_ibi_value_le.h      |    7 +-
 drivers/media/dvb/bt8xx/Kconfig                    |    2 +-
 drivers/media/dvb/bt8xx/dst_ca.c                   |   14 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    2 +-
 drivers/media/dvb/dm1105/Kconfig                   |    1 +
 drivers/media/dvb/dm1105/dm1105.c                  |  204 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |    2 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    2 +-
 drivers/media/dvb/dvb-core/dvbdev.c                |    4 +-
 drivers/media/dvb/dvb-core/dvbdev.h                |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |   67 +-
 drivers/media/dvb/dvb-usb/Makefile                 |    2 +
 drivers/media/dvb/dvb-usb/af9015.c                 |   60 +-
 drivers/media/dvb/dvb-usb/af9015.h                 |   31 +
 drivers/media/dvb/dvb-usb/ce6230.c                 |  328 ++
 drivers/media/dvb/dvb-usb/ce6230.h                 |   69 +
 drivers/media/dvb/dvb-usb/dib0700_core.c           |   10 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  164 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |   11 +
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    2 +-
 drivers/media/dvb/firewire/firedtv-avc.c           |    2 +-
 drivers/media/dvb/frontends/Kconfig                |   69 +-
 drivers/media/dvb/frontends/Makefile               |    6 +
 drivers/media/dvb/frontends/au8522.h               |   16 +
 drivers/media/dvb/frontends/au8522_decoder.c       |  835 ++++
 .../media/dvb/frontends/{au8522.c => au8522_dig.c} |   96 +-
 drivers/media/dvb/frontends/au8522_priv.h          |  412 ++
 drivers/media/dvb/frontends/cx24113.c              |    2 +-
 drivers/media/dvb/frontends/cx24116.c              |   63 +-
 drivers/media/dvb/frontends/cx24123.c              |    4 +-
 drivers/media/dvb/frontends/dib0070.h              |    2 -
 drivers/media/dvb/frontends/dib3000mc.h            |   36 +-
 drivers/media/dvb/frontends/dib7000m.h             |   28 +-
 drivers/media/dvb/frontends/dib7000p.h             |   35 +-
 drivers/media/dvb/frontends/dvb_dummy_fe.h         |   19 +
 drivers/media/dvb/frontends/itd1000_priv.h         |    2 +-
 drivers/media/dvb/frontends/lgdt3304.c             |    1 -
 drivers/media/dvb/frontends/lgdt3305.c             | 1087 +++++
 drivers/media/dvb/frontends/lgdt3305.h             |   85 +
 drivers/media/dvb/frontends/lnbh24.h               |   55 +
 drivers/media/dvb/frontends/lnbp21.c               |   41 +-
 drivers/media/dvb/frontends/lnbp21.h               |   34 +-
 drivers/media/dvb/frontends/s921_module.c          |    1 -
 drivers/media/dvb/frontends/stb6100_cfg.h          |    4 -
 drivers/media/dvb/frontends/stv0900.h              |   62 +
 drivers/media/dvb/frontends/stv0900_core.c         | 1949 +++++++++
 drivers/media/dvb/frontends/stv0900_init.h         |  441 ++
 drivers/media/dvb/frontends/stv0900_priv.h         |  430 ++
 drivers/media/dvb/frontends/stv0900_reg.h          | 3787 +++++++++++++++++
 drivers/media/dvb/frontends/stv0900_sw.c           | 2847 +++++++++++++
 drivers/media/dvb/frontends/stv6110.c              |  456 ++
 drivers/media/dvb/frontends/stv6110.h              |   62 +
 drivers/media/dvb/frontends/tda1004x.c             |   30 +-
 drivers/media/dvb/frontends/zl10036.c              |  519 +++
 drivers/media/dvb/frontends/zl10036.h              |   53 +
 drivers/media/dvb/frontends/zl10353.c              |    8 +-
 drivers/media/dvb/frontends/zl10353.h              |    4 +
 drivers/media/dvb/frontends/zl10353_priv.h         |    8 +-
 drivers/media/dvb/pluto2/pluto2.c                  |    7 +-
 drivers/media/dvb/siano/Makefile                   |    4 +-
 drivers/media/dvb/siano/sms-cards.c                |   92 +-
 drivers/media/dvb/siano/sms-cards.h                |    5 +-
 drivers/media/dvb/siano/smscoreapi.c               |   45 +-
 drivers/media/dvb/siano/smscoreapi.h               |   41 +-
 drivers/media/dvb/siano/smsdvb.c                   |   60 +-
 drivers/media/dvb/siano/smsusb.c                   |   73 +-
 drivers/media/dvb/ttpci/Kconfig                    |    2 +-
 drivers/media/dvb/ttpci/av7110.c                   |    2 +-
 drivers/media/dvb/ttpci/av7110_av.c                |    4 +-
 drivers/media/dvb/ttpci/av7110_ca.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_v4l.c               |  480 ++--
 drivers/media/dvb/ttpci/budget-av.c                |   88 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    6 +-
 drivers/media/radio/dsbr100.c                      |   10 +-
 drivers/media/radio/radio-aimslab.c                |  347 +-
 drivers/media/radio/radio-aztech.c                 |  378 +-
 drivers/media/radio/radio-cadet.c                  |  595 ++--
 drivers/media/radio/radio-gemtek-pci.c             |  329 +-
 drivers/media/radio/radio-gemtek.c                 |  396 +-
 drivers/media/radio/radio-maestro.c                |  337 +-
 drivers/media/radio/radio-maxiradio.c              |  374 +-
 drivers/media/radio/radio-mr800.c                  |  221 +-
 drivers/media/radio/radio-rtrack2.c                |  276 +-
 drivers/media/radio/radio-sf16fmi.c                |  283 +-
 drivers/media/radio/radio-sf16fmr2.c               |  371 +-
 drivers/media/radio/radio-si470x.c                 |  200 +-
 drivers/media/radio/radio-terratec.c               |  310 +-
 drivers/media/radio/radio-trust.c                  |  343 +-
 drivers/media/radio/radio-typhoon.c                |  349 +-
 drivers/media/radio/radio-zoltrix.c                |  378 +-
 drivers/media/video/Kconfig                        |   94 +-
 drivers/media/video/Makefile                       |   10 +-
 drivers/media/video/adv7170.c                      |  354 +-
 drivers/media/video/adv7175.c                      |  329 +-
 drivers/media/video/au0828/Kconfig                 |   10 +-
 drivers/media/video/au0828/Makefile                |    2 +-
 drivers/media/video/au0828/au0828-cards.c          |  127 +-
 drivers/media/video/au0828/au0828-core.c           |   34 +-
 drivers/media/video/au0828/au0828-dvb.c            |    2 +-
 drivers/media/video/au0828/au0828-i2c.c            |   72 +-
 drivers/media/video/au0828/au0828-reg.h            |    6 +
 drivers/media/video/au0828/au0828-video.c          | 1712 ++++++++
 drivers/media/video/au0828/au0828.h                |  181 +-
 drivers/media/video/bt819.c                        |  493 ++-
 drivers/media/video/bt856.c                        |  291 +-
 drivers/media/video/bt866.c                        |  282 +-
 drivers/media/video/bt8xx/Kconfig                  |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c             | 1672 ++++----
 drivers/media/video/bt8xx/bttv-driver.c            |  197 +-
 drivers/media/video/bt8xx/bttv-i2c.c               |   61 +-
 drivers/media/video/bt8xx/bttv-if.c                |   18 +-
 drivers/media/video/bt8xx/bttv-risc.c              |    4 +-
 drivers/media/video/bt8xx/bttv-vbi.c               |    2 +-
 drivers/media/video/bt8xx/bttv.h                   |   96 +-
 drivers/media/video/bt8xx/bttvp.h                  |   30 +-
 drivers/media/video/cafe_ccic.c                    |  432 +--
 drivers/media/video/cpia2/cpia2_v4l.c              |    1 +
 drivers/media/video/cs5345.c                       |    7 -
 drivers/media/video/cs53l32a.c                     |   12 +-
 drivers/media/video/cx18/Kconfig                   |    2 +-
 drivers/media/video/cx18/cx18-audio.c              |   52 +-
 drivers/media/video/cx18/cx18-audio.h              |    2 -
 drivers/media/video/cx18/cx18-av-audio.c           |  120 +-
 drivers/media/video/cx18/cx18-av-core.c            |  796 +++--
 drivers/media/video/cx18/cx18-av-core.h            |   49 +-
 drivers/media/video/cx18/cx18-av-firmware.c        |   16 +-
 drivers/media/video/cx18/cx18-av-vbi.c             |  367 +-
 drivers/media/video/cx18/cx18-cards.c              |   50 +-
 drivers/media/video/cx18/cx18-cards.h              |   18 +-
 drivers/media/video/cx18/cx18-controls.c           |   70 +-
 drivers/media/video/cx18/cx18-driver.c             |  416 +-
 drivers/media/video/cx18/cx18-driver.h             |  258 +-
 drivers/media/video/cx18/cx18-dvb.c                |    2 +-
 drivers/media/video/cx18/cx18-fileops.c            |  107 +-
 drivers/media/video/cx18/cx18-firmware.c           |   22 +-
 drivers/media/video/cx18/cx18-gpio.c               |  319 +-
 drivers/media/video/cx18/cx18-gpio.h               |   10 +-
 drivers/media/video/cx18/cx18-i2c.c                |  296 +-
 drivers/media/video/cx18/cx18-i2c.h                |    5 +-
 drivers/media/video/cx18/cx18-ioctl.c              |  273 +-
 drivers/media/video/cx18/cx18-mailbox.c            |   44 +-
 drivers/media/video/cx18/cx18-queue.c              |    4 +-
 drivers/media/video/cx18/cx18-queue.h              |    4 +-
 drivers/media/video/cx18/cx18-streams.c            |  210 +-
 drivers/media/video/cx18/cx18-vbi.c                |  155 +-
 drivers/media/video/cx18/cx18-vbi.h                |    2 +-
 drivers/media/video/cx18/cx18-version.h            |    4 +-
 drivers/media/video/cx18/cx18-video.c              |    3 +-
 drivers/media/video/cx18/cx23418.h                 |   16 +
 drivers/media/video/cx2341x.c                      |  196 +-
 drivers/media/video/cx23885/Kconfig                |   15 +-
 drivers/media/video/cx23885/Makefile               |    4 +-
 drivers/media/video/cx23885/cimax2.c               |  472 +++
 drivers/media/video/cx23885/cimax2.h               |   47 +
 drivers/media/video/cx23885/cx23885-417.c          |   49 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   94 +-
 drivers/media/video/cx23885/cx23885-core.c         |   43 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |  166 +-
 drivers/media/video/cx23885/cx23885-i2c.c          |   68 +-
 drivers/media/video/cx23885/cx23885-reg.h          |    2 +
 drivers/media/video/cx23885/cx23885-video.c        |   51 +-
 drivers/media/video/cx23885/cx23885.h              |   20 +-
 drivers/media/video/cx23885/netup-eeprom.c         |  107 +
 drivers/media/video/cx23885/netup-eeprom.h         |   42 +
 drivers/media/video/cx23885/netup-init.c           |  125 +
 drivers/media/video/cx23885/netup-init.h           |   25 +
 drivers/media/video/cx25840/cx25840-audio.c        |  121 +-
 drivers/media/video/cx25840/cx25840-core.c         |   65 +-
 drivers/media/video/cx25840/cx25840-core.h         |    8 +-
 drivers/media/video/cx25840/cx25840-vbi.c          |  314 +-
 drivers/media/video/cx88/Kconfig                   |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c          |    8 +-
 drivers/media/video/cx88/cx88-cards.c              |   99 +-
 drivers/media/video/cx88/cx88-core.c               |   11 +-
 drivers/media/video/cx88/cx88-dvb.c                |   18 +-
 drivers/media/video/cx88/cx88-i2c.c                |   41 +-
 drivers/media/video/cx88/cx88-input.c              |   29 +-
 drivers/media/video/cx88/cx88-video.c              |   52 +-
 drivers/media/video/cx88/cx88.h                    |   24 +-
 drivers/media/video/dabusb.c                       |   83 +-
 drivers/media/video/em28xx/em28xx-audio.c          |   77 +-
 drivers/media/video/em28xx/em28xx-cards.c          |  195 +-
 drivers/media/video/em28xx/em28xx-core.c           |   41 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |    3 -
 drivers/media/video/em28xx/em28xx-i2c.c            |   12 +-
 drivers/media/video/em28xx/em28xx-input.c          |   22 +-
 drivers/media/video/em28xx/em28xx-video.c          |   61 +-
 drivers/media/video/em28xx/em28xx.h                |   24 +-
 drivers/media/video/gspca/Kconfig                  |   27 +
 drivers/media/video/gspca/Makefile                 |  102 +-
 drivers/media/video/gspca/conex.c                  |   63 +-
 drivers/media/video/gspca/etoms.c                  |   36 +-
 drivers/media/video/gspca/finepix.c                |  433 +--
 drivers/media/video/gspca/gspca.c                  |  166 +-
 drivers/media/video/gspca/gspca.h                  |   14 +-
 drivers/media/video/gspca/jpeg.h                   |  263 +-
 drivers/media/video/gspca/m5602/m5602_core.c       |    7 +-
 drivers/media/video/gspca/mars.c                   |  506 ++-
 drivers/media/video/gspca/mr97310a.c               |  362 ++
 drivers/media/video/gspca/ov519.c                  |    7 +-
 drivers/media/video/gspca/ov534.c                  |  820 +++-
 drivers/media/video/gspca/pac207.c                 |    8 +-
 drivers/media/video/gspca/pac7311.c                |    7 +-
 drivers/media/video/gspca/sonixb.c                 |    7 +-
 drivers/media/video/gspca/sonixj.c                 |  951 ++++--
 drivers/media/video/gspca/spca500.c                |   99 +-
 drivers/media/video/gspca/spca501.c                |   22 +-
 drivers/media/video/gspca/spca505.c                |  525 ++--
 drivers/media/video/gspca/spca506.c                |   57 +-
 drivers/media/video/gspca/spca508.c                |  128 +-
 drivers/media/video/gspca/spca561.c                |  192 +-
 drivers/media/video/gspca/sq905.c                  |  456 ++
 drivers/media/video/gspca/sq905c.c                 |  328 ++
 drivers/media/video/gspca/stk014.c                 |   72 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |    7 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |   76 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |   65 -
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |  147 +-
 drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h |  130 +-
 drivers/media/video/gspca/stv06xx/stv06xx_sensor.h |    8 -
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |  123 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |   58 +-
 drivers/media/video/gspca/sunplus.c                |  124 +-
 drivers/media/video/gspca/t613.c                   |  564 ++--
 drivers/media/video/gspca/tv8532.c                 |  483 +--
 drivers/media/video/gspca/vc032x.c                 | 1591 ++++++--
 drivers/media/video/gspca/zc3xx.c                  |  884 +++--
 drivers/media/video/hdpvr/Kconfig                  |   10 +
 drivers/media/video/hdpvr/Makefile                 |    9 +
 drivers/media/video/hdpvr/hdpvr-control.c          |  201 +
 drivers/media/video/hdpvr/hdpvr-core.c             |  466 +++
 drivers/media/video/hdpvr/hdpvr-i2c.c              |  145 +
 drivers/media/video/hdpvr/hdpvr-video.c            | 1248 ++++++
 drivers/media/video/hdpvr/hdpvr.h                  |  303 ++
 drivers/media/video/hexium_gemini.c                |  292 +-
 drivers/media/video/hexium_orion.c                 |  103 +-
 drivers/media/video/indycam.c                      |  314 +-
 drivers/media/video/indycam.h                      |   19 +-
 drivers/media/video/ir-kbd-i2c.c                   |   84 +-
 drivers/media/video/ivtv/ivtv-controls.c           |    1 +
 drivers/media/video/ivtv/ivtv-driver.c             |   93 +-
 drivers/media/video/ivtv/ivtv-driver.h             |   26 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |   10 +-
 drivers/media/video/ivtv/ivtv-firmware.c           |    2 +-
 drivers/media/video/ivtv/ivtv-gpio.c               |    4 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |   14 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |   20 +-
 drivers/media/video/ivtv/ivtv-irq.c                |    4 +-
 drivers/media/video/ivtv/ivtv-queue.c              |    8 +-
 drivers/media/video/ivtv/ivtv-queue.h              |    8 +-
 drivers/media/video/ivtv/ivtv-streams.c            |   68 +-
 drivers/media/video/ivtv/ivtv-udma.c               |   10 +-
 drivers/media/video/ivtv/ivtv-udma.h               |    4 +-
 drivers/media/video/ivtv/ivtv-vbi.c                |    2 +
 drivers/media/video/ivtv/ivtv-version.h            |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c                |    6 +-
 drivers/media/video/ivtv/ivtvfb.c                  |    6 +-
 drivers/media/video/ks0127.c                       |  677 ++--
 drivers/media/video/ks0127.h                       |    2 -
 drivers/media/video/m52790.c                       |    7 -
 drivers/media/video/meye.c                         |   45 +-
 drivers/media/video/msp3400-driver.c               |  142 +-
 drivers/media/video/mt9m001.c                      |  164 +-
 drivers/media/video/mt9m111.c                      |   64 +-
 drivers/media/video/mt9t031.c                      |  179 +-
 drivers/media/video/mt9v022.c                      |  205 +-
 drivers/media/video/mx3_camera.c                   | 1220 ++++++
 drivers/media/video/mxb.c                          |  828 ++--
 drivers/media/video/omap24xxcam.c                  |    7 -
 drivers/media/video/ov7670.c                       |  552 ++--
 drivers/media/video/ov772x.c                       |  320 +-
 drivers/media/video/ovcamchip/ovcamchip_core.c     |  197 +-
 drivers/media/video/ovcamchip/ovcamchip_priv.h     |    7 +
 drivers/media/video/pvrusb2/Kconfig                |    8 +-
 drivers/media/video/pvrusb2/Makefile               |    7 +-
 drivers/media/video/pvrusb2/pvrusb2-audio.c        |  142 +-
 drivers/media/video/pvrusb2/pvrusb2-audio.h        |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c     |   95 +
 .../{pvrusb2-tuner.h => pvrusb2-cs53l32a.h}        |   21 +-
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c  |  245 +-
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h  |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c     |    5 -
 drivers/media/video/pvrusb2/pvrusb2-debugifc.h     |   12 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |  102 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.h      |   34 +-
 drivers/media/video/pvrusb2/pvrusb2-dvb.c          |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-encoder.c      |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |   50 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |  648 +++-
 drivers/media/video/pvrusb2/pvrusb2-hdw.h          |    6 +-
 .../media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c   |  113 -
 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c |  322 --
 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h |   50 -
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |  417 +--
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.h     |   57 +-
 drivers/media/video/pvrusb2/pvrusb2-main.c         |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c        |   12 +-
 drivers/media/video/pvrusb2/pvrusb2-tuner.c        |  120 -
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |   18 +-
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c    |  214 +-
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.h    |    7 +-
 drivers/media/video/pvrusb2/pvrusb2-wm8775.c       |  134 +-
 drivers/media/video/pvrusb2/pvrusb2-wm8775.h       |    4 +-
 drivers/media/video/pwc/Kconfig                    |   10 +
 drivers/media/video/pwc/pwc-if.c                   |   79 +-
 drivers/media/video/pwc/pwc.h                      |    6 +
 drivers/media/video/pxa_camera.c                   |   68 +-
 drivers/media/video/s2255drv.c                     |   41 +-
 drivers/media/video/saa5246a.c                     |   70 +-
 drivers/media/video/saa5249.c                      |   71 +-
 drivers/media/video/saa6588.c                      |  207 +-
 drivers/media/video/saa7110.c                      |  472 ++-
 drivers/media/video/saa7111.c                      |  492 ---
 drivers/media/video/saa7114.c                      | 1068 -----
 drivers/media/video/saa7115.c                      |   64 +-
 drivers/media/video/saa7127.c                      |    1 -
 drivers/media/video/saa7134/Kconfig                |   13 +-
 drivers/media/video/saa7134/saa6752hs.c            |  581 ++--
 drivers/media/video/saa7134/saa7134-cards.c        |  333 ++-
 drivers/media/video/saa7134/saa7134-core.c         |  108 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   75 +-
 drivers/media/video/saa7134/saa7134-empress.c      |   27 +-
 drivers/media/video/saa7134/saa7134-i2c.c          |   23 +-
 drivers/media/video/saa7134/saa7134-ts.c           |   15 +-
 drivers/media/video/saa7134/saa7134-video.c        |   75 +-
 drivers/media/video/saa7134/saa7134.h              |   40 +-
 drivers/media/video/saa7146.h                      |    2 -
 drivers/media/video/saa717x.c                      |   10 +-
 drivers/media/video/saa7185.c                      |  239 +-
 drivers/media/video/saa7191.c                      |  500 +--
 drivers/media/video/saa7191.h                      |   26 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |   82 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    4 +-
 drivers/media/video/soc_camera.c                   |  135 +-
 drivers/media/video/soc_camera_platform.c          |    9 +-
 drivers/media/video/stk-webcam.c                   |   24 +-
 drivers/media/video/tcm825x.c                      |   22 +-
 drivers/media/video/tcm825x.h                      |    2 +-
 drivers/media/video/tda7432.c                      |   22 +-
 drivers/media/video/tda9840.c                      |   82 +-
 drivers/media/video/tda9840.h                      |   14 -
 drivers/media/video/tda9875.c                      |   19 +-
 drivers/media/video/tea6415c.c                     |   53 +-
 drivers/media/video/tea6415c.h                     |   12 -
 drivers/media/video/tea6420.c                      |   69 +-
 drivers/media/video/tea6420.h                      |   27 +-
 drivers/media/video/tlv320aic23b.c                 |   12 +-
 drivers/media/video/tuner-core.c                   |  152 +-
 drivers/media/video/tvaudio.c                      |  173 +-
 drivers/media/video/tveeprom.c                     |    7 +-
 drivers/media/video/tvp514x.c                      |  113 +-
 drivers/media/video/tvp5150.c                      |   10 +-
 drivers/media/video/tw9910.c                       |   36 +-
 drivers/media/video/upd64031a.c                    |    7 -
 drivers/media/video/upd64083.c                     |    7 -
 drivers/media/video/usbvideo/vicam.c               |    2 +-
 drivers/media/video/usbvision/usbvision-core.c     |   49 +-
 drivers/media/video/usbvision/usbvision-i2c.c      |  153 +-
 drivers/media/video/usbvision/usbvision-video.c    |  125 +-
 drivers/media/video/usbvision/usbvision.h          |   10 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |    2 +-
 drivers/media/video/uvc/uvc_driver.c               |   45 +-
 drivers/media/video/uvc/uvc_status.c               |   16 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   20 +-
 drivers/media/video/uvc/uvc_video.c                |  133 +-
 drivers/media/video/uvc/uvcvideo.h                 |    8 +-
 drivers/media/video/v4l2-common.c                  |  265 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    1 -
 drivers/media/video/v4l2-dev.c                     |   54 +-
 drivers/media/video/v4l2-device.c                  |   58 +-
 drivers/media/video/v4l2-ioctl.c                   |  192 +-
 drivers/media/video/v4l2-subdev.c                  |   18 +
 drivers/media/video/videobuf-dma-contig.c          |    2 +-
 drivers/media/video/videobuf-vmalloc.c             |    2 +-
 drivers/media/video/vino.c                         | 1655 +++-----
 drivers/media/video/vivi.c                         |  495 ++-
 drivers/media/video/vp27smpx.c                     |    7 -
 drivers/media/video/vpx3220.c                      |  491 ++--
 drivers/media/video/w9966.c                        |    2 +-
 drivers/media/video/w9968cf.c                      |  133 +-
 drivers/media/video/w9968cf.h                      |   24 +-
 drivers/media/video/wm8739.c                       |    7 -
 drivers/media/video/wm8775.c                       |   12 +-
 drivers/media/video/zc0301/zc0301_sensor.h         |    8 +
 drivers/media/video/zoran/Kconfig                  |    8 +-
 drivers/media/video/zoran/videocodec.h             |    9 +-
 drivers/media/video/zoran/zoran.h                  |   97 +-
 drivers/media/video/zoran/zoran_card.c             |  555 +--
 drivers/media/video/zoran/zoran_card.h             |    3 +-
 drivers/media/video/zoran/zoran_device.c           |  529 +--
 drivers/media/video/zoran/zoran_device.h           |   14 +-
 drivers/media/video/zoran/zoran_driver.c           | 4385 +++++++-------------
 drivers/media/video/zoran/zoran_procfs.c           |    2 +-
 drivers/media/video/zoran/zr36016.c                |    5 -
 drivers/media/video/zoran/zr36050.c                |    4 -
 drivers/media/video/zoran/zr36060.c                |    4 -
 drivers/media/video/zr364xx.c                      |   17 +-
 include/linux/Kbuild                               |    2 -
 include/linux/i2c-id.h                             |    2 +
 include/linux/ivtv.h                               |   10 +-
 include/linux/video_decoder.h                      |   48 -
 include/linux/video_encoder.h                      |   23 -
 include/linux/videodev.h                           |   18 +
 include/linux/videodev2.h                          |   69 +-
 include/media/bt819.h                              |   33 +
 include/media/cx2341x.h                            |    6 +-
 include/media/cx25840.h                            |   12 +
 include/media/ir-common.h                          |    3 +
 include/media/ir-kbd-i2c.h                         |    3 +-
 include/media/ov772x.h                             |    5 +
 include/media/saa7146.h                            |    8 +
 include/media/saa7146_vv.h                         |   17 +-
 include/media/sh_mobile_ceu.h                      |    5 +-
 include/media/soc_camera.h                         |   24 +-
 include/media/v4l2-chip-ident.h                    |   94 +-
 include/media/v4l2-common.h                        |   24 +-
 include/media/v4l2-dev.h                           |    2 +
 include/media/v4l2-device.h                        |   40 +-
 include/media/v4l2-ioctl.h                         |    2 +
 include/media/v4l2-subdev.h                        |   22 +-
 include/media/videobuf-core.h                      |    1 +
 include/sound/tea575x-tuner.h                      |    8 +-
 sound/i2c/other/tea575x-tuner.c                    |  302 +-
 sound/pci/Kconfig                                  |    2 +-
 489 files changed, 48502 insertions(+), 27346 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/mx3_camera.h
 create mode 100644 drivers/media/common/tuners/mc44s803.c
 create mode 100644 drivers/media/common/tuners/mc44s803.h
 create mode 100644 drivers/media/common/tuners/mc44s803_priv.h
 create mode 100644 drivers/media/dvb/dvb-usb/ce6230.c
 create mode 100644 drivers/media/dvb/dvb-usb/ce6230.h
 create mode 100644 drivers/media/dvb/frontends/au8522_decoder.c
 rename drivers/media/dvb/frontends/{au8522.c => au8522_dig.c} (91%)
 create mode 100644 drivers/media/dvb/frontends/au8522_priv.h
 create mode 100644 drivers/media/dvb/frontends/lgdt3305.c
 create mode 100644 drivers/media/dvb/frontends/lgdt3305.h
 create mode 100644 drivers/media/dvb/frontends/lnbh24.h
 create mode 100644 drivers/media/dvb/frontends/stv0900.h
 create mode 100644 drivers/media/dvb/frontends/stv0900_core.c
 create mode 100644 drivers/media/dvb/frontends/stv0900_init.h
 create mode 100644 drivers/media/dvb/frontends/stv0900_priv.h
 create mode 100644 drivers/media/dvb/frontends/stv0900_reg.h
 create mode 100644 drivers/media/dvb/frontends/stv0900_sw.c
 create mode 100644 drivers/media/dvb/frontends/stv6110.c
 create mode 100644 drivers/media/dvb/frontends/stv6110.h
 create mode 100644 drivers/media/dvb/frontends/zl10036.c
 create mode 100644 drivers/media/dvb/frontends/zl10036.h
 create mode 100644 drivers/media/video/au0828/au0828-video.c
 create mode 100644 drivers/media/video/cx23885/cimax2.c
 create mode 100644 drivers/media/video/cx23885/cimax2.h
 create mode 100644 drivers/media/video/cx23885/netup-eeprom.c
 create mode 100644 drivers/media/video/cx23885/netup-eeprom.h
 create mode 100644 drivers/media/video/cx23885/netup-init.c
 create mode 100644 drivers/media/video/cx23885/netup-init.h
 create mode 100644 drivers/media/video/gspca/mr97310a.c
 create mode 100644 drivers/media/video/gspca/sq905.c
 create mode 100644 drivers/media/video/gspca/sq905c.c
 create mode 100644 drivers/media/video/hdpvr/Kconfig
 create mode 100644 drivers/media/video/hdpvr/Makefile
 create mode 100644 drivers/media/video/hdpvr/hdpvr-control.c
 create mode 100644 drivers/media/video/hdpvr/hdpvr-core.c
 create mode 100644 drivers/media/video/hdpvr/hdpvr-i2c.c
 create mode 100644 drivers/media/video/hdpvr/hdpvr-video.c
 create mode 100644 drivers/media/video/hdpvr/hdpvr.h
 create mode 100644 drivers/media/video/mx3_camera.c
 create mode 100644 drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c
 rename drivers/media/video/pvrusb2/{pvrusb2-tuner.h => pvrusb2-cs53l32a.h} (64%)
 delete mode 100644 drivers/media/video/pvrusb2/pvrusb2-i2c-chips-v4l2.c
 delete mode 100644 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.c
 delete mode 100644 drivers/media/video/pvrusb2/pvrusb2-i2c-cmd-v4l2.h
 delete mode 100644 drivers/media/video/pvrusb2/pvrusb2-tuner.c
 delete mode 100644 drivers/media/video/saa7111.c
 delete mode 100644 drivers/media/video/saa7114.c
 delete mode 100644 drivers/media/video/tda9840.h
 delete mode 100644 include/linux/video_decoder.h
 delete mode 100644 include/linux/video_encoder.h
 create mode 100644 include/media/bt819.h

Abylay Ospan (5):
      V4L/DVB (10796): Add init code for NetUP Dual DVB-S2 CI card
      V4L/DVB (10797): Add EEPROM code for NetUP Dual DVB-S2 CI card.
      V4L/DVB (10798): Add CIMax(R) SP2 Common Interface code for NetUP Dual DVB-S2 CI card
      V4L/DVB (11056): Bug fix in NetUP: restore high address lines in CI
      V4L/DVB (11057): Fix CiMax stability in Netup Dual DVB-S2 CI

Adam Baker (2):
      V4L/DVB (10639): gspca - sq905: New subdriver.
      V4L/DVB (10829): Support alternate resolutions for sq905

Alan Cox (2):
      V4L/DVB (11243): cx88: Missing failure checks
      V4L/DVB (11244): pluto2: silence spew of card hung up messages

Alan McIvor (1):
      V4L/DVB (11124): Add support for ProVideo PV-183 to bttv

Alexey Klimov (18):
      V4L/DVB (10316): v4l/dvb: use usb_make_path in usb-radio drivers
      V4L/DVB (10324): em28xx: Correct mailing list
      V4L/DVB (10335): gspca - all subdrivers: Fix CodingStyle in sd_mod_init function.
      V4L/DVB (10336): gspca - all subdrivers: Return ret instead of -1 in sd_mod_init.
      V4L/DVB (10455): radio-mr800: codingstyle cleanups
      V4L/DVB (10456): radio-mr800: place dev_err instead of dev_warn
      V4L/DVB (10457): radio-mr800: add more dev_err messages in probe
      V4L/DVB (10458): radio-mr800: move radio start and stop in one function
      V4L/DVB (10459): radio-mr800: fix amradio_set_freq
      V4L/DVB (10460): radio-mr800: add stereo support
      V4L/DVB (10461): radio-mr800: add few lost mutex locks
      V4L/DVB (10462): radio-mr800: increase version and add comments
      V4L/DVB (10463): radio-mr800: fix checking of retval after usb_bulk_msg
      V4L/DVB (10464): radio-si470x: use usb_make_path in usb-radio drivers
      V4L/DVB (10465): dsbr100: Add few lost mutex locks.
      V4L/DVB (10522): em28xx-audio: replace printk with em28xx_errdev
      V4L/DVB (10946): radio-rtrack2: fix double mutex_unlock
      V4L/DVB (10961): radio-terratec: remove linux/delay.h which hadn't been used.

Andy Walls (44):
      V4L/DVB (10274): cx18: Fix a PLL divisor update for the I2S master clock
      V4L/DVB (10275): cx18: Additional debug to display outgoing mailbox parameters
      V4L/DVB (10276): cx18, cx2341x, ivtv: Add AC-3 audio encoding control to cx18
      V4L/DVB (10277): cx18, cx2341x: Fix bugs in cx18 AC3 control and comply with V4L2 spec
      V4L/DVB (10278): cx18: Fix bad audio in first analog capture.
      V4L/DVB (10279): cx18: Print driver version number when logging status
      V4L/DVB (10280): cx18: Rename structure members: dev to pci_dev and v4l2dev to video_dev
      V4L/DVB (10281): cx18: Conversion to new V4L2 framework: use v4l2_device object
      V4L/DVB (10283): cx18: Call request_module() with proper argument types.
      V4L/DVB (10284): cx18: Add initial entry for a Leadtek DVR3100 H hybrid card
      V4L/DVB (10433): cx18: Defer A/V core initialization until a valid cx18_av_cmd arrives
      V4L/DVB (10434): cx18: Smarter verification of CX18_AUDIO_ENABLE register writes
      V4L/DVB (10435): cx18: Normalize APU after second APU firmware load
      V4L/DVB (10436): cx18: Fix coding style of a switch statement per checkpatch.pl
      V4L/DVB (10437): cx18: Remove an unused spinlock
      V4L/DVB (10439): cx18: Clean-up and enable sliced VBI handling
      V4L/DVB (10440): cx18: Fix presentation timestamp (PTS) for VBI buffers
      V4L/DVB (10441): cx18: Fix VBI ioctl() handling and Raw/Sliced VBI state management
      V4L/DVB (10442): cx18: Fixes for enforcing when Encoder Raw VBI params can be set
      V4L/DVB (10443): cx18: Use correct line counts per field in firmware API call
      V4L/DVB (10444): cx18: Fix sliced VBI PTS and fix artifacts in last raw line of field
      V4L/DVB (10445): cx18: Process Raw VBI on a whole frame basis; fix VBI buffer size
      V4L/DVB (10446): cx18: Finally get sliced VBI working - for 525 line 60 Hz systems at least
      V4L/DVB (10755): cx18: Convert the integrated A/V decoder core interface to a v4l2_subdev
      V4L/DVB (10756): cx18: Slim down instance handling, build names from v4l2_device.name
      V4L/DVB (10757): cx18, v4l2-chip-ident: Finish conversion of AV decoder core to v4l2_subdev
      V4L/DVB (10758): cx18: Convert I2C devices to v4l2_subdevices
      V4L/DVB (10759): cx18: Convert GPIO connected functions to act as v4l2_subdevices
      V4L/DVB (10760): cx18: Fix a memory leak of buffers used for sliced VBI insertion
      V4L/DVB (10761): cx18: Change log lines for internal subdevs and fix tveeprom reads
      V4L/DVB (10762): cx18: Get rid of unused variables related to video output
      V4L/DVB (10763): cx18: Increment version number due to significant changes for v4l2_subdevs
      V4L/DVB (10764): cx18: Disable AC3 controls as the firmware doesn't support AC3
      V4L/DVB (10850): cx18: Use strlcpy() instead of strncpy() for temp eeprom i2c_client setup
      V4L/DVB (10851): cx18: Fix a video scaling check problem introduced by sliced VBI changes
      V4L/DVB (10852): cx18: Include cx18-audio.h in cx18-audio.c to eliminate s-parse warning
      V4L/DVB (10853): cx18: Fix s-parse warnings and a logic error about extracting the VBI PTS
      V4L/DVB (10854): cx18: Correct comments about vertical and horizontal blanking timings
      V4L/DVB (10855): cx18: Fix VPS service register codes
      V4L/DVB (10856): cx18: Add interlock so sliced VBI insertion only happens for an MPEG PS
      V4L/DVB (11042): v4l2-api: Add definitions for V4L2_MPEG_STREAM_VBI_FMT_IVTV payloads
      V4L/DVB (11091): cx18, ivtv: Ensure endianess for linemasks in VBI embedded in MPEG stream
      V4L/DVB (11092): cx18: Optimize processing of VBI buffers from the capture unit
      V4L/DVB (11233): mxl5005s: Switch in mxl5005s_set_params should operate on correct values

Antoine Jacquet (1):
      V4L/DVB (10263): zr364xx: add support for Aiptek DV T300

Antonio Ospite (2):
      V4L/DVB (10344): gspca - ov534: Disable the Hercules webcams.
      V4L/DVB (10676): mt9m111: Call icl->reset() on mt9m111_reset().

Antti Palosaari (4):
      V4L/DVB (10286): af9015: add new USB ID for KWorld DVB-T 395U
      V4L/DVB (10329): af9015: remove dual_mode module param
      V4L/DVB (11215): zl10353: add support for Intel CE6230 and Intel CE6231
      V4L/DVB (11216): Add driver for Intel CE6230 DVB-T USB2.0

Arne Luehrs (1):
      V4L/DVB (10319): dib0700: enable IR receiver in Nova TD usb stick (52009)

Artem Makhutov (1):
      V4L/DVB (11248): Remove debug output from stb6100_cfg.h

Bruno Christo (1):
      V4L/DVB (10827): Add support for GeoVision GV-800(S)

Daniel Glöckner (1):
      V4L/DVB (11242): allow v4l2 drivers to provide a get_unmapped_area handler

Devin Heitmueller (36):
      V4L/DVB (10320): dib0700: fix i2c error message to make data type clear
      V4L/DVB (10321): dib0700: Report dib0700_i2c_enumeration failures
      V4L/DVB (11059): xc5000: fix bug for hybrid xc5000 devices with IF other than 5380
      V4L/DVB (11060): au8522: rename the au8522.c source file
      V4L/DVB (11061): au8522: move shared state and common functions into a separate header files
      V4L/DVB (11062): au8522: fix register read/write high bits
      V4L/DVB (11063): au8522: power down the digital demod when not in use
      V4L/DVB (11064): au8522: make use of hybrid framework so analog/digital demod can share state
      V4L/DVB (11065): au8522: add support for analog side of demodulator
      V4L/DVB (11066): au0828: add support for analog functionality in bridge
      V4L/DVB (11067): au0828: workaround a bug in the au0828 i2c handling
      V4L/DVB (11068): au0828: add analog profile for the HVR-850
      V4L/DVB (11069): au8522: add mutex protecting use of hybrid state
      V4L/DVB (11070): au0828: Rework the way the analog video binding occurs
      V4L/DVB (11071): tveeprom: add the xc5000 tuner to the tveeprom definition
      V4L/DVB (11072): au0828: advertise only NTSC-M (as opposed to all NTSC standards)
      V4L/DVB (11073): au0828: disable VBI code since it doesn't yet work
      V4L/DVB (11074): au0828: fix i2c enumeration bug
      V4L/DVB (11075): au0828: make register debug lines easier to read
      V4L/DVB (11076): au0828: make g_chip_ident call work properly
      V4L/DVB (11077): au0828: properly handle missing analog USB endpoint
      V4L/DVB (11078): au0828: properly handle non-existent analog inputs
      V4L/DVB (11079): au0828: fix panic on disconnect if analog initialization failed
      V4L/DVB (11080): au0828: Convert to use v4l2_device/subdev framework
      V4L/DVB (11081): au0828: make sure v4l2_device name is unique
      V4L/DVB (11082): au0828: remove memset calls in v4l2 routines.
      V4L/DVB (11083): au0828: remove some unneeded braces
      V4L/DVB (11084): au0828: add entry for undefined input type
      V4L/DVB (11085): au0828/au8522: Codingstyle fixes
      V4L/DVB (11086): au0828: rename macro for currently non-function VBI support
      V4L/DVB (11088): au0828: finish videodev/subdev conversion
      V4L/DVB (11089): au8522: finish conversion to v4l2_device/subdev
      V4L/DVB (11139): em28xx: add remote control definition for HVR-900 (both versions)
      V4L/DVB (11140): usbvision: fix oops on ARM platform when allocating transfer buffers
      V4L/DVB (11141): em28xx: fix oops on ARM platform when allocating transfer buffers
      V4L/DVB (11142): au0828: fix oops on ARM platform when allocating transfer buffers

Douglas Kosovic (1):
      V4L/DVB (10299): bttv: Add support for IVCE-8784 support for V4L2 bttv driver

Douglas Schilling Landgraf (13):
      V4L/DVB (10323): em28xx: Add entry for GADMEI TVR200
      V4L/DVB (10326): em28xx: Cleanup: fix bad whitespacing
      V4L/DVB (10327): em28xx: Add check before call em28xx_isoc_audio_deinit()
      V4L/DVB (10517): em28xx: remove bad check (changeset a31c595188af)
      V4L/DVB (10520): em28xx-audio: Add spinlock for trigger
      V4L/DVB (10521): em28xx-audio: Add lock for users
      V4L/DVB (10523): em28xx-audio: Add macros EM28XX_START_AUDIO / EM28XX_STOP_AUDIO
      V4L/DVB (10524): em28xx: Add DVC 101 model to Pinnacle Dazzle description
      V4L/DVB (10556): em28xx-cards: Add Pinnacle Dazzle Video Creator Plus DVC107 description
      V4L/DVB (10739): em28xx-cards: remove incorrect entry
      V4L/DVB (10740): em28xx-cards: Add SIIG AVTuner-PVR board
      V4L/DVB (10741): em28xx: Add Kaiser Baas Video to DVD maker support
      V4L/DVB (11222): gspca - zc3xx: The webcam DLink DSB - C320 has the sensor pas106.

Erik Andren (3):
      V4L/DVB (10334): gspca - stv06xx: Rework control description.
      V4L/DVB (10341): gspca - stv06xx: Plug a memory leak in the pb0100 sensor driver.
      V4L/DVB (10342): gspca - stv06xx: Add ctrl caching to the vv6410.

Erik S. Beiser (1):
      V4L/DVB (10826): cx88: Add IR support to pcHDTV HD3000 & HD5500

Guennadi Liakhovetski (9):
      V4L/DVB (10665): soc-camera: add data signal polarity flags to drivers
      V4L/DVB (10672): sh_mobile_ceu_camera: include NV* formats into the format list only once.
      V4L/DVB (10673): mt9t031: fix gain and hflip controls, register update, and scaling
      V4L/DVB (10674): soc-camera: camera host driver for i.MX3x SoCs
      V4L/DVB (10675): soc-camera: extend soc_camera_bus_param_compatible with more tests
      V4L/DVB (11024): soc-camera: separate S_FMT and S_CROP operations
      V4L/DVB (11025): soc-camera: configure drivers with a default format on open
      V4L/DVB (11026): sh-mobile-ceu-camera: set field to the value, configured at open()
      V4L/DVB (11027): soc-camera: configure drivers with a default format at probe time

Hans Verkuil (171):
      V4L/DVB (10231): v4l2-subdev: add v4l2_ext_controls support
      V4L/DVB (10244): v4l2: replace a few snprintfs with strlcpy
      V4L/DVB (10246): saa6752hs: convert to v4l2_subdev.
      V4L/DVB (10247): saa7134: convert to the new v4l2 framework.
      V4L/DVB (10249): v4l2-common: added v4l2_i2c_tuner_addrs()
      V4L/DVB (10251): cx25840: add comments explaining what the init() does.
      V4L/DVB (10252): v4l2 doc: explain why v4l2_device_unregister_subdev() has to be called.
      V4L/DVB (10271): saa7146: convert to video_ioctl2.
      V4L/DVB (10272): av7110: test type field in VIDIOC_G_SLICED_VBI_CAP
      V4L/DVB (10291): em28xx: fix VIDIOC_G_CTRL when there is no msp34xx device.
      V4L/DVB (10313): saa7146: fix VIDIOC_ENUMSTD.
      V4L/DVB (10406): gspca: fix compiler warning
      V4L/DVB (10408): v4l2: fix incorrect hue range check
      V4L/DVB (10409): v4l: remove unused I2C_DRIVERIDs.
      V4L/DVB (10486): ivtv/cx18: fix g_fmt and try_fmt for raw video
      V4L/DVB (10487): doc: update hm12 documentation.
      V4L/DVB (10488): ivtv: cleanup naming conventions
      V4L/DVB (10489): doc: use consistent naming conventions for vdev and v4l2_dev.
      V4L/DVB (10490): v4l2: prefill ident and revision from v4l2_dbg_chip_ident.
      V4L/DVB (10496): saa7146: implement v4l2_device support.
      V4L/DVB (10497): saa7146: i2c adapdata now points to v4l2_device.
      V4L/DVB (10498): saa7146: the adapter class will be NULL when v4l2_subdev is used.
      V4L/DVB (10499): saa7146: convert saa7146 and mxb in particular to v4l2_subdev.
      V4L/DVB (10500): saa7146: setting control while capturing should return EBUSY, not EINVAL.
      V4L/DVB (10501): saa7146: prevent unnecessary loading of v4l2-common.
      V4L/DVB (10502): saa7146: move v4l2 device registration to saa7146_vv.
      V4L/DVB (10536): saa6588: convert to v4l2-i2c-drv-legacy.h
      V4L/DVB (10537): saa6588: convert to v4l2_subdev.
      V4L/DVB (10538): saa6588: add g_chip_ident support.
      V4L/DVB (10539): saa6588: remove legacy_class, not needed for saa6588
      V4L/DVB (10540): cx2341x: fixed bug causing several audio controls to be no longer listed
      V4L/DVB (10542): v4l2-subdev: add querystd and g_input_status
      V4L/DVB (10544): v4l2-common: add comments warning that about the sort order
      V4L/DVB (10641): v4l2-dev: remove limit of 32 devices per driver in get_index()
      V4L/DVB (10642): vivi: update comment to reflect that vivi can now create more than 32 devs.
      V4L/DVB (10643): v4l2-device: allow a NULL parent device when registering.
      V4L/DVB (10644): v4l2-subdev: rename dev field to v4l2_dev
      V4L/DVB (10645): vivi: introduce v4l2_device and do several cleanups
      V4L/DVB (10646): vivi: controls are per-device, not global.
      V4L/DVB (10647): vivi: add slider flag to controls.
      V4L/DVB (10685): v4l2: add colorfx support to v4l2-common.c, and add to 'Changes' in spec.
      V4L/DVB (10686): v4l2: add V4L2_CTRL_FLAG_WRITE_ONLY flag.
      V4L/DVB (10687): v4l2-common/v4l2-spec: support/document write-only and button controls
      V4L/DVB (10691): v4l2-common: add v4l2_i2c_subdev_addr()
      V4L/DVB (10692): usbvision: convert to v4l2_device/v4l2_subdev.
      V4L/DVB (10698): v4l2-common: remove v4l2_ctrl_query_fill_std
      V4L/DVB (10700): saa7115: don't access reg 0x87 if it is not present.
      V4L/DVB (10701): saa7185: add colorbar support.
      V4L/DVB (10702): saa7115: add querystd and g_input_status support for zoran.
      V4L/DVB (10703): zoran: convert to video_ioctl2 and remove 'ready_to_be_freed' hack.
      V4L/DVB (10704): zoran: remove broken BIGPHYS_AREA and BUZ_HIMEM code, and allow for kmallocs > 128 kB
      V4L/DVB (10705): zoran: use slider flag with volume etc. controls.
      V4L/DVB (10706): zoran: fix field typo.
      V4L/DVB (10707): zoran: set bytesperline to 0 when using MJPEG.
      V4L/DVB (10708): zoran: remove old V4L1 ioctls, use v4l1-compat instead.
      V4L/DVB (10709): zoran: set correct parent of the video device.
      V4L/DVB (10710): zoran: cleanups in an attempt to make the source a bit more readable.
      V4L/DVB (10711): zoran: fix TRY_FMT support
      V4L/DVB (10712): zoran: fix G_FMT
      V4L/DVB (10713): zoran: if reqbufs is called with count == 0, do a streamoff.
      V4L/DVB (10714): zoran et al: convert zoran i2c modules to V4L2.
      V4L/DVB (10715): zoran: clean up some old V4L1 left-overs and remove the MAP_NR macro.
      V4L/DVB (10716): zoran: change buffer defaults to something that works with tvtime
      V4L/DVB (10717): zoran: TRY_FMT and S_FMT now do the same parameter checks.
      V4L/DVB (10718): bt866: convert to v4l2_subdev.
      V4L/DVB (10719): bt819: convert to v4l2_subdev.
      V4L/DVB (10720): bt819: that delay include is needed after all.
      V4L/DVB (10721): bt856: convert to v4l2_subdev.
      V4L/DVB (10722): ks0127: convert to v4l2_subdev.
      V4L/DVB (10723): ks0127: add supported ks0127 variants to the i2c device list.
      V4L/DVB (10724): saa7110: convert to v4l2_subdev.
      V4L/DVB (10725): saa7185: convert to v4l2_subdev.
      V4L/DVB (10726): vpx3220: convert to v4l2_subdev.
      V4L/DVB (10727): adv7170: convert to v4l2_subdev.
      V4L/DVB (10728): adv7175: convert to v4l2-subdev.
      V4L/DVB (10729): zoran: convert to v4l2_device/v4l2_subdev.
      V4L/DVB (10730): v4l-dvb: cleanup obsolete references to v4l1 headers.
      V4L/DVB (10731): zoran i2c modules: remove i2c autoprobing support.
      V4L/DVB (10732): zoran: s_jpegcomp should return a proper result, not 0.
      V4L/DVB (10733): zoran: increase bufsize to a value suitable for 768x576.
      V4L/DVB (10858): vino: convert to video_ioctl2.
      V4L/DVB (10859): vino: minor renames
      V4L/DVB (10860): saa7191: convert to v4l2-i2c-drv-legacy.h
      V4L/DVB (10861): vino/indycam/saa7191: convert to i2c modules to V4L2.
      V4L/DVB (10862): indycam: convert to v4l2_subdev
      V4L/DVB (10863): saa7191: convert to v4l2_subdev.
      V4L/DVB (10864): vino: introduce v4l2_device.
      V4L/DVB (10865): vino: convert to v4l2_subdev.
      V4L/DVB (10866): saa7191, indycam: remove compat code.
      V4L/DVB (10868): vino: add note that this conversion is untested.
      V4L/DVB (10873): w9968cf: add v4l2_device.
      V4L/DVB (10874): w9968cf/ovcamchip: convert to v4l2_subdev.
      V4L/DVB (10880): radio-aimslab: convert to v4l2_device.
      V4L/DVB (10881): radio-aztech: convert to v4l2_device.
      V4L/DVB (10882): radio-cadet: convert to v4l2_device.
      V4L/DVB (10883): radio-gemtek-pci: convert to v4l2_device.
      V4L/DVB (10884): radio-gemtek: convert to v4l2_device.
      V4L/DVB (10885): radio-maestro: convert to v4l2_device.
      V4L/DVB (10886): radio-maxiradio: convert to v4l2_device.
      V4L/DVB (10887): radio-rtrack2: convert to v4l2_device.
      V4L/DVB (10888): radio-sf16fmi: convert to v4l2_device.
      V4L/DVB (10889): radio-sf16fmr2: convert to v4l2_device.
      V4L/DVB (10890): radio-terratec: convert to v4l2_device.
      V4L/DVB (10891): radio-trust: convert to v4l2_device.
      V4L/DVB (10892): radio-typhoon: convert to v4l2_device.
      V4L/DVB (10893): radio-zoltrix: convert to v4l2_device.
      V4L/DVB (10894): ISA radio drivers: improve kernel log message
      V4L/DVB (10909): tvmixer: remove last remaining references to this deleted module.
      V4L/DVB (10910): videodev2.h: remove deprecated VIDIOC_G_CHIP_IDENT_OLD
      V4L/DVB (10912): vivi: fix compile warning.
      V4L/DVB (10914): v4l2: fix compile warnings when printing u64 value.
      V4L/DVB (10919): tlv320aic23b: use v4l2-i2c-drv.h instead of drv-legacy.h
      V4L/DVB (10920): v4l2-ioctl: fix partial-copy code.
      V4L/DVB (10921): msp3400: remove obsolete V4L1 code
      V4L/DVB (10959): radio: remove uaccess include
      V4L/DVB (10960): omap24xxcam: don't set vfl_type.
      V4L/DVB (10962): fired-avc: fix printk formatting warning.
      V4L/DVB (10965): ivtv: bump version
      V4L/DVB (10980): doc: improve the v4l2-framework documentation.
      V4L/DVB (10983): v4l2-common: add missing i2c_unregister_device.
      V4L/DVB (10987): cx23885: fix crash on non-netup cards
      V4L/DVB (10988): v4l2-dev: use parent field if the v4l2_device has no parent set.
      V4L/DVB (11021): v4l2-device: add a notify callback.
      V4L/DVB (11022): zoran/bt819: use new notify functionality.
      V4L/DVB (11044): v4l2-device: add v4l2_device_disconnect
      V4L/DVB (11045): v4l2: call v4l2_device_disconnect in USB drivers.
      V4L/DVB (11046): bttv: convert to v4l2_device.
      V4L/DVB (11047): cx88: convert to v4l2_device.
      V4L/DVB (11048): zoran: fix incorrect return type of notify function.
      V4L/DVB (11051): v4l-dvb: replace remaining references to the old mailinglist.
      V4L/DVB (11052): bt819: remove an unused header
      V4L/DVB (11053): saa7134: set v4l2_dev field of video_device
      V4L/DVB (11098): v4l2-common: remove incorrect MODULE test
      V4L/DVB (11100): au8522: fix compilation warning.
      V4L/DVB (11112): v4l2-subdev: add support for TRY_FMT, ENUM_FMT and G/S_PARM.
      V4L/DVB (11113): ov7670: convert to v4l2_subdev
      V4L/DVB (11114): cafe_ccic: convert to v4l2_device.
      V4L/DVB (11115): cafe_ccic: use v4l2_subdev to talk to the ov7670 sensor.
      V4L/DVB (11116): ov7670: cleanup and remove legacy code.
      V4L/DVB (11117): ov7670: add support to get/set registers
      V4L/DVB (11118): cafe_ccic: replace debugfs with g/s_register ioctls.
      V4L/DVB (11120): cafe_ccic: stick in a comment with a request for test results
      V4L/DVB (11253): saa7134: fix RTD Embedded Technologies VFG7350 support.
      V4L/DVB (11254): cs53l32a: remove legacy support.
      V4L/DVB (11255): dst_ca: fix compile warning.
      V4L/DVB (11256): dabusb: fix compile warning.
      V4L/DVB (11275): tvaudio: fix mute and s/g_tuner handling
      V4L/DVB (11276): tvaudio: add tda9875 support.
      V4L/DVB (11277): tvaudio: always call init_timer to prevent rmmod crash.
      V4L/DVB (11278): bttv: convert to v4l2_subdev since i2c autoprobing will disappear.
      V4L/DVB (11279): bttv: tda9875 is no longer used by bttv, so remove from bt8xx/Kconfig.
      V4L/DVB (11281): bttv: move saa6588 config to the helper chip config
      V4L/DVB (11282): saa7134: add RDS support.
      V4L/DVB (11283): saa6588: remove legacy code.
      V4L/DVB (11295): cx23885: convert to v4l2_device.
      V4L/DVB (11297): cx23885: convert to v4l2_subdev.
      V4L/DVB (11298): cx25840: remove legacy code for old-style i2c API
      V4L/DVB (11300): cx88: convert to v4l2_subdev.
      V4L/DVB (11301): wm8775: remove legacy code for old-style i2c API
      V4L/DVB (11302): tda9875: remove legacy code for old-style i2c API
      V4L/DVB (11303): tda7432: remove legacy code for old-style i2c API
      V4L/DVB (11304): v4l2: remove v4l2_subdev_command calls where they are no longer needed.
      V4L/DVB (11305): cx88: prevent probing rtc and ir devices
      V4L/DVB (11309): cx25840: cleanup: remove intermediate 'ioctl' step
      V4L/DVB (11310): cx18: remove intermediate 'ioctl' step
      V4L/DVB (11311): v4l: replace 'ioctl' references in v4l i2c drivers
      V4L/DVB (11312): tuner: remove V4L1 code from this driver.
      V4L/DVB (11313): v4l2-subdev: add enum_framesizes and enum_frameintervals.
      V4L/DVB (11314): au8522: remove unused I2C_DRIVERID
      V4L/DVB (11315): cx25840: fix 'unused variable' warning.
      V4L/DVB (11316): saa7191: tuner ops wasn't set.

Hans Werner (1):
      V4L/DVB (10392): lnbp21: documentation about the system register

Hans de Goede (1):
      V4L/DVB (11221): gspca - sonixj: Prefer sonixj instead of sn9c102 for 0471:0327.

Igor M. Liplianin (18):
      V4L/DVB (10266): Add support for TurboSight TBS6920 DVB-S2 PCI-e card.
      V4L/DVB (10267): Add support for TeVii S470 DVB-S2 PCI-e card.
      V4L/DVB (10268): Proper implement set_voltage in cx24116.
      V4L/DVB (10269): Add support for DVBWorld DVBS2 PCI-e 2005.
      V4L/DVB (10413): Bug fix: Restore HVR-4000 tuning.
      V4L/DVB (10743): dm1105: not demuxing from interrupt context.
      V4L/DVB (10744): dm1105: infrared remote code is remaked.
      V4L/DVB (10799): Add support for ST STV6110 silicon tuner.
      V4L/DVB (10800): Add support for ST LNBH24 LNB power controller.
      V4L/DVB (10801): Add headers for ST STV0900 dual demodulator.
      V4L/DVB (10802): Add more headers for ST STV0900 dual demodulator.
      V4L/DVB (10803): Add core code for ST STV0900 dual demodulator.
      V4L/DVB (10804): Add support for ST STV0900 dual demodulator.
      V4L/DVB (10805): Add support for NetUP Dual DVB-S2 CI card
      V4L/DVB (10808): Fix typo in lnbp21.c
      V4L/DVB (10871): stv0900: delete debug messages not related to stv0900 tuning algorythm
      V4L/DVB (11054): Shorten some lines in stv0900 to less then 81 characters
      V4L/DVB (11055): Fix typo in stv0900

Indika Katugampala (1):
      V4L/DVB (10528): em28xx: support added for IO-DATA GV/MVP SZ - EMPIA-2820 chipset

Jan Engelhardt (1):
      V4L/DVB (10391): dvb: constify VFTs

Janne Grunau (12):
      V4L/DVB (11095): adds V4L2_CID_SHARPNESS to v4l2_ctrl_query_fill()
      V4L/DVB (11096): V4L2 Driver for the Hauppauge HD PVR usb capture device
      V4L/DVB (11097): use video_ioctl2 as ioctl handler directly
      V4L/DVB (11125): fix mispelled Hauppauge in HD PVR and PVR USB2 driver comments
      V4L/DVB (11152): hdpvr: Fix build with Config_I2C not set
      V4L/DVB (11228): hdpvr: use debugging macro for buffer status
      V4L/DVB (11229): hdpvr: set usb interface dev as parent in struct video_device
      V4L/DVB (11230): hdpvr: return immediately from hdpvr_poll if data is available
      V4L/DVB (11231): hdpvr: locking fixes
      V4L/DVB (11245): hdpvr: add struct v4l2_device
      V4L/DVB (11246): hdpvr: convert printing macros to v4l2_* with struct v4l2_device
      V4L/DVB (11247): hdpvr: empty internal device buffer after stopping streaming

Jean Delvare (8):
      V4L/DVB (10867): vino: fold i2c-algo-sgi code into vino.
      V4L/DVB (10931): zoran: Drop the lock_norm module parameter
      V4L/DVB (10932): zoran: Don't frighten users with failed buffer allocation
      V4L/DVB (10938): em28xx: Prevent general protection fault on rmmod
      V4L/DVB (10939): ir-kbd-i2c: Prevent general protection fault on rmmod
      V4L/DVB (10940): saa6588: Prevent general protection fault on rmmod
      V4L/DVB (10943): cx88: Prevent general protection fault on rmmod
      V4L/DVB (11111a): MAINTAINERS: Drop references to deprecated video4linux list

Jean-Francois Moine (75):
      V4L/DVB (10332): gspca - main: Version change.
      V4L/DVB (10333): gspca - main and many subdrivers: Remove the epaddr variable.
      V4L/DVB (10337): gspca - common: Simplify the debug macros.
      V4L/DVB (10343): gspca - zc3xx / zc0301: Handle the 0ac8:303b instead of zc0301.
      V4L/DVB (10345): gspca - jpeg subdrivers: One quantization table per subdriver.
      V4L/DVB (10346): gspca - zc3xx: Fix bad variable type with i2c read.
      V4L/DVB (10347): gspca - mars: Optimize, rewrite initialization and add controls.
      V4L/DVB (10348): gspca - mars: Bad isoc packet scanning.
      V4L/DVB (10350): gspca - tv8532: Cleanup code.
      V4L/DVB (10352): gspca - spca508: Cleanup code.
      V4L/DVB (10353): gspca - some subdrivers: Don't get the control values from the webcam.
      V4L/DVB (10354): gspca - tv8532: Change the max brightness.
      V4L/DVB (10356): gspca - sonixj: Cleanup code.
      V4L/DVB (10357): gspca - main: Cleanup code.
      V4L/DVB (10360): gspca - mars: Bad interface/altsetting since 0a10a0e906be.
      V4L/DVB (10361): gspca - sonixj: Gamma control added.
      V4L/DVB (10363): gspca - spca500: Abnormal error message when starting ClickSmart310.
      V4L/DVB (10367): gspca - spca561: Optimize the isoc scanning function.
      V4L/DVB (10368): gspca - spca561: Fix bugs and rewrite the init/start of the rev72a.
      V4L/DVB (10370): gspca - main: Have 3 URBs instead of 2 for ISOC transfers.
      V4L/DVB (10371): gspca - spca561: Fix image problem in the 352x288 mode of rev72a.
      V4L/DVB (10372): gspca - sonixj: Cleanup code.
      V4L/DVB (10373): gspca - zc3xx: Sensor adcm2700 added.
      V4L/DVB (10374): gspca - zc3xx: Bad probe of the sensor adcm2700.
      V4L/DVB (10375): gspca - zc3xx: Remove duplicated sequence of sensor cs2102k.
      V4L/DVB (10376): gspca - zc3xx: Remove some useless tables of sensor adcm2700.
      V4L/DVB (10378): gspca - main: Avoid error on set interface on disconnection.
      V4L/DVB (10380): gspca - t613: Cleanup and optimize code.
      V4L/DVB (10381): gspca - t613: New unknown sensor added.
      V4L/DVB (10382): gspca - t613: Bad returned value when no known sensor found.
      V4L/DVB (10383): gspca - spca505: Cleanup and optimize code.
      V4L/DVB (10384): gspca - spca505: Simplify and add the brightness in start.
      V4L/DVB (10387): gspca - spca505: Move some sequences from probe to streamon.
      V4L/DVB (10389): gspca - zc3xx: Do work the sensor adcm2700.
      V4L/DVB (10419): gspca - sonixj: Sensor mt9v111 added.
      V4L/DVB (10420): gspca - vc032x: Webcam 041e:405b added and mi1310_soc updated.
      V4L/DVB (10421): gspca - documentation: Add the webcam 041e:405b.
      V4L/DVB (10423): gspca - sonixj: Bad sensor definition of the webcams 0c45:60c0.
      V4L/DVB (10424): gspca - vc032x: Add resolution 1280x1024 for sensor mi1310_soc.
      V4L/DVB (10425): gspca - sonixj: Bad initialization of sensor mt9v111.
      V4L/DVB (10427): gspca - sonixj: Sensor sp80708 added for webcam 0c45:6143.
      V4L/DVB (10428): gspca - sonixj: Specific gamma tables per sensor.
      V4L/DVB (10429): gspca - sonixj: Simplify the probe of the sensors mi0360/mt9v111.
      V4L/DVB (10430): gspca - sonixj: Adjust some exchanges with the sensor mt9v111.
      V4L/DVB (10431): gspca - vc032x: Bad revision for the webcam 041e:405b.
      V4L/DVB (10432): gspca - vc032x: Cleanup source, optimize and check i2c_write.
      V4L/DVB (10617): gspca - vc032x: Remove the vc0321 reset.
      V4L/DVB (10618): gspca - some drivers: Fix compilation warnings.
      V4L/DVB (10620): gspca - main: More checks of the device disconnection.
      V4L/DVB (10635): gspca - sonixj: No vertical flip control for mt9v111.
      V4L/DVB (10636): gspca - sonixj: Add autogain for ov7630/48 and vflip for ov7648.
      V4L/DVB (10637): gspca - t613: Bad sensor name in kernel trace when 'other' sensor.
      V4L/DVB (10638): gspca - t613: Bad debug level when displaying the sensor type.
      V4L/DVB (10679): gspca - sonixj: Handle the webcam 0c45:613c instead of sn9c102.
      V4L/DVB (10680): gspca - zc3xx: Bad probe of the ov7xxx sensors.
      V4L/DVB (10681): gspca - zc3xx: Bad probe of the ov7630c sensor.
      V4L/DVB (10787): gspca - mars: Bad webcam register values tied to saturation.
      V4L/DVB (10788): gspca - vc032x: Bad matrix for sensor mi1310_soc.
      V4L/DVB (11039): gspca - most jpeg subdrivers: Change the JPEG header creation.
      V4L/DVB (11040): gspca - most jpeg subdrivers: Have the JPEG quality settable.
      V4L/DVB (11103): gspca - main: May have isochronous transfers on altsetting 0
      V4L/DVB (11104): gspca - ov534: Bad frame pointer after adding the last packet
      V4L/DVB (11105): gspca - ov534: Adjust the packet scan function
      V4L/DVB (11106): gspca - ov534: New sensor ov965x and re-enable the webcam 06f8:3003
      V4L/DVB (11143): gspca - t613: Bad sensor detection.
      V4L/DVB (11144): gspca - t613: Don't re-read the ID registers at probe time.
      V4L/DVB (11145): gspca - t613: Greater delay after om6802 reset.
      V4L/DVB (11146): gspca - vc032x: Change the probe sequence.
      V4L/DVB (11209): gspca - vc032x: New sensor mi1320_soc and webcam 15b8:6001 added.
      V4L/DVB (11211): gspca - vc032x: Simplify the i2c write function.
      V4L/DVB (11212): gspca - vc032x: Use YVYU format for sensor mi1320_soc.
      V4L/DVB (11218): gspca - sq905: Update the frame pointer after adding the last packet.
      V4L/DVB (11219): gspca - sq905: Optimize the resolution setting.
      V4L/DVB (11220): gspca - finepix: Use a workqueue for streaming.
      V4L/DVB (11223): gspca - doc: Add the 15b8:6001 webcam to the Documentation.

Jochen Friedrich (2):
      V4L/DVB (10452): Add Freescale MC44S803 tuner driver
      V4L/DVB (10453): af9015: add MC44S803 support

Jose Alberto Reguero (1):
      V4L/DVB (10330): af9015: New remote RM-KS for Avermedia Volar-X

Klaus Flittner (1):
      V4L/DVB (11290): Add Elgato EyeTV DTT to dibcom driver

Kuninori Morimoto (8):
      V4L/DVB (10616): tw9910: color format check is added on set_fmt
      V4L/DVB (10666): ov772x: move configuration from start_capture() to set_fmt()
      V4L/DVB (10667): ov772x: setting method to register is changed.
      V4L/DVB (10668): ov772x: bit mask operation fix on ov772x_mask_set.
      V4L/DVB (10669): ov772x: Add image flip support
      V4L/DVB (10670): tw9910: bit mask operation fix on tw9910_mask_set.
      V4L/DVB (10671): sh_mobile_ceu: SOCAM flags are not platform dependent
      V4L/DVB (11028): ov772x: use soft sleep mode in stop_capture

Kyle Guinn (3):
      V4L/DVB (10365): Add Mars-Semi MR97310A format
      V4L/DVB (10366): gspca - mr97310a: New subdriver.
      V4L/DVB (10369): gspca - mr97310a: Fix camera initialization copy/paste bugs.

Laurent Pinchart (8):
      V4L/DVB (10293): uvcvideo: replace strn{cpy,cat} with strl{cpy,cat}.
      V4L/DVB (10294): uvcvideo: Add support for the Alcor Micro AU3820 chipset.
      V4L/DVB (10295): uvcvideo: Retry URB buffers allocation when the system is low on memory.
      V4L/DVB (10296): uvcvideo: Fix memory leak in input device handling
      V4L/DVB (10650): uvcvideo: Initialize streaming parameters with the probe control value
      V4L/DVB (10651): uvcvideo: Ignore empty bulk URBs
      V4L/DVB (10652): uvcvideo: Add quirk to override wrong bandwidth value for Vimicro devices
      V4L/DVB (11292): uvcvideo: Add support for Syntek cameras found in JAOtech Smart Terminals

Lierdakil (1):
      V4L/DVB (10388): gspca - pac207: Webcam 093a:2474 added.

Magnus Damm (2):
      V4L/DVB (10304): buf-dma-contig: fix USERPTR free handling
      V4L/DVB (11029): video: use videobuf_waiton() in sh_mobile_ceu free_buffer()

Martin Fuzzey (1):
      V4L/DVB (10945): pwc : fix LED and power setup for first open

Matthias Schwarzott (4):
      V4L/DVB (10662): remove redundant memset after kzalloc
      V4L/DVB (10822): Add support for Zarlink ZL10036 DVB-S tuner.
      V4L/DVB (10823): saa7134: add DVB support for Avermedia A700 cards
      V4L/DVB (10948): flexcop-pci: Print a message in case the new stream watchdog detects a problem

Mauro Carvalho Chehab (49):
      V4L/DVB (10211): vivi: Implements 4 inputs on vivi
      V4L/DVB (10298): remove err macro from few usb devices
      V4L/DVB (10305): videobuf-vmalloc: Fix: videobuf memory were never freed
      V4L/DVB (10394): KWorld ATSC 115 all static
      V4L/DVB (10404): saa7134-core: remove oss option, since saa7134-oss doesn't exist anymore
      V4L/DVB (10405): saa7134-core: loading saa7134-alsa is now the default
      V4L/DVB (10504): tda827x: Be sure that gate will be open/closed at the proper time
      V4L/DVB (10505): tda8290: Print an error if i2c_gate is not provided
      V4L/DVB (10506): saa7134: move tuner init code to saa7134-cards
      V4L/DVB (10507): saa7134: Fix analog mode on devices that need to open an i2c gate
      V4L/DVB (10508): saa7134: Cleanup: remove unused waitqueue from struct
      V4L/DVB (10509): saa7134-video: two int controls lack a step
      V4L/DVB (10511): saa7134: get rid of KBL
      V4L/DVB (10512): tda1004x: Fix eeprom firmware load on boards with 16MHz Xtal
      V4L/DVB (10514): em28xx: Add support for Kaiomy TVnPC U2 stick
      V4L/DVB (10515): Adds IR table for the IR provided with this board and includes it at
      V4L/DVB (10516): em28xx: Add support for Easy Cap Capture DC-60
      V4L/DVB (10570): v4l2-framework: documments videobuf usage on drivers
      V4L/DVB (10571): v4l2-framework.txt: Fixes the videobuf init functions
      V4L/DVB (10654): em28xx: VideoMate For You USB TV box requires tvaudio
      V4L/DVB (10738): Get rid of video_decoder.h header were uneeded
      V4L/DVB(10738a): remove include/linux/video_encoder.h
      V4L/DVB (10769): Update dependencies of the modules converted to V4L2
      V4L/DVB (10771): tea575x-tuner: convert it to V4L2 API
      V4L/DVB (10835): Kconfig: Add some missing selects for a required frontends
      V4L/DVB (10836): Kconfig: replace DVB_FE_CUSTOMIZE to DVB_FE_CUSTOMISE
      V4L/DVB (10837): Kconfig: only open the customise menu if selected
      V4L/DVB (10838): get rid of the other occurrences of DVB_FE_CUSTOMIZE typo
      V4L/DVB (10840): em28xx-dvb: Remove an unused header
      V4L/DVB (10842): Adds some missing frontend selects for saa7134 and dvb-usb
      V4L/DVB (10870): v4l2-ioctl: get rid of video_decoder.h
      V4L/DVB (10896): /frontends/Kconfig: Move af9013 Kconfig option to its proper place
      V4L/DVB (10897): Fix Kbuild MEDIA_TUNER_CUSTOMIZE dependencies
      V4L/DVB (10870a): remove all references for video_decoder.h
      V4L/DVB (10907): avoid loading the entire videodev.h header on V4L2 drivers
      V4L/DVB (10951): xc5000: Fix CodingStyle errors introduced by the last patch
      V4L/DVB (10908): videobuf-core: also needs a minimal subset of V4L1 header
      V4L/DVB (11108): get_dvb_firmware: Add option to download firmware for cx231xx
      V4L/DVB (11109): au0828: Fix compilation when VIDEO_ADV_DEBUG = n
      V4L/DVB (11110): au8522/au0828: Fix Kconfig dependencies
      V4L/DVB (11111): dvb_dummy_fe: Fix compilation breakage
      V4L/DVB (11127): Kconfig: replace all occurrences of CUSTOMIZE to CUSTOMISE
      V4L/DVB (11136): get_dvb_firmware: Add download code for cx18 firmwares
      V4L/DVB (11137): get_dvb_firmware: add cx23885 firmwares
      V4L/DVB (11138): get_dvb_firmware: add support for downloading the cx2584x firmware for pvrusb2
      V4L/DVB (11225): v4lgrab: fix compilation warnings
      V4L/DVB (11226): avoid warnings for request_ihex_firmware on dabusb and vicam
      V4L/DVB (11227): ce6230: avoid using unitialized var
      V4L/DVB (11308): msp3400: use the V4L2 header since no V4L1 code is there

Michael Krufky (36):
      V4L/DVB (10415): dib0700: add data debug to dib0700_i2c_xfer_new
      V4L/DVB (10416): tveeprom: update to include Hauppauge tuners 151-155
      V4L/DVB (10417): sms1xxx: add missing usb id 2040:2011
      V4L/DVB (10746): sms1xxx: enable rf switch on Hauppauge Tiger devices
      V4L/DVB (10747): sms1xxx: move definition of struct smsdvb_client_t into smsdvb.c
      V4L/DVB (10749): sms1xxx: move smsusb_id_table into smsusb.c
      V4L/DVB (10751): sms1xxx: fix checkpatch.pl violations introduced by previous changeset
      V4L/DVB (10752): sms1xxx: load smsdvb module automatically based on device id
      V4L/DVB (10753): siano: convert EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
      V4L/DVB (10772): siano: prevent duplicate variable declaration
      V4L/DVB (10779): mxl5007t: remove analog tuning code
      V4L/DVB (10780): mxl5007t: remove function mxl5007t_check_rf_input_power
      V4L/DVB (10781): mxl5007t: mxl5007t_get_status should report if tuner is locked
      V4L/DVB (10782): mxl5007t: warn when unknown revisions are detected
      V4L/DVB (10783): mxl5007t: fix devname for hybrid_tuner_request_state
      V4L/DVB (10784): mxl5007t: update driver for MxL 5007T V4
      V4L/DVB (10876): tda18271: add support for AGC configuration via tuner callback
      V4L/DVB (10877): saa7134: add analog support for Hauppauge HVR1110r3 boards
      V4L/DVB (10898): remove build-time dependencies on dib7000m
      V4L/DVB (10899): remove build-time dependencies on dib7000p
      V4L/DVB (10900): remove build-time dependencies on dib3000mc
      V4L/DVB (10901): cleanup linewraps in dib7000p.h
      V4L/DVB (10902): cleanup linewraps in dib7000m.h
      V4L/DVB (10903): cleanup linewraps in dib3000mc.h
      V4L/DVB (10904): remove dib0070_ctrl_agc_filter from dib0070.h
      V4L/DVB (10905): dib0700: enable DVB_FE_CUSTOMISE for dibcom frontends
      V4L/DVB (10923): saa7134: fix typo in product name
      V4L/DVB (10924): saa7134: enable serial transport streaming interface
      V4L/DVB (10925): add support for LG Electronics LGDT3305 ATSC/QAM-B Demodulator
      V4L/DVB (10926): saa7134: enable digital tv support for Hauppauge WinTV-HVR1120
      V4L/DVB (10927): dib0700: add support for Hauppauge ATSC MiniCard
      V4L/DVB (10968): lgdt3305: add email address to MODULE_AUTHOR
      V4L/DVB (10969): lgdt3305: add missing space in comment
      V4L/DVB (10970): lgdt3305: add MODULE_VERSION
      V4L/DVB (10984): lgdt3305: avoid OOPS in error path of lgdt3305_attach
      V4L/DVB (11251): tuner: prevent invalid initialization of t->config in set_type

Mike Isely (62):
      V4L/DVB (10236): pvrusb2: Stop advertising VBI capability - it isn't there
      V4L/DVB (10237): pvrusb2: Generate a device-unique identifier
      V4L/DVB (10238): pvrusb2: Change sysfs serial number handling
      V4L/DVB (10239): pvrusb2: Fix misleading comment caused by earlier commit
      V4L/DVB (10258): pvrusb2: Issue VIDIOC_INT_INIT to v4l2 modules when they first attach
      V4L/DVB (10259): pvrusb2: Code module name directly in printk
      V4L/DVB (10303): pvrusb2: Use usb_make_path() to determine device bus location
      V4L/DVB (11154): pvrusb2: Split i2c module handling from i2c adapter
      V4L/DVB (11155): pvrusb2: Set up v4l2_device instance
      V4L/DVB (11156): pvrusb2: Changes to further isolate old i2c layer
      V4L/DVB (11157): pvrusb2: whitespace trivial tweaks
      V4L/DVB (11158): pvrusb2: New device attribute mechanism to specify sub-devices
      V4L/DVB (11159): pvrusb2: Providing means to stop tracking an old i2c module
      V4L/DVB (11160): pvrusb2: whitespace tweaks
      V4L/DVB (11161): pvrusb2: Set i2c autoprobing to be off by default
      V4L/DVB (11162): pvrusb2: Tie up loose ends with v4l2-subdev setup
      V4L/DVB (11163): pvrusb2: Lay foundation for triggering sub-device updates
      V4L/DVB (11164): pvrusb2: Tie-in sub-device log requests
      V4L/DVB (11165): pvrusb2: Tie in debug register access to sub-devices
      V4L/DVB (11166): pvrusb2: Implement status fetching from sub-devices
      V4L/DVB (11167): pvrusb2: Tie in various v4l2 operations into the sub-device mechanism
      V4L/DVB (11168): pvrusb2: Define value for a null sub-device ID
      V4L/DVB (11169): pvrusb2: Note who our video decoder sub-device is, and set it up
      V4L/DVB (11170): pvrusb2: Clean-up / placeholders inserted for additional development
      V4L/DVB (11171): pvrusb2: Tie in sub-device decoder start/stop
      V4L/DVB (11172): pvrusb2: Cause overall initialization to fail if sub-driver(s) fail
      V4L/DVB (11173): pvrusb2: Fix backwards function header comments
      V4L/DVB (11174): pvrusb2: Implement reporting of connected sub-devices
      V4L/DVB (11175): pvrusb2: Implement sub-device specific update framework
      V4L/DVB (11176): pvrusb2: Tie in wm8775 sub-device handling
      V4L/DVB (11177): pvrusb2: Tie in saa7115 sub-device handling
      V4L/DVB (11178): pvrusb2: Make audio sample rate update into a sub-device broadcast
      V4L/DVB (11179): pvrusb2: make sub-device specific update function names uniform
      V4L/DVB (11180): pvrusb2: Tie in msp3400 sub-device support
      V4L/DVB (11181): pvrusb2: Fix silly 80 column issue
      V4L/DVB (11182): pvrusb2: Tie in cx25840 sub-device support
      V4L/DVB (11183): pvrusb2: Implement more sub-device loading trace and improve error handling
      V4L/DVB (11184): pvrusb2: Define default i2c address for wm8775 sub-device
      V4L/DVB (11185): pvrusb2: Fix uninitialized counter
      V4L/DVB (11186): pvrusb2: Fix bugs involved in listing of sub-devices
      V4L/DVB (11187): pvrusb2: Allow sub-devices to insert correctly
      V4L/DVB (11188): pvrusb2: Sub-device update must happen BEFORE state dirty bits are cleared
      V4L/DVB (11189): pvrusb2: Deal with space-after-comma coding style idiocy
      V4L/DVB (11190): pvrusb2: Broadcast tuner type change to sub-devices
      V4L/DVB (11191): pvrusb2: Define default I2C address for cx25840 sub-device
      V4L/DVB (11192): pvrusb2: Implement trace print for stream on / off action
      V4L/DVB (11193): pvrusb2: Correct some trace print inaccuracies
      V4L/DVB (11194): pvrusb2: Implement mechanism to force a full sub-device update
      V4L/DVB (11195): pvrusb2: Issue required core init broadcast to all sub-devices
      V4L/DVB (11196): pvrusb2: Define default I2C addresses for msp3400 and saa7115 sub-devices
      V4L/DVB (11197): pvrusb2: Fix incorrectly named sub-device ID
      V4L/DVB (11198): pvrusb2: Define default I2C address for CS53L32A sub-device
      V4L/DVB (11199): pvrusb2: Convert all device definitions to use new sub-device declarations
      V4L/DVB (11200): pvrusb2: Make a bunch of dvb config structures const (trivial)
      V4L/DVB (11201): pvrusb2: Fix space-after-comma idiocy
      V4L/DVB (11202): pvrusb2: Fix slightly mis-leading header in debug interface output
      V4L/DVB (11203): pvrusb2: Implement better reporting on attached sub-devices
      V4L/DVB (11204): pvrusb2: Remove old i2c layer; we use v4l2-subdev now
      V4L/DVB (11205): pvrusb2: Remove ancient IVTV specific ioctl functions
      V4L/DVB (11206): pvrusb2: Add sub-device for demod
      V4L/DVB (11207): pvrusb2: Add composite and s-video input support for OnAir devices
      V4L/DVB (11208): pvrusb2: Use v4l2_device_disconnect()

Márton Németh (2):
      V4L/DVB (10633): DAB: fix typo
      V4L/DVB (11293): uvcvideo: Add zero fill for VIDIOC_ENUM_FMT

Nam Phạm Thành (1):
      V4L/DVB (10242): pwc: add support for webcam snapshot button

Nicola Soranzo (2):
      V4L/DVB (10525): em28xx: Coding style fixes and a typo correction
      V4L/DVB (10555): em28xx: CodingStyle fixes

Oldřich Jedlička (1):
      V4L/DVB (10632): Added support for AVerMedia Cardbus Hybrid remote control

Oliver Endriss (1):
      V4L/DVB (10843): saa7146: Clean-up i2c error handling

Pascal Terjan (1):
      V4L/DVB (10825): Add ids for Yuan PD378S DVB adapter

Patrick Boettcher (2):
      V4L/DVB (11284): Fix i2c code of flexcop-driver for rare revisions
      V4L/DVB (11285): Remove unecessary udelay

Philippe Rétornaz (1):
      V4L/DVB (11035): mt9t031 bugfix

Randy Dunlap (4):
      V4L/DVB (10631): zoran: fix printk format
      V4L/DVB (10830): dm1105: uses ir_* functions, select VIDEO_IR
      V4L/DVB (10846): dvb/frontends: fix duplicate 'debug' symbol
      V4L/DVB (11237): media/zoran: fix printk format

Robert Krakora (3):
      V4L/DVB (10255): em28xx: Clock (XCLK) Cleanup
      V4L/DVB (10518): em28xx: Fix for em28xx memory leak and function rename
      V4L/DVB (10519): em28xx: Fix for em28xx audio startup

Robert Millan (1):
      V4L/DVB (10944): Conceptronic CTVFMI2 PCI Id

Roel Kluin (3):
      V4L/DVB (10629): tvp514x: try_count reaches 0, not -1
      V4L/DVB: calibration still successful at 10
      V4L/DVB (10657): [PATCH] V4L: missing parentheses?

Sascha Hauer (5):
      V4L/DVB (11030): soc-camera: add board hook to specify the buswidth for camera sensors
      V4L/DVB (11031): pcm990 baseboard: add camera bus width switch setting
      V4L/DVB (11032): mt9m001: allow setting of bus width from board code
      V4L/DVB (11033): mt9v022: allow setting of bus width from board code
      V4L/DVB (11034): soc-camera: remove now unused gpio member of struct soc_camera_link

Scott James Remnant (1):
      V4L/DVB (10947): Auto-load videodev module when device opened.

Sebastian Andrzej Siewior (1):
      V4L/DVB (10655): tvp514x: make the module aware of rich people

Sergio Aguirre (1):
      V4L/DVB (10575): V4L2: Add COLORFX user control

Sri Deevi (1):
      V4L/DVB (10950): xc5000: prepare it to be used by cx231xx module

Stephan Wienczny (1):
      V4L/DVB (10949): Add support for Terratec Cinergy HT PCI MKII

Steven Toth (1):
      V4L/DVB (11296): cx23885: bugfix error message if firmware is not found

Stoyan Gaydarov (1):
      V4L/DVB (11235): changed ioctls to unlocked

Theodore Kilgore (2):
      V4L/DVB (10986): mr97310a: don't discard frame headers on stream output
      V4L/DVB (11213): gspca - sq905c: New subdriver.

Thierry MERLE (5):
      V4L/DVB (10306): usbvision: use usb_make_path to report bus info
      V4L/DVB (10307): em28xx: use usb_make_path to report bus info
      V4L/DVB (10308): uvcvideo: use usb_make_path to report bus info
      V4L/DVB (10309): s2255drv: use usb_make_path to report bus info
      V4L/DVB (10379): gspca - main: Use usb_make_path() for VIDIOC_QUERYCAP.

Tim Farrington (1):
      V4L/DVB (10574): saa7134: fix Avermedia E506R composite input

Tobias Klauser (1):
      V4L/DVB (10628): V4L: Storage class should be before const qualifier

Tobias Lorenz (3):
      V4L/DVB (10530): Documentation and code cleanups
      V4L/DVB (10531): Code rearrangements in preparation for other report types
      V4L/DVB (10534): Output HW/SW version from scratchpad

Trent Piepho (41):
      V4L/DVB (10558): bttv: norm value should be unsigned
      V4L/DVB (10559): bttv: Fix TDA9880 norm setting code
      V4L/DVB (10560): bttv: make tuner card info more consistent
      V4L/DVB (10561): bttv: store card database more efficiently
      V4L/DVB (10562): bttv: rework the way digital inputs are indicated
      V4L/DVB (10563): bttv: clean up mux code for IVC-120G
      V4L/DVB (10564): bttv: fix external mux for PHYTEC VD-009
      V4L/DVB (10565): bttv: fix external mux for RemoteVision MX
      V4L/DVB (10566): bttv: clean up mux code for IDS Eagle
      V4L/DVB (10567): bttv: shrink muxsel data in card database
      V4L/DVB (10568): bttv: dynamically allocate device data
      V4L/DVB (10791): videodev: not possible to register NULL video_device
      V4L/DVB (10792): cx88: remove unnecessary forward declaration of cx88_core
      V4L/DVB (10794): v4l2: Move code to zero querybuf output struct to v4l2_ioctl
      V4L/DVB (10811): videodev: only copy needed part of RW ioctl's parameter
      V4L/DVB (10812): v4l2: Zero out read-only ioctls in one place
      V4L/DVB (10813): v4l2: New function v4l2_video_std_frame_period
      V4L/DVB (10814): saa7146: some small fixes
      V4L/DVB (10815): bttv: Don't need to zero ioctl parameter fields
      V4L/DVB (10816): cx88: Don't need to zero ioctl parameter fields
      V4L/DVB (10817): stkwebcam: Don't need to zero ioctl parameter fields
      V4L/DVB (10818): usbvision: Don't need to zero ioctl parameter fields
      V4L/DVB (10819): gspca: Don't need to zero ioctl parameter fields
      V4L/DVB (10820): meye: Don't need to zero ioctl parameter fields
      V4L/DVB (10848): zoran: Change first argument to zoran_v4l2_buffer_status
      V4L/DVB (10930): zoran: Unify buffer descriptors
      V4L/DVB (10933): zoran: Pass zoran_fh pointers instead of file pointers
      V4L/DVB (10934): zoran: replace functions names in strings with __func__
      V4L/DVB (11260): v4l2-ioctl:  Check format for S_PARM and G_PARM
      V4L/DVB (11261): saa7146: Remove buffer type check from vidioc_g_parm
      V4L/DVB (11262): bttv: Remove buffer type check from vidioc_g_parm
      V4L/DVB (11263): gspca: Stop setting buffer type, and avoid memset in querycap
      V4L/DVB (11264): omap24xxcam: Remove buffer type check from vidioc_s/g_parm
      V4L/DVB (11265): stkwebcam: Remove buffer type check from g_parm and q/dq/reqbufs
      V4L/DVB (11266): vino: Remove code for things already done by video_ioctl2
      V4L/DVB (11267): cafe_ccic: Remove buffer type check from XXXbuf
      V4L/DVB (11268): cx23885-417: Don't need to zero ioctl parameter fields
      V4L/DVB (11269): cx88-blackbird: Stop setting buffer type in XXX_fmt_vid_cap
      V4L/DVB (11270): meye: Remove buffer type checks from XXX_fmt_vid_cap, XXXbuf
      V4L/DVB (11271): usbvision: Remove buffer type checks from enum_fmt_vid_cap, XXXbuf
      V4L/DVB (11272): zr364xx: Remove code for things already done by video_ioctl2

Uri Shkolnik (2):
      V4L/DVB (10748): sms1xxx: restore smsusb_driver.name to smsusb
      V4L/DVB (10750): import changes from Siano

Uwe Bugla (2):
      V4L/DVB (11287): Code cleanup (passes checkpatch now) of the b2c2-flexcop-drivers 1/2
      V4L/DVB (11288): Code cleanup (passes checkpatch now) of the b2c2-flexcop-drivers 2/2

Vitaly Wool (1):
      V4L/DVB (10833): em28xx: enable Compro VideoMate ForYou sound

Xoan Loureiro (1):
      V4L/DVB (11289): Patch for Yuan MC770 DVB-T (1164:0871)

klaas de waal (1):
      V4L/DVB (11236): tda827x: fix locking issues with DVB-C

sebastian.blanes@gmail.com (1):
      V4L/DVB (10824): Add "Sony PlayTV" to dibcom driver

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
