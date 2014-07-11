Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51614 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaGKJhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:37:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 30/32] [media] coda: store per-context work buffer size in struct coda_devtype
Date: Fri, 11 Jul 2014 11:36:41 +0200
Message-Id: <1405071403-1859-31-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We had the workbuf_size field since the beginning.
Use it to tighten the code a little bit.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 58 +++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 1c2482a..79e76b8 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -44,10 +44,6 @@
 
 #define CODADX6_MAX_INSTANCES	4
 
-#define CODA_FMO_BUF_SIZE	32
-#define CODADX6_WORK_BUF_SIZE	(288 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
-#define CODA7_WORK_BUF_SIZE	(128 * 1024)
-#define CODA9_WORK_BUF_SIZE	(80 * 1024)
 #define CODA7_TEMP_BUF_SIZE	(304 * 1024)
 #define CODA9_TEMP_BUF_SIZE	(204 * 1024)
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
@@ -1984,18 +1980,8 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 	size_t size;
 	int ret;
 
-	switch (dev->devtype->product) {
-	case CODA_7541:
-		size = CODA7_WORK_BUF_SIZE;
-		break;
-	case CODA_960:
-		size = CODA9_WORK_BUF_SIZE;
-		if (q_data->fourcc == V4L2_PIX_FMT_H264)
-			size += CODA9_PS_SAVE_SIZE;
-		break;
-	default:
+	if (dev->devtype->product == CODA_DX6)
 		return 0;
-	}
 
 	if (ctx->psbuf.vaddr) {
 		v4l2_err(&dev->v4l2_dev, "psmembuf still allocated\n");
@@ -2031,6 +2017,10 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 		}
 	}
 
+	size = dev->devtype->workbuf_size;
+	if (dev->devtype->product == CODA_960 &&
+	    q_data->fourcc == V4L2_PIX_FMT_H264)
+		size += CODA9_PS_SAVE_SIZE;
 	ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size, "workbuf");
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate %d byte context buffer",
@@ -3686,28 +3676,32 @@ enum coda_platform {
 
 static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX27] = {
-		.firmware   = "v4l-codadx6-imx27.bin",
-		.product    = CODA_DX6,
-		.codecs     = codadx6_codecs,
-		.num_codecs = ARRAY_SIZE(codadx6_codecs),
+		.firmware     = "v4l-codadx6-imx27.bin",
+		.product      = CODA_DX6,
+		.codecs       = codadx6_codecs,
+		.num_codecs   = ARRAY_SIZE(codadx6_codecs),
+		.workbuf_size = 288 * 1024 + FMO_SLICE_SAVE_BUF_SIZE * 8 * 1024,
 	},
 	[CODA_IMX53] = {
-		.firmware   = "v4l-coda7541-imx53.bin",
-		.product    = CODA_7541,
-		.codecs     = coda7_codecs,
-		.num_codecs = ARRAY_SIZE(coda7_codecs),
+		.firmware     = "v4l-coda7541-imx53.bin",
+		.product      = CODA_7541,
+		.codecs       = coda7_codecs,
+		.num_codecs   = ARRAY_SIZE(coda7_codecs),
+		.workbuf_size = 128 * 1024,
 	},
 	[CODA_IMX6Q] = {
-		.firmware   = "v4l-coda960-imx6q.bin",
-		.product    = CODA_960,
-		.codecs     = coda9_codecs,
-		.num_codecs = ARRAY_SIZE(coda9_codecs),
+		.firmware     = "v4l-coda960-imx6q.bin",
+		.product      = CODA_960,
+		.codecs       = coda9_codecs,
+		.num_codecs   = ARRAY_SIZE(coda9_codecs),
+		.workbuf_size = 80 * 1024,
 	},
 	[CODA_IMX6DL] = {
-		.firmware   = "v4l-coda960-imx6dl.bin",
-		.product    = CODA_960,
-		.codecs     = coda9_codecs,
-		.num_codecs = ARRAY_SIZE(coda9_codecs),
+		.firmware     = "v4l-coda960-imx6dl.bin",
+		.product      = CODA_960,
+		.codecs       = coda9_codecs,
+		.num_codecs   = ARRAY_SIZE(coda9_codecs),
+		.workbuf_size = 80 * 1024,
 	},
 };
 
@@ -3830,7 +3824,7 @@ static int coda_probe(struct platform_device *pdev)
 	switch (dev->devtype->product) {
 	case CODA_DX6:
 		ret = coda_alloc_aux_buf(dev, &dev->workbuf,
-					 CODADX6_WORK_BUF_SIZE, "workbuf",
+					 dev->devtype->workbuf_size, "workbuf",
 					 dev->debugfs_root);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to allocate work buffer\n");
-- 
2.0.0

