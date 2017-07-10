Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:56236 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753703AbdGJLTW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 07:19:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [BUGREPORT] media: v4l: omap_vout: vrfb: initialize DMA flags
Date: Mon, 10 Jul 2017 13:18:48 +0200
Message-Id: <20170710111912.887188-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Passing uninitialized flags into device_prep_interleaved_dma is clearly
a bad idea, and we get a compiler warning for it:

drivers/media/platform/omap/omap_vout_vrfb.c: In function 'omap_vout_prepare_vrfb':
drivers/media/platform/omap/omap_vout_vrfb.c:273:5: error: 'flags' may be used uninitialized in this function [-Werror=maybe-uninitialized]

It seems that the OMAP dmaengine ignores the flags, but we should
pick the right ones anyway. Unfortunately I don't know what they
should be, so I just picked the most common flags. Please set the
right flags here and fold the modified patch.

Fixes: 6a1560ecaa8c ("media: v4l: omap_vout: vrfb: Convert to dmaengine")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/omap/omap_vout_vrfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index 45a553d4f5b2..fed28b6bbbc0 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -233,7 +233,7 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
 			   struct videobuf_buffer *vb)
 {
 	struct dma_async_tx_descriptor *tx;
-	enum dma_ctrl_flags flags;
+	enum dma_ctrl_flags flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
 	struct dma_chan *chan = vout->vrfb_dma_tx.chan;
 	struct dma_device *dmadev = chan->device;
 	struct dma_interleaved_template *xt = vout->vrfb_dma_tx.xt;
-- 
2.9.0
