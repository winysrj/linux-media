Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57515 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992475AbcBSJTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 04:19:11 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: add support for firmware files named as distributed by NXP
Date: Fri, 19 Feb 2016 10:18:57 +0100
Message-Id: <1455873537-1173-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Try loading the firmware from firmware files named vpu_fw_imx*.bin, as
they are originally distributed by NXP. Fall back to v4l-coda*-imx6*.bin.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 61 +++++++++++++++++++++++--------
 drivers/media/platform/coda/coda.h        |  3 +-
 2 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 0bc544d..fe884c1 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1982,16 +1982,44 @@ static void coda_copy_firmware(struct coda_dev *dev, const u8 * const buf,
 	}
 }
 
+static void coda_fw_callback(const struct firmware *fw, void *context);
+
+static int coda_firmware_request(struct coda_dev *dev)
+{
+	char *fw = dev->devtype->firmware[dev->firmware];
+
+	dev_dbg(&dev->plat_dev->dev, "requesting firmware '%s' for %s\n", fw,
+		coda_product_name(dev->devtype->product));
+
+	return request_firmware_nowait(THIS_MODULE, true, fw,
+				       &dev->plat_dev->dev, GFP_KERNEL, dev,
+				       coda_fw_callback);
+}
+
 static void coda_fw_callback(const struct firmware *fw, void *context)
 {
 	struct coda_dev *dev = context;
 	struct platform_device *pdev = dev->plat_dev;
 	int i, ret;
 
-	if (!fw) {
+	if (!fw && dev->firmware == 1) {
 		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
 		goto put_pm;
 	}
+	if (!fw) {
+		dev->firmware = 1;
+		coda_firmware_request(dev);
+		return;
+	}
+	if (dev->firmware == 1) {
+		/*
+		 * Since we can't suppress warnings for failed asynchronous
+		 * firmware requests, report that the fallback firmware was
+		 * found.
+		 */
+		dev_info(&pdev->dev, "Using fallback firmware %s\n",
+			 dev->devtype->firmware[dev->firmware]);
+	}
 
 	/* allocate auxiliary per-device code buffer for the BIT processor */
 	ret = coda_alloc_aux_buf(dev, &dev->codebuf, fw->size, "codebuf",
@@ -2050,17 +2078,6 @@ put_pm:
 	pm_runtime_put_sync(&pdev->dev);
 }
 
-static int coda_firmware_request(struct coda_dev *dev)
-{
-	char *fw = dev->devtype->firmware;
-
-	dev_dbg(&dev->plat_dev->dev, "requesting firmware '%s' for %s\n", fw,
-		coda_product_name(dev->devtype->product));
-
-	return request_firmware_nowait(THIS_MODULE, true,
-		fw, &dev->plat_dev->dev, GFP_KERNEL, dev, coda_fw_callback);
-}
-
 enum coda_platform {
 	CODA_IMX27,
 	CODA_IMX53,
@@ -2070,7 +2087,10 @@ enum coda_platform {
 
 static const struct coda_devtype coda_devdata[] = {
 	[CODA_IMX27] = {
-		.firmware     = "v4l-codadx6-imx27.bin",
+		.firmware     = {
+			"vpu_fw_imx27_TO2.bin",
+			"v4l-codadx6-imx27.bin"
+		},
 		.product      = CODA_DX6,
 		.codecs       = codadx6_codecs,
 		.num_codecs   = ARRAY_SIZE(codadx6_codecs),
@@ -2080,7 +2100,10 @@ static const struct coda_devtype coda_devdata[] = {
 		.iram_size    = 0xb000,
 	},
 	[CODA_IMX53] = {
-		.firmware     = "v4l-coda7541-imx53.bin",
+		.firmware     = {
+			"vpu_fw_imx53.bin",
+			"v4l-coda7541-imx53.bin"
+		},
 		.product      = CODA_7541,
 		.codecs       = coda7_codecs,
 		.num_codecs   = ARRAY_SIZE(coda7_codecs),
@@ -2091,7 +2114,10 @@ static const struct coda_devtype coda_devdata[] = {
 		.iram_size    = 0x14000,
 	},
 	[CODA_IMX6Q] = {
-		.firmware     = "v4l-coda960-imx6q.bin",
+		.firmware     = {
+			"vpu_fw_imx6q.bin",
+			"v4l-coda960-imx6q.bin"
+		},
 		.product      = CODA_960,
 		.codecs       = coda9_codecs,
 		.num_codecs   = ARRAY_SIZE(coda9_codecs),
@@ -2102,7 +2128,10 @@ static const struct coda_devtype coda_devdata[] = {
 		.iram_size    = 0x21000,
 	},
 	[CODA_IMX6DL] = {
-		.firmware     = "v4l-coda960-imx6dl.bin",
+		.firmware     = {
+			"vpu_fw_imx6d.bin",
+			"v4l-coda960-imx6dl.bin"
+		},
 		.product      = CODA_960,
 		.codecs       = coda9_codecs,
 		.num_codecs   = ARRAY_SIZE(coda9_codecs),
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index d08e984..8f2c71e 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -50,7 +50,7 @@ enum coda_product {
 struct coda_video_device;
 
 struct coda_devtype {
-	char			*firmware;
+	char			*firmware[2];
 	enum coda_product	product;
 	const struct coda_codec	*codecs;
 	unsigned int		num_codecs;
@@ -74,6 +74,7 @@ struct coda_dev {
 	struct video_device	vfd[5];
 	struct platform_device	*plat_dev;
 	const struct coda_devtype *devtype;
+	int			firmware;
 
 	void __iomem		*regs_base;
 	struct clk		*clk_per;
-- 
2.7.0

