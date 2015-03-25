Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56416 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524AbbCYW6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 18:58:39 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 09/15] omap3isp: Replace mmio_base_phys array with the histogram block base
Date: Thu, 26 Mar 2015 00:57:33 +0200
Message-Id: <1427324259-18438-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only the histogram sub-block driver uses the physical address. Do not store
it for other sub-blocks.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c     |    3 ++-
 drivers/media/platform/omap3isp/isp.h     |    6 +++---
 drivers/media/platform/omap3isp/isphist.c |    3 +--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index c045318..68d7edfc 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2247,7 +2247,8 @@ static int isp_map_mem_resource(struct platform_device *pdev,
 	if (IS_ERR(isp->mmio_base[res]))
 		return PTR_ERR(isp->mmio_base[res]);
 
-	isp->mmio_base_phys[res] = mem->start;
+	if (res == OMAP3_ISP_IOMEM_HIST)
+		isp->mmio_hist_base_phys = mem->start;
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index b932a6f..9535524 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -138,8 +138,8 @@ struct isp_xclk {
  * @irq_num: Currently used IRQ number.
  * @mmio_base: Array with kernel base addresses for ioremapped ISP register
  *             regions.
- * @mmio_base_phys: Array with physical L4 bus addresses for ISP register
- *                  regions.
+ * @mmio_hist_base_phys: Physical L4 bus address for ISP hist block register
+ *			 region.
  * @mapping: IOMMU mapping
  * @stat_lock: Spinlock for handling statistics
  * @isp_mutex: Mutex for serializing requests to ISP.
@@ -175,7 +175,7 @@ struct isp_device {
 	unsigned int irq_num;
 
 	void __iomem *mmio_base[OMAP3_ISP_IOMEM_LAST];
-	unsigned long mmio_base_phys[OMAP3_ISP_IOMEM_LAST];
+	unsigned long mmio_hist_base_phys;
 
 	struct dma_iommu_mapping *mapping;
 
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index 738b946..7138b04 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -193,8 +193,7 @@ static int hist_buf_dma(struct ispstat *hist)
 	omap3isp_flush(hist->isp);
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.src_addr = hist->isp->mmio_base_phys[OMAP3_ISP_IOMEM_HIST]
-		     + ISPHIST_DATA;
+	cfg.src_addr = hist->isp->mmio_hist_base_phys + ISPHIST_DATA;
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	cfg.src_maxburst = hist->buf_size / 4;
 
-- 
1.7.10.4

