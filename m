Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaDUM3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 02/26] omap3isp: stat: Remove impossible WARN_ON
Date: Mon, 21 Apr 2014 14:28:48 +0200
Message-Id: <1398083352-8451-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The WARN_ON statements in the buffer allocation functions try to catch
conditions where buffers would have already been allocated. As the
buffers are explicitly freed right before being allocated this can't
happen.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 48b702a..c6c1290 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -400,7 +400,6 @@ static int isp_stat_bufs_alloc_iommu(struct ispstat *stat, unsigned int size)
 		struct ispstat_buffer *buf = &stat->buf[i];
 		struct iovm_struct *iovm;
 
-		WARN_ON(buf->dma_addr);
 		buf->iommu_addr = omap_iommu_vmalloc(isp->domain, isp->dev, 0,
 							size, IOMMU_FLAG);
 		if (IS_ERR((void *)buf->iommu_addr)) {
@@ -441,7 +440,6 @@ static int isp_stat_bufs_alloc_dma(struct ispstat *stat, unsigned int size)
 	for (i = 0; i < STAT_MAX_BUFS; i++) {
 		struct ispstat_buffer *buf = &stat->buf[i];
 
-		WARN_ON(buf->iommu_addr);
 		buf->virt_addr = dma_alloc_coherent(stat->isp->dev, size,
 					&buf->dma_addr, GFP_KERNEL | GFP_DMA);
 
-- 
1.8.3.2

