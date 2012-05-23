Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9045 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2EWMKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 08:10:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4H007XT5SGBG50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:09:52 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00KCM5TU5D@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 13:10:42 +0100 (BST)
Date: Wed, 23 May 2012 14:10:14 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv6 00/13] Integration of videobuf2 with dmabuf
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
This patchset adds support for DMABUF [2] importing to V4L2 stack.
The support for DMABUF exporting was moved to separate patchset
due to dependency on patches for DMA mapping redesign by
Marek Szyprowski [4].

v6:
- fixed missing entry in v4l2_memory_names
- fixed a bug occuring after get_user_pages failure
- fixed a bug caused by using invalid vma for get_user_pages
- prepare/finish no longer call dma_sync for dmabuf buffers

v5:
- removed change of importer/exporter behaviour
- fixes vb2_dc_pages_to_sgt basing on Laurent's hints
- changed pin/unpin words to lock/unlock in Doc

v4:
- rebased on mainline 3.4-rc2
- included missing importing support for s5p-fimc and s5p-tv
- added patch for changing map/unmap for importers
- fixes to Documentation part
- coding style fixes
- pairing {map/unmap}_dmabuf in vb2-core
- fixing variable types and semantic of arguments in videobufb2-dma-contig.c

v3:
- rebased on mainline 3.4-rc1
- split 'code refactor' patch to multiple smaller patches
- squashed fixes to Sumit's patches
- patchset is no longer dependant on 'DMA mapping redesign'
- separated path for handling IO and non-IO mappings
- add documentation for DMABUF importing to V4L
- removed all DMABUF exporter related code
- removed usage of dma_get_pages extension

v2:
- extended VIDIOC_EXPBUF argument from integer memoffset to struct
  v4l2_exportbuffer
- added patch that breaks DMABUF spec on (un)map_atachment callcacks but allows
  to work with existing implementation of DMABUF prime in DRM
- all dma-contig code refactoring patches were squashed
- bugfixes

v1: List of changes since [1].
- support for DMA api extension dma_get_pages, the function is used to retrieve
  pages used to create DMA mapping.
- small fixes/code cleanup to videobuf2
- added prepare and finish callbacks to vb2 allocators, it is used keep
  consistency between dma-cpu acess to the memory (by Marek Szyprowski)
- support for exporting of DMABUF buffer in V4L2 and Videobuf2, originated from
  [3].
- support for dma-buf exporting in vb2-dma-contig allocator
- support for DMABUF for s5p-tv and s5p-fimc (capture interface) drivers,
  originated from [3]
- changed handling for userptr buffers (by Marek Szyprowski, Andrzej
  Pietrasiewicz)
- let mmap method to use dma_mmap_writecombine call (by Marek Szyprowski)

[1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
[2] https://lkml.org/lkml/2011/12/26/29
[3] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/36354/focus=36355
[4] http://thread.gmane.org/gmane.linux.kernel.cross-arch/12819

Laurent Pinchart (2):
  v4l: vb2-dma-contig: Shorten vb2_dma_contig prefix to vb2_dc
  v4l: vb2-dma-contig: Reorder functions

Marek Szyprowski (2):
  v4l: vb2: add prepare/finish callbacks to allocators
  v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator

Sumit Semwal (4):
  v4l: Add DMABUF as a memory type
  v4l: vb2: add support for shared buffer (dma_buf)
  v4l: vb: remove warnings about MEMORY_DMABUF
  v4l: vb2-dma-contig: add support for dma_buf importing

Tomasz Stanislawski (5):
  Documentation: media: description of DMABUF importing in V4L2
  v4l: vb2-dma-contig: Remove unneeded allocation context structure
  v4l: vb2-dma-contig: add support for scatterlist in userptr mode
  v4l: s5p-tv: mixer: support for dmabuf importing
  v4l: s5p-fimc: support for dmabuf importing

 Documentation/DocBook/media/v4l/compat.xml         |    4 +
 Documentation/DocBook/media/v4l/io.xml             |  179 +++++++
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    1 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 +
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   45 +-
 drivers/media/video/s5p-fimc/Kconfig               |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c        |    2 +-
 drivers/media/video/s5p-tv/Kconfig                 |    1 +
 drivers/media/video/s5p-tv/mixer_video.c           |    2 +-
 drivers/media/video/v4l2-ioctl.c                   |    1 +
 drivers/media/video/videobuf-core.c                |    4 +
 drivers/media/video/videobuf2-core.c               |  207 +++++++-
 drivers/media/video/videobuf2-dma-contig.c         |  520 +++++++++++++++++---
 include/linux/videodev2.h                          |    7 +
 include/media/videobuf2-core.h                     |   34 ++
 15 files changed, 924 insertions(+), 99 deletions(-)

-- 
1.7.9.5

