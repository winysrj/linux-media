Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61833 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2AWNvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:37 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LY9008107TZ9Q@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY900D9E7TYTD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:35 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:05 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 00/10] Integration of videobuf2 with dmabuf
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Message-id: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
This patchset is an incremental patch to patchset created by Sumit
Semwal [1].  The patches are dedicated to help find a better solution for
support of buffer sharing by V4L2 API.  It is expected to start discussion on
final installment for dma-buf in vb2-dma-contig allocator.  Current version of
the patches contain little documentation. It is going to be fixed after
achieving consensus about design for buffer exporting.  Moreover the API
between vb2-core and the allocator should be revised.

The amount of changes to vb2-dma-contig.c was significant making the difference
patch very difficult to read.  Therefore the patch was split into two parts.
One removes old file, the next patch creates the version of the file.

The patchset contains extension for DMA API and its implementation for ARM
architecture. Therefore the patchset should be applied on the top of:

http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/3.2-dma-v5

After applying patches from [2] and [1].

v1: List of changes since [1].
- support for DMA api extension dma_get_pages, the function is used to retrieve pages
 used to create DMA mapping.
- small fixes/code cleanup to videobuf2
- added prepare and finish callbacks to vb2 allocators, it is used keep consistency between dma-cpu acess to the memory (by Marek Szyprowski)
- support for exporting of DMABUF buffer in V4L2 and Videobuf2, originated from [3].
- support for dma-buf exporting in vb2-dma-contig allocator
- support for DMABUF for s5p-tv and s5p-fimc (capture interface) drivers, originated from [3]
- changed handling for userptr buffers (by Marek Szyprowski, Andrzej Pietrasiewicz)
- let mmap method to use dma_mmap_writecombine call (by Marek Szyprowski)

[1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
[2] https://lkml.org/lkml/2011/12/26/29
[3] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/36354/focus=36355


Marek Szyprowski (2):
  [media] media: vb2: remove plane argument from call_memop and cleanup
    mempriv usage
  media: vb2: add prepare/finish callbacks to allocators

Tomasz Stanislawski (8):
  arm: dma: support for dma_get_pages
  v4l: vb2: fixes for DMABUF support
  v4l: add buffer exporting via dmabuf
  v4l: vb2: add buffer exporting via dmabuf
  v4l: vb2: remove dma-contig allocator
  v4l: vb2-dma-contig: code refactoring, support for DMABUF exporting
  v4l: fimc: integrate capture i-face with dmabuf
  v4l: s5p-tv: mixer: integrate with dmabuf

 arch/arm/include/asm/dma-mapping.h          |    8 +
 arch/arm/mm/dma-mapping.c                   |   44 ++
 drivers/media/video/s5p-fimc/fimc-capture.c |   11 +-
 drivers/media/video/s5p-tv/mixer_video.c    |   11 +-
 drivers/media/video/v4l2-compat-ioctl32.c   |    1 +
 drivers/media/video/v4l2-ioctl.c            |   11 +
 drivers/media/video/videobuf2-core.c        |  114 ++++-
 drivers/media/video/videobuf2-dma-contig.c  |  754 +++++++++++++++++++++------
 include/linux/dma-mapping.h                 |    2 +
 include/linux/videodev2.h                   |    1 +
 include/media/v4l2-ioctl.h                  |    1 +
 include/media/videobuf2-core.h              |   10 +-
 12 files changed, 789 insertions(+), 179 deletions(-)

-- 
1.7.5.4

