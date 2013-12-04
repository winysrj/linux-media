Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49252 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab3LDRNc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 12:13:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: Use devm_ioremap_resource()
Date: Wed,  4 Dec 2013 18:13:34 +0100
Message-Id: <1386177214-27132-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace devm_request_mem_region() and devm_ioremap_nocache() with
devm_ioremap_resource(). The behaviour remains the same and the code is
simplified.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c | 25 +++++--------------------
 drivers/media/platform/omap3isp/isp.h |  2 --
 2 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 561bce8..7753c0c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2120,28 +2120,13 @@ static int isp_map_mem_resource(struct platform_device *pdev,
 	/* request the mem region for the camera registers */
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, res);
-	if (!mem) {
-		dev_err(isp->dev, "no mem resource?\n");
-		return -ENODEV;
-	}
-
-	if (!devm_request_mem_region(isp->dev, mem->start, resource_size(mem),
-				     pdev->name)) {
-		dev_err(isp->dev,
-			"cannot reserve camera register I/O region\n");
-		return -ENODEV;
-	}
-	isp->mmio_base_phys[res] = mem->start;
-	isp->mmio_size[res] = resource_size(mem);
 
 	/* map the region */
-	isp->mmio_base[res] = devm_ioremap_nocache(isp->dev,
-						   isp->mmio_base_phys[res],
-						   isp->mmio_size[res]);
-	if (!isp->mmio_base[res]) {
-		dev_err(isp->dev, "cannot map camera register I/O region\n");
-		return -ENODEV;
-	}
+	isp->mmio_base[res] = devm_ioremap_resource(isp->dev, mem);
+	if (IS_ERR(isp->mmio_base[res]))
+		return PTR_ERR(isp->mmio_base[res]);
+
+	isp->mmio_base_phys[res] = mem->start;
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index ce65d3a..a798cb7 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -151,7 +151,6 @@ struct isp_xclk {
  *             regions.
  * @mmio_base_phys: Array with physical L4 bus addresses for ISP register
  *                  regions.
- * @mmio_size: Array with ISP register regions size in bytes.
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
  * @crashed: Bitmask of crashed entities (indexed by entity ID)
@@ -187,7 +186,6 @@ struct isp_device {
 
 	void __iomem *mmio_base[OMAP3_ISP_IOMEM_LAST];
 	unsigned long mmio_base_phys[OMAP3_ISP_IOMEM_LAST];
-	resource_size_t mmio_size[OMAP3_ISP_IOMEM_LAST];
 
 	/* ISP Obj */
 	spinlock_t stat_lock;	/* common lock for statistic drivers */
-- 
Regards,

Laurent Pinchart

