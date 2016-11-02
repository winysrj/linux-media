Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:37718 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752483AbcKBMkF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:40:05 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] media: omap3isp: Use dma_request_chan() to requesting DMA channel
Date: Wed, 2 Nov 2016 14:39:59 +0200
Message-ID: <20161102123959.6098-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the new dma_request_chan() the client driver does not need to look for
the DMA resource and it does not need to pass filter_fn anymore.
By switching to the new API the driver can now support deferred probing
against DMA.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
Hi,

the original patch was sent 29.04.2016:
https://patchwork.kernel.org/patch/8981811/

I have rebased it on top of linux-next.

Regards,
Peter

 drivers/media/platform/omap3isp/isphist.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index 7138b043a4aa..e163e3d92517 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -18,7 +18,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dmaengine.h>
-#include <linux/omap-dmaengine.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
@@ -486,27 +485,19 @@ int omap3isp_hist_init(struct isp_device *isp)
 	hist->isp = isp;
 
 	if (HIST_CONFIG_DMA) {
-		struct platform_device *pdev = to_platform_device(isp->dev);
-		struct resource *res;
-		unsigned int sig = 0;
-		dma_cap_mask_t mask;
-
-		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
-
-		res = platform_get_resource_byname(pdev, IORESOURCE_DMA,
-						   "hist");
-		if (res)
-			sig = res->start;
-
-		hist->dma_ch = dma_request_slave_channel_compat(mask,
-				omap_dma_filter_fn, &sig, isp->dev, "hist");
-		if (!hist->dma_ch)
+		hist->dma_ch = dma_request_chan(isp->dev, "hist");
+		if (IS_ERR(hist->dma_ch)) {
+			ret = PTR_ERR(hist->dma_ch);
+			if (ret == -EPROBE_DEFER)
+				return ret;
+
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

