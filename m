Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51615 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaGKJhE (ORCPT
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
Subject: [PATCH v3 31/32] [media] coda: store global temporary buffer size in struct coda_devtype
Date: Fri, 11 Jul 2014 11:36:42 +0200
Message-Id: <1405071403-1859-32-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Similarly to the work buffer size, store the temporary buffer size in the
coda_devtype structure.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 79e76b8..36ad0e8 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -44,8 +44,6 @@
 
 #define CODADX6_MAX_INSTANCES	4
 
-#define CODA7_TEMP_BUF_SIZE	(304 * 1024)
-#define CODA9_TEMP_BUF_SIZE	(204 * 1024)
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
 #define CODADX6_IRAM_SIZE	0xb000
@@ -110,6 +108,7 @@ struct coda_devtype {
 	struct coda_codec	*codecs;
 	unsigned int		num_codecs;
 	size_t			workbuf_size;
+	size_t			tempbuf_size;
 };
 
 /* Per-queue, driver-specific private data */
@@ -3688,6 +3687,7 @@ static const struct coda_devtype coda_devdata[] = {
 		.codecs       = coda7_codecs,
 		.num_codecs   = ARRAY_SIZE(coda7_codecs),
 		.workbuf_size = 128 * 1024,
+		.tempbuf_size = 304 * 1024,
 	},
 	[CODA_IMX6Q] = {
 		.firmware     = "v4l-coda960-imx6q.bin",
@@ -3695,6 +3695,7 @@ static const struct coda_devtype coda_devdata[] = {
 		.codecs       = coda9_codecs,
 		.num_codecs   = ARRAY_SIZE(coda9_codecs),
 		.workbuf_size = 80 * 1024,
+		.tempbuf_size = 204 * 1024,
 	},
 	[CODA_IMX6DL] = {
 		.firmware     = "v4l-coda960-imx6dl.bin",
@@ -3702,6 +3703,7 @@ static const struct coda_devtype coda_devdata[] = {
 		.codecs       = coda9_codecs,
 		.num_codecs   = ARRAY_SIZE(coda9_codecs),
 		.workbuf_size = 80 * 1024,
+		.tempbuf_size = 204 * 1024,
 	},
 };
 
@@ -3821,8 +3823,7 @@ static int coda_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "failed to create debugfs root\n");
 
 	/* allocate auxiliary per-device buffers for the BIT processor */
-	switch (dev->devtype->product) {
-	case CODA_DX6:
+	if (dev->devtype->product == CODA_DX6) {
 		ret = coda_alloc_aux_buf(dev, &dev->workbuf,
 					 dev->devtype->workbuf_size, "workbuf",
 					 dev->debugfs_root);
@@ -3831,17 +3832,11 @@ static int coda_probe(struct platform_device *pdev)
 			v4l2_device_unregister(&dev->v4l2_dev);
 			return ret;
 		}
-		break;
-	case CODA_7541:
-		dev->tempbuf.size = CODA7_TEMP_BUF_SIZE;
-		break;
-	case CODA_960:
-		dev->tempbuf.size = CODA9_TEMP_BUF_SIZE;
-		break;
 	}
-	if (dev->tempbuf.size) {
+
+	if (dev->devtype->tempbuf_size) {
 		ret = coda_alloc_aux_buf(dev, &dev->tempbuf,
-					 dev->tempbuf.size, "tempbuf",
+					 dev->devtype->tempbuf_size, "tempbuf",
 					 dev->debugfs_root);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to allocate temp buffer\n");
-- 
2.0.0

