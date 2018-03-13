Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:40713 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933209AbeCMMGC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 08:06:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: v4l: omap_vout: vrfb: remove an unused variable
Date: Tue, 13 Mar 2018 13:05:36 +0100
Message-Id: <20180313120548.2603484-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We now get a warning after the 'dmadev' variable is no longer used:

drivers/media/platform/omap/omap_vout_vrfb.c: In function 'omap_vout_prepare_vrfb':
drivers/media/platform/omap/omap_vout_vrfb.c:239:21: error: unused variable 'dmadev' [-Werror=unused-variable]

Fixes: 8f0aa38292f2 ("media: v4l: omap_vout: vrfb: Use the wrapper for prep_interleaved_dma()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/omap/omap_vout_vrfb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index 72c0ac2cbf3d..1d8508237220 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -236,7 +236,6 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
 	struct dma_async_tx_descriptor *tx;
 	enum dma_ctrl_flags flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
 	struct dma_chan *chan = vout->vrfb_dma_tx.chan;
-	struct dma_device *dmadev = chan->device;
 	struct dma_interleaved_template *xt = vout->vrfb_dma_tx.xt;
 	dma_cookie_t cookie;
 	enum dma_status status;
-- 
2.9.0
