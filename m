Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:52655 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1HaSC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 14:02:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/9 v6] new ioctl()s and soc-camera implementation
Date: Wed, 31 Aug 2011 20:02:39 +0200
Message-Id: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here goes the next round, addressing Pawel's review of the vb2 
implementation - thanks!

Guennadi Liakhovetski (9):
  V4L: add a new videobuf2 buffer state VB2_BUF_STATE_PREPARED
  V4L: add two new ioctl()s for multi-size videobuffer management
  V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF
    ioctl()s
  V4L: vb2: prepare to support multi-size buffers
  V4L: vb2: add support for buffers of different sizes on a single
    queue
  V4L: sh-mobile-ceu-camera: prepare to support multi-size buffers
  dmaengine: ipu-idmac: add support for the DMA_PAUSE control
  V4L: mx3-camera: prepare to support multi-size buffers
  V4L: soc-camera: add 2 new ioctl() handlers

 Documentation/DocBook/media/v4l/io.xml             |   17 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |  147 ++++++++
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++++
 drivers/dma/ipu/ipu_idmac.c                        |   65 +++--
 drivers/media/video/atmel-isi.c                    |    6 +-
 drivers/media/video/marvell-ccic/mcam-core.c       |    3 +-
 drivers/media/video/mem2mem_testdev.c              |    7 +-
 drivers/media/video/mx3_camera.c                   |  160 +++++-----
 drivers/media/video/pwc/pwc-if.c                   |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |    6 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |    7 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |    5 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  123 +++++---
 drivers/media/video/soc_camera.c                   |   33 ++-
 drivers/media/video/v4l2-compat-ioctl32.c          |   67 ++++-
 drivers/media/video/v4l2-ioctl.c                   |   29 ++
 drivers/media/video/videobuf2-core.c               |  348 ++++++++++++++++----
 drivers/media/video/vivi.c                         |    6 +-
 include/linux/videodev2.h                          |   15 +
 include/media/v4l2-ioctl.h                         |    2 +
 include/media/videobuf2-core.h                     |   43 ++-
 24 files changed, 939 insertions(+), 264 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml

-- 
1.7.2.5

Enjoy
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
