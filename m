Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2924 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaF0IpP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 04:45:15 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id s5R8jB5r077426
	for <linux-media@vger.kernel.org>; Fri, 27 Jun 2014 10:45:13 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.83.144] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 6ACD32A1FCD
	for <linux-media@vger.kernel.org>; Fri, 27 Jun 2014 10:45:05 +0200 (CEST)
Message-ID: <53AD2F16.2010102@xs4all.nl>
Date: Fri, 27 Jun 2014 10:45:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] Patches for 3.17
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

For the most part these patches are a bunch of cleanups and fixes for 3.17.

In addition the deprecated sn9c102 driver is removed and the V4L2_FL_USE_FH_PRIO
is removed now that all drivers using struct v4l2_fh use the core prio support.

Regards,

	Hans

The following changes since commit b5b620584b9c4644b85e932895a742e0c192d66c:

   [media] technisat-sub2: Fix stream curruption on high bitrate (2014-06-26 09:20:18 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v3.17a

for you to fetch changes up to 485f9441f2845bb83da6a31e90357d23b293e032:

   media: Documentation: remove V4L2_FL_USE_FH_PRIO flag. (2014-06-27 10:25:10 +0200)

----------------------------------------------------------------
Alan (1):
       dvb-frontends: Add static

Alexey Khoroshilov (1):
       tlg2300: fix leak at failure path in poseidon_probe()

Anthony DeStefano (2):
       staging: rtl2832_sdr: fixup checkpatch/style issues
       staging: solo6x10: fix for sparse warning message

Benoit Taine (1):
       drx-j: Use kmemdup instead of kmalloc + memcpy

Dan Carpenter (1):
       cx18: remove duplicate CX18_ALSA_DBGFLG_WARN define

Hans Verkuil (3):
       em28xx: add MSI Digivox Trio support
       DocBook media: fix small typo
       sn9c102: remove deprecated driver

Lars-Peter Clausen (1):
       adv7604: Update recommended writes for the adv7611

Ovidiu Toader (1):
       staging/media/rtl2832u_sdr: fix coding style problems by adding blank lines

Paul Bolle (1):
       dm644x_ccdc: remove check for CONFIG_DM644X_VIDEO_PORT_ENABLE

Peter Senna Tschudin (2):
       drivers/media/usb/usbvision/usbvision-core.c: Remove useless return variables
       drivers/media: Remove useless return variables

Philipp Zabel (2):
       mem2mem: make queue lock in v4l2_m2m_poll interruptible
       videobuf2-dma-contig: allow to vmap contiguous dma buffers

Pranith Kumar (1):
       update reference, kerneltrap.org no longer works

Ramakrishnan Muthukrishnan (4):
       media: v4l2-core: remove the use of V4L2_FL_USE_FH_PRIO flag.
       media: remove the setting of the flag V4L2_FL_USE_FH_PRIO.
       media: v4l2-dev.h: remove V4L2_FL_USE_FH_PRIO flag.
       media: Documentation: remove V4L2_FL_USE_FH_PRIO flag.

Rickard Strandqvist (1):
       media: usb: dvb-usb-v2: mxl111sf.c: Cleaning up uninitialized variables

  Documentation/DocBook/media/v4l/io.xml             |    2 +-
  Documentation/video4linux/v4l2-framework.txt       |    8 +-
  Documentation/video4linux/v4l2-pci-skeleton.c      |    5 -
  Documentation/zh_CN/video4linux/v4l2-framework.txt |    7 +-
  MAINTAINERS                                        |    9 -
  drivers/media/common/saa7146/saa7146_fops.c        |    1 -
  drivers/media/dvb-frontends/drx39xyj/drxj.c        |   14 +-
  drivers/media/dvb-frontends/tda18271c2dd_maps.h    |    8 +-
  drivers/media/i2c/adv7604.c                        |    5 +-
  drivers/media/parport/bw-qcam.c                    |    1 -
  drivers/media/parport/c-qcam.c                     |    1 -
  drivers/media/parport/pms.c                        |    1 -
  drivers/media/parport/w9966.c                      |    1 -
  drivers/media/pci/bt8xx/bttv-driver.c              |    1 -
  drivers/media/pci/cx18/cx18-alsa.h                 |    1 -
  drivers/media/pci/cx18/cx18-streams.c              |    1 -
  drivers/media/pci/cx25821/cx25821-video.c          |    1 -
  drivers/media/pci/cx88/cx88-core.c                 |    1 -
  drivers/media/pci/ivtv/ivtv-streams.c              |    1 -
  drivers/media/pci/meye/meye.c                      |    1 -
  drivers/media/pci/ngene/ngene-core.c               |    7 +-
  drivers/media/pci/saa7134/saa7134-core.c           |    1 -
  drivers/media/pci/saa7134/saa7134-empress.c        |    1 -
  drivers/media/pci/sta2x11/sta2x11_vip.c            |    1 -
  drivers/media/platform/arv.c                       |    1 -
  drivers/media/platform/blackfin/bfin_capture.c     |    1 -
  drivers/media/platform/davinci/dm644x_ccdc.c       |    5 -
  drivers/media/platform/davinci/vpbe_display.c      |    1 -
  drivers/media/platform/davinci/vpfe_capture.c      |    1 -
  drivers/media/platform/davinci/vpif_capture.c      |    1 -
  drivers/media/platform/davinci/vpif_display.c      |    1 -
  drivers/media/platform/s3c-camif/camif-capture.c   |    1 -
  drivers/media/platform/s5p-tv/mixer_video.c        |    2 -
  drivers/media/platform/vivi.c                      |    1 -
  drivers/media/radio/dsbr100.c                      |    1 -
  drivers/media/radio/radio-cadet.c                  |    1 -
  drivers/media/radio/radio-isa.c                    |    1 -
  drivers/media/radio/radio-keene.c                  |    1 -
  drivers/media/radio/radio-ma901.c                  |    1 -
  drivers/media/radio/radio-miropcm20.c              |    1 -
  drivers/media/radio/radio-mr800.c                  |    3 +-
  drivers/media/radio/radio-raremono.c               |    1 -
  drivers/media/radio/radio-sf16fmi.c                |    1 -
  drivers/media/radio/radio-si476x.c                 |    1 -
  drivers/media/radio/radio-tea5764.c                |    1 -
  drivers/media/radio/radio-tea5777.c                |    1 -
  drivers/media/radio/radio-timb.c                   |    1 -
  drivers/media/radio/si470x/radio-si470x-usb.c      |    1 -
  drivers/media/radio/si4713/radio-platform-si4713.c |    1 -
  drivers/media/radio/si4713/radio-usb-si4713.c      |    1 -
  drivers/media/radio/tea575x.c                      |    1 -
  drivers/media/tuners/r820t.c                       |    2 +-
  drivers/media/usb/au0828/au0828-video.c            |    2 -
  drivers/media/usb/cpia2/cpia2_v4l.c                |    1 -
  drivers/media/usb/cx231xx/cx231xx-417.c            |    1 -
  drivers/media/usb/cx231xx/cx231xx-video.c          |   12 +-
  drivers/media/usb/dvb-usb-v2/mxl111sf.c            |    2 +-
  drivers/media/usb/em28xx/em28xx-cards.c            |    2 +
  drivers/media/usb/em28xx/em28xx-video.c            |    1 -
  drivers/media/usb/gspca/gspca.c                    |    1 -
  drivers/media/usb/hdpvr/hdpvr-video.c              |    1 -
  drivers/media/usb/pwc/pwc-if.c                     |    1 -
  drivers/media/usb/s2255/s2255drv.c                 |    1 -
  drivers/media/usb/stk1160/stk1160-v4l.c            |    1 -
  drivers/media/usb/stkwebcam/stk-webcam.c           |    1 -
  drivers/media/usb/tlg2300/pd-main.c                |    2 +
  drivers/media/usb/tlg2300/pd-radio.c               |    1 -
  drivers/media/usb/tm6000/tm6000-video.c            |    1 -
  drivers/media/usb/usbtv/usbtv-video.c              |    1 -
  drivers/media/usb/usbvision/usbvision-core.c       |   16 +-
  drivers/media/usb/uvc/uvc_driver.c                 |    1 -
  drivers/media/usb/zr364xx/zr364xx.c                |    1 -
  drivers/media/v4l2-core/v4l2-dev.c                 |    6 +-
  drivers/media/v4l2-core/v4l2-fh.c                  |   13 +-
  drivers/media/v4l2-core/v4l2-ioctl.c               |    9 +-
  drivers/media/v4l2-core/v4l2-mem2mem.c             |    8 +-
  drivers/media/v4l2-core/videobuf2-dma-contig.c     |    8 +
  drivers/staging/media/Kconfig                      |    2 -
  drivers/staging/media/Makefile                     |    1 -
  drivers/staging/media/davinci_vpfe/vpfe_video.c    |    1 -
  drivers/staging/media/go7007/go7007-v4l2.c         |    1 -
  drivers/staging/media/msi3101/sdr-msi3101.c        |    1 -
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   |   47 +-
  drivers/staging/media/sn9c102/Kconfig              |   17 -
  drivers/staging/media/sn9c102/Makefile             |   15 -
  drivers/staging/media/sn9c102/sn9c102.h            |  214 -----
  drivers/staging/media/sn9c102/sn9c102.txt          |  592 -------------
  drivers/staging/media/sn9c102/sn9c102_config.h     |   86 --
  drivers/staging/media/sn9c102/sn9c102_core.c       | 3465 --------------------------------------------------------------------------
  drivers/staging/media/sn9c102/sn9c102_devtable.h   |  145 ----
  drivers/staging/media/sn9c102/sn9c102_hv7131d.c    |  269 ------
  drivers/staging/media/sn9c102/sn9c102_hv7131r.c    |  369 --------
  drivers/staging/media/sn9c102/sn9c102_mi0343.c     |  352 --------
  drivers/staging/media/sn9c102/sn9c102_mi0360.c     |  453 ----------
  drivers/staging/media/sn9c102/sn9c102_mt9v111.c    |  260 ------
  drivers/staging/media/sn9c102/sn9c102_ov7630.c     |  634 --------------
  drivers/staging/media/sn9c102/sn9c102_ov7660.c     |  546 ------------
  drivers/staging/media/sn9c102/sn9c102_pas106b.c    |  308 -------
  drivers/staging/media/sn9c102/sn9c102_pas202bcb.c  |  340 --------
  drivers/staging/media/sn9c102/sn9c102_sensor.h     |  307 -------
  drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c |  154 ----
  drivers/staging/media/sn9c102/sn9c102_tas5110d.c   |  119 ---
  drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c |  165 ----
  drivers/staging/media/solo6x10/solo6x10-jpeg.h     |    2 +-
  drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |    1 -
  drivers/staging/media/solo6x10/solo6x10-v4l2.c     |    1 -
  include/media/v4l2-dev.h                           |    2 -
  107 files changed, 104 insertions(+), 8975 deletions(-)
  delete mode 100644 drivers/staging/media/sn9c102/Kconfig
  delete mode 100644 drivers/staging/media/sn9c102/Makefile
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102.h
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102.txt
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_config.h
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_core.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_devtable.h
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_hv7131d.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_hv7131r.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mi0343.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mi0360.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_mt9v111.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_ov7630.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_ov7660.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_pas106b.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_pas202bcb.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_sensor.h
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5110d.c
  delete mode 100644 drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c
