Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13580 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758720Ab2DJNKw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M29005Z1LXIAI60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:30 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900EMJLY2XY@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:50 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:34 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 00/13] Support for dmabuf exporting for videobuf2
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
The patches adds support for DMABUF [1] exporting to V4L2 stack.  It was
updated from [7] after Laurent Pinchart's review.  The previous patchset was
split into two parts.  The support for DMABUF importing was posted in [2]. The
exporter part is dependant on DMA mapping redesign [3] which is not merged into
the mainline. Therefore it is posted as a separate patchset.

This patchset is rebased on 3.4-rc1 plus the following patchsets:

- support for DMABUF importing in V4L2 [2]
- DMA mapping redesign [3]
- support for dma_get_pages extension [4]
- support for vmap extension to dmabuf framework by Dave Airlie [5][6] 

[1] https://lkml.org/lkml/2011/12/26/29
[2] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/46586
[3] http://thread.gmane.org/gmane.linux.kernel.cross-arch/12819
[4] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/43793/focus=43803
[5] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/46713
[6] http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-dmabuf2&id=c481a5451744fe3c4c950a446be10d3212d633d8
[7] http://thread.gmane.org/gmane.comp.video.dri.devel/66213

Marek Szyprowski (1):
  v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call

Tomasz Stanislawski (12):
  v4l: add buffer exporting via dmabuf
  v4l: vb2: add buffer exporting via dmabuf
  v4l: vb2-dma-contig: add setup of sglist for MMAP buffers
  v4l: vb2-dma-contig: add support for DMABUF exporting
  v4l: vb2-dma-contig: add vmap/kmap for dmabuf exporting
  v4l: vb2-dma-contig: change map/unmap behaviour for importers
  v4l: vb2-dma-contig: change map/unmap behaviour for exporters
  v4l: s5p-tv: mixer: support for dmabuf importing
  v4l: s5p-tv: mixer: support for dmabuf exporting
  v4l: fimc: support for dmabuf importing
  v4l: fimc: support for dmabuf exporting
  v4l: vivi: support for dmabuf exporting

 drivers/media/video/Kconfig                 |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c |   11 ++-
 drivers/media/video/s5p-tv/Kconfig          |    1 +
 drivers/media/video/s5p-tv/mixer_video.c    |   12 ++-
 drivers/media/video/v4l2-compat-ioctl32.c   |    1 +
 drivers/media/video/v4l2-ioctl.c            |    7 +
 drivers/media/video/videobuf2-core.c        |   66 ++++++++
 drivers/media/video/videobuf2-dma-contig.c  |  224 +++++++++++++++++++++++++-
 drivers/media/video/vivi.c                  |    9 +
 include/linux/videodev2.h                   |   23 +++
 include/media/v4l2-ioctl.h                  |    2 +
 include/media/videobuf2-core.h              |    2 +
 12 files changed, 348 insertions(+), 11 deletions(-)

-- 
1.7.5.4

