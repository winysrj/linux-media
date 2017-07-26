Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:61789 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751629AbdGZPX2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 11:23:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: v4l: omap_vout: vrfb: initialize DMA flags
Date: Wed, 26 Jul 2017 17:23:07 +0200
Message-Id: <20170726152320.4077805-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Passing uninitialized flags into device_prep_interleaved_dma is clearly
a bad idea, and we get a compiler warning for it:

drivers/media/platform/omap/omap_vout_vrfb.c: In function 'omap_vout_prepare_vrfb':
drivers/media/platform/omap/omap_vout_vrfb.c:273:5: error: 'flags' may be used uninitialized in this function [-Werror=maybe-uninitialized]

It seems that the OMAP dmaengine ignores the flags, but we should
pick the right ones anyway. This sets the flags I guessed based
on what other drivers used, and Peter confirmed that they are the
right ones.

Fixes: 6a1560ecaa8c ("media: v4l: omap_vout: vrfb: Convert to dmaengine")
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Originally sent on July 10 as a bugreport. Since Peter has confirmed
the fix to be correct, please merge this for 4.13.
---
 drivers/media/platform/omap/omap_vout_vrfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index 040eacc45168..123c2b26a933 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -234,7 +234,7 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
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
