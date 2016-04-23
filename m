Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35898 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbcDWXts (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 19:49:48 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 03/13] v4l: vsp1: Implement runtime PM support
Date: Sun, 24 Apr 2016 02:49:50 +0300
Message-Id: <1461455400-28767-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the manual refcount and clock management code by runtime PM.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/Kconfig          |   1 +
 drivers/media/platform/vsp1/vsp1.h      |   3 -
 drivers/media/platform/vsp1/vsp1_drv.c  | 101 ++++++++++++++++----------------
 drivers/media/platform/vsp1/vsp1_pipe.c |   2 +-
 4 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f453910050be..28d0db102c0b 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -264,6 +264,7 @@ config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
+	depends on PM
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 46738b6c5f72..9e09bce43cf3 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -64,9 +64,6 @@ struct vsp1_device {
 	void __iomem *mmio;
 	struct clk *clock;
 
-	struct mutex lock;
-	int ref_count;
-
 	struct vsp1_bru *bru;
 	struct vsp1_hsit *hsi;
 	struct vsp1_hsit *hst;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index e2d779fac0eb..d6abc7f1216a 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -19,6 +19,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/videodev2.h>
 
 #include <media/v4l2-subdev.h>
@@ -462,35 +463,16 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 /*
  * vsp1_device_get - Acquire the VSP1 device
  *
- * Increment the VSP1 reference count and initialize the device if the first
- * reference is taken.
+ * Make sure the device is not suspended and initialize it if needed.
  *
  * Return 0 on success or a negative error code otherwise.
  */
 int vsp1_device_get(struct vsp1_device *vsp1)
 {
-	int ret = 0;
-
-	mutex_lock(&vsp1->lock);
-	if (vsp1->ref_count > 0)
-		goto done;
-
-	ret = clk_prepare_enable(vsp1->clock);
-	if (ret < 0)
-		goto done;
-
-	ret = vsp1_device_init(vsp1);
-	if (ret < 0) {
-		clk_disable_unprepare(vsp1->clock);
-		goto done;
-	}
-
-done:
-	if (!ret)
-		vsp1->ref_count++;
+	int ret;
 
-	mutex_unlock(&vsp1->lock);
-	return ret;
+	ret = pm_runtime_get_sync(vsp1->dev);
+	return ret < 0 ? ret : 0;
 }
 
 /*
@@ -501,12 +483,7 @@ done:
  */
 void vsp1_device_put(struct vsp1_device *vsp1)
 {
-	mutex_lock(&vsp1->lock);
-
-	if (--vsp1->ref_count == 0)
-		clk_disable_unprepare(vsp1->clock);
-
-	mutex_unlock(&vsp1->lock);
+	pm_runtime_put_sync(vsp1->dev);
 }
 
 /* -----------------------------------------------------------------------------
@@ -518,37 +495,55 @@ static int vsp1_pm_suspend(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 
-	WARN_ON(mutex_is_locked(&vsp1->lock));
+	vsp1_pipelines_suspend(vsp1);
+	pm_runtime_force_suspend(vsp1->dev);
 
-	if (vsp1->ref_count == 0)
-		return 0;
+	return 0;
+}
 
-	vsp1_pipelines_suspend(vsp1);
+static int vsp1_pm_resume(struct device *dev)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(vsp1->clock);
+	pm_runtime_force_resume(vsp1->dev);
+	vsp1_pipelines_resume(vsp1);
 
 	return 0;
 }
+#endif
 
-static int vsp1_pm_resume(struct device *dev)
+static int vsp1_pm_runtime_suspend(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 
-	WARN_ON(mutex_is_locked(&vsp1->lock));
+	clk_disable_unprepare(vsp1->clock);
 
-	if (vsp1->ref_count == 0)
-		return 0;
+	return 0;
+}
 
-	clk_prepare_enable(vsp1->clock);
+static int vsp1_pm_runtime_resume(struct device *dev)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+	int ret;
 
-	vsp1_pipelines_resume(vsp1);
+	ret = clk_prepare_enable(vsp1->clock);
+	if (ret < 0)
+		return ret;
+
+	if (vsp1->info) {
+		ret = vsp1_device_init(vsp1);
+		if (ret < 0) {
+			clk_disable_unprepare(vsp1->clock);
+			return ret;
+		}
+	}
 
 	return 0;
 }
-#endif
 
 static const struct dev_pm_ops vsp1_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(vsp1_pm_suspend, vsp1_pm_resume)
+	SET_RUNTIME_PM_OPS(vsp1_pm_runtime_suspend, vsp1_pm_runtime_resume, NULL)
 };
 
 /* -----------------------------------------------------------------------------
@@ -640,10 +635,11 @@ static int vsp1_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	vsp1->dev = &pdev->dev;
-	mutex_init(&vsp1->lock);
 	INIT_LIST_HEAD(&vsp1->entities);
 	INIT_LIST_HEAD(&vsp1->videos);
 
+	platform_set_drvdata(pdev, vsp1);
+
 	/* I/O, IRQ and clock resources */
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
@@ -670,12 +666,14 @@ static int vsp1_probe(struct platform_device *pdev)
 	}
 
 	/* Configure device parameters based on the version register. */
-	ret = clk_prepare_enable(vsp1->clock);
+	pm_runtime_enable(&pdev->dev);
+
+	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
-		return ret;
+		goto done;
 
 	version = vsp1_read(vsp1, VI6_IP_VERSION);
-	clk_disable_unprepare(vsp1->clock);
+	pm_runtime_put_sync(&pdev->dev);
 
 	for (i = 0; i < ARRAY_SIZE(vsp1_device_infos); ++i) {
 		if ((version & VI6_IP_VERSION_MODEL_MASK) ==
@@ -687,7 +685,8 @@ static int vsp1_probe(struct platform_device *pdev)
 
 	if (!vsp1->info) {
 		dev_err(&pdev->dev, "unsupported IP version 0x%08x\n", version);
-		return -ENXIO;
+		ret = -ENXIO;
+		goto done;
 	}
 
 	dev_dbg(&pdev->dev, "IP version 0x%08x\n", version);
@@ -696,12 +695,14 @@ static int vsp1_probe(struct platform_device *pdev)
 	ret = vsp1_create_entities(vsp1);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to create entities\n");
-		return ret;
+		goto done;
 	}
 
-	platform_set_drvdata(pdev, vsp1);
+done:
+	if (ret)
+		pm_runtime_disable(&pdev->dev);
 
-	return 0;
+	return ret;
 }
 
 static int vsp1_remove(struct platform_device *pdev)
@@ -710,6 +711,8 @@ static int vsp1_remove(struct platform_device *pdev)
 
 	vsp1_destroy_entities(vsp1);
 
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 4f3b4a1d028a..0c1dc80eb304 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -383,7 +383,7 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
 {
 	unsigned int i;
 
-	/* Resume pipeline all running pipelines. */
+	/* Resume all running pipelines. */
 	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
 		struct vsp1_pipeline *pipe;
-- 
2.7.3

