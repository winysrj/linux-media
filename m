Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59829 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZDGA6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 20:58:08 -0400
Date: Mon, 6 Apr 2009 21:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.30] V4L/DVB updates
Message-ID: <20090406215632.3eb96373@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the second part of updates for 2.6.30 (this time, 121 patches).

It contains:
   - pxa_camera/soc-camera, ivtv, pvrusb2, af9015 updates;
   - the second part of v4l2 dev/subdev conversion;
   - almost get rid of legacy i2c API usage;
   - several i2c legacy code remvoed;
   - Fix buglets in v4l1 compatibility layer
   - Add AVerMedia A310 USB IDs to CE6230 driver.
   - Add cx231xx USB driver;
   - Add lgs8gxx frontend driver;
   - gspca updates;
   - some Kconfig fixes;
   - a few other bug fixes and improvements;
   - removal of the legacy list at MAINTAINERS file.

Cheers,
Mauro.

---

 Documentation/video4linux/pxa_camera.txt          |  125 +
 Documentation/video4linux/v4l2-framework.txt      |   21 +-
 MAINTAINERS                                       |    1 -
 arch/arm/mach-mx1/Makefile                        |    3 +
 arch/arm/mach-mx1/devices.c                       |    2 +-
 arch/arm/mach-mx1/ksym_mx1.c                      |   18 +
 arch/arm/mach-mx1/mx1_camera_fiq.S                |   35 +
 arch/arm/mach-mx3/clock.c                         |    2 +-
 arch/arm/plat-mxc/include/mach/memory.h           |    8 +
 arch/arm/plat-mxc/include/mach/mx1_camera.h       |   35 +
 drivers/media/dvb/dvb-usb/Kconfig                 |    4 +-
 drivers/media/dvb/dvb-usb/af9015.c                |   63 +-
 drivers/media/dvb/dvb-usb/af9015.h                |   75 +-
 drivers/media/dvb/dvb-usb/ce6230.c                |    8 +-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h           |    4 +
 drivers/media/dvb/firewire/firedtv-avc.c          |    2 +-
 drivers/media/dvb/frontends/Kconfig               |    7 +
 drivers/media/dvb/frontends/Makefile              |    1 +
 drivers/media/dvb/frontends/au8522_decoder.c      |   12 +-
 drivers/media/dvb/frontends/lgs8gxx.c             |  816 +++++++
 drivers/media/dvb/frontends/lgs8gxx.h             |   90 +
 drivers/media/dvb/frontends/lgs8gxx_priv.h        |   70 +
 drivers/media/radio/dsbr100.c                     |   88 +-
 drivers/media/radio/radio-aimslab.c               |   12 -
 drivers/media/radio/radio-aztech.c                |   12 -
 drivers/media/radio/radio-gemtek-pci.c            |   12 -
 drivers/media/radio/radio-gemtek.c                |   11 -
 drivers/media/radio/radio-maestro.c               |   12 -
 drivers/media/radio/radio-maxiradio.c             |   12 -
 drivers/media/radio/radio-mr800.c                 |   85 +-
 drivers/media/radio/radio-rtrack2.c               |   12 -
 drivers/media/radio/radio-sf16fmi.c               |   12 -
 drivers/media/radio/radio-sf16fmr2.c              |   12 -
 drivers/media/radio/radio-si470x.c                |    9 +-
 drivers/media/radio/radio-terratec.c              |   12 -
 drivers/media/radio/radio-trust.c                 |   12 -
 drivers/media/radio/radio-typhoon.c               |   12 -
 drivers/media/radio/radio-zoltrix.c               |   12 -
 drivers/media/video/Kconfig                       |   15 +-
 drivers/media/video/Makefile                      |    4 +-
 drivers/media/video/adv7170.c                     |   19 +-
 drivers/media/video/adv7175.c                     |   17 +-
 drivers/media/video/au0828/Kconfig                |    1 +
 drivers/media/video/au0828/au0828-cards.c         |   19 +-
 drivers/media/video/au0828/au0828-core.c          |    9 +-
 drivers/media/video/au0828/au0828-i2c.c           |   72 +-
 drivers/media/video/au0828/au0828-reg.h           |   35 +-
 drivers/media/video/au0828/au0828-video.c         |   12 +-
 drivers/media/video/au0828/au0828.h               |    1 +
 drivers/media/video/bt819.c                       |   15 +-
 drivers/media/video/bt856.c                       |   11 +-
 drivers/media/video/bt866.c                       |   11 +-
 drivers/media/video/bt8xx/bttv-cards.c            |   70 +-
 drivers/media/video/bt8xx/bttv-driver.c           |   25 +-
 drivers/media/video/bt8xx/bttvp.h                 |    2 +-
 drivers/media/video/cafe_ccic.c                   |    2 +-
 drivers/media/video/cs5345.c                      |   11 +-
 drivers/media/video/cs53l32a.c                    |    9 +-
 drivers/media/video/cx18/cx18-audio.c             |    9 +-
 drivers/media/video/cx18/cx18-av-core.c           |   70 +-
 drivers/media/video/cx18/cx18-av-core.h           |    5 -
 drivers/media/video/cx18/cx18-driver.c            |    4 +-
 drivers/media/video/cx18/cx18-fileops.c           |    2 +-
 drivers/media/video/cx18/cx18-gpio.c              |    6 +-
 drivers/media/video/cx18/cx18-i2c.c               |   14 +-
 drivers/media/video/cx18/cx18-ioctl.c             |   12 +-
 drivers/media/video/cx18/cx18-video.c             |   16 +-
 drivers/media/video/cx231xx/Kconfig               |   35 +
 drivers/media/video/cx231xx/Makefile              |   14 +
 drivers/media/video/cx231xx/cx231xx-audio.c       |  586 +++++
 drivers/media/video/cx231xx/cx231xx-avcore.c      | 2581 +++++++++++++++++++++
 drivers/media/video/cx231xx/cx231xx-cards.c       |  914 ++++++++
 drivers/media/video/cx231xx/cx231xx-conf-reg.h    |  494 ++++
 drivers/media/video/cx231xx/cx231xx-core.c        | 1200 ++++++++++
 drivers/media/video/cx231xx/cx231xx-dvb.c         |  559 +++++
 drivers/media/video/cx231xx/cx231xx-i2c.c         |  555 +++++
 drivers/media/video/cx231xx/cx231xx-input.c       |  246 ++
 drivers/media/video/cx231xx/cx231xx-pcb-cfg.c     |  795 +++++++
 drivers/media/video/cx231xx/cx231xx-pcb-cfg.h     |  231 ++
 drivers/media/video/cx231xx/cx231xx-reg.h         | 1564 +++++++++++++
 drivers/media/video/cx231xx/cx231xx-vbi.c         |  701 ++++++
 drivers/media/video/cx231xx/cx231xx-vbi.h         |   65 +
 drivers/media/video/cx231xx/cx231xx-video.c       | 2434 +++++++++++++++++++
 drivers/media/video/cx231xx/cx231xx.h             |  779 +++++++
 drivers/media/video/cx23885/cx23885-cards.c       |    5 +-
 drivers/media/video/cx23885/cx23885-core.c        |    2 +-
 drivers/media/video/cx23885/cx23885-dvb.c         |    2 +-
 drivers/media/video/cx23885/cx23885-video.c       |   16 +-
 drivers/media/video/cx23885/cx23885.h             |    2 +-
 drivers/media/video/cx25840/cx25840-audio.c       |   66 +-
 drivers/media/video/cx25840/cx25840-core.c        |  185 ++-
 drivers/media/video/cx25840/cx25840-core.h        |    1 +
 drivers/media/video/cx25840/cx25840-firmware.c    |   11 +-
 drivers/media/video/cx88/cx88-cards.c             |   17 +-
 drivers/media/video/cx88/cx88-core.c              |    2 +-
 drivers/media/video/cx88/cx88-dvb.c               |    2 +-
 drivers/media/video/cx88/cx88-video.c             |   25 +-
 drivers/media/video/cx88/cx88.h                   |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c         |  150 +-
 drivers/media/video/em28xx/em28xx-core.c          |   12 +-
 drivers/media/video/em28xx/em28xx-i2c.c           |   71 +-
 drivers/media/video/em28xx/em28xx-video.c         |   83 +-
 drivers/media/video/em28xx/em28xx.h               |   10 +-
 drivers/media/video/gspca/gspca.c                 |    1 +
 drivers/media/video/gspca/gspca.h                 |    1 +
 drivers/media/video/gspca/m5602/Makefile          |    3 +-
 drivers/media/video/gspca/m5602/m5602_bridge.h    |    8 +-
 drivers/media/video/gspca/m5602/m5602_core.c      |   36 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.c   |   77 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.h   |   61 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c    |  570 ++++--
 drivers/media/video/gspca/m5602/m5602_ov9650.h    |  239 +--
 drivers/media/video/gspca/m5602/m5602_po1030.c    |  114 +-
 drivers/media/video/gspca/m5602/m5602_po1030.h    |   98 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c    |  173 ++-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h    |  134 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.c    |  154 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.h    |   94 +-
 drivers/media/video/gspca/m5602/m5602_sensor.h    |   17 +-
 drivers/media/video/gspca/sq905.c                 |    6 +
 drivers/media/video/gspca/vc032x.c                |  403 +----
 drivers/media/video/ivtv/ivtv-driver.c            |    9 +-
 drivers/media/video/ivtv/ivtv-fileops.c           |   17 +-
 drivers/media/video/ivtv/ivtv-gpio.c              |   18 +-
 drivers/media/video/ivtv/ivtv-i2c.c               |   17 +-
 drivers/media/video/ivtv/ivtv-ioctl.c             |   16 +-
 drivers/media/video/ivtv/ivtv-routing.c           |   66 +-
 drivers/media/video/ks0127.c                      |   21 +-
 drivers/media/video/m52790.c                      |    7 +-
 drivers/media/video/msp3400-driver.c              |   40 +-
 drivers/media/video/msp3400-driver.h              |    3 +-
 drivers/media/video/msp3400-kthreads.c            |    6 +-
 drivers/media/video/mt9m001.c                     |    2 +-
 drivers/media/video/mt9t031.c                     |   21 +
 drivers/media/video/mx1_camera.c                  |  827 +++++++
 drivers/media/video/mx3_camera.c                  |    2 +-
 drivers/media/video/mxb.c                         |  144 +-
 drivers/media/video/ov772x.c                      |   65 +-
 drivers/media/video/pvrusb2/pvrusb2-audio.c       |    8 +-
 drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c    |    7 +-
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c        |   12 +-
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c |    9 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c         |   11 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c    |   12 -
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c       |   14 +-
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c   |    8 +-
 drivers/media/video/pvrusb2/pvrusb2-wm8775.c      |   12 +-
 drivers/media/video/pwc/Kconfig                   |    2 +-
 drivers/media/video/pxa_camera.c                  |  511 +++--
 drivers/media/video/s2255drv.c                    |    8 +-
 drivers/media/video/saa7110.c                     |   17 +-
 drivers/media/video/saa7115.c                     |   61 +-
 drivers/media/video/saa7127.c                     |   11 +-
 drivers/media/video/saa7134/saa6752hs.c           |    4 -
 drivers/media/video/saa7134/saa7134-cards.c       |   41 +-
 drivers/media/video/saa7134/saa7134-core.c        |   11 +-
 drivers/media/video/saa7134/saa7134-video.c       |    6 +-
 drivers/media/video/saa7134/saa7134.h             |    2 +-
 drivers/media/video/saa717x.c                     |   25 +-
 drivers/media/video/saa7185.c                     |    9 +-
 drivers/media/video/saa7191.c                     |   10 +-
 drivers/media/video/soc_camera.c                  |    6 +-
 drivers/media/video/tda9840.c                     |    1 -
 drivers/media/video/tea6415c.c                    |    6 +-
 drivers/media/video/tea6420.c                     |   18 +-
 drivers/media/video/tuner-core.c                  |   81 +-
 drivers/media/video/tvaudio.c                     |   44 +-
 drivers/media/video/tvp5150.c                     |   40 +-
 drivers/media/video/upd64031a.c                   |   11 +-
 drivers/media/video/upd64083.c                    |    9 +-
 drivers/media/video/usbvision/usbvision-core.c    |    5 +-
 drivers/media/video/usbvision/usbvision-i2c.c     |   10 +-
 drivers/media/video/usbvision/usbvision-video.c   |   14 +-
 drivers/media/video/uvc/Kconfig                   |    2 +-
 drivers/media/video/v4l1-compat.c                 |    9 +-
 drivers/media/video/v4l2-common.c                 |   62 +-
 drivers/media/video/v4l2-dev.c                    |   11 +-
 drivers/media/video/v4l2-ioctl.c                  |   34 +-
 drivers/media/video/v4l2-subdev.c                 |  128 -
 drivers/media/video/vino.c                        |   33 +-
 drivers/media/video/vp27smpx.c                    |    2 +-
 drivers/media/video/vpx3220.c                     |   23 +-
 drivers/media/video/w9968cf.c                     |    5 +-
 drivers/media/video/w9968cf.h                     |    2 +-
 drivers/media/video/wm8775.c                      |    9 +-
 drivers/media/video/zoran/zoran.h                 |    4 +-
 drivers/media/video/zoran/zoran_card.c            |   12 +-
 drivers/media/video/zoran/zoran_device.c          |   22 +-
 drivers/media/video/zoran/zoran_driver.c          |   26 +-
 drivers/media/video/zr364xx.c                     |    1 -
 include/linux/i2c-id.h                            |    1 +
 include/linux/videodev2.h                         |    5 +
 include/media/msp3400.h                           |    4 +-
 include/media/ov772x.h                            |   35 +
 include/media/saa7146.h                           |    2 +-
 include/media/tvaudio.h                           |   19 +
 include/media/v4l2-common.h                       |  141 +-
 include/media/v4l2-i2c-drv-legacy.h               |  152 --
 include/media/v4l2-i2c-drv.h                      |    6 +-
 include/media/v4l2-subdev.h                       |  115 +-
 200 files changed, 18702 insertions(+), 3343 deletions(-)
 create mode 100644 Documentation/video4linux/pxa_camera.txt
 create mode 100644 arch/arm/mach-mx1/ksym_mx1.c
 create mode 100644 arch/arm/mach-mx1/mx1_camera_fiq.S
 create mode 100644 arch/arm/plat-mxc/include/mach/mx1_camera.h
 create mode 100644 drivers/media/dvb/frontends/lgs8gxx.c
 create mode 100644 drivers/media/dvb/frontends/lgs8gxx.h
 create mode 100644 drivers/media/dvb/frontends/lgs8gxx_priv.h
 create mode 100644 drivers/media/video/cx231xx/Kconfig
 create mode 100644 drivers/media/video/cx231xx/Makefile
 create mode 100644 drivers/media/video/cx231xx/cx231xx-audio.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-avcore.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-cards.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-conf-reg.h
 create mode 100644 drivers/media/video/cx231xx/cx231xx-core.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-dvb.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-i2c.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-input.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-pcb-cfg.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-pcb-cfg.h
 create mode 100644 drivers/media/video/cx231xx/cx231xx-reg.h
 create mode 100644 drivers/media/video/cx231xx/cx231xx-vbi.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx-vbi.h
 create mode 100644 drivers/media/video/cx231xx/cx231xx-video.c
 create mode 100644 drivers/media/video/cx231xx/cx231xx.h
 create mode 100644 drivers/media/video/mx1_camera.c
 delete mode 100644 drivers/media/video/v4l2-subdev.c
 delete mode 100644 include/media/v4l2-i2c-drv-legacy.h

Adam Baker (1):
      V4L/DVB (11387): Sensor orientation reporting

Alexander Beregalov (1):
      V4L/DVB (11438): au0828: fix Kconfig dependance

Alexey Klimov (4):
      V4L/DVB (11391): pci-isa radios: remove open and release functions
      V4L/DVB (11393): radio-si470x: fix possible bug with freeing memory order
      V4L/DVB (11435): dsbr100 radio: convert to to v4l2_device
      V4L/DVB (11436): radio-mr800: convert to to v4l2_device

Antti Palosaari (4):
      V4L/DVB (11336): af9015: remove experimental
      V4L/DVB (11337): af9015: add new USB ID for KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)
      V4L/DVB (11339): af9015: remove wrong definitions
      V4L/DVB (11340): af9015: add support for AverMedia AVerTV Volar Black HD (A850)

David Wong (1):
      V4L/DVB (11398): Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX China DMB-TH digital demodulator

Dean Anderson (1):
      V4L/DVB (11392): patch: s2255drv driver removal problem fixed

Devin Heitmueller (2):
      V4L/DVB (11342): au0828: better document i2c registers
      V4L/DVB (11343): au0828: make i2c clock speed per-board configurable

Douglas Schilling Landgraf (1):
      V4L/DVB (11331): em28xx: convert to v4l2_subdev

Erik Andr?n (24):
      V4L/DVB (11403): gspca - m5602-s5k4aa: No more "default" mode
      V4L/DVB (11404): gspca - m5602-s5k4aa: Add start function and VGA resolution init.
      V4L/DVB (11405): gspca - m5602: Simplify error handling
      V4L/DVB (11406): gspca - m5602-ov9650: Add QCIF resolution support
      V4L/DVB (11407): gspca - m5602-ov9650: Clean up ov9650_start() function.
      V4L/DVB (11409): gspca - m5602-ov9650: Set the ov9650 sensor in soft sleep when inactive.
      V4L/DVB (11410): gspca - m5602-ov9650: Always init the ov9650 before starting a stream
      V4L/DVB (11411): gspca - m5602: Rework v4l ctrl handling in all sensors
      V4L/DVB (11412): gspca - m5602-ov9650: Checkpatch fixes
      V4L/DVB (11413): gspca - m5602-mt9m111: Separate mode vectors per sensor.
      V4L/DVB (11414): gspca - m5602-mt9m111: Move v4l2 controls to main sensor file.
      V4L/DVB (11415): gspca - m5602: Remove an unused member in the sd struct.
      V4L/DVB (11416): gspca - m5602: Constify all sensor structs
      V4L/DVB (11417): gspca - m5602-ov9650: Autogain is on by default
      V4L/DVB (11418): gspca - m5602-ov9650: Auto white balancing is on by default
      V4L/DVB (11419): gspca - m5602-ov9650: Don't read exposure data from COM1.
      V4L/DVB (11420): gspca - m5602: Improve error handling in the ov9650 driver
      V4L/DVB (11421): gspca - m5602-ov9650: Synthesize modesetting.
      V4L/DVB (11422): gspca - m5602-ov9650: Replace a magic constant with a define
      V4L/DVB (11423): gspca - m5602-ov9650: Add a disconnect hook, setup a ctrl cache ctrl.
      V4L/DVB (11424): gspca - m5602-ov9650: Use the local ctrl cache. Adjust image on vflip.
      V4L/DVB (11425): gspca - m5602: Move the vflip quirk to probe stage.
      V4L/DVB (11426): gspca - m5602: Don't touch hflip/vflip register on Read/Modify/Write
      V4L/DVB (11427): gspca - m5602: Minor cleanups

Geert Uytterhoeven (1):
      V4L/DVB (11392a): Remove reference to obsolete linux-dvb@linuxtv.org

Guennadi Liakhovetski (5):
      V4L/DVB (11323): pxa-camera: simplify the .buf_queue path by merging two loops
      V4L/DVB (11325): soc-camera: fix breakage caused by 1fa5ae857bb14f6046205171d98506d8112dd74e
      V4L/DVB (11326): mt9m001: fix advertised pixel clock polarity
      V4L/DVB (11347): mt9t031: use platform power hook
      V4L/DVB (11349): mx3-camera: adapt the clock definition and the driver to the new clock naming

Hans Verkuil (23):
      V4L/DVB (10982): cx231xx: fix compile warning
      V4L/DVB (10989): cx25840: cx23885 detection was broken
      V4L/DVB (11361): msp3400: remove i2c legacy code
      V4L/DVB (11362): saa7115: remove i2c legacy code
      V4L/DVB (11363): tvp5150: remove i2c legacy code.
      V4L/DVB (11364): tuner: remove i2c legacy code.
      V4L/DVB (11365): tvaudio: remove i2c legacy code
      V4L/DVB (11366): v4l: remove obsolete header and source
      V4L/DVB (11367): v4l2-common: remove legacy code
      V4L/DVB (11368): v4l2-subdev: move s_standby from core to tuner.
      V4L/DVB (11369): v4l2-subdev: add load_fw and use that instead of abusing core->init.
      V4L/DVB (11370): v4l2-subdev: move s_std from tuner to core.
      V4L/DVB (11371): v4l2: remove legacy fields in v4l2-i2c-drv.h.
      V4L/DVB (11372): v4l2: use old-style i2c API for kernels < 2.6.26 instead of < 2.6.22
      V4L/DVB (11374): v4l2-common: add v4l2_i2c_new_probed_subdev_addr
      V4L/DVB (11373): v4l2-common: add explicit v4l2_device pointer as first arg to new_(probed)_subdev
      V4L/DVB (11375): v4l2: use v4l2_i2c_new_probed_subdev_addr where appropriate.
      V4L/DVB (11376): tvaudio.h: add static inline to retrieve the list of possible i2c addrs.
      V4L/DVB (11377): v4l: increase version numbers of drivers converted to v4l2_subdev.
      V4L/DVB (11379): mxb: fix copy-and-paste bug in mute.
      V4L/DVB (11380): v4l2-subdev: change s_routing prototype
      V4L/DVB (11381): ivtv/cx18: remove VIDIOC_INT_S_AUDIO_ROUTING debug support.
      V4L/DVB (11390): 2-dev.c: return 0 for NULL open and release callbacks

Huang Weiyi (2):
      V4L/DVB: usbvision: remove unused #include <version.h>
      V4L/DVB: zr364xx: remove unused #include <version.h>

Janne Grunau (8):
      V4L/DVB (11351): v4l: use usb_interface for v4l2_device_register
      V4L/DVB (11352): cx231xx: use usb_interface.dev for v4l2_device_register
      V4L/DVB (11353): cx231xx: remove explicitly set v4l2_device.name
      V4L/DVB (11354): usbvision: use usb_interface.dev for v4l2_device_register
      V4L/DVB (11355): pvrusb2: use usb_interface.dev for v4l2_device_register
      V4L/DVB (11356): au0828: use usb_interface.dev for v4l2_device_register
      V4L/DVB (11357): au0828: remove explicitly set v4l2_device.name and unused au0828_instance
      V4L/DVB (11358): w9968cf: use usb_interface.dev for v4l2_device_register

Jean Delvare (1):
      V4L/DVB (11437): pvrusb2: Drop client_register/unregister stubs

Jean-Francois Moine (1):
      V4L/DVB (11402): gspca - vc032x: Remove the JPEG tables of mi1320_soc.

Juan Jesús García de Soria Lucena (1):
      V4L/DVB (11328): Add AVerMedia A310 USB IDs to CE6230 driver.

Kuninori Morimoto (2):
      V4L/DVB (11324): ov772x: wrong pointer for soc_camera_link is modified
      V4L/DVB (11327): ov772x: add edge contrl support

Kyle McMartin (1):
      V4L/DVB (11318): fix misspelling of kconfig option

Lukas Karas (1):
      V4L/DVB (11408): gspca - m5602-s5k83a: Add led support to the s5k83a sensor.

Marc Schneider (1):
      V4L/DVB (11338): af9015: add support for TrekStor DVB-T USB Stick

Matthias Schwarzott (1):
      V4L/DVB (11386): saa7134: Add analog RF tuner support for Avermedia A700 DVB-S Hybrid+FM card

Mauro Carvalho Chehab (13):
      V4L/DVB (10953): cx25840: Fix CodingStyle errors introduced by the last patch
      V4L/DVB (10955): cx231xx: CodingStyle automatic fixes with Lindent
      V4L/DVB (10956): cx231xx: First series of manual CodingStyle fixes
      V4L/DVB (10957a): cx231xx: Fix compilation breakage
      V4L/DVB (11130): cx231xx: fix an inverted logic at vidioc_streamoff
      V4L/DVB (11131): cx231xx: avoid trying to access unfilled dev struct
      V4L/DVB (11132): cx231xx: usb probe cleanups
      V4L/DVB (11133): cx231xx: don't print pcb config debug messages by default
      V4L/DVB (11134): cx231xx: dmesg cleanup
      V4L/DVB (11135): cx231xx: use usb_make_path() for bus_info
      V4L/DVB (11250): cx231xx: Fix Kconfig help items
      V4L/DVB (11360): em28xx: use usb_interface.dev for v4l2_device_register
      cx231xx: Convert to snd_card_create()

Mike Isely (3):
      V4L/DVB (11332): pvrusb2: Fix incorrect reporting of default value for non-integer controls
      V4L/DVB (11333): pvrusb2: Report def_val items in sysfs symbolically, consistent with cur_val
      V4L/DVB (11334): pvrusb2: Fix uninitialized tuner_setup field(s)

Paulius Zaleckas (1):
      V4L/DVB (11350): Add camera (CSI) driver for MX1

Randy Dunlap (2):
      V4L/DVB (11439): UVC: uvc_status_cleanup(): undefined reference to `input_unregister_device'
      V4L/DVB (11440): PWC: fix build error when CONFIG_INPUT=m

Robert Jarzmik (4):
      V4L/DVB (11319): pxa_camera: Enforce YUV422P frame sizes to be 16 multiples
      V4L/DVB (11320): pxa_camera: Remove YUV planar formats hole
      V4L/DVB (11321): pxa_camera: Redesign DMA handling
      V4L/DVB (11322): pxa_camera: Fix overrun condition on last buffer

Russell King (1):
      V4L/DVB (11329): Fix buglets in v4l1 compatibility layer

Sri Deevi (7):
      V4L/DVB (10952): cx25840: prepare it to be used by cx231xx module
      V4L/DVB (10954): Add cx231xx USB driver
      V4L/DVB (10957): cx231xx: Fix CodingStyle
      V4L/DVB (10958): cx231xx: some additional CodingStyle and minor fixes
      V4L/DVB (11038): Fix the issue with audio module & correction of Names
      V4L/DVB (11128): cx231xx: convert the calls to subdev format
      V4L/DVB (11129): cx231xx: Use generic names for each device block

Stefan Richter (1):
      Revert "V4L/DVB (10962): fired-avc: fix printk formatting warning."

Stuart Hall (1):
      V4L/DVB (11345): af9015: support for DigitalNow TinyTwin remote

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
