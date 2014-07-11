Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51628 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaGKJhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:37:05 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 32/32] [media] coda: store IRAM size in struct coda_devtype
Date: Fri, 11 Jul 2014 11:36:43 +0200
Message-Id: <1405071403-1859-33-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Similarly to workbuf_size and tempbuf_size, store iram_size in the
coda_devtype structure. This also decreases the IRAM used on i.MX6DL
to 128 KiB.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 36ad0e8..7e69eda 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -46,9 +46,6 @@
 
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
-#define CODADX6_IRAM_SIZE	0xb000
-#define CODA7_IRAM_SIZE		0x14000
-#define CODA9_IRAM_SIZE		0x21000
 
 #define CODA7_PS_BUF_SIZE	0x28000
 #define CODA9_PS_SAVE_SIZE	(512 * 1024)
@@ -109,6 +106,7 @@ struct coda_devtype {
 	unsigned int		num_codecs;
 	size_t			workbuf_size;
 	size_t			tempbuf_size;
+	size_t			iram_size;
 };
 
 /* Per-queue, driver-specific private data */
@@ -3680,6 +3678,7 @@ static const struct coda_devtype coda_devdata[] = {
 		.codecs       = codadx6_codecs,
 		.num_codecs   = ARRAY_SIZE(codadx6_codecs),
 		.workbuf_size = 288 * 1024 + FMO_SLICE_SAVE_BUF_SIZE * 8 * 1024,
+		.iram_size    = 0xb000,
 	},
 	[CODA_IMX53] = {
 		.firmware     = "v4l-coda7541-imx53.bin",
@@ -3688,6 +3687,7 @@ static const struct coda_devtype coda_devdata[] = {
 		.num_codecs   = ARRAY_SIZE(coda7_codecs),
 		.workbuf_size = 128 * 1024,
 		.tempbuf_size = 304 * 1024,
+		.iram_size    = 0x14000,
 	},
 	[CODA_IMX6Q] = {
 		.firmware     = "v4l-coda960-imx6q.bin",
@@ -3696,6 +3696,7 @@ static const struct coda_devtype coda_devdata[] = {
 		.num_codecs   = ARRAY_SIZE(coda9_codecs),
 		.workbuf_size = 80 * 1024,
 		.tempbuf_size = 204 * 1024,
+		.iram_size    = 0x21000,
 	},
 	[CODA_IMX6DL] = {
 		.firmware     = "v4l-coda960-imx6dl.bin",
@@ -3704,6 +3705,7 @@ static const struct coda_devtype coda_devdata[] = {
 		.num_codecs   = ARRAY_SIZE(coda9_codecs),
 		.workbuf_size = 80 * 1024,
 		.tempbuf_size = 204 * 1024,
+		.iram_size    = 0x20000,
 	},
 };
 
@@ -3845,16 +3847,7 @@ static int coda_probe(struct platform_device *pdev)
 		}
 	}
 
-	switch (dev->devtype->product) {
-	case CODA_DX6:
-		dev->iram.size = CODADX6_IRAM_SIZE;
-		break;
-	case CODA_7541:
-		dev->iram.size = CODA7_IRAM_SIZE;
-		break;
-	case CODA_960:
-		dev->iram.size = CODA9_IRAM_SIZE;
-	}
+	dev->iram.size = dev->devtype->iram_size;
 	dev->iram.vaddr = gen_pool_dma_alloc(dev->iram_pool, dev->iram.size,
 					     &dev->iram.paddr);
 	if (!dev->iram.vaddr) {
-- 
2.0.0

