Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57617 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaFXO40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 12/29] [media] coda: Add runtime pm support
Date: Tue, 24 Jun 2014 16:55:54 +0200
Message-Id: <1403621771-11636-13-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows to use the runtime pm and generic pm domain frameworks
to completely gate power to the VPU if it is unused. This functionality
is available on i.MX6.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Use pm_runtime_enabled()
---
 drivers/media/platform/coda.c | 65 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 0a0b1ed..bd243ed 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/of.h>
@@ -2766,6 +2767,13 @@ static int coda_open(struct file *file)
 		ctx->reg_idx = idx;
 	}
 
+	/* Power up and upload firmware if necessary */
+	ret = pm_runtime_get_sync(&dev->plat_dev->dev);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "failed to power up: %d\n", ret);
+		goto err_pm_get;
+	}
+
 	ret = clk_prepare_enable(dev->clk_per);
 	if (ret)
 		goto err_clk_per;
@@ -2835,6 +2843,8 @@ err_ctx_init:
 err_clk_ahb:
 	clk_disable_unprepare(dev->clk_per);
 err_clk_per:
+	pm_runtime_put_sync(&dev->plat_dev->dev);
+err_pm_get:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
@@ -2876,6 +2886,7 @@ static int coda_release(struct file *file)
 	v4l2_ctrl_handler_free(&ctx->ctrls);
 	clk_disable_unprepare(dev->clk_ahb);
 	clk_disable_unprepare(dev->clk_per);
+	pm_runtime_put_sync(&dev->plat_dev->dev);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
@@ -3190,7 +3201,7 @@ static int coda_hw_init(struct coda_dev *dev)
 
 	ret = clk_prepare_enable(dev->clk_per);
 	if (ret)
-		return ret;
+		goto err_clk_per;
 
 	ret = clk_prepare_enable(dev->clk_ahb);
 	if (ret)
@@ -3316,6 +3327,7 @@ static int coda_hw_init(struct coda_dev *dev)
 
 err_clk_ahb:
 	clk_disable_unprepare(dev->clk_per);
+err_clk_per:
 	return ret;
 }
 
@@ -3341,10 +3353,29 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
 	release_firmware(fw);
 
-	ret = coda_hw_init(dev);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
-		return;
+	if (pm_runtime_enabled(&pdev->dev) && pdev->dev.pm_domain) {
+		/*
+		 * Enabling power temporarily will cause coda_hw_init to be
+		 * called via coda_runtime_resume by the pm domain.
+		 */
+		ret = pm_runtime_get_sync(&dev->plat_dev->dev);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev, "failed to power on: %d\n",
+				 ret);
+			return;
+		}
+
+		pm_runtime_put_sync(&dev->plat_dev->dev);
+	} else {
+		/*
+		 * If runtime pm is disabled or pm_domain is not set,
+		 * initialize once manually.
+		 */
+		ret = coda_hw_init(dev);
+		if (ret < 0) {
+			v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
+			return;
+		}
 	}
 
 	dev->vfd.fops	= &coda_fops,
@@ -3582,6 +3613,8 @@ static int coda_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev);
 
+	pm_runtime_enable(&pdev->dev);
+
 	return coda_firmware_request(dev);
 }
 
@@ -3592,6 +3625,7 @@ static int coda_remove(struct platform_device *pdev)
 	video_unregister_device(&dev->vfd);
 	if (dev->m2m_dev)
 		v4l2_m2m_release(dev->m2m_dev);
+	pm_runtime_disable(&pdev->dev);
 	if (dev->alloc_ctx)
 		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(&dev->v4l2_dev);
@@ -3605,6 +3639,26 @@ static int coda_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+static int coda_runtime_resume(struct device *dev)
+{
+	struct coda_dev *cdev = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (dev->pm_domain) {
+		ret = coda_hw_init(cdev);
+		if (ret)
+			v4l2_err(&cdev->v4l2_dev, "HW initialization failed\n");
+	}
+
+	return ret;
+}
+#endif
+
+static const struct dev_pm_ops coda_pm_ops = {
+	SET_RUNTIME_PM_OPS(NULL, coda_runtime_resume, NULL)
+};
+
 static struct platform_driver coda_driver = {
 	.probe	= coda_probe,
 	.remove	= coda_remove,
@@ -3612,6 +3666,7 @@ static struct platform_driver coda_driver = {
 		.name	= CODA_NAME,
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(coda_dt_ids),
+		.pm	= &coda_pm_ops,
 	},
 	.id_table = coda_platform_ids,
 };
-- 
2.0.0

