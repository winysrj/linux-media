Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62269 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754923AbdEHPEa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:04:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 00/18] vb2: Handle user cache hints, allow drivers to choose cache coherency
Date: Mon,  8 May 2017 18:03:12 +0300
Message-Id: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a rebased and partially reworked version of the vb2 cache hints
support patch series posted by first myself, then Laurent and then myself
again.

I'm still posting this as RFC primarily because more testing and driver
changes will be needed. In particular, a lot of platform drivers assume
non-coherent memory but are not properly labelled as such.

Please see the end of the message for detailed changes.

This set unifies the cache coherency hint flags and corrects cache
management in videobuf2 dma-contig and dma-sg memtype implementation. The
support for non-coherent memory is completed: support for MMAP buffers is
added and begin_cpu_access and end_cpu_access functions are added to DMA
ops.

Comments are welcome.

changes since RFC v3:

- Document V4L2_BUF_FLAG_NO_CACHE_SYNC flag behaviour for QBUF and DQBUF
  for CAPTURE and OUTPUT buffers.

- Set queue dma_attrs DMA_ATTR_NON_CONSISTENT flag for omap3isp.

- Put dma_sgt in vb2_dc_buf in order to avoid allocating and releasing it
  separately. It's generally needed anyway.

- Buffer preparation DMA direction is generally DMA_TO_DEVICE for both
  CAPTURE and OUTPUT buffers: V4L2 does not guarantee that the user space
  could not write to capture buffers as well.

  Documentation/DMA-API.txt:

	- Before reading values that have been written by DMA from the device
	  (use the DMA_FROM_DEVICE direction)
	- After writing values that will be written to the device using DMA
	  (use the DMA_TO_DEVICE) direction
	- before *and* after handing memory to the device if the memory is
	  DMA_BIDIRECTIONAL

  Cache maintenance can also be skipped for OUTPUT buffers in buffer
  finish as the hardware did not write to the buffer.

changes since RFC v2:

- Nicer looking tests for the need for syncing.

- Also set DMA attributes for USERPTR buffers.

- Unconditionally assign buf->attrs for MMAP buffers.

- Don't call vb2_dc_get_base_sgt() until buf->dev is set.

- Provide {begin,end}_cpu_access() dmabuf ops for cache management.

- Make similar changes to dma-sg memops to support DMA attributes.


Sakari Ailus (13):
  vb2: Rename confusingly named internal buffer preparation functions
  vb2: Move buffer cache synchronisation to prepare from queue
  vb2: Move cache synchronisation from buffer done to dqbuf handler
  v4l: Unify cache management hint buffer flags
  vb2: Anticipate queue specific DMA attributes for USERPTR buffers
  vb2: dma-contig: Assign DMA attrs for a buffer unconditionally
  vb2: dma-contig: Remove redundant sgt_base field
  vb2: dma-contig: Don't warn on failure in obtaining scatterlist
  vb2: dma-contig: Move vb2_dc_get_base_sgt() up
  vb2: dma-contig: Fix DMA attribute and cache management
  vb2: dma-contig: Add WARN_ON_ONCE() to check for potential bugs
  vb2: dma-sg: Let drivers decide DMA attrs of MMAP and USERPTR bufs
  vb2: Improve struct vb2_mem_ops documentation; alloc and put are for
    MMAP

Samu Onkalo (1):
  vb2: Don't sync cache for a buffer if so requested

 Documentation/media/uapi/v4l/buffer.rst            |  24 ++--
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |   5 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 129 ++++++++++++++-------
 drivers/media/v4l2-core/videobuf2-dma-contig.c     | 120 ++++++++++++-------
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |  47 ++++++--
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  14 ++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |   3 +-
 include/media/videobuf2-core.h                     |  46 +++++---
 include/trace/events/v4l2.h                        |   3 +-
 include/uapi/linux/videodev2.h                     |   7 +-
 10 files changed, 263 insertions(+), 135 deletions(-)

-- 
Regards,
Sakari



Sakari Ailus (17):
  vb2: Rename confusingly named internal buffer preparation functions
  vb2: Move buffer cache synchronisation to prepare from queue
  vb2: Move cache synchronisation from buffer done to dqbuf handler
  v4l: Unify cache management hint buffer flags
  vb2: Anticipate queue specific DMA attributes for USERPTR buffers
  vb2: dma-contig: Assign DMA attrs for a buffer unconditionally
  vb2: dma-contig: Remove redundant sgt_base field
  vb2: dma-contig: Don't warn on failure in obtaining scatterlist
  vb2: dma-contig: Allocate sgt as part of struct vb2_dc_buf
  vb2: dma-contig: Fix DMA attribute and cache management
  vb2: dma-contig: Add WARN_ON_ONCE() to check for potential bugs
  vb2: dma-sg: Let drivers decide DMA attrs of MMAP and USERPTR bufs
  vb2: Improve struct vb2_mem_ops documentation; alloc and put are for
    MMAP
  vb2: Dma direction is always DMA_TO_DEVICE in buffer preparation
  vb2: Do sync plane cache only for CAPTURE buffers in finish memop
  docs-rst: Document precise V4L2_BUF_FLAG_NO_CACHE_SYNC flag behaviour
  v4l: Use non-consistent DMA mappings for hardware that deserves it

Samu Onkalo (1):
  vb2: Don't sync cache for a buffer if so requested

 Documentation/media/uapi/v4l/buffer.rst            |  45 +++--
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |   5 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   1 +
 drivers/media/v4l2-core/videobuf2-core.c           | 122 ++++++++-----
 drivers/media/v4l2-core/videobuf2-dma-contig.c     | 191 ++++++++++++---------
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |  85 ++++++---
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  14 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |   3 +-
 include/media/videobuf2-core.h                     |  46 +++--
 include/trace/events/v4l2.h                        |   3 +-
 include/uapi/linux/videodev2.h                     |   7 +-
 11 files changed, 338 insertions(+), 184 deletions(-)

-- 
2.7.4
