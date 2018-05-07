Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37980 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752280AbeEGMr0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:47:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org
Subject: [PATCH 2/2] omap3isp: Don't use GFP_DMA
Date: Mon,  7 May 2018 15:47:23 +0300
Message-Id: <20180507124723.2153-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180507124723.2153-1-sakari.ailus@linux.intel.com>
References: <20180507124723.2153-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The isp stat driver allocates memory for DMA and uses GFP_DMA flag for
dev_alloc_coherent. The flag is no longer needed as the DMA mask is used
for the purpose. Remove it.

Reported-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/ispstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 34a91125da36..c68562189961 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -371,7 +371,7 @@ static int isp_stat_bufs_alloc_one(struct device *dev,
 	int ret;
 
 	buf->virt_addr = dma_alloc_coherent(dev, size, &buf->dma_addr,
-					    GFP_KERNEL | GFP_DMA);
+					    GFP_KERNEL);
 	if (!buf->virt_addr)
 		return -ENOMEM;
 
-- 
2.11.0
