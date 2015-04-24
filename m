Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46630 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965355AbbDXIMM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 04:12:12 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 743B82A002F
	for <linux-media@vger.kernel.org>; Fri, 24 Apr 2015 10:11:43 +0200 (CEST)
Message-ID: <5539FABF.3080608@xs4all.nl>
Date: Fri, 24 Apr 2015 10:11:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2d

for you to fetch changes up to 01dcae42e1d19014a6c83258bc4944b56b111372:

  usbtv: fix v4l2-compliance issues (2015-04-24 10:09:46 +0200)

----------------------------------------------------------------
Cheolhyun Park (1):
      drx-j: Misspelled comment corrected

Dan Carpenter (1):
      i2c: ov2659: signedness bug inov2659_set_fmt()

Geert Uytterhoeven (3):
      v4l: xilinx: VIDEO_XILINX should depend on HAS_DMA
      v4l: VIDEOBUF2_DMA_SG should depend on HAS_DMA
      Input: TOUCHSCREEN_SUR40 should depend on HAS_DMA

Hans Verkuil (7):
      cx88: v4l2-compliance fixes
      bttv: fix missing irq after reloading driver
      DocBook/media: fix typo
      DocBook/media: Improve G_EDID specification
      saa7164: fix querycap warning
      cx18: add missing caps for the PCM video device
      usbtv: fix v4l2-compliance issues

Jan Kara (1):
      vb2: Push mmap_sem down to memops

Julia Lawall (3):
      si4713: fix error return code
      as102: fix error return code
      radio: fix error return code

Lad, Prabhakar (1):
      media: i2c: ov2659: add VIDEO_V4L2_SUBDEV_API dependency

Prashant Laddha (4):
      v4l2-dv-timings: fix rounding error in vsync_bp calculation
      v4l2-dv-timings: fix rounding in hblank and hsync calculation
      v4l2-dv-timings: add sanity checks in cvt,gtf calculations
      v4l2-dv-timings: replace hsync magic number with a macro

Steven Toth (6):
      saa7164: I2C improvements for upcoming HVR2255/2205 boards
      saa7164: Adding additional I2C debug.
      saa7164: Improvements for I2C handling
      saa7164: Add Digital TV support for the HVR2255 and HVR2205
      saa7164: Copyright update
      saa7164: fix HVR2255 ATSC inversion issue

jean-michel.hautbois@vodalys.com (1):
      media: adv7604: Fix masks used for querying timings in ADV7611

 Documentation/DocBook/media/v4l/controls.xml      |   4 +-
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml |   7 +++
 drivers/input/touchscreen/Kconfig                 |   3 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c       |  38 ++++++------
 drivers/media/i2c/Kconfig                         |   2 +-
 drivers/media/i2c/adv7604.c                       |  69 +++++++++++++++++-----
 drivers/media/i2c/ov2659.c                        |   2 +-
 drivers/media/pci/bt8xx/bttv-driver.c             |   2 +
 drivers/media/pci/cx18/cx18-streams.c             |   1 +
 drivers/media/pci/cx88/cx88-core.c                |   2 +
 drivers/media/pci/cx88/cx88-mpeg.c                |   6 +-
 drivers/media/pci/cx88/cx88-vbi.c                 |   6 +-
 drivers/media/pci/cx88/cx88-video.c               |   7 +--
 drivers/media/pci/cx88/cx88.h                     |   1 -
 drivers/media/pci/saa7164/saa7164-api.c           |  21 +++++--
 drivers/media/pci/saa7164/saa7164-buffer.c        |   2 +-
 drivers/media/pci/saa7164/saa7164-bus.c           |   2 +-
 drivers/media/pci/saa7164/saa7164-cards.c         | 188 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/pci/saa7164/saa7164-cmd.c           |   2 +-
 drivers/media/pci/saa7164/saa7164-core.c          |   2 +-
 drivers/media/pci/saa7164/saa7164-dvb.c           | 232 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/media/pci/saa7164/saa7164-encoder.c       |  13 +++--
 drivers/media/pci/saa7164/saa7164-fw.c            |   2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c           |   9 +--
 drivers/media/pci/saa7164/saa7164-reg.h           |   2 +-
 drivers/media/pci/saa7164/saa7164-types.h         |   2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c           |  13 +++--
 drivers/media/pci/saa7164/saa7164.h               |   7 ++-
 drivers/media/platform/xilinx/Kconfig             |   2 +-
 drivers/media/radio/radio-timb.c                  |   4 +-
 drivers/media/radio/si4713/si4713.c               |   4 +-
 drivers/media/usb/as102/as102_drv.c               |   1 +
 drivers/media/usb/usbtv/usbtv-video.c             |  12 ++--
 drivers/media/v4l2-core/Kconfig                   |   2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c         |  29 +++++++---
 drivers/media/v4l2-core/videobuf2-core.c          |   2 -
 drivers/media/v4l2-core/videobuf2-dma-contig.c    |   7 +++
 drivers/media/v4l2-core/videobuf2-dma-sg.c        |   6 ++
 drivers/media/v4l2-core/videobuf2-vmalloc.c       |   6 +-
 39 files changed, 605 insertions(+), 117 deletions(-)
