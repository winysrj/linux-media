Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004AbZIOCcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 22:32:50 -0400
Date: Mon, 14 Sep 2009 23:32:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.32] V4L/DVB updates
Message-ID: <20090914233239.5dd6f5c8@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the first set of patches for 2.6.32. During this cycle, we avoided to make
lots of changes at core, in order to have the system more stable, since there
were lots of internal API changes merged during 2.6.31 window. 

In summary, this series have:
  - New tuner/frontend driver for ce5039/zl10039;
  - New webcam driver: jeilinj;
  - radio si4713 were broken into a common part and an usb part, to 
    allow its usage with some different devices;
  - IR standardization: use a more uniform mapping for IR keys along different
    video boards;
  - dvb-usb: allow dynamic IR key table replacement;
  - As usual, lots of cleanups, new board additions, driver improvements
    and fixes.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.cx23885       |    2 +
 Documentation/video4linux/CARDLIST.cx88          |    1 +
 Documentation/video4linux/CARDLIST.em28xx        |    5 +-
 Documentation/video4linux/CARDLIST.saa7134       |    4 +
 Documentation/video4linux/CARDLIST.tuner         |    1 +
 Documentation/video4linux/CQcam.txt              |    4 +-
 Documentation/video4linux/gspca.txt              |    6 +
 Documentation/video4linux/si4713.txt             |  176 +
 drivers/media/common/ir-functions.c              |   15 +-
 drivers/media/common/ir-keymaps.c                | 5022 ++++++++++++----------
 drivers/media/common/tuners/tda18271-fe.c        |   20 +-
 drivers/media/common/tuners/tda18271-priv.h      |   20 +-
 drivers/media/common/tuners/tda18271.h           |    3 +
 drivers/media/common/tuners/tuner-simple.c       |    6 +
 drivers/media/common/tuners/tuner-types.c        |   25 +
 drivers/media/dvb/Kconfig                        |   13 +
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c        |  218 +-
 drivers/media/dvb/bt8xx/dst.c                    |    2 +-
 drivers/media/dvb/dm1105/dm1105.c                |  150 +-
 drivers/media/dvb/dvb-core/dmxdev.c              |  231 +-
 drivers/media/dvb/dvb-core/dmxdev.h              |    9 +-
 drivers/media/dvb/dvb-core/dvb_demux.c           |    8 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c        |   35 +-
 drivers/media/dvb/dvb-core/dvbdev.h              |    5 +
 drivers/media/dvb/dvb-usb/Kconfig                |    6 +-
 drivers/media/dvb/dvb-usb/a800.c                 |   68 +-
 drivers/media/dvb/dvb-usb/af9005-remote.c        |   76 +-
 drivers/media/dvb/dvb-usb/af9015.c               |   20 +-
 drivers/media/dvb/dvb-usb/af9015.h               |  460 +-
 drivers/media/dvb/dvb-usb/anysee.c               |   92 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c       |   74 +-
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c         |    1 +
 drivers/media/dvb/dvb-usb/cxusb.c                |  260 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c      |  387 +-
 drivers/media/dvb/dvb-usb/dibusb-common.c        |  244 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c            |   10 +-
 drivers/media/dvb/dvb-usb/digitv.c               |  114 +-
 drivers/media/dvb/dvb-usb/dtt200u.c              |   36 +-
 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c          |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h          |    6 +
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c       |   73 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h              |   17 +-
 drivers/media/dvb/dvb-usb/dw2102.c               |  403 ++-
 drivers/media/dvb/dvb-usb/m920x.c                |   68 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c          |   97 +-
 drivers/media/dvb/dvb-usb/opera1.c               |   55 +-
 drivers/media/dvb/dvb-usb/vp702x.c               |    6 +-
 drivers/media/dvb/dvb-usb/vp7045.c               |  102 +-
 drivers/media/dvb/firewire/firedtv-avc.c         |  143 +-
 drivers/media/dvb/frontends/Kconfig              |    7 +
 drivers/media/dvb/frontends/Makefile             |    1 +
 drivers/media/dvb/frontends/cx22700.c            |    2 +-
 drivers/media/dvb/frontends/cx24113.c            |    6 +-
 drivers/media/dvb/frontends/cx24123.c            |    2 +-
 drivers/media/dvb/frontends/dib0070.c            |    2 +-
 drivers/media/dvb/frontends/dib7000p.c           |    2 +-
 drivers/media/dvb/frontends/dvb-pll.c            |   75 +
 drivers/media/dvb/frontends/dvb-pll.h            |    4 +
 drivers/media/dvb/frontends/lgs8gxx.c            |  484 ++-
 drivers/media/dvb/frontends/lgs8gxx.h            |   11 +-
 drivers/media/dvb/frontends/lgs8gxx_priv.h       |   12 +-
 drivers/media/dvb/frontends/mt312.c              |    7 +-
 drivers/media/dvb/frontends/stb6100.c            |    4 +-
 drivers/media/dvb/frontends/stv0900_core.c       |    8 +-
 drivers/media/dvb/frontends/stv0900_sw.c         |    2 +-
 drivers/media/dvb/frontends/stv6110.c            |   48 +-
 drivers/media/dvb/frontends/stv6110.h            |    2 +-
 drivers/media/dvb/frontends/tda10021.c           |    2 +-
 drivers/media/dvb/frontends/tda8261.c            |    4 +-
 drivers/media/dvb/frontends/ves1820.c            |    2 +-
 drivers/media/dvb/frontends/zl10036.c            |    2 +-
 drivers/media/dvb/frontends/zl10039.c            |  308 ++
 drivers/media/dvb/frontends/zl10039.h            |   40 +
 drivers/media/dvb/frontends/zl10353.c            |   14 +-
 drivers/media/dvb/pluto2/pluto2.c                |    2 +-
 drivers/media/dvb/ttpci/av7110_v4l.c             |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c              |    6 +-
 drivers/media/radio/Kconfig                      |   59 +-
 drivers/media/radio/Makefile                     |    4 +-
 drivers/media/radio/radio-cadet.c                |    6 +-
 drivers/media/radio/radio-si470x.c               | 1863 --------
 drivers/media/radio/radio-si4713.c               |  367 ++
 drivers/media/radio/si470x/Kconfig               |   37 +
 drivers/media/radio/si470x/Makefile              |    9 +
 drivers/media/radio/si470x/radio-si470x-common.c |  798 ++++
 drivers/media/radio/si470x/radio-si470x-i2c.c    |  401 ++
 drivers/media/radio/si470x/radio-si470x-usb.c    |  988 +++++
 drivers/media/radio/si470x/radio-si470x.h        |  225 +
 drivers/media/radio/si4713-i2c.c                 | 2060 +++++++++
 drivers/media/radio/si4713-i2c.h                 |  237 +
 drivers/media/video/Kconfig                      |    6 +-
 drivers/media/video/au0828/au0828-dvb.c          |    2 +-
 drivers/media/video/au0828/au0828-i2c.c          |    1 -
 drivers/media/video/bt8xx/bttv-cards.c           |    1 +
 drivers/media/video/bt8xx/bttv-driver.c          |   14 +-
 drivers/media/video/bt8xx/bttv-i2c.c             |    2 -
 drivers/media/video/bt8xx/bttv-input.c           |   27 +-
 drivers/media/video/cafe_ccic.c                  |    1 -
 drivers/media/video/cx18/cx18-cards.c            |    8 +-
 drivers/media/video/cx18/cx18-cards.h            |   18 +-
 drivers/media/video/cx18/cx18-driver.c           |   41 +-
 drivers/media/video/cx18/cx18-fileops.c          |    2 +-
 drivers/media/video/cx18/cx18-i2c.c              |   59 +-
 drivers/media/video/cx18/cx18-ioctl.c            |    2 +-
 drivers/media/video/cx231xx/cx231xx-conf-reg.h   |    8 +-
 drivers/media/video/cx231xx/cx231xx-i2c.c        |    1 -
 drivers/media/video/cx231xx/cx231xx-video.c      |    4 +-
 drivers/media/video/cx231xx/cx231xx.h            |    2 +-
 drivers/media/video/cx23885/cimax2.c             |    1 +
 drivers/media/video/cx23885/cx23885-417.c        |   57 +-
 drivers/media/video/cx23885/cx23885-cards.c      |   77 +-
 drivers/media/video/cx23885/cx23885-core.c       |   30 +-
 drivers/media/video/cx23885/cx23885-dvb.c        |   54 +-
 drivers/media/video/cx23885/cx23885-i2c.c        |    1 -
 drivers/media/video/cx23885/cx23885.h            |   14 +-
 drivers/media/video/cx25840/cx25840-core.c       |   15 +-
 drivers/media/video/cx25840/cx25840-firmware.c   |   48 +-
 drivers/media/video/cx88/cx88-cards.c            |   56 +-
 drivers/media/video/cx88/cx88-dvb.c              |   16 +-
 drivers/media/video/cx88/cx88-input.c            |   78 +-
 drivers/media/video/cx88/cx88.h                  |    1 +
 drivers/media/video/em28xx/em28xx-cards.c        |  115 +-
 drivers/media/video/em28xx/em28xx-i2c.c          |    1 -
 drivers/media/video/em28xx/em28xx-video.c        |  161 +-
 drivers/media/video/em28xx/em28xx.h              |    8 +-
 drivers/media/video/gspca/Kconfig                |   21 +-
 drivers/media/video/gspca/Makefile               |    2 +
 drivers/media/video/gspca/conex.c                |    2 +-
 drivers/media/video/gspca/etoms.c                |    4 +-
 drivers/media/video/gspca/gspca.c                |   66 +-
 drivers/media/video/gspca/gspca.h                |    5 +-
 drivers/media/video/gspca/jeilinj.c              |  388 ++
 drivers/media/video/gspca/m5602/m5602_s5k83a.c   |    4 +-
 drivers/media/video/gspca/mr97310a.c             |  853 ++++-
 drivers/media/video/gspca/pac207.c               |   37 +-
 drivers/media/video/gspca/pac7311.c              |    2 +
 drivers/media/video/gspca/sn9c20x.c              |  235 +-
 drivers/media/video/gspca/sonixj.c               |   40 +-
 drivers/media/video/gspca/spca501.c              |    2 +-
 drivers/media/video/gspca/spca506.c              |    2 +-
 drivers/media/video/gspca/spca508.c              |   59 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c      |    4 +-
 drivers/media/video/gspca/sunplus.c              |  386 +-
 drivers/media/video/gspca/t613.c                 |  210 +-
 drivers/media/video/gspca/tv8532.c               |    2 +-
 drivers/media/video/gspca/vc032x.c               | 1126 +++--
 drivers/media/video/gspca/zc3xx.c                |    2 +-
 drivers/media/video/hdpvr/hdpvr-control.c        |   24 +-
 drivers/media/video/hdpvr/hdpvr-core.c           |   12 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c            |    1 -
 drivers/media/video/hdpvr/hdpvr-video.c          |    6 +-
 drivers/media/video/ir-kbd-i2c.c                 |   64 +-
 drivers/media/video/ivtv/ivtv-cards.c            |   70 +-
 drivers/media/video/ivtv/ivtv-cards.h            |    3 +-
 drivers/media/video/ivtv/ivtv-driver.c           |    3 +-
 drivers/media/video/ivtv/ivtv-gpio.c             |   13 -
 drivers/media/video/ivtv/ivtv-i2c.c              |    2 -
 drivers/media/video/meye.c                       |    3 +-
 drivers/media/video/pvrusb2/pvrusb2-audio.c      |    5 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c   |    1 -
 drivers/media/video/pwc/pwc-if.c                 |   78 +-
 drivers/media/video/pwc/pwc-v4l.c                |    2 +-
 drivers/media/video/pwc/pwc.h                    |    7 +-
 drivers/media/video/saa6588.c                    |   60 +-
 drivers/media/video/saa7134/Kconfig              |    1 +
 drivers/media/video/saa7134/saa6752hs.c          |    2 +-
 drivers/media/video/saa7134/saa7134-alsa.c       |  242 +-
 drivers/media/video/saa7134/saa7134-cards.c      |  213 +-
 drivers/media/video/saa7134/saa7134-core.c       |    4 +-
 drivers/media/video/saa7134/saa7134-dvb.c        |   17 +-
 drivers/media/video/saa7134/saa7134-input.c      |  120 +-
 drivers/media/video/saa7134/saa7134-video.c      |    5 +-
 drivers/media/video/saa7134/saa7134.h            |    9 +
 drivers/media/video/sn9c102/sn9c102_devtable.h   |    2 +-
 drivers/media/video/stk-webcam.c                 |    1 -
 drivers/media/video/stv680.c                     |    9 +-
 drivers/media/video/tuner-core.c                 |    4 +-
 drivers/media/video/tveeprom.c                   |    4 +-
 drivers/media/video/uvc/uvc_ctrl.c               |  255 +-
 drivers/media/video/uvc/uvc_driver.c             |  570 ++-
 drivers/media/video/uvc/uvc_isight.c             |    7 +-
 drivers/media/video/uvc/uvc_v4l2.c               |  277 +-
 drivers/media/video/uvc/uvc_video.c              |  434 +-
 drivers/media/video/uvc/uvcvideo.h               |  278 +-
 drivers/media/video/v4l1-compat.c                |    5 +-
 drivers/media/video/v4l2-common.c                |   52 +
 drivers/media/video/v4l2-compat-ioctl32.c        |   67 +-
 drivers/media/video/v4l2-ioctl.c                 |   33 +-
 drivers/media/video/vino.c                       |    1 -
 drivers/media/video/w9968cf.c                    |    1 -
 drivers/media/video/zoran/zoran_card.c           |    3 +-
 drivers/media/video/zr364xx.c                    | 1226 +++++-
 include/linux/dvb/dmx.h                          |    2 +
 include/linux/usb/video.h                        |  164 +
 include/linux/videodev2.h                        |  105 +-
 include/media/ir-common.h                        |  138 +-
 include/media/ir-kbd-i2c.h                       |   22 +-
 include/media/radio-si4713.h                     |   30 +
 include/media/si4713.h                           |   49 +
 include/media/tuner.h                            |    1 +
 include/media/v4l2-subdev.h                      |    5 +
 201 files changed, 17261 insertions(+), 8751 deletions(-)
 create mode 100644 Documentation/video4linux/si4713.txt
 create mode 100644 drivers/media/dvb/frontends/zl10039.c
 create mode 100644 drivers/media/dvb/frontends/zl10039.h
 delete mode 100644 drivers/media/radio/radio-si470x.c
 create mode 100644 drivers/media/radio/radio-si4713.c
 create mode 100644 drivers/media/radio/si470x/Kconfig
 create mode 100644 drivers/media/radio/si470x/Makefile
 create mode 100644 drivers/media/radio/si470x/radio-si470x-common.c
 create mode 100644 drivers/media/radio/si470x/radio-si470x-i2c.c
 create mode 100644 drivers/media/radio/si470x/radio-si470x-usb.c
 create mode 100644 drivers/media/radio/si470x/radio-si470x.h
 create mode 100644 drivers/media/radio/si4713-i2c.c
 create mode 100644 drivers/media/radio/si4713-i2c.h
 create mode 100644 drivers/media/video/gspca/jeilinj.c
 create mode 100644 include/linux/usb/video.h
 create mode 100644 include/media/radio-si4713.h
 create mode 100644 include/media/si4713.h

Abylay Ospan (2):
      V4L/DVB (12311): Change clocking configuration and frequency for NetUP card.
      V4L/DVB (12312): stv0900: fix i2c repeater configuration must be set to manual

AceLan Kao (1):
      V4L/DVB (12352): gspca - vc032x: Fix mi1310_soc preview and LED

Aleksandr V. Piskunov (1):
      V4L/DVB (12485): zl10353: correct implementation of FE_READ_UNCORRECTED_BLOCKS

Andreas Oberritter (2):
      V4L/DVB (12275): Add two new ioctls: DMX_ADD_PID and DMX_REMOVE_PID
      V4L/DVB (12276): Remove a useless check from dvb_dmx_swfilter_packet()

Andrzej Hajda (1):
      V4L/DVB (12465): cx88: High resolution timer for Remote Controls

Andy Walls (10):
      V4L/DVB (12207): cx18: Add an EEPROM dump routine for the Yuan MPC718 and future cards
      V4L/DVB (12209): ivtv: Add card entry for AVerMedia UltraTV 1500 MCE (M113 variant)
      V4L/DVB (12210): ivtv: Fix automatic detection of AVerMedia UltraTV 1500MCE.
      V4L/DVB (12334): tuner-simple: Add an entry for the Partsnic PTI-5NF05 NTSC tuner
      V4L/DVB (12335): ivtv: Fix errors in AVerTV M113 card definitions and add a new M113 card
      V4L/DVB (12336): ivtv: Fix improper GPIO audio mux input switch on video standard change
      V4L/DVB (12366): ir-kbd-i2c: Allow use of ir-kdb-i2c internal get_key funcs and set ir_type
      V4L/DVB (12367): cx18: Add i2c initialization for Z8F0811/Hauppage IR transceivers
      V4L/DVB (12368): ir-kbd-i2c: Add support for Z8F0811/Hauppage IR transceivers
      V4L/DVB (12699): cx18: ir-kbd-i2c initialization data should point to a persistent object

Beholder Intl. Ltd. Dmitry Belimov (1):
      V4L/DVB (12419): Fix incorrect type of tuner for the BeholdTV H6 card

Brian Johnson (5):
      V4L/DVB (12351): gspca - sn9c20x: Misc fixes
      V4L/DVB (12704): gspca - sn9c20x: Fix exposure on SOI968 sensors
      V4L/DVB (12705): gspca - sn9c20x: Add SXGA support to SOI968
      V4L/DVB (12706): gspca - sn9c20x: disable exposure/gain controls for MT9M111 sensors.
      V4L/DVB (12707): gspca - sn9c20x: Add SXGA support to MT9M111

David T.L. Wong (1):
      V4L/DVB (12423): cxusb, d680 dmbth use unified lgs8gxx code instead of lgs8gl5

David Wong (2):
      V4L/DVB (12271): lgs8gxx: add lgs8g75 support
      V4L/DVB (12272): cx23885: add card Magic-Pro ProHDTV Extreme 2

Denis Loginov (1):
      V4L/DVB (12356): gspca - sonixj: Webcam 0c45:6148 added

Devin Heitmueller (1):
      V4L/DVB (12444): em28xx: add support for Terratec Cinergy Hybrid T USB XS remote control

Dmitri Belimov (4):
      V4L/DVB (12487): Fix control AC-3 of the 6752HS
      V4L/DVB (12488): Add RDS config for BeholdTV cards
      V4L/DVB (12573): FM1216MK5 FM radio
      V4L/DVB (12587): Add support BeholdTV X7 card

Dmitry Torokhov (1):
      V4L/DVB (12489): pwc - fix few use-after-free and memory leaks

Douglas Schilling Landgraf (2):
      V4L/DVB (12434): em28xx: fix empire auto-detect
      V4L/DVB (12720): em28xx-cards: Add vendor/product id for Kworld DVD Maker 2

Eberhard Mattes (1):
      V4L/DVB (12388): dvb-usb: fix tuning with Cinergy T2

Eduardo Valentin (6):
      V4L/DVB (12547): v4l2-subdev.h: Add g/s_modulator callbacks to subdev api
      V4L/DVB (12548): v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX controls
      V4L/DVB (12549): v4l2: video device: Add FM TX controls default configurations
      V4L/DVB (12551): FM TX: si4713: Add files to add radio interface for si4713
      V4L/DVB (12552): FM TX: si4713: Add files to handle si4713 i2c device
      V4L/DVB (12554): FM TX: si4713: Add document file

Eugene Yudin (1):
      V4L/DVB (12589): Add support for RoverMedia TV Link Pro FM

Guennadi Liakhovetski (1):
      V4L/DVB (12158): v4l: add cropping prototypes to struct v4l2_subdev_video_ops

Hans Verkuil (14):
      V4L/DVB (12212): v4l2: add RDS API to videodev2.h
      V4L/DVB (12214): bttv: set RDS capability if applicable.
      V4L/DVB (12215): saa6588: conform to the final RDS spec.
      V4L/DVB (12216): saa7134: set RDS capability if applicable.
      V4L/DVB (12217): radio-cadet: conform to the RDS spec.
      V4L/DVB (12218): radio-si470x: conform to the RDS spec.
      V4L/DVB (12316): v4l: add V4L2_CAP_RDS_OUTPUT and V4L2_CAP_MODULATOR caps
      V4L/DVB (12426): pvrusb2: fix compile warning
      V4L/DVB (12427): cx24113: fix mips compiler warning
      V4L/DVB (12455): radio-typhoon: remove obsolete RADIO_TYPHOON_PROC_FS config option
      V4L/DVB (12543): v4l: introduce string control support.
      V4L/DVB (12553): FM TX: si4713: Add Kconfig and Makefile entries
      V4L/DVB (12612): si4713: simplify the code to remove a compiler warning.
      V4L/DVB (12613): cx25840: fix determining the firmware name

Hans de Goede (12):
      V4L/DVB (12357): gspca - tv8532: Bad ISOC packet scan
      V4L/DVB (12616): gspca_pac207: remove a number of unneeded (repeated) register writes
      V4L/DVB (12617): gspca_pac207: enable higher framerates / lower exposure settings
      V4L/DVB (12619): gspca: mr97310a fix detection of sensortype for vivicam with id byte of 0x53
      V4L/DVB (12620): gspca_mr97310a: cleanup/fixup control handling
      V4L/DVB (12621): gspca_mr97310a: Move detection of CIF sensor type to probe() function
      V4L/DVB (12622): gspca_mr97310a: make the probing a bit less chatty
      V4L/DVB (12623): gspca_mr97310a: Add controls for CIF type 0 sensor cams
      V4L/DVB (12624): gspca_mr97310a: Use correct register for CIF type 1 sensor gain settings
      V4L/DVB (12625): Add new V4L2_FMT_FLAG_EMULATED flag to videodev2.h
      V4L/DVB (12626): gspca_mr97310a: Allow overriding of detected sensor type
      V4L/DVB (12627): gspca_mr97310a: Add one more vivitar mini cam to the list of CIF cams

Henrik Kurelid (2):
      V4L/DVB (12482): firedtv: add PID filtering for SW zigzag retune
      V4L/DVB (12582): The current AVC debugging can clog the log down a lot since many

Igor M. Liplianin (9):
      V4L/DVB (12309): Add output clock configuration for stv6110 tuner.
      V4L/DVB (12310): stv6110 tuner: remove unused iq_wiring configuration parameter.
      V4L/DVB (12313): stv6110: Read registers through one time i2c_transfer calling
      V4L/DVB (12314): cx23885: add CAM presence checkout
      V4L/DVB (12332): Create card parameters array in SDMC DM1105 driver
      V4L/DVB (12461): Add ce5039(zl10039) tuner support.
      V4L/DVB (12462): Add TeVii S630 USB DVB-S card support.
      V4L/DVB (12463): Add support for Compro VideoMate S350 DVB-S PCI card.
      V4L/DVB (12486): cx88: fix TBS 8920 card support

James A Webb (1):
      V4L/DVB (12584): Support for Kaiser Baas ExpressCard Dual HD Tuner

Jan Nikitenko (1):
      V4L/DVB (12342): af9015: avoid magically sized temporary buffer in eeprom_dump

Janne Grunau (3):
      V4L/DVB (12684): DVB: make DVB_MAX_ADAPTERS configurable
      V4L/DVB (12685): dvb-core: check fe->ops.set_frontend return value
      V4L/DVB (12686): dvb-core: check supported QAM modulations

Jean Delvare (2):
      V4L/DVB (12343): Stop defining I2C adapter IDs nobody uses
      V4L/DVB (12365): ir-kbd-i2c: Remove superfulous inlines

Jean-Francois Moine (19):
      V4L/DVB (12226): gspca - spca508: Extend the write_vector routine.
      V4L/DVB (12227): gspca - pac7311: Webcam 093a:2629 added.
      V4L/DVB (12228): gspca - vc032x: Webcam 0ac8:c301 added.
      V4L/DVB (12229): gspca - main: Change the ISOC initialization mechanism.
      V4L/DVB (12230): gspca - t613: Change tas5130a init sequences.
      V4L/DVB (12231): gspca - main: Version change.
      V4L/DVB (12280): gspca - sonixj: Remove auto gain/wb/expo for the ov7660 sensor.
      V4L/DVB (12353): gspca - vc032x: Add the 1280x960 resolution for sensor mi1310_soc
      V4L/DVB (12354): gspca - vc032x: H and V flip controls added for mi13x0_soc sensors
      V4L/DVB (12355): gspca - vc032x: Cleanup source
      V4L/DVB (12358): gspca - main: Memorize the current alt before setting it
      V4L/DVB (12383): gspca - vc032x: Bad h/v flip controls when inverted by default.
      V4L/DVB (12501): gspca - sonixj: Do the ov7660 sensor work again.
      V4L/DVB (12691): gspca - sonixj: Don't use mdelay().
      V4L/DVB (12692): gspca - sunplus: Optimize code.
      V4L/DVB (12693): gspca - sunplus: The brightness is signed.
      V4L/DVB (12694): gspca - vc032x: Change the start exchanges of the sensor hv7131r.
      V4L/DVB (12695): gspca - vc032x: Do the LED work with the sensor hv7131r.
      V4L/DVB (12696): gspca - sonixj / sn9c102: Two drivers for 0c45:60fc and 0c45:613e.

Jiri Slaby (2):
      V4L/DVB (12372): saa7134: fix lock imbalance
      V4L/DVB (12373): hdpvr: fix lock imbalances

Joe Perches (5):
      V4L/DVB (12196): cx18-fileops.c: Remove unnecessary semicolons
      V4L/DVB (12197): Remove unnecessary semicolons
      V4L/DVB (12198): ivtv-driver.c: Remove unnecessary semicolons
      V4L/DVB (12204): bttv and meye: Use PCI_VDEVICE
      V4L/DVB (12703): gspca - sn9c20x: Reduces size of object

Johannes Goerner (1):
      V4L/DVB (12281): gspca - sunplus: Webcam 052b:1803 added.

Joonyoung Shim (4):
      V4L/DVB (12413): radio-si470x: separate common and usb code
      V4L/DVB (12414): radio-si470x: change to dev_* macro from printk
      V4L/DVB (12415): radio-si470x: add disconnect check function
      V4L/DVB (12416): radio-si470x: add i2c driver for si470x

Julia Lawall (3):
      V4L/DVB (12421): drivers/media/video/gspca: introduce missing kfree
      V4L/DVB (12477): Use dst_type field instead of type_flags
      V4L/DVB (12483): Use DIV_ROUND_CLOSEST

Julian Scheel (1):
      V4L/DVB (12481): Fix lowband tuning with tda8261

Lamarque Vieira Souza (3):
      V4L/DVB (12278): zr364xx: implement V4L2_CAP_STREAMING
      V4L/DVB (12325): Implement changing resolution on the fly for zr364xx driver
      V4L/DVB (12326): zr364xx: error message when buffer is too small and code cleanup

Laurent Pinchart (8):
      V4L/DVB (12184): uvcvideo: Use class-specific descriptor types from usb/ch9.h
      V4L/DVB (12185): uvcvideo: Prefix all UVC constants with UVC_
      V4L/DVB (12186): uvcvideo: Remove unused Logitech-specific constants
      V4L/DVB (12187): uvcvideo: Move UVC definitions to linux/usb/video.h
      V4L/DVB (12188): uvcvideo: Set PROBE_MINMAX quirk for Aveo Technology webcams
      V4L/DVB (12327): uvcvideo: Add PROBE_DEF quirk and enable it for the MT6227 device
      V4L/DVB (12378): uvcvideo: Restructure the driver to support multiple simultaneous streams.
      V4L/DVB (12379): uvcvideo: Multiple streaming interfaces support

Mart Raudsepp (1):
      V4L/DVB: af9015: add new USB ID for KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)

Marton Nemeth (1):
      V4L/DVB (12382): gspca - main: Remove vidioc_s_std().

Matthias Schwarzott (1):
      V4L/DVB (12200): mt312: Fix checkpatch warnings

Mauro Carvalho Chehab (37):
      V4L/DVB (12147): pwc: remove definitions that are already present at videodev2.h
      V4L/DVB (12149): videodev2.h: Reorganize fourcc table
      V4L/DVB (12124): v4l2-ioctl: better output debug messages for VIDIOC_ENUM_FRAMESIZES
      V4L/DVB (12168): v4l2-ioctl: avoid flooding log with unasked debug messages
      V4L/DVB (12273): em28xx-video: rename ac97 audio controls to better document it
      V4L/DVB (12274): em28xx-video: better implement ac97 control ioctls
      V4L/DVB (12345): em28xx: fix audio VIDIOC_S_CTRL adjustments on devices without ac97
      V4L/DVB (12376): em28xx: fix V4L2 API compliance: don't expose audio inputs for devices without it
      V4L/DVB (12408): em28xx: Implement g/s_register via address match
      V4L/DVB (12452): gspca/Kconfig: Fix bad identation for USB_GSPCA_SN9C20X_EVDEV
      V4L/DVB (12466): Kconfig files: Fix improper use of whitespaces
      V4L/DVB (12468): saa7134: Fix bad whitespacing
      V4L/DVB (12470): cx231xx/cx231xx-conf-reg.h: fix bad whitespaces
      V4L/DVB (12471): stv06xx: fix bad whitespaces
      V4L/DVB (12472): hdpvr-control: fix bad whitespaces
      V4L/DVB (12478): ARRAY_SIZE changes
      V4L/DVB (12557): Use C99 comment CodingStyle
      V4L/DVB (12558): CodingStyle: Use [0x0f] instead of [ 0x0f ]
      V4L/DVB (12559): Properly indent comments with tabs
      V4L/DVB (12560): Fix a number of EXPORT_SYMBOL warnings
      V4L/DVB (12562): ir-keymaps: replace KEY_KP[0-9] to KEY_[0-9]
      V4L/DVB (12563): ir-keymaps: add a link to the IR standard layout page
      V4L/DVB (12564): ir-keymaps: Replace most KEY_[A-Z] to the proper definitions
      V4L/DVB (12565): ir-keymaps: standardize timeshift key
      V4L/DVB (12566): ir-keymaps: Fix IR mappings for channel and volume +/- keys
      V4L/DVB (12567): ir-keymaps: use KEY_CAMERA for snapshots
      V4L/DVB (12585): Add remote support to cph03x bttv card
      V4L/DVB (12591): em28xx: Add entry for GADMEI UTV330+ and related IR keymap
      V4L/DVB (12469): fix bad whitespaces at cx88_geniatech_x8000_mt
      V4L/DVB (12595): common/ir: use a struct for keycode tables
      V4L/DVB (12598): dvb-usb: store rc5 custom and data at the same field
      V4L/DVB (12599): dvb-usb-remote: Allow dynamically replacing the IR keycodes
      V4L/DVB (12600): dvb-usb-remote: return KEY_RESERVED if there's free space for new keys
      V4L/DVB (12698): em28xx: ir-kbd-i2c init data needs a persistent object
      V4L/DVB (12701): saa7134: ir-kbd-i2c init data needs a persistent object
      V4L/DVB (12712): em28xx: properly load ir-kbd-i2c when needed
      V4L/DVB (12713): em28xx: Cleanups at ir_i2c handler

Mhayk Whandson (1):
      V4L/DVB (12370): v4l doc: fix cqcam source code path

Michael Krufky (4):
      V4L/DVB (12360): au0828: fix typo: dvb uses bulk xfer, dont say isoc in debug
      V4L/DVB (12576): tda18271: simplify debug printk macros
      V4L/DVB (12577): tda18271: remove excess whitespace from tda_foo printk macros
      V4L/DVB (12578): tda18271: allow drivers to request RF tracking filter calibration during attach

Nam Phạm Thành (1):
      V4L/DVB (12475): Add support for Humax/Coex DVB-T USB Stick 2.0 High Speed

Oldřich Jedlička (2):
      V4L/DVB (12490): Report only 32kHz for ALSA
      V4L/DVB (12586): Update ALSA capture controls according to selected source.

Oliver Neukum (2):
      V4L/DVB (12369): stv680: kfree called before usb_kill_urb
      V4L/DVB (12491): remove unnecessary power management primitive in stk-webcam

Pete Hildebrandt (1):
      V4L/DVB (12396): [patch] Added Support for STK7700D (DVB)

Roel Kluin (3):
      V4L/DVB (12199): remove redundant tests on unsigned
      V4L/DVB (12435): strlcpy() will always null terminate the string.
      V4L/DVB (12575): Fix test of bandwidth range in cx22700_set_tps()

Stefan Richter (1):
      V4L/DVB (12583): firedtv: combine some debug logging code

Stephane Marguet (Stemp) (1):
      V4L/DVB (12690): gspca - pac7311: Webcam 06f8:3009 added.

Steven Toth (5):
      V4L/DVB (12304): cx23885: Remove hardcoded gpio bits from the encoder driver
      V4L/DVB (12305): cx23885: Convert existing HVR1800 GPIO calls into new format
      V4L/DVB (12306): cx23885: Add support for ATSC/QAM on Hauppauge HVR-1850
      V4L/DVB (12307): cx23885: Modify hardware revision detection for newer silicon
      V4L/DVB (12347): cx25840: Bugfix for no DVB-T on the Hauppauge HVR-1700

Theodore Kilgore (2):
      V4L/DVB (12459): gspca - jeilinj: New subdriver for Jeilin chip.
      V4L/DVB (12618): gspca: mr97310a add support for CIF and more VGA camera's

Tobias Lorenz (4):
      V4L/DVB (12142): radio-si470x: Add suport for RDS endpoint interrupt mode
      V4L/DVB (12143): radio-si470x: cleanups
      V4L/DVB (12144): radio-si470x: removed v4l2_queryctrl in favor of v4l2_ctrl_query_fill
      V4L/DVB (12417): I2C cleanups and version checks

Trent Piepho (7):
      V4L/DVB (12287): dvb-pll: Add Samsung TDTC9251DH0 DVB-T NIM
      V4L/DVB (12288): dvb-pll: Add support for Samsung TBDU18132 DVB-S NIM
      V4L/DVB (12289): dvb-pll: Add support for Samsung TBMU24112 DVB-S NIM
      V4L/DVB (12290): dvb-pll: Add support for Alps TDEE4 DVB-C NIM
      V4L/DVB (12292): b2c2: Use dvb-pll for AirStar DVB-T's tuner
      V4L/DVB (12293): b2c2: Use dvb-pll for Skystar2 rev 2.3 and rev 2.6
      V4L/DVB (12294): b2c2: Use dvb-pll for Cablestar2

Vasiliy Temnikov (1):
      V4L/DVB (12574): support AverMedia Studio 505

Vlastimil Labsky (1):
      V4L/DVB (12439): cx88: add support for WinFast DTV2000H rev. J

Zhenyu Wang (1):
      V4L/DVB (12190): em28xx: Add support for Gadmei UTV330+

hermann pitton (2):
      V4L/DVB (12420): saa7134: fix the radio on Avermedia GO 007 FM
      V4L/DVB (12492): saa7134-input: don't probe for the Pinnacle remotes anymore

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
