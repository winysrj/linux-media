Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZISEti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 00:49:38 -0400
Date: Sat, 19 Sep 2009 01:49:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.31] V4L/DVB updates
Message-ID: <20090919014930.7dd90f77@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the second (and final) part of new stuff for kernel 2.6.31.

This series adds two relevant improvements at the multimedia support:

1) Support for ISDB-T (for broadcast TV) and ISDB-S (for satellite transmissions). 

This means that finally we have support for Digital TV standards used in Japan
and Brasil, and being implemented on several countries in South America and
maybe in other Asian Countries.

2) Documentation for V4L2 and DVB APIs

Since 1999, V4L2 API were used in kernel, and since 2002, DVB API.
However, during all those time, there weren't a single document describing DVB
API on kernel, and V4L2 API were never added. This situation always bother me
since I started maintaining the subsystem. On this series, this gap is finally
filled: Both V4L2 and DVB API specs were converted from DocBook v3.1 and LaTex
to DocBook XML 4.1.2, and added at Documentation/DocBook. It were converted
as an unique document, to be easier to be referenced and used.

I hope that this will improve the usage of the API and help to keep it updated
with the latest changes at the code.

This series also contains several new drivers:

   - new driver for NXP saa7164;
   - new driver for gl860 webcams;
   - new driver for dibcom 80xx chips (ISDB-T);
   - new driver for Earthsoft PT1 ISDB-T/ISDB-S cards;
   - new driver for 774 Friio White USB ISDB-T receiver;
   - new drivers for DaVinci display (vpif, dm646x, vpfe, dm355, dm644x);
   - new driver for adv7180 analog decoder;
   - new staging driver for cx25821. This device has 10 simultaneous video input/output
into a single PCIe chip, being probably the most complex device currently supported.
Help is needed to cleanup the driver and put it into kernel CodingStyle;

Also in this patch series:

   - em28xx: Add support for VBI;
   - tda18271: several improvements;
   - gspca - m5602-s5k4aa: several improvements at control capabilities;
   - dibcom drivers: add support for stk7770p;
   - soc-camera: converted to v4l dev/subdev model, allowing future share of code with
     other drivers;
   - miscelaneous fixes, driver additions, etc;

Cheers,
Mauro.

---

 Documentation/DocBook/Makefile                     |   10 +-
 Documentation/DocBook/dvb/.gitignore               |    1 +
 Documentation/DocBook/dvb/audio.xml                | 1473 ++++++++++++
 Documentation/DocBook/dvb/ca.xml                   |  221 ++
 Documentation/DocBook/dvb/demux.xml                |  973 ++++++++
 Documentation/DocBook/dvb/dvbapi.xml               |   87 +
 Documentation/DocBook/dvb/dvbstb.pdf               |  Bin 0 -> 1881 bytes
 Documentation/DocBook/dvb/dvbstb.png               |  Bin 0 -> 22655 bytes
 Documentation/DocBook/dvb/examples.xml             |  365 +++
 Documentation/DocBook/dvb/frontend.xml             | 1766 ++++++++++++++
 Documentation/DocBook/dvb/intro.xml                |  191 ++
 Documentation/DocBook/dvb/isdbt.xml                |  314 +++
 Documentation/DocBook/dvb/kdapi.xml                | 2309 ++++++++++++++++++
 Documentation/DocBook/dvb/net.xml                  |   12 +
 Documentation/DocBook/dvb/video.xml                | 1971 ++++++++++++++++
 Documentation/DocBook/media-entities.tmpl          |  364 +++
 Documentation/DocBook/media-indices.tmpl           |   85 +
 Documentation/DocBook/media.tmpl                   |  112 +
 Documentation/DocBook/stylesheet.xsl               |    1 +
 Documentation/DocBook/v4l/.gitignore               |    1 +
 Documentation/DocBook/v4l/biblio.xml               |  188 ++
 Documentation/DocBook/v4l/capture.c.xml            |  659 ++++++
 Documentation/DocBook/v4l/common.xml               | 1160 +++++++++
 Documentation/DocBook/v4l/compat.xml               | 2457 ++++++++++++++++++++
 Documentation/DocBook/v4l/controls.xml             | 2049 ++++++++++++++++
 Documentation/DocBook/v4l/crop.gif                 |  Bin 0 -> 5967 bytes
 Documentation/DocBook/v4l/crop.pdf                 |  Bin 0 -> 5846 bytes
 Documentation/DocBook/v4l/dev-capture.xml          |  115 +
 Documentation/DocBook/v4l/dev-codec.xml            |   26 +
 Documentation/DocBook/v4l/dev-effect.xml           |   25 +
 Documentation/DocBook/v4l/dev-osd.xml              |  164 ++
 Documentation/DocBook/v4l/dev-output.xml           |  111 +
 Documentation/DocBook/v4l/dev-overlay.xml          |  379 +++
 Documentation/DocBook/v4l/dev-radio.xml            |   57 +
 Documentation/DocBook/v4l/dev-raw-vbi.xml          |  347 +++
 Documentation/DocBook/v4l/dev-rds.xml              |  168 ++
 Documentation/DocBook/v4l/dev-sliced-vbi.xml       |  708 ++++++
 Documentation/DocBook/v4l/dev-teletext.xml         |   40 +
 Documentation/DocBook/v4l/driver.xml               |  208 ++
 Documentation/DocBook/v4l/fdl-appendix.xml         |  671 ++++++
 Documentation/DocBook/v4l/fieldseq_bt.gif          |  Bin 0 -> 25430 bytes
 Documentation/DocBook/v4l/fieldseq_bt.pdf          |  Bin 0 -> 9185 bytes
 Documentation/DocBook/v4l/fieldseq_tb.gif          |  Bin 0 -> 25323 bytes
 Documentation/DocBook/v4l/fieldseq_tb.pdf          |  Bin 0 -> 9173 bytes
 Documentation/DocBook/v4l/func-close.xml           |   70 +
 Documentation/DocBook/v4l/func-ioctl.xml           |  146 ++
 Documentation/DocBook/v4l/func-mmap.xml            |  185 ++
 Documentation/DocBook/v4l/func-munmap.xml          |   83 +
 Documentation/DocBook/v4l/func-open.xml            |  121 +
 Documentation/DocBook/v4l/func-poll.xml            |  127 +
 Documentation/DocBook/v4l/func-read.xml            |  189 ++
 Documentation/DocBook/v4l/func-select.xml          |  138 ++
 Documentation/DocBook/v4l/func-write.xml           |  136 ++
 Documentation/DocBook/v4l/io.xml                   | 1073 +++++++++
 Documentation/DocBook/v4l/keytable.c.xml           |  172 ++
 Documentation/DocBook/v4l/libv4l.xml               |  167 ++
 Documentation/DocBook/v4l/pixfmt-grey.xml          |   70 +
 Documentation/DocBook/v4l/pixfmt-nv12.xml          |  151 ++
 Documentation/DocBook/v4l/pixfmt-nv16.xml          |  174 ++
 Documentation/DocBook/v4l/pixfmt-packed-rgb.xml    |  862 +++++++
 Documentation/DocBook/v4l/pixfmt-packed-yuv.xml    |  244 ++
 Documentation/DocBook/v4l/pixfmt-sbggr16.xml       |   91 +
 Documentation/DocBook/v4l/pixfmt-sbggr8.xml        |   75 +
 Documentation/DocBook/v4l/pixfmt-sgbrg8.xml        |   75 +
 Documentation/DocBook/v4l/pixfmt-sgrbg8.xml        |   75 +
 Documentation/DocBook/v4l/pixfmt-uyvy.xml          |  128 +
 Documentation/DocBook/v4l/pixfmt-vyuy.xml          |  128 +
 Documentation/DocBook/v4l/pixfmt-y16.xml           |   89 +
 Documentation/DocBook/v4l/pixfmt-y41p.xml          |  157 ++
 Documentation/DocBook/v4l/pixfmt-yuv410.xml        |  141 ++
 Documentation/DocBook/v4l/pixfmt-yuv411p.xml       |  155 ++
 Documentation/DocBook/v4l/pixfmt-yuv420.xml        |  157 ++
 Documentation/DocBook/v4l/pixfmt-yuv422p.xml       |  161 ++
 Documentation/DocBook/v4l/pixfmt-yuyv.xml          |  128 +
 Documentation/DocBook/v4l/pixfmt-yvyu.xml          |  128 +
 Documentation/DocBook/v4l/pixfmt.xml               |  801 +++++++
 Documentation/DocBook/v4l/remote_controllers.xml   |  175 ++
 Documentation/DocBook/v4l/v4l2.xml                 |  479 ++++
 Documentation/DocBook/v4l/v4l2grab.c.xml           |  164 ++
 Documentation/DocBook/v4l/vbi_525.gif              |  Bin 0 -> 4741 bytes
 Documentation/DocBook/v4l/vbi_525.pdf              |  Bin 0 -> 3395 bytes
 Documentation/DocBook/v4l/vbi_625.gif              |  Bin 0 -> 5095 bytes
 Documentation/DocBook/v4l/vbi_625.pdf              |  Bin 0 -> 3683 bytes
 Documentation/DocBook/v4l/vbi_hsync.gif            |  Bin 0 -> 2400 bytes
 Documentation/DocBook/v4l/vbi_hsync.pdf            |  Bin 0 -> 7405 bytes
 Documentation/DocBook/v4l/videodev2.h.xml          | 1640 +++++++++++++
 Documentation/DocBook/v4l/vidioc-cropcap.xml       |  174 ++
 .../DocBook/v4l/vidioc-dbg-g-chip-ident.xml        |  275 +++
 .../DocBook/v4l/vidioc-dbg-g-register.xml          |  275 +++
 Documentation/DocBook/v4l/vidioc-encoder-cmd.xml   |  204 ++
 Documentation/DocBook/v4l/vidioc-enum-fmt.xml      |  164 ++
 .../DocBook/v4l/vidioc-enum-frameintervals.xml     |  270 +++
 .../DocBook/v4l/vidioc-enum-framesizes.xml         |  282 +++
 Documentation/DocBook/v4l/vidioc-enumaudio.xml     |   86 +
 Documentation/DocBook/v4l/vidioc-enumaudioout.xml  |   89 +
 Documentation/DocBook/v4l/vidioc-enuminput.xml     |  287 +++
 Documentation/DocBook/v4l/vidioc-enumoutput.xml    |  172 ++
 Documentation/DocBook/v4l/vidioc-enumstd.xml       |  391 ++++
 Documentation/DocBook/v4l/vidioc-g-audio.xml       |  188 ++
 Documentation/DocBook/v4l/vidioc-g-audioout.xml    |  154 ++
 Documentation/DocBook/v4l/vidioc-g-crop.xml        |  143 ++
 Documentation/DocBook/v4l/vidioc-g-ctrl.xml        |  130 +
 Documentation/DocBook/v4l/vidioc-g-enc-index.xml   |  213 ++
 Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml   |  307 +++
 Documentation/DocBook/v4l/vidioc-g-fbuf.xml        |  456 ++++
 Documentation/DocBook/v4l/vidioc-g-fmt.xml         |  201 ++
 Documentation/DocBook/v4l/vidioc-g-frequency.xml   |  145 ++
 Documentation/DocBook/v4l/vidioc-g-input.xml       |  100 +
 Documentation/DocBook/v4l/vidioc-g-jpegcomp.xml    |  180 ++
 Documentation/DocBook/v4l/vidioc-g-modulator.xml   |  246 ++
 Documentation/DocBook/v4l/vidioc-g-output.xml      |  100 +
 Documentation/DocBook/v4l/vidioc-g-parm.xml        |  332 +++
 Documentation/DocBook/v4l/vidioc-g-priority.xml    |  144 ++
 .../DocBook/v4l/vidioc-g-sliced-vbi-cap.xml        |  264 +++
 Documentation/DocBook/v4l/vidioc-g-std.xml         |   99 +
 Documentation/DocBook/v4l/vidioc-g-tuner.xml       |  535 +++++
 Documentation/DocBook/v4l/vidioc-log-status.xml    |   58 +
 Documentation/DocBook/v4l/vidioc-overlay.xml       |   83 +
 Documentation/DocBook/v4l/vidioc-qbuf.xml          |  168 ++
 Documentation/DocBook/v4l/vidioc-querybuf.xml      |  103 +
 Documentation/DocBook/v4l/vidioc-querycap.xml      |  284 +++
 Documentation/DocBook/v4l/vidioc-queryctrl.xml     |  428 ++++
 Documentation/DocBook/v4l/vidioc-querystd.xml      |   83 +
 Documentation/DocBook/v4l/vidioc-reqbufs.xml       |  160 ++
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |  129 +
 Documentation/DocBook/v4l/vidioc-streamon.xml      |  106 +
 Documentation/dvb/get_dvb_firmware                 |   37 +-
 Documentation/dvb/technisat.txt                    |   75 +-
 Documentation/video4linux/CARDLIST.cx23885         |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |    3 +-
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/CARDLIST.saa7164         |    9 +
 Documentation/video4linux/CARDLIST.tuner           |    2 +
 Documentation/video4linux/gspca.txt                |    2 +
 Documentation/video4linux/soc-camera.txt           |   40 +
 Documentation/video4linux/v4l2-framework.txt       |   61 +-
 arch/sh/boards/board-ap325rxa.c                    |   58 +-
 drivers/media/common/tuners/tda18271-common.c      |    3 +-
 drivers/media/common/tuners/tda18271-fe.c          |   83 +-
 drivers/media/common/tuners/tda18271-maps.c        |    3 +-
 drivers/media/common/tuners/tda18271-priv.h        |    1 +
 drivers/media/common/tuners/tda18271.h             |   14 +
 drivers/media/common/tuners/tuner-types.c          |   27 +
 drivers/media/dvb/Kconfig                          |    4 +
 drivers/media/dvb/Makefile                         |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |  218 ++-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |   17 +
 drivers/media/dvb/dvb-usb/Kconfig                  |    9 +-
 drivers/media/dvb/dvb-usb/Makefile                 |    3 +
 drivers/media/dvb/dvb-usb/af9015.c                 |   50 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |   14 +-
 drivers/media/dvb/dvb-usb/ce6230.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  501 ++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h            |   11 +
 drivers/media/dvb/dvb-usb/friio-fe.c               |  483 ++++
 drivers/media/dvb/dvb-usb/friio.c                  |  525 +++++
 drivers/media/dvb/dvb-usb/friio.h                  |   99 +
 drivers/media/dvb/dvb-usb/m920x.c                  |    2 +
 drivers/media/dvb/frontends/Kconfig                |    8 +
 drivers/media/dvb/frontends/Makefile               |    1 +
 drivers/media/dvb/frontends/au8522_decoder.c       |    5 +
 drivers/media/dvb/frontends/dib0070.c              |  803 ++++---
 drivers/media/dvb/frontends/dib0070.h              |   30 +-
 drivers/media/dvb/frontends/dib7000p.c             |   33 +-
 drivers/media/dvb/frontends/dib8000.c              | 2277 ++++++++++++++++++
 drivers/media/dvb/frontends/dib8000.h              |   79 +
 drivers/media/dvb/frontends/dibx000_common.c       |   95 +-
 drivers/media/dvb/frontends/dibx000_common.h       |   31 +-
 drivers/media/dvb/frontends/lgdt3304.c             |    2 +
 drivers/media/dvb/frontends/s921_module.c          |    2 +
 drivers/media/dvb/pt1/Kconfig                      |   12 +
 drivers/media/dvb/pt1/Makefile                     |    5 +
 drivers/media/dvb/pt1/pt1.c                        | 1056 +++++++++
 drivers/media/dvb/pt1/va1j5jf8007s.c               |  658 ++++++
 drivers/media/dvb/pt1/va1j5jf8007s.h               |   40 +
 drivers/media/dvb/pt1/va1j5jf8007t.c               |  468 ++++
 drivers/media/dvb/pt1/va1j5jf8007t.h               |   40 +
 drivers/media/radio/Kconfig                        |    2 +-
 drivers/media/radio/radio-si4713.c                 |    1 -
 drivers/media/video/Kconfig                        |   93 +
 drivers/media/video/Makefile                       |    6 +
 drivers/media/video/adv7180.c                      |  202 ++
 drivers/media/video/adv7343.c                      |    1 -
 drivers/media/video/au0828/au0828-cards.c          |    4 +-
 drivers/media/video/bt8xx/bttv-cards.c             |   44 +-
 drivers/media/video/cafe_ccic.c                    |    2 +-
 drivers/media/video/cx18/cx18-driver.c             |    2 +-
 drivers/media/video/cx18/cx18-i2c.c                |   16 +-
 drivers/media/video/cx18/cx18-streams.c            |    4 +-
 drivers/media/video/cx231xx/cx231xx-cards.c        |    4 +-
 drivers/media/video/cx23885/cimax2.c               |   12 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   14 +-
 drivers/media/video/cx23885/cx23885-core.c         |    1 +
 drivers/media/video/cx23885/cx23885-dvb.c          |    5 +
 drivers/media/video/cx23885/cx23885-video.c        |    6 +-
 drivers/media/video/cx23885/cx23885.h              |    2 +
 drivers/media/video/cx23885/netup-eeprom.c         |    6 +-
 drivers/media/video/cx88/cx88-cards.c              |   14 +-
 drivers/media/video/cx88/cx88-video.c              |    6 +-
 drivers/media/video/davinci/Makefile               |   17 +
 drivers/media/video/davinci/ccdc_hw_device.h       |  110 +
 drivers/media/video/davinci/dm355_ccdc.c           |  978 ++++++++
 drivers/media/video/davinci/dm355_ccdc_regs.h      |  310 +++
 drivers/media/video/davinci/dm644x_ccdc.c          |  878 +++++++
 drivers/media/video/davinci/dm644x_ccdc_regs.h     |  145 ++
 drivers/media/video/davinci/vpfe_capture.c         | 2124 +++++++++++++++++
 drivers/media/video/davinci/vpif.c                 |  296 +++
 drivers/media/video/davinci/vpif.h                 |  642 +++++
 drivers/media/video/davinci/vpif_capture.c         | 2168 +++++++++++++++++
 drivers/media/video/davinci/vpif_capture.h         |  165 ++
 drivers/media/video/davinci/vpif_display.c         | 1656 +++++++++++++
 drivers/media/video/davinci/vpif_display.h         |  175 ++
 drivers/media/video/davinci/vpss.c                 |  301 +++
 drivers/media/video/em28xx/Kconfig                 |    1 +
 drivers/media/video/em28xx/Makefile                |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   59 +-
 drivers/media/video/em28xx/em28xx-core.c           |   51 +-
 drivers/media/video/em28xx/em28xx-dvb.c            |   19 +
 drivers/media/video/em28xx/em28xx-reg.h            |   16 +
 drivers/media/video/em28xx/em28xx-vbi.c            |  142 ++
 drivers/media/video/em28xx/em28xx-video.c          |  589 ++++-
 drivers/media/video/em28xx/em28xx.h                |   26 +-
 drivers/media/video/et61x251/et61x251_core.c       |    6 +-
 drivers/media/video/gspca/Kconfig                  |    1 +
 drivers/media/video/gspca/Makefile                 |    1 +
 drivers/media/video/gspca/gl860/Kconfig            |    8 +
 drivers/media/video/gspca/gl860/Makefile           |   10 +
 drivers/media/video/gspca/gl860/gl860-mi1320.c     |  537 +++++
 drivers/media/video/gspca/gl860/gl860-mi2020.c     |  937 ++++++++
 drivers/media/video/gspca/gl860/gl860-ov2640.c     |  505 ++++
 drivers/media/video/gspca/gl860/gl860-ov9655.c     |  337 +++
 drivers/media/video/gspca/gl860/gl860.c            |  785 +++++++
 drivers/media/video/gspca/gl860/gl860.h            |  108 +
 drivers/media/video/gspca/jeilinj.c                |    2 +
 drivers/media/video/gspca/m5602/m5602_ov7660.c     |  262 +++-
 drivers/media/video/gspca/m5602/m5602_ov7660.h     |  138 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |   13 +
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   19 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |  151 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |   15 +-
 drivers/media/video/gspca/vc032x.c                 |    7 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |   18 +-
 drivers/media/video/ivtv/ivtv-streams.c            |    4 +-
 drivers/media/video/mt9m001.c                      |  435 ++--
 drivers/media/video/mt9m111.c                      |  524 +++--
 drivers/media/video/mt9t031.c                      |  491 +++--
 drivers/media/video/mt9v022.c                      |  434 ++--
 drivers/media/video/mx1_camera.c                   |   78 +-
 drivers/media/video/mx3_camera.c                   |  207 +-
 drivers/media/video/mxb.c                          |   14 +-
 drivers/media/video/ov772x.c                       |  381 ++--
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |    2 +
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   10 +-
 drivers/media/video/pxa_camera.c                   |  358 ++--
 drivers/media/video/saa7134/saa7134-cards.c        |   53 +-
 drivers/media/video/saa7134/saa7134-core.c         |    6 +-
 drivers/media/video/saa7134/saa7134-dvb.c          |   30 +
 drivers/media/video/saa7134/saa7134-input.c        |    4 +
 drivers/media/video/saa7134/saa7134.h              |    1 +
 drivers/media/video/saa7164/Kconfig                |   18 +
 drivers/media/video/saa7164/Makefile               |   12 +
 drivers/media/video/saa7164/saa7164-api.c          |  600 +++++
 drivers/media/video/saa7164/saa7164-buffer.c       |  155 ++
 drivers/media/video/saa7164/saa7164-bus.c          |  448 ++++
 drivers/media/video/saa7164/saa7164-cards.c        |  624 +++++
 drivers/media/video/saa7164/saa7164-cmd.c          |  572 +++++
 drivers/media/video/saa7164/saa7164-core.c         |  740 ++++++
 drivers/media/video/saa7164/saa7164-dvb.c          |  602 +++++
 drivers/media/video/saa7164/saa7164-fw.c           |  613 +++++
 drivers/media/video/saa7164/saa7164-i2c.c          |  141 ++
 drivers/media/video/saa7164/saa7164-reg.h          |  166 ++
 drivers/media/video/saa7164/saa7164-types.h        |  287 +++
 drivers/media/video/saa7164/saa7164.h              |  400 ++++
 drivers/media/video/sh_mobile_ceu_camera.c         | 1062 ++++++++-
 drivers/media/video/sn9c102/sn9c102_core.c         |    6 +-
 drivers/media/video/soc_camera.c                   |  725 ++++---
 drivers/media/video/soc_camera_platform.c          |  163 +-
 drivers/media/video/tuner-core.c                   |   12 +
 drivers/media/video/tvp514x.c                      | 1030 ++++-----
 drivers/media/video/tvp514x_regs.h                 |   10 -
 drivers/media/video/tw9910.c                       |  361 ++--
 drivers/media/video/usbvision/usbvision-i2c.c      |   12 +-
 drivers/media/video/uvc/uvc_video.c                |    7 +-
 drivers/media/video/v4l1-compat.c                  |   14 +-
 drivers/media/video/v4l2-common.c                  |  133 --
 drivers/media/video/v4l2-dev.c                     |  154 +-
 drivers/media/video/vino.c                         |    8 +-
 drivers/media/video/w9968cf.c                      |    4 +-
 drivers/media/video/zc0301/zc0301_core.c           |    6 +-
 drivers/media/video/zoran/zoran_card.c             |    8 +-
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/cx25821/Kconfig                    |   34 +
 drivers/staging/cx25821/Makefile                   |   14 +
 drivers/staging/cx25821/README                     |    6 +
 drivers/staging/cx25821/cx25821-alsa.c             |  789 +++++++
 drivers/staging/cx25821/cx25821-audio-upstream.c   |  804 +++++++
 drivers/staging/cx25821/cx25821-audio-upstream.h   |   57 +
 drivers/staging/cx25821/cx25821-audio.h            |   57 +
 drivers/staging/cx25821/cx25821-audups11.c         |  434 ++++
 drivers/staging/cx25821/cx25821-biffuncs.h         |   45 +
 drivers/staging/cx25821/cx25821-cards.c            |   70 +
 drivers/staging/cx25821/cx25821-core.c             | 1551 ++++++++++++
 drivers/staging/cx25821/cx25821-gpio.c             |   98 +
 drivers/staging/cx25821/cx25821-gpio.h             |    2 +
 drivers/staging/cx25821/cx25821-i2c.c              |  419 ++++
 drivers/staging/cx25821/cx25821-medusa-defines.h   |   51 +
 drivers/staging/cx25821/cx25821-medusa-reg.h       |  455 ++++
 drivers/staging/cx25821/cx25821-medusa-video.c     |  869 +++++++
 drivers/staging/cx25821/cx25821-medusa-video.h     |   49 +
 drivers/staging/cx25821/cx25821-reg.h              | 1592 +++++++++++++
 drivers/staging/cx25821/cx25821-sram.h             |  261 +++
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |  835 +++++++
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |  101 +
 drivers/staging/cx25821/cx25821-video-upstream.c   |  894 +++++++
 drivers/staging/cx25821/cx25821-video-upstream.h   |  109 +
 drivers/staging/cx25821/cx25821-video.c            | 1299 +++++++++++
 drivers/staging/cx25821/cx25821-video.h            |  194 ++
 drivers/staging/cx25821/cx25821-video0.c           |  451 ++++
 drivers/staging/cx25821/cx25821-video1.c           |  451 ++++
 drivers/staging/cx25821/cx25821-video2.c           |  452 ++++
 drivers/staging/cx25821/cx25821-video3.c           |  451 ++++
 drivers/staging/cx25821/cx25821-video4.c           |  450 ++++
 drivers/staging/cx25821/cx25821-video5.c           |  450 ++++
 drivers/staging/cx25821/cx25821-video6.c           |  450 ++++
 drivers/staging/cx25821/cx25821-video7.c           |  449 ++++
 drivers/staging/cx25821/cx25821-videoioctl.c       |  496 ++++
 drivers/staging/cx25821/cx25821-vidups10.c         |  435 ++++
 drivers/staging/cx25821/cx25821-vidups9.c          |  433 ++++
 drivers/staging/cx25821/cx25821.h                  |  602 +++++
 drivers/staging/go7007/Kconfig                     |   84 +-
 drivers/staging/go7007/Makefile                    |   20 +-
 drivers/staging/go7007/go7007-driver.c             |   35 +-
 drivers/staging/go7007/go7007-fw.c                 |    3 +-
 drivers/staging/go7007/go7007-i2c.c                |   12 +-
 drivers/staging/go7007/go7007-priv.h               |    6 +-
 drivers/staging/go7007/go7007-usb.c                |   58 +-
 drivers/staging/go7007/go7007-v4l2.c               |  225 +-
 drivers/staging/go7007/go7007.txt                  |  176 +-
 drivers/staging/go7007/s2250-board.c               |  107 +-
 drivers/staging/go7007/s2250-loader.c              |    8 +-
 drivers/staging/go7007/snd-go7007.c                |    2 +-
 drivers/staging/go7007/wis-tw9903.c                |    3 +-
 include/linux/dvb/frontend.h                       |   46 +-
 include/linux/dvb/version.h                        |    2 +-
 include/linux/videodev2.h                          |    3 +-
 include/media/davinci/ccdc_types.h                 |   43 +
 include/media/davinci/dm355_ccdc.h                 |  321 +++
 include/media/davinci/dm644x_ccdc.h                |  184 ++
 include/media/davinci/vpfe_capture.h               |  198 ++
 include/media/davinci/vpfe_types.h                 |   51 +
 include/media/davinci/vpss.h                       |   69 +
 include/media/soc_camera.h                         |  113 +-
 include/media/soc_camera_platform.h                |    9 +-
 include/media/tuner.h                              |    2 +
 include/media/tvp514x.h                            |    4 -
 include/media/v4l2-chip-ident.h                    |    3 +
 include/media/v4l2-common.h                        |   24 +-
 include/media/v4l2-dev.h                           |    6 +-
 361 files changed, 86808 insertions(+), 4033 deletions(-)
 create mode 100644 Documentation/DocBook/dvb/.gitignore
 create mode 100644 Documentation/DocBook/dvb/audio.xml
 create mode 100644 Documentation/DocBook/dvb/ca.xml
 create mode 100644 Documentation/DocBook/dvb/demux.xml
 create mode 100644 Documentation/DocBook/dvb/dvbapi.xml
 create mode 100644 Documentation/DocBook/dvb/dvbstb.pdf
 create mode 100644 Documentation/DocBook/dvb/dvbstb.png
 create mode 100644 Documentation/DocBook/dvb/examples.xml
 create mode 100644 Documentation/DocBook/dvb/frontend.xml
 create mode 100644 Documentation/DocBook/dvb/intro.xml
 create mode 100644 Documentation/DocBook/dvb/isdbt.xml
 create mode 100644 Documentation/DocBook/dvb/kdapi.xml
 create mode 100644 Documentation/DocBook/dvb/net.xml
 create mode 100644 Documentation/DocBook/dvb/video.xml
 create mode 100644 Documentation/DocBook/media-entities.tmpl
 create mode 100644 Documentation/DocBook/media-indices.tmpl
 create mode 100644 Documentation/DocBook/media.tmpl
 create mode 100644 Documentation/DocBook/v4l/.gitignore
 create mode 100644 Documentation/DocBook/v4l/biblio.xml
 create mode 100644 Documentation/DocBook/v4l/capture.c.xml
 create mode 100644 Documentation/DocBook/v4l/common.xml
 create mode 100644 Documentation/DocBook/v4l/compat.xml
 create mode 100644 Documentation/DocBook/v4l/controls.xml
 create mode 100644 Documentation/DocBook/v4l/crop.gif
 create mode 100644 Documentation/DocBook/v4l/crop.pdf
 create mode 100644 Documentation/DocBook/v4l/dev-capture.xml
 create mode 100644 Documentation/DocBook/v4l/dev-codec.xml
 create mode 100644 Documentation/DocBook/v4l/dev-effect.xml
 create mode 100644 Documentation/DocBook/v4l/dev-osd.xml
 create mode 100644 Documentation/DocBook/v4l/dev-output.xml
 create mode 100644 Documentation/DocBook/v4l/dev-overlay.xml
 create mode 100644 Documentation/DocBook/v4l/dev-radio.xml
 create mode 100644 Documentation/DocBook/v4l/dev-raw-vbi.xml
 create mode 100644 Documentation/DocBook/v4l/dev-rds.xml
 create mode 100644 Documentation/DocBook/v4l/dev-sliced-vbi.xml
 create mode 100644 Documentation/DocBook/v4l/dev-teletext.xml
 create mode 100644 Documentation/DocBook/v4l/driver.xml
 create mode 100644 Documentation/DocBook/v4l/fdl-appendix.xml
 create mode 100644 Documentation/DocBook/v4l/fieldseq_bt.gif
 create mode 100644 Documentation/DocBook/v4l/fieldseq_bt.pdf
 create mode 100644 Documentation/DocBook/v4l/fieldseq_tb.gif
 create mode 100644 Documentation/DocBook/v4l/fieldseq_tb.pdf
 create mode 100644 Documentation/DocBook/v4l/func-close.xml
 create mode 100644 Documentation/DocBook/v4l/func-ioctl.xml
 create mode 100644 Documentation/DocBook/v4l/func-mmap.xml
 create mode 100644 Documentation/DocBook/v4l/func-munmap.xml
 create mode 100644 Documentation/DocBook/v4l/func-open.xml
 create mode 100644 Documentation/DocBook/v4l/func-poll.xml
 create mode 100644 Documentation/DocBook/v4l/func-read.xml
 create mode 100644 Documentation/DocBook/v4l/func-select.xml
 create mode 100644 Documentation/DocBook/v4l/func-write.xml
 create mode 100644 Documentation/DocBook/v4l/io.xml
 create mode 100644 Documentation/DocBook/v4l/keytable.c.xml
 create mode 100644 Documentation/DocBook/v4l/libv4l.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-grey.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv12.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv16.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-packed-rgb.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-packed-yuv.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-sbggr16.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-sbggr8.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-sgbrg8.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-sgrbg8.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-uyvy.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-vyuy.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y16.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y41p.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yuv410.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yuv411p.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yuv420.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yuv422p.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yuyv.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yvyu.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt.xml
 create mode 100644 Documentation/DocBook/v4l/remote_controllers.xml
 create mode 100644 Documentation/DocBook/v4l/v4l2.xml
 create mode 100644 Documentation/DocBook/v4l/v4l2grab.c.xml
 create mode 100644 Documentation/DocBook/v4l/vbi_525.gif
 create mode 100644 Documentation/DocBook/v4l/vbi_525.pdf
 create mode 100644 Documentation/DocBook/v4l/vbi_625.gif
 create mode 100644 Documentation/DocBook/v4l/vbi_625.pdf
 create mode 100644 Documentation/DocBook/v4l/vbi_hsync.gif
 create mode 100644 Documentation/DocBook/v4l/vbi_hsync.pdf
 create mode 100644 Documentation/DocBook/v4l/videodev2.h.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-cropcap.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-dbg-g-chip-ident.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-dbg-g-register.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-encoder-cmd.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-enum-fmt.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-enum-frameintervals.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-enum-framesizes.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-enumaudio.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-enumaudioout.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-enuminput.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-enumoutput.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-enumstd.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-audio.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-audioout.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-crop.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-ctrl.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-enc-index.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-fbuf.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-fmt.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-frequency.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-input.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-jpegcomp.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-modulator.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-output.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-parm.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-priority.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-sliced-vbi-cap.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-std.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-g-tuner.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-log-status.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-overlay.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-qbuf.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-querybuf.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-querycap.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-queryctrl.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-querystd.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-reqbufs.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-streamon.xml
 create mode 100644 Documentation/video4linux/CARDLIST.saa7164
 create mode 100644 drivers/media/dvb/dvb-usb/friio-fe.c
 create mode 100644 drivers/media/dvb/dvb-usb/friio.c
 create mode 100644 drivers/media/dvb/dvb-usb/friio.h
 create mode 100644 drivers/media/dvb/frontends/dib8000.c
 create mode 100644 drivers/media/dvb/frontends/dib8000.h
 create mode 100644 drivers/media/dvb/pt1/Kconfig
 create mode 100644 drivers/media/dvb/pt1/Makefile
 create mode 100644 drivers/media/dvb/pt1/pt1.c
 create mode 100644 drivers/media/dvb/pt1/va1j5jf8007s.c
 create mode 100644 drivers/media/dvb/pt1/va1j5jf8007s.h
 create mode 100644 drivers/media/dvb/pt1/va1j5jf8007t.c
 create mode 100644 drivers/media/dvb/pt1/va1j5jf8007t.h
 create mode 100644 drivers/media/video/adv7180.c
 create mode 100644 drivers/media/video/davinci/Makefile
 create mode 100644 drivers/media/video/davinci/ccdc_hw_device.h
 create mode 100644 drivers/media/video/davinci/dm355_ccdc.c
 create mode 100644 drivers/media/video/davinci/dm355_ccdc_regs.h
 create mode 100644 drivers/media/video/davinci/dm644x_ccdc.c
 create mode 100644 drivers/media/video/davinci/dm644x_ccdc_regs.h
 create mode 100644 drivers/media/video/davinci/vpfe_capture.c
 create mode 100644 drivers/media/video/davinci/vpif.c
 create mode 100644 drivers/media/video/davinci/vpif.h
 create mode 100644 drivers/media/video/davinci/vpif_capture.c
 create mode 100644 drivers/media/video/davinci/vpif_capture.h
 create mode 100644 drivers/media/video/davinci/vpif_display.c
 create mode 100644 drivers/media/video/davinci/vpif_display.h
 create mode 100644 drivers/media/video/davinci/vpss.c
 create mode 100644 drivers/media/video/em28xx/em28xx-vbi.c
 create mode 100644 drivers/media/video/gspca/gl860/Kconfig
 create mode 100644 drivers/media/video/gspca/gl860/Makefile
 create mode 100644 drivers/media/video/gspca/gl860/gl860-mi1320.c
 create mode 100644 drivers/media/video/gspca/gl860/gl860-mi2020.c
 create mode 100644 drivers/media/video/gspca/gl860/gl860-ov2640.c
 create mode 100644 drivers/media/video/gspca/gl860/gl860-ov9655.c
 create mode 100644 drivers/media/video/gspca/gl860/gl860.c
 create mode 100644 drivers/media/video/gspca/gl860/gl860.h
 create mode 100644 drivers/media/video/saa7164/Kconfig
 create mode 100644 drivers/media/video/saa7164/Makefile
 create mode 100644 drivers/media/video/saa7164/saa7164-api.c
 create mode 100644 drivers/media/video/saa7164/saa7164-buffer.c
 create mode 100644 drivers/media/video/saa7164/saa7164-bus.c
 create mode 100644 drivers/media/video/saa7164/saa7164-cards.c
 create mode 100644 drivers/media/video/saa7164/saa7164-cmd.c
 create mode 100644 drivers/media/video/saa7164/saa7164-core.c
 create mode 100644 drivers/media/video/saa7164/saa7164-dvb.c
 create mode 100644 drivers/media/video/saa7164/saa7164-fw.c
 create mode 100644 drivers/media/video/saa7164/saa7164-i2c.c
 create mode 100644 drivers/media/video/saa7164/saa7164-reg.h
 create mode 100644 drivers/media/video/saa7164/saa7164-types.h
 create mode 100644 drivers/media/video/saa7164/saa7164.h
 create mode 100644 drivers/staging/cx25821/Kconfig
 create mode 100644 drivers/staging/cx25821/Makefile
 create mode 100644 drivers/staging/cx25821/README
 create mode 100644 drivers/staging/cx25821/cx25821-alsa.c
 create mode 100644 drivers/staging/cx25821/cx25821-audio-upstream.c
 create mode 100644 drivers/staging/cx25821/cx25821-audio-upstream.h
 create mode 100644 drivers/staging/cx25821/cx25821-audio.h
 create mode 100644 drivers/staging/cx25821/cx25821-audups11.c
 create mode 100644 drivers/staging/cx25821/cx25821-biffuncs.h
 create mode 100644 drivers/staging/cx25821/cx25821-cards.c
 create mode 100644 drivers/staging/cx25821/cx25821-core.c
 create mode 100644 drivers/staging/cx25821/cx25821-gpio.c
 create mode 100644 drivers/staging/cx25821/cx25821-gpio.h
 create mode 100644 drivers/staging/cx25821/cx25821-i2c.c
 create mode 100644 drivers/staging/cx25821/cx25821-medusa-defines.h
 create mode 100644 drivers/staging/cx25821/cx25821-medusa-reg.h
 create mode 100644 drivers/staging/cx25821/cx25821-medusa-video.c
 create mode 100644 drivers/staging/cx25821/cx25821-medusa-video.h
 create mode 100644 drivers/staging/cx25821/cx25821-reg.h
 create mode 100644 drivers/staging/cx25821/cx25821-sram.h
 create mode 100644 drivers/staging/cx25821/cx25821-video-upstream-ch2.c
 create mode 100644 drivers/staging/cx25821/cx25821-video-upstream-ch2.h
 create mode 100644 drivers/staging/cx25821/cx25821-video-upstream.c
 create mode 100644 drivers/staging/cx25821/cx25821-video-upstream.h
 create mode 100644 drivers/staging/cx25821/cx25821-video.c
 create mode 100644 drivers/staging/cx25821/cx25821-video.h
 create mode 100644 drivers/staging/cx25821/cx25821-video0.c
 create mode 100644 drivers/staging/cx25821/cx25821-video1.c
 create mode 100644 drivers/staging/cx25821/cx25821-video2.c
 create mode 100644 drivers/staging/cx25821/cx25821-video3.c
 create mode 100644 drivers/staging/cx25821/cx25821-video4.c
 create mode 100644 drivers/staging/cx25821/cx25821-video5.c
 create mode 100644 drivers/staging/cx25821/cx25821-video6.c
 create mode 100644 drivers/staging/cx25821/cx25821-video7.c
 create mode 100644 drivers/staging/cx25821/cx25821-videoioctl.c
 create mode 100644 drivers/staging/cx25821/cx25821-vidups10.c
 create mode 100644 drivers/staging/cx25821/cx25821-vidups9.c
 create mode 100644 drivers/staging/cx25821/cx25821.h
 create mode 100644 include/media/davinci/ccdc_types.h
 create mode 100644 include/media/davinci/dm355_ccdc.h
 create mode 100644 include/media/davinci/dm644x_ccdc.h
 create mode 100644 include/media/davinci/vpfe_capture.h
 create mode 100644 include/media/davinci/vpfe_types.h
 create mode 100644 include/media/davinci/vpss.h

Abylay Ospan (2):
      V4L/DVB (12956): Fix gpio mutex in NetUP Dual DVB-S2 CI card.
      V4L/DVB (12957): Fix MAC address reading from EEPROM in NetUP Dual DVB-S2 CI card.

Akihiro Tsukada (1):
      V4L/DVB (13000): add driver for 774 Friio White USB ISDB-T receiver

Andreas Mohr (1):
      V4L/DVB (13003): Correct dangerous and inefficient msecs_to_jiffies() calculation in some V4L2 drivers

Andy Walls (1):
      V4L/DVB (12884): cx18: Eliminate warning about discarding 'const' is assignment for IR init

Antti Palosaari (9):
      V4L/DVB (12752): get_dvb_firmware: add af9015 firmware
      V4L/DVB (12754): af9015: [2/2] fix USB TS configuration
      V4L/DVB (12755): af9015: improve usb control message function slightly
      V4L/DVB (12756): af9015: fix typo in register compare
      V4L/DVB (12950): tuner-simple: add Philips CU1216L
      V4L/DVB (12951): em28xx: add Reddo DVB-C USB TV Box
      V4L/DVB (12959): anysee: increase BULK transfer size from 512 to 8192
      V4L/DVB (12960): anysee: coding style fix
      V4L/DVB (12962): ce6230: increase BULK transfer size from 512 to 8192

Brian Kloppenborg (1):
      V4L/DVB (12878): gspca - m5602-s5k4aa: Add vflip quirk for the GX700

Chaithrika U S (5):
      V4L/DVB (12175): davinci/vpif: Add Video Port Interface (VPIF) driver
      V4L/DVB (12176): davinci/vpif_display: Add VPIF display driver
      V4L/DVB (12177): dm646x: Add an entry for dm646x EVM card at building system
      V4L/DVB (12178): vpif_display: Fix compile time warnings for mutex locking
      V4L/DVB (12453a): DaVinci: DM646x: Update the structure name as per header file changes

Devin Heitmueller (14):
      V4L/DVB (12740): em28xx: better describe vinctrl registers
      V4L/DVB (12741): em28xx: make video isoc stream work when VBI is enabled
      V4L/DVB (12742): em28xx: add raw VBI support for NTSC
      V4L/DVB (12743): em28xx: fix mmap_mapper with vbi
      V4L/DVB (12744): em28xx: restructure fh/dev locking to handle both video and vbi
      V4L/DVB (12745): em28xx: remove unreferenced variable
      V4L/DVB (12746): em28xx: do not create /dev/vbiX device if VBI not supported
      V4L/DVB (12747): em28xx: only advertise VBI capability if supported
      V4L/DVB (12748): em28xx: implement g_std v4l call
      V4L/DVB (12749): em28xx: remove unneeded code that set VINCTRL register
      V4L/DVB (12750): em28xx: fix unused variable warning
      V4L/DVB (12880): em28xx: fix codingstyle issues introduced with VBI support
      V4L/DVB (12881): em28xx: fix codingstyle issues in em28xx-video.c
      V4L/DVB (12882): em28xx: remove text editor tags from em28xx-vbi.c

Dmitri Belimov (1):
      V4L/DVB (13001): Key filter for BeholdTV cards.

Dmitry Belimov (1):
      V4L/DVB (13011): Change tuner type of BeholdTV cards

Erik Andrén (21):
      V4L/DVB (12877): gspca - m5602-s5k4aa: Add vflip quirk for the Amilo Pa 2548
      V4L/DVB (12977): gspca - m5602-ov7660: Create blue gain control
      V4L/DVB (12978): gspca - m5602-ov7660: Add red gain control
      V4L/DVB (12979): gspca - m5602-ov7660: Ensure that the default exposure is set
      V4L/DVB (12980): gspca - m5602-ov7660: Create auto white balance ctrl
      V4L/DVB (12981): gspca - m5602-ov7660: Set blue and red gain at init
      V4L/DVB (12982): gspca - m5602-ov7660: Add auto gain ctrl
      V4L/DVB (12983): gspca - m5602-ov7660: Add auto exposure ctrl
      V4L/DVB (12984): gspca - m5602-ov7660: Use a new raw init
      V4L/DVB (12985): gspca - m5602-ov7660: Replace magic constants with defines
      V4L/DVB (12986): gspca - m5602-ov7660: Add hflip, vflip controls
      V4L/DVB (12987): gspca - m5602-ov7660: Set the hsync correctly
      V4L/DVB (12988): gspca - m5602-ov7660: Remove old init
      V4L/DVB (12989): gspca - m5602-ov7660: Don't set gain during init
      V4L/DVB (12990): gspca - m5602-ov7660: Don't set blue and red gain during init
      V4L/DVB (12991): gspca - m5602-ov7660: Remove redundant init writes
      V4L/DVB (12992): gspca - m5602-ov7660: Disable red and blue gain for now
      V4L/DVB (13004): gspca - stv06xx: Harmonize the debug macros when tracing writes and reads
      V4L/DVB (13005): gspca - stv06xx: Translate swedish comments to english
      V4L/DVB (13006): gspca - stv06xx: Fix a misindentation
      V4L/DVB (13007): gspca - stv06xx-hdcs: Add exposure and gain ctrls to hdcs_1020

Guennadi Liakhovetski (34):
      V4L/DVB (12504): soc-camera: prepare soc_camera_platform.c and its users for conversion
      V4L/DVB (12505): soc_camera_platform: pass device pointer from soc-camera core on .add_device()
      V4L/DVB (12506): soc-camera: convert to platform device
      V4L/DVB (12507): sh: soc-camera updates
      V4L/DVB (12508): soc-camera: remove unused .iface from struct soc_camera_platform_info
      V4L/DVB (12509): sh: prepare board-ap325rxa.c for v4l2-subdev conversion
      V4L/DVB (12510): soc-camera: (partially) convert to v4l2-(sub)dev API
      V4L/DVB (12511): V4L2: add a new V4L2_CID_BAND_STOP_FILTER integer control
      V4L/DVB (12512): ov772x: implement a band-stop filter support
      V4L/DVB (12513): soc-camera: add support for camera-host controls
      V4L/DVB (12514): sh_mobile_ceu_camera: add a control for the camera low-pass filter
      V4L/DVB (12515): soc-camera: use struct v4l2_rect in struct soc_camera_device
      V4L/DVB (12516): ov772x: successful S_FMT and S_CROP must update user-provided rectangle
      V4L/DVB (12517): mt9t031: improve rectangle placement in invalid S_CROP
      V4L/DVB (12518): ov772x: S_CROP must return actually configured geometry
      V4L/DVB (12519): soc-camera: put pixel format initialisation back in probe, add .put_formats()
      V4L/DVB (12520): sh-mobile-ceu-camera: do not wait for interrupt when releasing buffers
      V4L/DVB (12521): soc-camera: use .s_std() from struct v4l2_subdev_core_ops
      V4L/DVB (12522): sh-mobile-ceu-camera: implement host-side cropping
      V4L/DVB (12523): tw9910: return updated geometry on successful S_FMT and S_CROP
      V4L/DVB (12524): soc-camera: S_CROP V4L2 API compliance fix
      V4L/DVB (12525): soc-camera: prohibit geometry change with initialised buffers
      V4L/DVB (12526): ov772x: do not use scaling for cropping
      V4L/DVB (12527): tw9910: do not lie about cropping abilities
      V4L/DVB (12528): sh_mobile_ceu_camera: implement host-side image scaling
      V4L/DVB (12529): soc-camera: switch to s_crop v4l2-subdev video operation
      V4L/DVB (12530): soc-camera: switch to using v4l2_subdev_call()
      V4L/DVB (12531): soc-camera: Use I2C device for dev_{dbg,info,...} output in all clients
      V4L/DVB (12532): soc-camera: Use camera device object for core output
      V4L/DVB (12533): soc-camera: Use video device object for output in host drivers
      V4L/DVB (12534): soc-camera: V4L2 API compliant scaling (S_FMT) and cropping (S_CROP)
      V4L/DVB (12535): soc-camera: remove .init() and .release() methods from struct soc_camera_ops
      V4L/DVB (12536): soc-camera: remove .gain and .exposure struct soc_camera_device members
      V4L/DVB (12580): soc-camera: remove now unneeded subdevice group ID assignments

HIRANO Takahito (1):
      V4L/DVB (12997): Add the DTV_ISDB_TS_ID property for ISDB_S

Hans Verkuil (7):
      V4L/DVB (12948): v4l1-compat: fix VIDIOC_G_STD handling
      V4L/DVB (12540): v4l: simplify v4l2_i2c_new_subdev and friends
      V4L/DVB (12541): v4l: remove video_register_device_index
      V4L/DVB (12722): v4l2-dev: replace 'kernel number' by 'device node number'.
      V4L/DVB (12723): ivtv/cx18: replace 'kernel number' with 'device node number'.
      V4L/DVB (12724): v4l2-dev: add simple wrapper functions around the devnode numbers
      V4L/DVB (12725): v4l: warn when desired devnodenr is in use & add _no_warn function

Henk Vergonet (3):
      V4L/DVB (12870): tda18271: update temperature compensation calculatation formula
      V4L/DVB (12871): tda18271: fix bad data in tda18271_cid_target table
      V4L/DVB (13002): Adds support for Zolid Hybrid PCI card:

Huang Weiyi (2):
      V4L/DVB (12201): adv7343: remove unused #include <linux/version.h>
      V4L/DVB (13029): radio-si4713: remove #include <linux/version.h>

James Blanford (2):
      V4L/DVB (13008): gspca - stv06xx-hdcs: Fixup exposure
      V4L/DVB (13009): gspca - stv06xx-hdcs: Reduce exposure range

Jean-Francois Moine (1):
      V4L/DVB (12953): gspca - vc032x: Bad GPIO of the Samsung Q1 on start/stop streaming.

Jose Alberto Reguero (1):
      V4L/DVB (12753): af9015: [1/2] fix USB TS configuration

Julia Lawall (1):
      V4L/DVB (13012): uvc: introduce missing kfree

Matti J. Aaltonen (1):
      V4L/DVB (13013): FM TX: si4713: Kconfig: Fixed two typos.

Mauro Carvalho Chehab (28):
      V4L/DVB (12730): Add conexant cx25821 driver
      V4L/DVB (12731): cx25821: Add missing include
      V4L/DVB (12732): cx25821: fix bad whitespacing
      V4L/DVB (12733): cx25821: some CodingStyle fixes
      V4L/DVB (12734): cx25821: Fix some compilation troubles
      cx25821: Add driver to the building system
      V4L/DVB (12761): DocBook: add media API specs
      V4L/DVB (12847): cx25821: Add README with todo list
      V4L/DVB (12851): cx25821/Makefile: Cleanup
      V4L/DVB (12858): go7007: whitespacing cleanups
      V4L/DVB (12859): go7007: semaphore -> mutex conversion
      DocBook/media: renamed xml documents to tmpl
      DocBook/media: copy also the pictures to the proper place
      DocBook: Don't use graphics callouts
      DocBook/media: Some typo fixes
      DocBook/media: fix some broken links
      DocBook/media: update dvb url's and use ulink tag instead of emphasis
      DocBook/media: Remove Satellites from Analog TV Tuners and Modulators
      V4L/DVB (12906): dib0700: Add support for Prolink SBTVD
      V4L/DVB (12915): DocBook/media: Add isdb-t documentation
      V4L/DVB (12917): DocBook/media: add V4L2_PIX_FMT_TM6000
      V4L/DVB (12919): DocBook/media: fix some DocBook non-compliances
      V4L/DVB (12920): DocBook/media: Some xmlto or DTD's don't accept reference inside appendix
      Docbook/media: Fix some issues at the docbooks
      V4L/DVB (12993a): saa7164: Fix compilation warning on i386
      V4L/DVB(12993b): gl860: Prevent a potential risk of zeroing a floating pointer
      V4L/DVB (12999): Add a driver for Earthsoft PT1
      V4L/DVB (13033): pt1: Don't use a deprecated DMA_BIT_MASK macro

Michael Krufky (16):
      V4L/DVB (12861): tda18271: add support for additional low-power standby modes
      V4L/DVB (12862): tda18271: add debug to show which standby mode is in use
      V4L/DVB (12863): tda18271: add new standby mode: slave tuner output / loop thru on
      V4L/DVB (12864): tda18271: change output feature configuration to a bitmask
      V4L/DVB (12865): tda18271: move tda18271_sleep directly below tda18271_init
      V4L/DVB (12866): tda18271: move small_i2c assignment to the state config block
      V4L/DVB (12867): tda18271: ensure that configuration options are set for multiple instances
      V4L/DVB (12868): tda18271: improve error log in function tda18271_write_regs
      V4L/DVB (12869): tda18271: fix comments and make tda18271_agc debug less verbose
      V4L/DVB (12873): saa7134: disable tda18271 slave tuner output / loop thru in standby mode
      V4L/DVB (12874): pvrusb2: disable tda18271 slave tuner output / loop thru in standby mode
      V4L/DVB (12875): cx23885: disable tda18271 slave tuner output / loop thru in standby mode
      V4L/DVB (12964): tuner-core: add support for NXP TDA18271 without TDA829X demod
      V4L/DVB (12967): saa7164: fix Kconfig: rename DVB_FE_CUSTOMIZE to MEDIA_TUNER_CUSTOMISE
      V4L/DVB (12968): saa7164: fix Kconfig: remove HOTPLUG dependency
      V4L/DVB (12970): saa7164: fix 64bit build warning

Muralidharan Karicheri (13):
      V4L/DVB (12246): tvp514x: Migration to sub-device framework
      V4L/DVB (12247): tvp514x: formatting comments as per kernel documentation
      V4L/DVB (12248): v4l: vpfe capture bridge driver for DM355 and DM6446
      V4L/DVB (12249): v4l: ccdc hw device header file for vpfe capture
      V4L/DVB (12250): v4l: dm355 ccdc module for vpfe capture driver
      V4L/DVB (12251): v4l: dm644x ccdc module for vpfe capture driver
      V4L/DVB (12252): v4l: ccdc types used across ccdc modules for vpfe capture driver
      V4L/DVB (12253): v4l: common vpss module for video drivers
      V4L/DVB (12254): v4l: Makefile and config files for vpfe capture driver
      V4L/DVB (12906a): V4L : vpif display updates to support vpif capture
      V4L/DVB (12906b): V4L : vpif capture - Kconfig and Makefile changes
      V4L/DVB (12906c): V4L : vpif capture driver for DM6467
      V4L/DVB (12906d): V4L : vpif updates for DM6467 vpif capture driver

Olivier Grenie (3):
      V4L/DVB (12886): Added new Pinnacle USB devices
      V4L/DVB (12887): DIB7000P: SNR calcuation forr DiB7000P
      V4L/DVB (12888): STK7770P: Add support for STK7770P

Olivier Lorin (1):
      V4L/DVB (12954): gspca - gl860: Addition of GL860 based webcams

Patrick Boettcher (8):
      V4L/DVB (12889): DIB0700: added USB IDs for a Terratec DVB-T XXS
      V4L/DVB (12892): DVB-API: add support for ISDB-T and ISDB-Tsb (version 5.1)
      V4L/DVB (12896): ISDB-T: add mapping of LAYER_ENABLED to frontend-cache
      V4L/DVB (12898): DiB0070: Update to latest internal release
      V4L/DVB (12899): DiB0070: Indenting driver with indent -linux
      V4L/DVB (12900): DiB8000: added support for DiBcom ISDB-T/ISDB-Tsb demodulator DiB8000
      V4L/DVB (12901): DiB0700: add support for STK807XP and STK807XPVR
      V4L/DVB (12903): DiB8000: fix channel search parameter initialization

Pete Eberlein (8):
      V4L/DVB (13020): go7007: Updates to Kconfig and Makefile
      V4L/DVB (13021): go7007: Fix whitespace and line lengths
      V4L/DVB (13022): go7007: Fix mpeg controls
      V4L/DVB (13023): go7007: Merge struct gofh and go declarations
      V4L/DVB (13024): go7007: Implement vidioc_g_std and vidioc_querystd
      V4L/DVB (13025): s2250-board: Fix memory leaks
      V4L/DVB (13026): s2250-board: Implement brightness and contrast controls
      V4L/DVB (13027): go7007: convert printks to v4l2_info

Richard Röjfors (1):
      V4L/DVB (13019): video: initial support for ADV7180

Roel Kluin (4):
      V4L/DVB (13015): kmalloc failure ignored in m920x_firmware_download()
      V4L/DVB (13016): kmalloc failure ignored in lgdt3304_attach() and s921_attach()
      V4L/DVB (13017): gspca: kmalloc failure ignored in sd_start()
      V4L/DVB (13018): kzalloc failure ignored in au8522_probe()

Steven Toth (28):
      V4L/DVB (12922): Add the SAA7164 I2C bus identifier
      V4L/DVB (12923): SAA7164: Add support for the NXP SAA7164 silicon
      V4L/DVB (12924): SAA7164: Fix some 32/64bit compile time warnings
      V4L/DVB (12925): SAA7164: Adjust I/F's to the TDA10048 enabling DVB-T lock
      V4L/DVB (12926): SAA7164: Email address change
      V4L/DVB (12927): SAA7164: Remove volatiles for PCI writes (coding style violation)
      V4L/DVB (12928): SAA7164: Increase firmware load tolerance
      V4L/DVB (12929): SAA7164: OOPS avoidance during interrupt handling
      V4L/DVB (12930): SAA7164: Removed spurious I2C errors during driver load with DVB-T boards.
      V4L/DVB (12931): SAA7164: Fix the 88021 definition to work with production boards.
      V4L/DVB (12932): SAA7164: Fixed the missing eeprom parse on a specific board.
      V4L/DVB (12933): SAA7164: Fix IRQ related system hang when firmware is not found.
      V4L/DVB (12934): SAA7164: Fix i2c eeprom read errors during load (some boards).
      V4L/DVB (12935): SAA7164: Ensure we specify I/F's for all bandwidths
      V4L/DVB (12936): SAA7164: Added waitsecs module parameter
      V4L/DVB (12937): SAA7164: Cleanup a printk
      V4L/DVB (12938): SAA7164: Increase the firmware command timeout to avoid firmware errors.
      V4L/DVB (12939): SAA7164: Removed a duplicate call to address any PCI quirks.
      V4L/DVB (12940): SAA7164: IRQ / message timeout related change
      V4L/DVB (12941): SAA7164: Removed spurious debug
      V4L/DVB (12942): SAA7164: HVR2250 changes related to attach time tuner configuration
      V4L/DVB (12943): SAA7164: Add a warning about addr usage
      V4L/DVB (12944): SAA7164: Minor i2c assignment cleanup
      V4L/DVB (12945): SAA7164: Ensure the HVR-2200 second tuner is configured in slave mode.
      V4L/DVB (12946): SAA7164: Add support for a new HVR-2250 hardware revision
      V4L/DVB (12974): SAA7164: Remove the SAA7164 bus id, no longer required.
      V4L/DVB (12975): SAA7164: Remove the i2c client_attach/detach support, no longer required.
      V4L/DVB (12976): SAA7164: Removed bus registration messages from driver startup

Uwe Bugla (1):
      V4L/DVB (12902): Documentation: synchronize documentation for Technisat cards

Vladimir Geroy (1):
      V4L/DVB (13014): Add support for Compro VideoMate E800 (DVB-T part only)

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
