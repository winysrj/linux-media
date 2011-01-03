Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58904 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1ACQsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 11:48:06 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LEG00DLHHC2CV80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Jan 2011 16:48:02 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LEG002Y9HC292@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Jan 2011 16:48:02 +0000 (GMT)
Received: from [106.116.37.156] (unknown [106.116.37.156])
	by linux.samsung.com (Postfix) with ESMTP id CBAFC270070	for
 <linux-media@vger.kernel.org>; Mon, 03 Jan 2011 17:48:00 +0100 (CET)
Date: Mon, 03 Jan 2011 17:48:01 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 2.6.38] Videbuf2 framework,
 NOON010PC30 sensor driver and s5p-fimc updates
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4D21FDC1.7000803@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Please pull from our tree for the following items:

1. V4L2 multiplane extension,
2. The Videobuf2 framework,
3. Mem2mem framework and vivi conversion to Videbuf2,
4. s5p-fimc driver conversion to Videbuf2 and multiplane ext. and various
   driver updates and bugfixes,
5. Siliconfile NOON010PC30 sensor subdev driver,
6. Patches for SAA7134 driver for Videbuf2 testing.

The patch series has been rebased onto staging/for_v2.6.38 branch on top
of s5p-fimc driver patches that were recently added to v2.6.37-rc8.
The SAA7134 driver patches are meant for Vb2 testing only. The test hardware
for those was the Avermedia  AVerTV Super 007 TV card.

Thanks!
Sylwester



The following changes since commit 6d09afc3bdf7f6b52358c30490b9434ba18d6344:

  [media] s5p-fimc: Fix output DMA handling in S5PV310 IP revisions (2010-12-28
15:50:50 +0100)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2

Andrzej Pietrasiewicz (3):
      v4l: videobuf2: add DMA scatter/gather allocator
      v4l: saa7134: remove radio, vbi, mpeg, input, alsa, tvaudio, saa6752hs
support
      v4l: saa7134: quick and dirty port to videobuf2

Hyunwoong Kim (5):
      [media] s5p-fimc: fix the value of YUV422 1-plane formats
      [media] s5p-fimc: Configure scaler registers depending on FIMC version
      [media] s5p-fimc: update checking scaling ratio range
      [media] s5p-fimc: Support stop_streaming and job_abort
      [media] s5p-fimc: fix MSCTRL.FIFO_CTRL for performance enhancement

Marek Szyprowski (4):
      v4l: videobuf2: add generic memory handling routines
      v4l: videobuf2: add read() and write() emulator
      v4l: vivi: port to videobuf2
      v4l: mem2mem: port to videobuf2

Pawel Osciak (8):
      v4l: Add multi-planar API definitions to the V4L2 API
      v4l: Add multi-planar ioctl handling code
      v4l: Add compat functions for the multi-planar API
      v4l: fix copy sizes in compat32 for ext controls
      v4l: v4l2-ioctl: add buffer type conversion for multi-planar-aware ioctls
      v4l: add videobuf2 Video for Linux 2 driver framework
      v4l: videobuf2: add vmalloc allocator
      v4l: videobuf2: add DMA coherent allocator

Sungchun Kang (1):
      [media] s5p-fimc: fimc_stop_capture bug fix

Sylwester Nawrocki (15):
      v4l: v4l2-ioctl: Fix conversion between multiplane and singleplane buffers
      v4l: mem2mem: port m2m_testdev to vb2
      v4l: Add multiplanar format fourccs for s5p-fimc driver
      [media] s5p-fimc: Porting to videobuf 2
      [media] s5p-fimc: Conversion to multiplanar formats
      [media] s5p-fimc: Use v4l core mutex in ioctl and file operations
      [media] s5p-fimc: Rename s3c_fimc* to s5p_fimc*
      [media] s5p-fimc: Derive camera bus width from mediabus pixelcode
      [media] s5p-fimc: Enable interworking without subdev s_stream
      [media] s5p-fimc: Use default input DMA burst count
      [media] s5p-fimc: Enable simultaneous rotation and flipping
      [media] s5p-fimc: Add control of the external sensor clock
      [media] s5p-fimc: Move scaler details handling to the register API file
      [media] Add chip identity for NOON010PC30 camera sensor
      [media] Add v4l2 subdev driver for NOON010PC30L image sensor

 drivers/media/video/Kconfig                 |   36 +-
 drivers/media/video/Makefile                |    7 +
 drivers/media/video/mem2mem_testdev.c       |  227 ++--
 drivers/media/video/noon010pc30.c           |  792 ++++++++++++
 drivers/media/video/s5p-fimc/fimc-capture.c |  550 +++++----
 drivers/media/video/s5p-fimc/fimc-core.c    |  872 +++++++------
 drivers/media/video/s5p-fimc/fimc-core.h    |  133 +--
 drivers/media/video/s5p-fimc/fimc-reg.c     |  201 ++--
 drivers/media/video/s5p-fimc/regs-fimc.h    |   29 +-
 drivers/media/video/saa7134/Kconfig         |    2 +-
 drivers/media/video/saa7134/Makefile        |    8 +-
 drivers/media/video/saa7134/saa7134-cards.c | 1415 ++++++++-------------
 drivers/media/video/saa7134/saa7134-core.c  |  454 +++-----
 drivers/media/video/saa7134/saa7134-video.c |  859 +++++--------
 drivers/media/video/saa7134/saa7134.h       |   48 +-
 drivers/media/video/v4l2-compat-ioctl32.c   |  229 +++-
 drivers/media/video/v4l2-ioctl.c            |  626 +++++++++-
 drivers/media/video/v4l2-mem2mem.c          |  232 ++--
 drivers/media/video/videobuf2-core.c        | 1804 +++++++++++++++++++++++++++
 drivers/media/video/videobuf2-dma-contig.c  |  185 +++
 drivers/media/video/videobuf2-dma-sg.c      |  292 +++++
 drivers/media/video/videobuf2-memops.c      |  232 ++++
 drivers/media/video/videobuf2-vmalloc.c     |  132 ++
 drivers/media/video/vivi.c                  |  357 +++---
 include/linux/videodev2.h                   |  131 ++-
 include/media/noon010pc30.h                 |   28 +
 include/media/{s3c_fimc.h => s5p_fimc.h}    |   20 +-
 include/media/v4l2-chip-ident.h             |    3 +
 include/media/v4l2-ioctl.h                  |   16 +
 include/media/v4l2-mem2mem.h                |   56 +-
 include/media/videobuf2-core.h              |  380 ++++++
 include/media/videobuf2-dma-contig.h        |   29 +
 include/media/videobuf2-dma-sg.h            |   32 +
 include/media/videobuf2-memops.h            |   45 +
 include/media/videobuf2-vmalloc.h           |   20 +
 35 files changed, 7392 insertions(+), 3090 deletions(-)
 create mode 100644 drivers/media/video/noon010pc30.c
 create mode 100644 drivers/media/video/videobuf2-core.c
 create mode 100644 drivers/media/video/videobuf2-dma-contig.c
 create mode 100644 drivers/media/video/videobuf2-dma-sg.c
 create mode 100644 drivers/media/video/videobuf2-memops.c
 create mode 100644 drivers/media/video/videobuf2-vmalloc.c
 create mode 100644 include/media/noon010pc30.h
 rename include/media/{s3c_fimc.h => s5p_fimc.h} (75%)
 create mode 100644 include/media/videobuf2-core.h
 create mode 100644 include/media/videobuf2-dma-contig.h
 create mode 100644 include/media/videobuf2-dma-sg.h
 create mode 100644 include/media/videobuf2-memops.h
 create mode 100644 include/media/videobuf2-vmalloc.h

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
