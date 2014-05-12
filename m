Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3939 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaELIbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 04:31:25 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id s4C8VKB3055134
	for <linux-media@vger.kernel.org>; Mon, 12 May 2014 10:31:22 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3E13C2A19A4
	for <linux-media@vger.kernel.org>; Mon, 12 May 2014 10:31:10 +0200 (CEST)
Message-ID: <537086CE.9000800@xs4all.nl>
Date: Mon, 12 May 2014 10:31:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] Various fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Updated version of my pull request of May 9th, adding the remaining em28xx patches
from Frank.)

Hi Mauro,

I went through my pending patches queue and managed to go through most of it.

Most patches are fairly trivial, but you should take a close look at the
videobuf-dma-contig patch from Ma Haijun since you introduced the vm_iomap_memory()
change. I reviewed it carefully and tested it and it seems sound to me, but
that's one patch that needs an extra pair of eyeballs.

Also note that I tested the saa7134 querybuf patch from Mikhail Domrachev successfully
using my signal generator.

Regards,

	Hans


The following changes since commit 393cbd8dc532c1ebed60719da8d379f50d445f28:

  [media] smiapp: Use %u for printing u32 value (2014-04-23 16:05:06 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16d

for you to fetch changes up to 87b3628098449bb09e2bebf14bf9ce1978cec524:

  em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio (2014-05-12 10:27:00 +0200)

----------------------------------------------------------------
Alexander Shiyan (1):
      media: coda: Use full device name for request_irq()

Bartlomiej Zolnierkiewicz (1):
      v4l: ti-vpe: fix devm_ioremap_resource() return value checking

Daeseok Youn (1):
      s2255drv: fix memory leak s2255_probe()

Dan Carpenter (1):
      av7110: fix confusing indenting

Frank Schaefer (24):
      em28xx: fix indenting in em28xx_usb_probe()
      em28xx: remove some unused fields from struct em28xx
      em28xx: remove function em28xx_compression_disable() and its call
      em28xx: move norm_maxw() and norm_maxh() from em28xx.h to em28xx-video.c
      em28xx: remove the i2c_set_adapdata() call in em28xx_i2c_register()
      em28xx: move sub-module data structs to a common place in the main struct
      em28xx-video: simplify usage of the pointer to struct v4l2_ctrl_handler in em28xx_v4l2_init()
      em28xx: start moving em28xx-v4l specific data to its own struct
      em28xx: move struct v4l2_ctrl_handler ctrl_handler from struct em28xx to struct v4l2
      em28xx: move struct v4l2_clk *clk from struct em28xx to struct v4l2
      em28xx: move video_device structs from struct em28xx to struct v4l2
      em28xx: move videobuf2 related data from struct em28xx to struct v4l2
      em28xx: move v4l2 frame resolutions and scale data from struct em28xx to struct v4l2
      em28xx: move vinmode and vinctrl data from struct em28xx to struct v4l2
      em28xx: move TV norm from struct em28xx to struct v4l2
      em28xx: move struct em28xx_fmt *format from struct em28xx to struct v4l2
      em28xx: move progressive/interlaced fields from struct em28xx to struct v4l2
      em28xx: move sensor parameter fields from struct em28xx to struct v4l2
      em28xx: move capture state tracking fields from struct em28xx to struct v4l2
      em28xx: move v4l2 user counting fields from struct em28xx to struct v4l2
      em28xx: move tuner frequency field from struct em28xx to struct v4l2
      em28xx: remove field tda9887_conf from struct em28xx
      em28xx: remove field tuner_addr from struct em28xx
      em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio

Hans Verkuil (2):
      v4l2-pci-skeleton: fix typo
      v4l2-ioctl: drop spurious newline in string

Himangi Saraogi (1):
      timblogiw: Introduce the use of the managed version of kzalloc

Jinqiang Zeng (1):
      fix the code style errors in sn9c102

Kirill Tkhai (1):
      s2255: Do not free fw_data until timer handler has actually stopped using it

Lad, Prabhakar (1):
      media: davinci: vpbe: release buffers in case start_streaming call back fails

Ma Haijun (1):
      videobuf-dma-contig: fix incorrect argument to vm_iomap_memory() call

Masanari Iida (1):
      media: parport: Fix format string mismatch in bw-qcam.c

Mikhail Domrachev (1):
      saa7134: add vidioc_querystd

Pali Rohár (1):
      radio-bcm2048: fix wrong overflow check

Ricardo Ribalda (1):
      videobuf2-dma-sg: Fix NULL pointer dereference BUG

Takashi Iwai (1):
      ivtv: Fix Oops when no firmware is loaded

Vitaly Osipov (2):
      staging: media: omap24xx: fix up checkpatch error message
      staging: media: omap24xx: use pr_info() instead of KERN_INFO

 Documentation/video4linux/v4l2-pci-skeleton.c      |   2 +-
 drivers/media/parport/bw-qcam.c                    |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |   6 +
 drivers/media/pci/saa7134/saa7134-empress.c        |   1 +
 drivers/media/pci/saa7134/saa7134-reg.h            |   5 +
 drivers/media/pci/saa7134/saa7134-video.c          |  41 ++++-
 drivers/media/pci/saa7134/saa7134.h                |   1 +
 drivers/media/pci/ttpci/av7110_av.c                |   6 +-
 drivers/media/platform/coda.c                      |   2 +-
 drivers/media/platform/davinci/vpbe_display.c      |  11 +-
 drivers/media/platform/ti-vpe/csc.c                |   4 +-
 drivers/media/platform/ti-vpe/sc.c                 |   4 +-
 drivers/media/platform/timblogiw.c                 |   8 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |  39 ++---
 drivers/media/usb/em28xx/em28xx-camera.c           |  51 +++---
 drivers/media/usb/em28xx/em28xx-cards.c            |  22 +--
 drivers/media/usb/em28xx/em28xx-i2c.c              |   1 -
 drivers/media/usb/em28xx/em28xx-vbi.c              |  10 +-
 drivers/media/usb/em28xx/em28xx-video.c            | 614 ++++++++++++++++++++++++++++++++++++++++++-------------------------------
 drivers/media/usb/em28xx/em28xx.h                  | 152 ++++++++----------
 drivers/media/usb/s2255/s2255drv.c                 |   6 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c      |   2 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |   2 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c      |   2 +-
 drivers/staging/media/omap24xx/tcm825x.c           |  12 +-
 drivers/staging/media/sn9c102/sn9c102.h            |  30 ++--
 drivers/staging/media/sn9c102/sn9c102_core.c       | 342 +++++++++++++++++++++--------------------
 drivers/staging/media/sn9c102/sn9c102_devtable.h   |  22 +--
 drivers/staging/media/sn9c102/sn9c102_hv7131d.c    |  22 +--
 drivers/staging/media/sn9c102/sn9c102_mi0343.c     |  30 ++--
 drivers/staging/media/sn9c102/sn9c102_mi0360.c     |  30 ++--
 drivers/staging/media/sn9c102/sn9c102_ov7630.c     |  22 +--
 drivers/staging/media/sn9c102/sn9c102_ov7660.c     |  22 +--
 drivers/staging/media/sn9c102/sn9c102_pas106b.c    |  22 +--
 drivers/staging/media/sn9c102/sn9c102_pas202bcb.c  |  22 +--
 drivers/staging/media/sn9c102/sn9c102_sensor.h     |  34 ++--
 drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c |  18 +--
 drivers/staging/media/sn9c102/sn9c102_tas5110d.c   |  14 +-
 drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c |  18 +--
 40 files changed, 894 insertions(+), 762 deletions(-)
