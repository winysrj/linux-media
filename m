Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51017 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2KWTlI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 14:41:08 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3562975eek.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 11:41:06 -0800 (PST)
Message-ID: <50AFD150.9080900@gmail.com>
Date: Fri, 23 Nov 2012 20:41:04 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PULL FOR v3.8] DMABUF support in Video4Linux
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series adds DMABUF importer and exporting feature to V4L2 API
and to some s5p-* drivers.

I'm sending this on behalf of Tomasz Stanislawski. Please pull for v3.8.

The following changes since commit 1323024fd3296537dd34da70fe70b4df12a308ec:

   [media] siano: fix build with allmodconfig (2012-11-23 13:48:39 -0200)

are available in the git repository at:
   git://linuxtv.org/snawrocki/media.git samsung/dmabuf_for_v3.8

Laurent Pinchart (2):
       v4l: vb2-dma-contig: shorten vb2_dma_contig prefix to vb2_dc
       v4l: vb2-dma-contig: reorder functions

Marek Szyprowski (4):
       v4l: vb2: add prepare/finish callbacks to allocators
       v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator
       v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call
       v4l: vb2-dma-contig: fail if user ptr buffer is not correctly aligned

Sumit Semwal (4):
       v4l: Add DMABUF as a memory type
       v4l: vb2: add support for shared buffer (dma_buf)
       v4l: vb: remove warnings about MEMORY_DMABUF
       v4l: vb2-dma-contig: add support for dma_buf importing

Tomasz Stanislawski (18):
       Documentation: media: description of DMABUF importing in V4L2
       v4l: vb2-dma-contig: remove reference of alloc_ctx from a buffer
       v4l: vb2-dma-contig: add support for scatterlist in userptr mode
       v4l: vb2-vmalloc: add support for dmabuf importing
       v4l: vivi: support for dmabuf importing
       v4l: uvc: add support for DMABUF importing
       v4l: mem2mem_testdev: add support for dmabuf importing
       v4l: s5p-tv: mixer: support for dmabuf importing
       v4l: s5p-fimc: support for dmabuf importing
       Documentation: media: description of DMABUF exporting in V4L2
       v4l: add buffer exporting via dmabuf
       v4l: vb2: add buffer exporting via dmabuf
       v4l: vb2-dma-contig: add support for DMABUF exporting
       v4l: vb2-dma-contig: add reference counting for a device from 
allocator context
       v4l: vb2-dma-contig: align buffer size to PAGE_SIZE
       v4l: s5p-fimc: support for dmabuf exporting
       v4l: s5p-tv: mixer: support for dmabuf exporting
       v4l: s5p-mfc: support for dmabuf exporting

  Documentation/DocBook/media/v4l/compat.xml         |    7 +
  Documentation/DocBook/media/v4l/io.xml             |  184 +++++-
  Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
  .../DocBook/media/v4l/vidioc-create-bufs.xml       |   16 +-
  Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |  212 ++++++
  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   17 +
  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 +-
  drivers/media/platform/mem2mem_testdev.c           |    4 +-
  drivers/media/platform/s5p-fimc/fimc-capture.c     |   11 +-
  drivers/media/platform/s5p-fimc/fimc-m2m.c         |   14 +-
  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   14 +
  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   14 +
  drivers/media/platform/s5p-tv/mixer_video.c        |   12 +-
  drivers/media/platform/vivi.c                      |    2 +-
  drivers/media/usb/uvc/uvc_queue.c                  |    2 +-
  drivers/media/v4l2-core/Kconfig                    |    3 +
  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   19 +
  drivers/media/v4l2-core/v4l2-dev.c                 |    1 +
  drivers/media/v4l2-core/v4l2-ioctl.c               |   11 +
  drivers/media/v4l2-core/v4l2-mem2mem.c             |   13 +
  drivers/media/v4l2-core/videobuf-core.c            |    4 +
  drivers/media/v4l2-core/videobuf2-core.c           |  300 +++++++++-
  drivers/media/v4l2-core/videobuf2-dma-contig.c     |  700 
++++++++++++++++++--
  drivers/media/v4l2-core/videobuf2-memops.c         |   40 --
  drivers/media/v4l2-core/videobuf2-vmalloc.c        |   56 ++
  include/media/v4l2-ioctl.h                         |    2 +
  include/media/v4l2-mem2mem.h                       |    3 +
  include/media/videobuf2-core.h                     |   38 ++
  include/media/videobuf2-memops.h                   |    5 -
  include/uapi/linux/videodev2.h                     |   35 +
  30 files changed, 1646 insertions(+), 141 deletions(-)
  create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml

---

Regards,
Sylwester
