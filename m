Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40105 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaI2Myk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 08:54:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/6] [media] coda: simplify frame memory control register handling
Date: Mon, 29 Sep 2014 14:53:46 +0200
Message-Id: <1411995227-3623-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
References: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the firmware newer writes to FRAME_MEM_CTRL, we can initialize it once
per context (incidentally, we already do write it in coda_hw_init) and never
have to read it back.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 8 ++++----
 drivers/media/platform/coda/coda-common.c | 4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 747b544..3839e35 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -729,10 +729,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		break;
 	}
 
-	value = coda_read(dev, CODA_REG_BIT_FRAME_MEM_CTRL);
-	value &= ~(1 << 2 | 0x7 << 9);
-	ctx->frame_mem_ctrl = value;
-	coda_write(dev, value, CODA_REG_BIT_FRAME_MEM_CTRL);
+	coda_write(dev, ctx->frame_mem_ctrl, CODA_REG_BIT_FRAME_MEM_CTRL);
 
 	if (dev->devtype->product == CODA_DX6) {
 		/* Configure the coda */
@@ -741,6 +738,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	}
 
 	/* Could set rotation here if needed */
+	value = 0;
 	switch (dev->devtype->product) {
 	case CODA_DX6:
 		value = (q_data_src->width & CODADX6_PICWIDTH_MASK)
@@ -1296,6 +1294,8 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	/* Update coda bitstream read and write pointers from kfifo */
 	coda_kfifo_sync_to_device_full(ctx);
 
+	coda_write(dev, ctx->frame_mem_ctrl, CODA_REG_BIT_FRAME_MEM_CTRL);
+
 	ctx->display_idx = -1;
 	ctx->frm_dis_flg = 0;
 	coda_write(dev, 0, CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index fac2517..feb270f 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1423,8 +1423,10 @@ static int coda_open(struct file *file, enum coda_inst_type inst_type,
 	ctx->dev = dev;
 	ctx->idx = idx;
 	switch (dev->devtype->product) {
-	case CODA_7541:
 	case CODA_960:
+		ctx->frame_mem_ctrl = 1 << 12;
+		/* fallthrough */
+	case CODA_7541:
 		ctx->reg_idx = 0;
 		break;
 	default:
-- 
2.1.0

