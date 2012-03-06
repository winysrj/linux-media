Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25078 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759103Ab2CFLiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 06:38:16 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0G00KGUOBQRT80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:14 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0G00CLDOBQW5@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 11:38:14 +0000 (GMT)
Date: Tue, 06 Mar 2012 12:38:01 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 0/9] Integration of videobuf2 with dmabuf
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com
Message-id: <1331033890-10350-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
This patchset is an incremental patch to patchset created by Sumit Semwal [1].
The patches are dedicated to help find a better solution for support of buffer
sharing by V4L2 API.  It is expected to start discussion on the final
installment for dma-buf in vb2-dma-contig allocator.  Current version of the
patches contain little documentation. It is going to be fixed after achieving
consensus about design for buffer exporting.  Moreover the API between vb2-core
and the allocator should be revised.

The patches were successfully tested to cooperate with EXYNOS DRM driver using
DMABUF mechanism.

Please note, that the amount of changes to vb2-dma-contig.c was significant
making the difference patch very difficult to read.

The patchset makes use of dma_get_pages extension for DMA API, which is posted
on a top of dma-mapping patches by Marek Szyprowski [4] [5].

The tree, that contains all needed patches, can be found here [6].

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
[5] http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/3.3-rc5-dma-v7
[6] http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/3.3-rc5-vb2-dma-contig-dmabuf-drm


Sumit Semwal (1):
  v4l: vb2: Add dma-contig allocator as dma_buf user

Tomasz Stanislawski (8):
  v4l: vb2: fixes for DMABUF support
  v4l: vb2-dma-contig: update and code refactoring
  v4l: add buffer exporting via dmabuf
  v4l: vb2: add buffer exporting via dmabuf
  v4l: vb2-dma-contig: add support for DMABUF exporting
  v4l: vb2-dma-contig: change map/unmap behaviour
  v4l: fimc: integrate capture i-face with dmabuf
  v4l: s5p-tv: mixer: integrate with dmabuf

 drivers/media/video/Kconfig                 |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c |   11 +-
 drivers/media/video/s5p-tv/Kconfig          |    1 +
 drivers/media/video/s5p-tv/mixer_video.c    |   12 +-
 drivers/media/video/v4l2-compat-ioctl32.c   |    1 +
 drivers/media/video/v4l2-ioctl.c            |   11 +
 drivers/media/video/videobuf2-core.c        |   88 +++-
 drivers/media/video/videobuf2-dma-contig.c  |  717 ++++++++++++++++++++++++---
 include/linux/videodev2.h                   |   20 +
 include/media/v4l2-ioctl.h                  |    2 +
 include/media/videobuf2-core.h              |    8 +-
 11 files changed, 779 insertions(+), 93 deletions(-)

-- 
1.7.5.4

