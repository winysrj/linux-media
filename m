Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60985 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2DTOTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 10:19:00 -0400
Date: Fri, 20 Apr 2012 16:06:07 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv5 00/13] Integration of videobuf2 with dmabuf
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de
Message-id: <1334930780-28976-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
This patchset adds support for DMABUF [2] importing to V4L2 stack.
The support for DMABUF exporting was moved to separate patchset
due to dependency on patches for DMA mapping redesign by
Marek Szyprowski [4].

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
  v4l: vb2-dma-contig: add support for dma_buf importing

Tomasz Stanislawski (4):
  Documentation: media: description of DMABUF importing in V4L2
  v4l: vb2-dma-contig: Remove unneeded allocation context structure
  v4l: s5p-tv: mixer: support for dmabuf importing
  v4l: s5p-fimc: support for dmabuf importing

 Documentation/DocBook/media/v4l/compat.xml         |    4 +
 Documentation/DocBook/media/v4l/io.xml             |  179 +++++++
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    1 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 +
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 +-
 drivers/media/video/Kconfig                        |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c        |    2 +-
 drivers/media/video/s5p-tv/Kconfig                 |    1 +
 drivers/media/video/s5p-tv/mixer_video.c           |    2 +-
 drivers/media/video/videobuf-core.c                |    4 +
 drivers/media/video/videobuf2-core.c               |  207 ++++++++-
 drivers/media/video/videobuf2-dma-contig.c         |  529 +++++++++++++++++---
 include/linux/videodev2.h                          |    7 +
 include/media/videobuf2-core.h                     |   34 ++
 14 files changed, 932 insertions(+), 101 deletions(-)

-- 
1.7.5.4

