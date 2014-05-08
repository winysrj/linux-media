Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48923 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaEHNSi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 09:18:38 -0400
Received: from avalon.localnet (unknown [91.178.192.101])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A3EB435A2D
	for <linux-media@vger.kernel.org>; Thu,  8 May 2014 15:16:00 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.16] Migrate the OMAP3 ISP driver to videobuf2
Date: Thu, 08 May 2014 15:19:02 +0200
Message-ID: <1490830.vhB1M3oxv4@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 286f600bc890347f7ec7bd50d33210d53a9095a3:

  iommu/omap: Fix map protection value handling (2014-04-16 16:30:18 +0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/videobuf2

for you to fetch changes up to 04930b353d8ee711d223a94ec644b5433a53e135:

  omap3isp: Rename isp_buffer isp_addr field to dma (2014-05-03 00:58:48 
+0200)

The series depends on patches for the OMAP IOMMU driver. I've asked Joerg 
Roedel to merge them in his tree and provide a stable branch, you can find it 
at

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git arm/omap

The branch will be merged in v3.16.

The series also has a runtime dependency on commit 
59f0f119e85cfb173db518328b55efbac4087c9f ("arm: dma-mapping: Fix mapping size 
value") that has been merged in v3.15-rc3. It would thus be nice if you could 
merge v3.15-rc3 in the master branch first, to avoid git bisection breakages.

----------------------------------------------------------------
Laurent Pinchart (26):
      omap3isp: stat: Rename IS_COHERENT_BUF to ISP_STAT_USES_DMAENGINE
      omap3isp: stat: Remove impossible WARN_ON
      omap3isp: stat: Share common code for buffer allocation
      omap3isp: stat: Merge dma_addr and iommu_addr fields
      omap3isp: stat: Store sg table in ispstat_buffer
      omap3isp: stat: Use the DMA API
      omap3isp: ccdc: Use the DMA API for LSC
      omap3isp: ccdc: Use the DMA API for FPC
      omap3isp: video: Set the buffer bytesused field at completion time
      omap3isp: queue: Move IOMMU handling code to the queue
      omap3isp: queue: Use sg_table structure
      omap3isp: queue: Merge the prepare and sglist functions
      omap3isp: queue: Inline the ispmmu_v(un)map functions
      omap3isp: queue: Allocate kernel buffers with dma_alloc_coherent
      omap3isp: queue: Fix the dma_map_sg() return value check
      omap3isp: queue: Map PFNMAP buffers to device
      omap3isp: queue: Use sg_alloc_table_from_pages()
      omap3isp: Use the ARM DMA IOMMU-aware operations
      omap3isp: queue: Don't build scatterlist for kernel buffer
      omap3isp: Move queue mutex to isp_video structure
      omap3isp: Move queue irqlock to isp_video structure
      omap3isp: Move buffer irqlist to isp_buffer structure
      omap3isp: Cancel all queued buffers when stopping the video stream
      v4l: vb2: Add a function to discard all DONE buffers
      omap3isp: Move to videobuf2
      omap3isp: Rename isp_buffer isp_addr field to dma

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
 drivers/media/platform/omap3isp/ispqueue.c    | 1161 ------------------------
 drivers/media/platform/omap3isp/ispqueue.h    |  188 ------
 drivers/media/platform/omap3isp/ispresizer.c  |    8 +-
 drivers/media/platform/omap3isp/ispstat.c     |  197 +++---
 drivers/media/platform/omap3isp/ispstat.h     |    3 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  325 ++++-----
 drivers/media/platform/omap3isp/ispvideo.h    |   29 +-
 drivers/media/v4l2-core/videobuf2-core.c      |   24 +
 drivers/staging/media/omap4iss/iss_video.c    |    2 +-
 include/media/videobuf2-core.h                |    1 +
 21 files changed, 458 insertions(+), 1745 deletions(-)
 delete mode 100644 drivers/media/platform/omap3isp/ispqueue.c
 delete mode 100644 drivers/media/platform/omap3isp/ispqueue.h

-- 
Regards,

Laurent Pinchart

