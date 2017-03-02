Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56231 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751870AbdCBLGm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Mar 2017 06:06:42 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: disable BWB for all codecs on CODA 960
Date: Thu,  2 Mar 2017 11:19:52 +0100
Message-Id: <20170302101952.16917-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I don't know what the BWB unit is, I guess W is for write and one of the
Bs is for burst. All I know is that there repeatedly have been issues
with it hanging on certain streams (ENGR00223231, ENGR00293425), with
various firmware versions, sometimes blocking something related to the
GDI bus or the GDI AXI adapter. There are some error cases that we don't
know how to recover from without a reboot. Apparently this unit can be
disabled by setting bit 12 in the FRAME_MEM_CTRL mailbox register to
zero, so do that to avoid crashes.

Side effects are reduced burst lengths when writing out decoded frames
to memory, so there is an "enable_bwb" module parameter to turn it back
on.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 7 ++++++-
 drivers/media/platform/coda/coda_regs.h   | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 4d25ca1981301..aeb2456830348 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -71,6 +71,10 @@ static int disable_vdoa;
 module_param(disable_vdoa, int, 0644);
 MODULE_PARM_DESC(disable_vdoa, "Disable Video Data Order Adapter tiled to raster-scan conversion");
 
+static int enable_bwb = 0;
+module_param(enable_bwb, int, 0644);
+MODULE_PARM_DESC(enable_bwb, "Enable BWB unit, may crash on certain streams");
+
 void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
 	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
@@ -1891,7 +1895,8 @@ static int coda_open(struct file *file)
 	ctx->idx = idx;
 	switch (dev->devtype->product) {
 	case CODA_960:
-		ctx->frame_mem_ctrl = 1 << 12;
+		if (enable_bwb)
+			ctx->frame_mem_ctrl = CODA9_FRAME_ENABLE_BWB;
 		/* fallthrough */
 	case CODA_7541:
 		ctx->reg_idx = 0;
diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 3490602fa6e1e..77ee46a934272 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -51,6 +51,7 @@
 #define		CODA7_STREAM_SEL_64BITS_ENDIAN	(1 << 1)
 #define		CODA_STREAM_ENDIAN_SELECT	(1 << 0)
 #define CODA_REG_BIT_FRAME_MEM_CTRL		0x110
+#define		CODA9_FRAME_ENABLE_BWB		(1 << 12)
 #define		CODA9_FRAME_TILED2LINEAR	(1 << 11)
 #define		CODA_FRAME_CHROMA_INTERLEAVE	(1 << 2)
 #define		CODA_IMAGE_ENDIAN_SELECT	(1 << 0)
-- 
2.11.0
