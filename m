Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:54798 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaFLVb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 17:31:56 -0400
Date: Thu, 12 Jun 2014 18:31:43 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.16-rc1] OMAP3 updates
Message-id: <20140612183143.57763619.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/omap3isp

For some driver improvements on OMAP3. This series depend on some iommu
patches already merged.

Thanks,
Mauro

The following changes since commit 85ac1a1772bb41da895bad83a81f6a62c8f293f6:

  [media] media: stk1160: Avoid stack-allocated buffer for control URBs (2014-05-24 17:12:11 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/omap3isp

for you to fetch changes up to 21d8582d480443574d6a8811e25ccb65dff974d5:

  [media] omap3isp: Rename isp_buffer isp_addr field to dma (2014-05-25 11:40:09 -0300)

----------------------------------------------------------------
Laurent Pinchart (26):
      [media] omap3isp: stat: Rename IS_COHERENT_BUF to ISP_STAT_USES_DMAENGINE
      [media] omap3isp: stat: Remove impossible WARN_ON
      [media] omap3isp: stat: Share common code for buffer allocation
      [media] omap3isp: stat: Merge dma_addr and iommu_addr fields
      [media] omap3isp: stat: Store sg table in ispstat_buffer
      [media] omap3isp: stat: Use the DMA API
      [media] omap3isp: ccdc: Use the DMA API for LSC
      [media] omap3isp: ccdc: Use the DMA API for FPC
      [media] omap3isp: video: Set the buffer bytesused field at completion time
      [media] omap3isp: queue: Move IOMMU handling code to the queue
      [media] omap3isp: queue: Use sg_table structure
      [media] omap3isp: queue: Merge the prepare and sglist functions
      [media] omap3isp: queue: Inline the ispmmu_v(un)map functions
      [media] omap3isp: queue: Allocate kernel buffers with dma_alloc_coherent
      [media] omap3isp: queue: Fix the dma_map_sg() return value check
      [media] omap3isp: queue: Map PFNMAP buffers to device
      [media] omap3isp: queue: Use sg_alloc_table_from_pages()
      [media] omap3isp: Use the ARM DMA IOMMU-aware operations
      [media] omap3isp: queue: Don't build scatterlist for kernel buffer
      [media] omap3isp: Move queue mutex to isp_video structure
      [media] omap3isp: Move queue irqlock to isp_video structure
      [media] omap3isp: Move buffer irqlist to isp_buffer structure
      [media] omap3isp: Cancel all queued buffers when stopping the video stream
      [media] v4l: vb2: Add a function to discard all DONE buffers
      [media] omap3isp: Move to videobuf2
      [media] omap3isp: Rename isp_buffer isp_addr field to dma

Mauro Carvalho Chehab (1):
      Merge branch 'arm/omap' of git://git.kernel.org/.../joro/iommu into topic/omap3isp

 drivers/iommu/omap-iommu.c                    |   31 +-
 drivers/iommu/omap-iopgtable.h                |    3 -
 drivers/media/platform/Kconfig                |    4 +-
 drivers/media/platform/omap3isp/Makefile      |    2 +-
 drivers/media/platform/omap3isp/isp.c         |  108 ++-
 drivers/media/platform/omap3isp/isp.h         |    8 +-
 drivers/media/platform/omap3isp/ispccdc.c     |  107 ++-
 drivers/media/platform/omap3isp/ispccdc.h     |   16 +-
 drivers/media/platform/omap3isp/ispccp2.c     |    4 +-
 drivers/media/platform/omap3isp/ispcsi2.c     |    4 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c |    2 +-
 drivers/media/platform/omap3isp/isph3a_af.c   |    2 +-
 drivers/media/platform/omap3isp/isppreview.c  |    8 +-
 drivers/media/platform/omap3isp/ispqueue.c    | 1161 -------------------------
 drivers/media/platform/omap3isp/ispqueue.h    |  188 ----
 drivers/media/platform/omap3isp/ispresizer.c  |    8 +-
 drivers/media/platform/omap3isp/ispstat.c     |  197 ++---
 drivers/media/platform/omap3isp/ispstat.h     |    3 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  325 +++----
 drivers/media/platform/omap3isp/ispvideo.h    |   29 +-
 drivers/media/v4l2-core/videobuf2-core.c      |   24 +
 drivers/staging/media/omap4iss/iss_video.c    |    2 +-
 include/media/videobuf2-core.h                |    1 +
 23 files changed, 470 insertions(+), 1767 deletions(-)
 delete mode 100644 drivers/media/platform/omap3isp/ispqueue.c
 delete mode 100644 drivers/media/platform/omap3isp/ispqueue.h

