Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1HXSli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 14:41:38 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 0/7 v5] new ioctl()s and soc-camera implementation
Date: Wed, 24 Aug 2011 20:41:25 +0200
Message-Id: <1314211292-10414-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is now trying to implement our most recent decisions. Any 
improvements should be doable as incremental patches. As long as we are 
happy with ioctl()s themselves, the rest can be improved. I'll quote my 
earlier email with our strategic design decisions:

1. VIDIOC_CREATE_BUFS passes struct v4l2_create_buffers from the user to 
   the kernel, in which struct v4l2_format is embedded. The user _must_ 
   fill in .type member of struct v4l2_format. For .type == 
   V4L2_BUF_TYPE_VIDEO_CAPTURE or V4L2_BUF_TYPE_VIDEO_OUTPUT .fmt.pix is 
   used, for .type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE or 
   V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE .fmt.pix_mp is used. In both these 
   cases the user _must_ fill in .width, .height, .pixelformat, .field, 
   .colorspace by possibly calling VIDIOC_G_FMT or VIDIOC_TRY_FMT. The 
   user also _may_ optionally fill in any further buffer-size related 
   fields, if it believes to have any special requirements to them. On 
   a successful return from the ioctl() .count and .index fields are 
   filled in by the kernel, .format stays unchanged. The user has to call 
   VIDIOC_QUERYBUF to retrieve specific buffer information.

2. Videobuf2 drivers, that implement .vidioc_create_bufs() operation, call 
   vb2_create_bufs() with a pointer to struct v4l2_create_buffers as a 
   second argument. vb2_create_bufs() in turn calls the .queue_setup() 
   driver callback, whose prototype is modified as follows:

int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
                        unsigned int *num_buffers,
                        unsigned int *num_planes, unsigned int sizes[],
                        void *alloc_ctxs[]);

   with &create->format as a second argument. As pointed out above, this 
   struct is not modified by V4L, instead, the usual arguments 3-6 are 
   filled in by the driver, which are then used by vb2_create_bufs() to 
   call __vb2_queue_alloc().

3. vb2_reqbufs() shall call .queue_setup() with fmt == NULL, which will be 
   a signal to the driver to use the current format.

I also split out ioctl() documentation. I'm sure it's still not perfect 
and, being a favourite target for improvement suggestions in the past, I 
humbly propose to leave any comma fixes to incremental patches too. BTW, 
yes, I did try to replace various constants with '&...;' links, it didn't 
work for me.

Thanks
Guennadi

Guennadi Liakhovetski (7):
  V4L: add a new videobuf2 buffer state VB2_BUF_STATE_PREPARED
  V4L: add two new ioctl()s for multi-size videobuffer management
  V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF
    ioctl()s
  V4L: vb2: prepare to support multi-size buffers
  V4L: vb2: add support for buffers of different sizes on a single
    queue
  V4L: sh-mobile-ceu-camera: prepare to support multi-size buffers
  V4L: soc-camera: add 2 new ioctl() handlers

 Documentation/DocBook/media/v4l/io.xml             |   17 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |  147 +++++++++
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++++
 drivers/media/video/atmel-isi.c                    |    6 +-
 drivers/media/video/marvell-ccic/mcam-core.c       |    3 +-
 drivers/media/video/mem2mem_testdev.c              |    7 +-
 drivers/media/video/mx3_camera.c                   |    1 +
 drivers/media/video/pwc/pwc-if.c                   |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |    6 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |    7 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |    5 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  122 +++++---
 drivers/media/video/soc_camera.c                   |   33 ++-
 drivers/media/video/v4l2-compat-ioctl32.c          |   67 ++++-
 drivers/media/video/v4l2-ioctl.c                   |   29 ++
 drivers/media/video/videobuf2-core.c               |  341 ++++++++++++++++----
 drivers/media/video/vivi.c                         |    6 +-
 include/linux/videodev2.h                          |   15 +
 include/media/v4l2-ioctl.h                         |    2 +
 include/media/videobuf2-core.h                     |   39 ++-
 23 files changed, 804 insertions(+), 163 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml

-- 
1.7.2.5

