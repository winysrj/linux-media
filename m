Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42789 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbbBWPUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:20:24 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 09/12] [media] coda: remove duplicate error messages for buffer allocations
Date: Mon, 23 Feb 2015 16:20:10 +0100
Message-Id: <1424704813-20792-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

coda_alloc_aux_buf already prints an error, no need to print duplicate
error messages all over the place.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 21 ++++-----------------
 drivers/media/platform/coda/coda-common.c | 12 +++---------
 2 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 0073f5a..2304158 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -402,10 +402,8 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 	if (!ctx->parabuf.vaddr) {
 		ret = coda_alloc_context_buf(ctx, &ctx->parabuf,
 					     CODA_PARA_BUF_SIZE, "parabuf");
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
+		if (ret < 0)
 			return ret;
-		}
 	}
 
 	if (dev->devtype->product == CODA_DX6)
@@ -417,22 +415,15 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 			DIV_ROUND_UP(q_data->height, 16)) * 3200 / 8 + 512;
 		ret = coda_alloc_context_buf(ctx, &ctx->slicebuf, size,
 					     "slicebuf");
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev,
-				 "failed to allocate %d byte slice buffer",
-				 ctx->slicebuf.size);
+		if (ret < 0)
 			goto err;
-		}
 	}
 
 	if (!ctx->psbuf.vaddr && dev->devtype->product == CODA_7541) {
 		ret = coda_alloc_context_buf(ctx, &ctx->psbuf,
 					     CODA7_PS_BUF_SIZE, "psbuf");
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev,
-				 "failed to allocate psmem buffer");
+		if (ret < 0)
 			goto err;
-		}
 	}
 
 	if (!ctx->workbuf.vaddr) {
@@ -442,12 +433,8 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 			size += CODA9_PS_SAVE_SIZE;
 		ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size,
 					     "workbuf");
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev,
-				 "failed to allocate %d byte context buffer",
-				 ctx->workbuf.size);
+		if (ret < 0)
 			goto err;
-		}
 	}
 
 	return 0;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 172805b..b42ccfc 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1925,10 +1925,8 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	/* allocate auxiliary per-device code buffer for the BIT processor */
 	ret = coda_alloc_aux_buf(dev, &dev->codebuf, fw->size, "codebuf",
 				 dev->debugfs_root);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to allocate code buffer\n");
+	if (ret < 0)
 		goto put_pm;
-	}
 
 	/* Copy the whole firmware image to the code buffer */
 	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
@@ -2166,20 +2164,16 @@ static int coda_probe(struct platform_device *pdev)
 		ret = coda_alloc_aux_buf(dev, &dev->workbuf,
 					 dev->devtype->workbuf_size, "workbuf",
 					 dev->debugfs_root);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "failed to allocate work buffer\n");
+		if (ret < 0)
 			goto err_v4l2_register;
-		}
 	}
 
 	if (dev->devtype->tempbuf_size) {
 		ret = coda_alloc_aux_buf(dev, &dev->tempbuf,
 					 dev->devtype->tempbuf_size, "tempbuf",
 					 dev->debugfs_root);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "failed to allocate temp buffer\n");
+		if (ret < 0)
 			goto err_v4l2_register;
-		}
 	}
 
 	dev->iram.size = dev->devtype->iram_size;
-- 
2.1.4

