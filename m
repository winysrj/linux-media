Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42828 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaIVQGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 12:06:03 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2] [media] coda: Improve runtime PM support
Date: Mon, 22 Sep 2014 18:05:56 +0200
Message-Id: <1411401956-29330-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulf Hansson <ulf.hansson@linaro.org>

For several reasons it's good practice to leave devices in runtime PM
active state while those have been probed.

In this cases we also want to prevent the device from going inactive,
until the firmware has been completely installed, especially when using
a PM domain.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

---
Changes since v1:
 - Deactivate PM domain on error
 - Added a comment to runtime PM setup
---
 drivers/media/platform/coda/coda-common.c | 55 ++++++++++++-------------------
 1 file changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 0997b5c..ced4760 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1688,7 +1688,7 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 
 	if (!fw) {
 		v4l2_err(&dev->v4l2_dev, "firmware request failed\n");
-		return;
+		goto put_pm;
 	}
 
 	/* allocate auxiliary per-device code buffer for the BIT processor */
@@ -1696,50 +1696,27 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 				 dev->debugfs_root);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to allocate code buffer\n");
-		return;
+		goto put_pm;
 	}
 
 	/* Copy the whole firmware image to the code buffer */
 	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
 	release_firmware(fw);
 
-	if (pm_runtime_enabled(&pdev->dev) && pdev->dev.pm_domain) {
-		/*
-		 * Enabling power temporarily will cause coda_hw_init to be
-		 * called via coda_runtime_resume by the pm domain.
-		 */
-		ret = pm_runtime_get_sync(&dev->plat_dev->dev);
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev, "failed to power on: %d\n",
-				 ret);
-			return;
-		}
-
-		ret = coda_check_firmware(dev);
-		if (ret < 0)
-			return;
-
-		pm_runtime_put_sync(&dev->plat_dev->dev);
-	} else {
-		/*
-		 * If runtime pm is disabled or pm_domain is not set,
-		 * initialize once manually.
-		 */
-		ret = coda_hw_init(dev);
-		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
-			return;
-		}
-
-		ret = coda_check_firmware(dev);
-		if (ret < 0)
-			return;
+	ret = coda_hw_init(dev);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
+		goto put_pm;
 	}
 
+	ret = coda_check_firmware(dev);
+	if (ret < 0)
+		goto put_pm;
+
 	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 	if (IS_ERR(dev->alloc_ctx)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
-		return;
+		goto put_pm;
 	}
 
 	dev->m2m_dev = v4l2_m2m_init(&coda_m2m_ops);
@@ -1771,12 +1748,15 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	v4l2_info(&dev->v4l2_dev, "codec registered as /dev/video[%d-%d]\n",
 		  dev->vfd[0].num, dev->vfd[1].num);
 
+	pm_runtime_put_sync(&pdev->dev);
 	return;
 
 rel_m2m:
 	v4l2_m2m_release(dev->m2m_dev);
 rel_ctx:
 	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+put_pm:
+	pm_runtime_put_sync(&pdev->dev);
 }
 
 static int coda_firmware_request(struct coda_dev *dev)
@@ -1998,6 +1978,13 @@ static int coda_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev);
 
+	/*
+	 * Start activated so we can directly call coda_hw_init in
+	 * coda_fw_callback regardless of whether CONFIG_PM_RUNTIME is
+	 * enabled or whether the device is associated with a PM domain.
+	 */
+	pm_runtime_get_noresume(&pdev->dev);
+	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
 	return coda_firmware_request(dev);
-- 
2.1.0

