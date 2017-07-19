Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33651 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753570AbdGSKGT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 06:06:19 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>,
        Ian Arkver <ian.arkver.dev@gmail.com>
Subject: [PATCH] [media] coda: disable BWB only while decoding on CODA 960
Date: Wed, 19 Jul 2017 12:06:12 +0200
Message-Id: <20170719100612.16748-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disabling the BWB works around hangups observed while decoding. Since no
issues have been observed while encoding, and disabling BWB also reduces
encoding performance, reenable it for encoding.

Cc: Ian Arkver <ian.arkver.dev@gmail.com>
Reported-by: Ian Arkver <ian.arkver.dev@gmail.com>
Fixes: 89ed025d5c53 ("[media] coda: disable BWB for all codecs on CODA 960")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 829c7895a98a2..21d89c411f149 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -73,7 +73,7 @@ MODULE_PARM_DESC(disable_vdoa, "Disable Video Data Order Adapter tiled to raster
 
 static int enable_bwb = 0;
 module_param(enable_bwb, int, 0644);
-MODULE_PARM_DESC(enable_bwb, "Enable BWB unit, may crash on certain streams");
+MODULE_PARM_DESC(enable_bwb, "Enable BWB unit for decoding, may crash on certain streams");
 
 void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
@@ -1938,7 +1938,13 @@ static int coda_open(struct file *file)
 	ctx->idx = idx;
 	switch (dev->devtype->product) {
 	case CODA_960:
-		if (enable_bwb)
+		/*
+		 * Enabling the BWB when decoding can hang the firmware with
+		 * certain streams. The issue was tracked as ENGR00293425 by
+		 * Freescale. As a workaround, disable BWB for all decoders.
+		 * The enable_bwb module parameter allows to override this.
+		 */
+		if (enable_bwb || ctx->inst_type == CODA_INST_ENCODER)
 			ctx->frame_mem_ctrl = CODA9_FRAME_ENABLE_BWB;
 		/* fallthrough */
 	case CODA_7541:
@@ -2142,7 +2148,8 @@ static int coda_hw_init(struct coda_dev *dev)
 			   CODA_REG_BIT_STREAM_CTRL);
 	}
 	if (dev->devtype->product == CODA_960)
-		coda_write(dev, 1 << 12, CODA_REG_BIT_FRAME_MEM_CTRL);
+		coda_write(dev, CODA9_FRAME_ENABLE_BWB,
+				CODA_REG_BIT_FRAME_MEM_CTRL);
 	else
 		coda_write(dev, 0, CODA_REG_BIT_FRAME_MEM_CTRL);
 
-- 
2.11.0
