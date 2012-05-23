Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52045 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EWNHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:46 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4H000ZY8GM2S@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:34 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00MG78GW3Q@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:44 +0100 (BST)
Date: Wed, 23 May 2012 15:07:23 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 00/12] Support for dmabuf exporting for videobuf2
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
The patches adds support for DMABUF exporting to V4L2 stack.  The latest
support for DMABUF importing was posted in [1]. The exporter part is dependant
on DMA mapping redesign [2] which is not merged into the mainline. Therefore it
is posted as a separate patchset. Moreover some patches depends on vmap
extension for DMABUF by Dave Airlie [3] and sg_alloc_table_from_pages function
[4].

Changelog:
v0: (RFC)
- updated setup of VIDIOC_EXPBUF ioctl
- doc updates
- introduced workaround to avoid using dma_get_pages,
- removed caching of exported dmabuf to avoid existence of circular reference
  between dmabuf and vb2_dc_buf or resource leakage
- removed all 'change behaviour' patches
- inital support for exporting in s5p-mfs driver
- removal of vb2_mmap_pfn_range that is no longer used
- use sg_alloc_table_from_pages instead of creating sglist in vb2_dc code
- move attachment allocation to exporter's attach callback

[1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/48730
[2] http://thread.gmane.org/gmane.linux.kernel.cross-arch/14098
[3] http://permalink.gmane.org/gmane.comp.video.dri.devel/69302
[4] This patchset is rebased on 3.4-rc1 plus the following patchsets:

Marek Szyprowski (1):
  v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call

Tomasz Stanislawski (11):
  v4l: add buffer exporting via dmabuf
  v4l: vb2: add buffer exporting via dmabuf
  v4l: vb2-dma-contig: add setup of sglist for MMAP buffers
  v4l: vb2-dma-contig: add support for DMABUF exporting
  v4l: vb2-dma-contig: add vmap/kmap for dmabuf exporting
  v4l: s5p-fimc: support for dmabuf exporting
  v4l: s5p-tv: mixer: support for dmabuf exporting
  v4l: s5p-mfc: support for dmabuf exporting
  v4l: vb2: remove vb2_mmap_pfn_range function
  v4l: vb2-dma-contig: use sg_alloc_table_from_pages function
  v4l: vb2-dma-contig: Move allocation of dbuf attachment to attach cb

 drivers/media/video/s5p-fimc/fimc-capture.c |    9 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c   |   13 ++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c   |   13 ++
 drivers/media/video/s5p-tv/mixer_video.c    |   10 +
 drivers/media/video/v4l2-compat-ioctl32.c   |    1 +
 drivers/media/video/v4l2-dev.c              |    1 +
 drivers/media/video/v4l2-ioctl.c            |    6 +
 drivers/media/video/videobuf2-core.c        |   67 ++++++
 drivers/media/video/videobuf2-dma-contig.c  |  323 ++++++++++++++++++++++-----
 drivers/media/video/videobuf2-memops.c      |   40 ----
 include/linux/videodev2.h                   |   26 +++
 include/media/v4l2-ioctl.h                  |    2 +
 include/media/videobuf2-core.h              |    2 +
 include/media/videobuf2-memops.h            |    5 -
 14 files changed, 411 insertions(+), 107 deletions(-)

-- 
1.7.9.5

