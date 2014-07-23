Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59256 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068AbaGWP3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 11:29:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/8] [media] coda: move BIT processor command execution out of pic_run_work
Date: Wed, 23 Jul 2014 17:28:41 +0200
Message-Id: <1406129325-10771-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
References: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for the split, move the AXI_SRAM_USE register access and the
PIC_RUN command execution out of pic_run_work into prepare_encode/decode.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index ecab30a..04a7b12 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1040,6 +1040,13 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	coda_write(dev, 0, CODA_CMD_DEC_PIC_BB_START);
 	coda_write(dev, 0, CODA_CMD_DEC_PIC_START_BYTE);
 
+	if (dev->devtype->product != CODA_DX6)
+		coda_write(dev, ctx->iram_info.axi_sram_use,
+				CODA7_REG_BIT_AXI_SRAM_USE);
+
+	coda_kfifo_sync_to_device_full(ctx);
+	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
+
 	return 0;
 }
 
@@ -1186,6 +1193,12 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
 	}
 
+	if (dev->devtype->product != CODA_DX6)
+		coda_write(dev, ctx->iram_info.axi_sram_use,
+				CODA7_REG_BIT_AXI_SRAM_USE);
+
+	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
+
 	return 0;
 }
 
@@ -1245,14 +1258,6 @@ static void coda_pic_run_work(struct work_struct *work)
 		return;
 	}
 
-	if (dev->devtype->product != CODA_DX6)
-		coda_write(dev, ctx->iram_info.axi_sram_use,
-				CODA7_REG_BIT_AXI_SRAM_USE);
-
-	if (ctx->inst_type == CODA_INST_DECODER)
-		coda_kfifo_sync_to_device_full(ctx);
-	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
-
 	if (!wait_for_completion_timeout(&ctx->completion, msecs_to_jiffies(1000))) {
 		dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout\n");
 
-- 
2.0.1

