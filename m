Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:58582 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757258AbcKDH6G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 03:58:06 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] media: omap3isp: Use dma_request_chan_by_mask() to request the DMA channel
Date: Fri, 4 Nov 2016 09:58:02 +0200
Message-ID: <20161104075802.19063-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When requesting the DMA channel it was mandatory that we do not have DMA
resource nor valid DMA channel via DT. In this case the
dma_request_slave_channel_compat() would fall back and request any channel
with SW trigger.

The same can be achieved with the dma_request_chan_by_mask() without the
misleading use of the DMAengine API - implying that the omap3isp does
need to have DMA resource or valid dma binding in DT.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
Hi,

Changes sicne v1:
- use dma_request_chan_by_mask() to request the channel as for the histogram
  data reading we do not have hw syncronisation. Add comment about this also to
  clarify the reason.

Regards,
Peter

 drivers/media/platform/omap3isp/isphist.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index 7138b043a4aa..a4ed5d140d48 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -18,7 +18,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dmaengine.h>
-#include <linux/omap-dmaengine.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
@@ -486,27 +485,30 @@ int omap3isp_hist_init(struct isp_device *isp)
 	hist->isp = isp;
 
 	if (HIST_CONFIG_DMA) {
-		struct platform_device *pdev = to_platform_device(isp->dev);
-		struct resource *res;
-		unsigned int sig = 0;
 		dma_cap_mask_t mask;
 
+		/*
+		 * We need slave capable channel without DMA request line for
+		 * reading out the data.
+		 * For this we can use dma_request_chan_by_mask() as we are
+		 * happy with any channel as long as it is capable of slave
+		 * configuration.
+		 */
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
+		hist->dma_ch = dma_request_chan_by_mask(&mask);
+		if (IS_ERR(hist->dma_ch)) {
+			ret = PTR_ERR(hist->dma_ch);
+			if (ret == -EPROBE_DEFER)
+				return ret;
 
-		res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
-						   "hist");
-		if (res)
-			sig = res->start;
-
-		hist->dma_ch = dma_request_slave_channel_compat(mask,
-				omap_dma_filter_fn, &sig, isp->dev, "hist");
-		if (!hist->dma_ch)
+			hist->dma_ch = NULL;
 			dev_warn(isp->dev,
 				 "hist: DMA channel request failed, using PIO\n");
-		else
+		} else {
 			dev_dbg(isp->dev, "hist: using DMA channel %s\n",
 				dma_chan_name(hist->dma_ch));
+		}
 	}
 
 	hist->ops = &hist_ops;
-- 
2.10.2

