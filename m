Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30886 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2FNOcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 10:32:39 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5M00AKV337QK80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:33:07 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M5M00EJP32ADX@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 15:32:35 +0100 (BST)
Date: Thu, 14 Jun 2012 16:32:20 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 0/9] Support for dmabuf exporting for videobuf2
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
The patches adds support for DMABUF exporting to V4L2 stack.  The latest
support for DMABUF importing was posted in [1]. The exporter part is dependant
on DMA mapping redesign [2] which is expected to be merged into the mainline.
Therefore it is posted as a separate patchset. Moreover some patches depends on
vmap extension for DMABUF by Dave Airlie [3] and sg_alloc_table_from_pages
function [4]. The last patch 'v4l: vb2-dma-contig: use dma_get_sgtable' depends
on dma_get_sgtable extension to DMA api [5].

The tree with all the patches and extensions is available at:
repo: git://git.infradead.org/users/kmpark/linux-2.6-samsung
branch: media-for3.5-vb2-dmabuf-v7

Changelog:

v2:
- add documentation for DMABUF exporting
- squashed 'let mmap method to use dma_mmap_coherent call' with
  'remove vb2_mmap_pfn_range function'
- move setup of scatterlist for MMAP buffers from alloc to DMABUF export code
- use locking to serialize map/unmap of DMABUF attachments
- squash vmap/kmap, setup of sg lists, allocation in attachments into
  dma-contig exporter patch
- fix occasional failure of follow_pfn trick by using init_mm in artificial
  VMA
- add support for exporting in s5p-mfc driver
- drop all code that duplicates sg_alloc_table_from_pages
- introduce usage of dma_get_sgtable as generic solution
  to follow_pfn trick

v1:
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

v0: RFC
- initial version

[1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/49438
[2] http://thread.gmane.org/gmane.linux.kernel.cross-arch/14098
[3] http://permalink.gmane.org/gmane.comp.video.dri.devel/69302
[4] This patchset is rebased on 3.4-rc1 plus the following patchsets:
[5] http://www.spinics.net/lists/linux-arch/msg18282.html

Marek Szyprowski (1):
  v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call

Tomasz Stanislawski (8):
  Documentation: media: description of DMABUF exporting in V4L2
  v4l: add buffer exporting via dmabuf
  v4l: vb2: add buffer exporting via dmabuf
  v4l: vb2-dma-contig: add support for DMABUF exporting
  v4l: s5p-fimc: support for dmabuf exporting
  v4l: s5p-tv: mixer: support for dmabuf exporting
  v4l: s5p-mfc: support for dmabuf exporting
  v4l: vb2-dma-contig: use dma_get_sgtable

 Documentation/DocBook/media/v4l/compat.xml        |    3 +
 Documentation/DocBook/media/v4l/io.xml            |    3 +
 Documentation/DocBook/media/v4l/v4l2.xml          |    1 +
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml |  223 ++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-capture.c       |    9 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c         |   18 ++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c         |   18 ++
 drivers/media/video/s5p-tv/mixer_video.c          |   10 +
 drivers/media/video/v4l2-compat-ioctl32.c         |    1 +
 drivers/media/video/v4l2-dev.c                    |    1 +
 drivers/media/video/v4l2-ioctl.c                  |    6 +
 drivers/media/video/videobuf2-core.c              |   67 ++++++
 drivers/media/video/videobuf2-dma-contig.c        |  224 ++++++++++++++++++++-
 drivers/media/video/videobuf2-memops.c            |   40 ----
 include/linux/videodev2.h                         |   26 +++
 include/media/v4l2-ioctl.h                        |    2 +
 include/media/videobuf2-core.h                    |    2 +
 include/media/videobuf2-memops.h                  |    5 -
 18 files changed, 612 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml

-- 
1.7.9.5

