Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbaDCWiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 13/25] omap3isp: queue: Inline the ispmmu_v(un)map functions
Date: Fri,  4 Apr 2014 00:39:43 +0200
Message-Id: <1396564795-27192-14-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ispmmu_vmap() and ispmmu_vunmap() functions are just wrappers around
omap_iommu_vmap() and omap_iommu_vunmap(). Inline them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.c | 36 ++++--------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index a7be7d7..088710b 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -39,36 +39,6 @@
 #include "ispvideo.h"
 
 /* -----------------------------------------------------------------------------
- * IOMMU management
- */
-
-#define IOMMU_FLAG	(IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8)
-
-/*
- * ispmmu_vmap - Wrapper for virtual memory mapping of a scatter gather table
- * @dev: Device pointer specific to the OMAP3 ISP.
- * @sgt: Pointer to source scatter gather table.
- *
- * Returns a resulting mapped device address by the ISP MMU, or -ENOMEM if
- * we ran out of memory.
- */
-static dma_addr_t
-ispmmu_vmap(struct isp_device *isp, const struct sg_table *sgt)
-{
-	return omap_iommu_vmap(isp->domain, isp->dev, 0, sgt, IOMMU_FLAG);
-}
-
-/*
- * ispmmu_vunmap - Unmap a device address from the ISP MMU
- * @dev: Device pointer specific to the OMAP3 ISP.
- * @da: Device address generated from a ispmmu_vmap call.
- */
-static void ispmmu_vunmap(struct isp_device *isp, dma_addr_t da)
-{
-	omap_iommu_vunmap(isp->domain, isp->dev, (u32)da);
-}
-
-/* -----------------------------------------------------------------------------
  * Video buffers management
  */
 
@@ -227,7 +197,8 @@ static void isp_video_buffer_cleanup(struct isp_video_buffer *buf)
 	unsigned int i;
 
 	if (buf->dma) {
-		ispmmu_vunmap(video->isp, buf->dma);
+		omap_iommu_vunmap(video->isp->domain, video->isp->dev,
+				  buf->dma);
 		buf->dma = 0;
 	}
 
@@ -521,7 +492,8 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 		}
 	}
 
-	addr = ispmmu_vmap(video->isp, &buf->sgt);
+	addr = omap_iommu_vmap(video->isp->domain, video->isp->dev, 0,
+			       &buf->sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_8);
 	if (IS_ERR_VALUE(addr)) {
 		ret = -EIO;
 		goto done;
-- 
1.8.3.2

