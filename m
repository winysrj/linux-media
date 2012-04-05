Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52733 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2DEOAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:00:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M200095IEWZ1G70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:35 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2000D5ZEWUUI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Apr 2012 15:00:31 +0100 (BST)
Date: Thu, 05 Apr 2012 15:59:57 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 00/11] Integration of videobuf2 with dmabuf
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com
Message-id: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
This patchset adds support for DMABUF [2] importing to V4L2 stack.  It was
updated after Laurent Pinchart's review.  The support for DMABUF exporting was
moved to separate patchset due to dependency on patches for DMA mapping
redesign by Marek Szyprowski [4].

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

Andrzej Pietrasiewicz (1):
  v4l: vb2-dma-contig: add support for scatterlist in userptr mode

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
  v4l: vb2: Add dma-contig allocator as dma_buf user

Tomasz Stanislawski (2):
  Documentation: media: description of DMABUF importing in V4L2
  v4l: vb2-dma-contig: Remove unneeded allocation context structure

 Documentation/DocBook/media/v4l/compat.xml         |    4 +
 Documentation/DocBook/media/v4l/io.xml             |  177 +++++++
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    1 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 +
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    8 +-
 drivers/media/video/videobuf-core.c                |    4 +
 drivers/media/video/videobuf2-core.c               |  195 +++++++-
 drivers/media/video/videobuf2-dma-contig.c         |  536 +++++++++++++++++---
 include/linux/videodev2.h                          |    8 +
 include/media/videobuf2-core.h                     |   38 ++
 10 files changed, 910 insertions(+), 76 deletions(-)

-- 
1.7.5.4

