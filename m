Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52429 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaDCWh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:37:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 00/25] OMAP3 ISP: Move to videobuf2
Date: Fri,  4 Apr 2014 00:39:30 +0200
Message-Id: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I think the subject line should be enough to get everybody excited about this
patch series (everybody being Sakari, me, and possibly one or two other
developers). The idea is pretty clear, I've tried to keep patches small and
reviewable (24/25 is a bit too big for my taste, but splitting it further
would be pretty difficult), so please look at them for details.

The patches are based on top of the latest media master branch. They also
depend at runtime on an OMAP IOMMU cleanup series. I've asked Joerg Roedel to
provide a stable branch based on v3.15-rc1 (when it will be available).

Laurent Pinchart (25):
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
 drivers/media/platform/omap3isp/ispqueue.c    | 1161 -------------------------
 drivers/media/platform/omap3isp/ispqueue.h    |  188 ----
 drivers/media/platform/omap3isp/ispresizer.c  |    8 +-
 drivers/media/platform/omap3isp/ispstat.c     |  197 ++---
 drivers/media/platform/omap3isp/ispstat.h     |    3 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  323 +++----
 drivers/media/platform/omap3isp/ispvideo.h    |   29 +-
 drivers/media/v4l2-core/videobuf2-core.c      |   24 +
 drivers/staging/media/omap4iss/iss_video.c    |    2 +-
 include/media/videobuf2-core.h                |    1 +
 21 files changed, 456 insertions(+), 1745 deletions(-)
 delete mode 100644 drivers/media/platform/omap3isp/ispqueue.c
 delete mode 100644 drivers/media/platform/omap3isp/ispqueue.h

-- 
Regards,

Laurent Pinchart

