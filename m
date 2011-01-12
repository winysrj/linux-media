Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:11708 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1ALKZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 05:25:44 -0500
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LEW00GOONMUYF70@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Jan 2011 19:25:42 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LEW001SJNMP66@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Jan 2011 19:25:42 +0900 (KST)
Date: Wed, 12 Jan 2011 11:25:36 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [GIT PATCHES FOR 2.6.38] Videbuf2 framework,
 NOON010PC30 sensor driver and s5p-fimc updates
In-reply-to: <4D2CBB3F.5050904@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"'Andrzej Pietrasiewicz/Poland R&D Center-Linux/./????'"
	<andrzej.p@samsung.com>, pawel@osciak.com
Cc: linux-media@vger.kernel.org
Message-id: <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <4D21FDC1.7000803@samsung.com> <4D2CBB3F.5050904@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Mauro,

I've rebased our fimc and saa patches onto http://linuxtv.org/git/mchehab/experimental.git
vb2_test branch.

The last 2 patches are for SAA7134 driver and are only to show that videobuf2-dma-sg works
correctly. 

The following changes since commit 15af3ad8cafe8028f09d1b6c014bb2e997937694:

  [media] vb2 core: Fix a few printk warnings (2011-01-11 18:19:24 -0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2_test

Andrzej Pietrasiewicz (2):
      v4l: saa7134: remove radio, vbi, mpeg, input, alsa, tvaudio, saa6752hs support
      v4l: saa7134: quick and dirty port to videobuf2

Hyunwoong Kim (5):
      [media] s5p-fimc: fix the value of YUV422 1-plane formats
      [media] s5p-fimc: Configure scaler registers depending on FIMC version
      [media] s5p-fimc: update checking scaling ratio range
      [media] s5p-fimc: Support stop_streaming and job_abort
      [media] s5p-fimc: fix MSCTRL.FIFO_CTRL for performance enhancement

Marek Szyprowski (2):
      v4l: mem2mem: port to videobuf2
      v4l: mem2mem: port m2m_testdev to vb2

Pawel Osciak (2):
      Fix mmap() example in the V4L2 API DocBook
      Add multi-planar API documentation

Sungchun Kang (1):
      [media] s5p-fimc: fimc_stop_capture bug fix

Sylwester Nawrocki (14):
      v4l: Add multiplanar format fourccs for s5p-fimc driver
      v4l: Add DocBook documentation for YU12M, NV12M image formats
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

 Documentation/DocBook/media-entities.tmpl     |    8 +
 Documentation/DocBook/v4l/common.xml          |    2 +
 Documentation/DocBook/v4l/compat.xml          |   11 +
 Documentation/DocBook/v4l/dev-capture.xml     |   13 +-
 Documentation/DocBook/v4l/dev-output.xml      |   13 +-
 Documentation/DocBook/v4l/func-mmap.xml       |   10 +-
 Documentation/DocBook/v4l/func-munmap.xml     |    3 +-
 Documentation/DocBook/v4l/io.xml              |  287 ++++-
 Documentation/DocBook/v4l/pixfmt-nv12m.xml    |  154 +++
 Documentation/DocBook/v4l/pixfmt-yuv420m.xml  |  162 +++
 Documentation/DocBook/v4l/pixfmt.xml          |  118 ++-
 Documentation/DocBook/v4l/planar-apis.xml     |   81 ++
 Documentation/DocBook/v4l/v4l2.xml            |   21 +-
 Documentation/DocBook/v4l/vidioc-enum-fmt.xml |    2 +
 Documentation/DocBook/v4l/vidioc-g-fmt.xml    |   15 +-
 Documentation/DocBook/v4l/vidioc-qbuf.xml     |   24 +-
 Documentation/DocBook/v4l/vidioc-querybuf.xml |   14 +-
 Documentation/DocBook/v4l/vidioc-querycap.xml |   24 +-
 drivers/media/video/Kconfig                   |   12 +-
 drivers/media/video/Makefile                  |    1 +
 drivers/media/video/mem2mem_testdev.c         |  227 ++---
 drivers/media/video/noon010pc30.c             |  792 ++++++++++++++
 drivers/media/video/s5p-fimc/fimc-capture.c   |  550 ++++++----
 drivers/media/video/s5p-fimc/fimc-core.c      |  872 ++++++++-------
 drivers/media/video/s5p-fimc/fimc-core.h      |  134 ++--
 drivers/media/video/s5p-fimc/fimc-reg.c       |  199 ++--
 drivers/media/video/s5p-fimc/regs-fimc.h      |   29 +-
 drivers/media/video/saa7134/Kconfig           |    2 +-
 drivers/media/video/saa7134/Makefile          |    8 +-
 drivers/media/video/saa7134/saa7134-cards.c   | 1415 +++++++++----------------
 drivers/media/video/saa7134/saa7134-core.c    |  466 +++------
 drivers/media/video/saa7134/saa7134-video.c   |  854 ++++++----------
 drivers/media/video/saa7134/saa7134.h         |   48 +-
 drivers/media/video/v4l2-mem2mem.c            |  232 ++--
 include/linux/videodev2.h                     |    7 +
 include/media/noon010pc30.h                   |   28 +
 include/media/{s3c_fimc.h => s5p_fimc.h}      |   20 +-
 include/media/v4l2-chip-ident.h               |    3 +
 include/media/v4l2-mem2mem.h                  |   56 +-
 39 files changed, 3961 insertions(+), 2956 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv12m.xml
 create mode 100644 Documentation/DocBook/v4l/pixfmt-yuv420m.xml
 create mode 100644 Documentation/DocBook/v4l/planar-apis.xml
 create mode 100644 drivers/media/video/noon010pc30.c
 create mode 100644 include/media/noon010pc30.h
 rename include/media/{s3c_fimc.h => s5p_fimc.h} (75%)

