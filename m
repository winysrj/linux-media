Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:24450 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbEFKXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 06:23:30 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v3 2/3] media: atmel-isi: add runtime pm support
Date: Wed, 6 May 2015 18:25:54 +0800
Message-ID: <1430907955-28665-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1430907955-28665-1-git-send-email-josh.wu@atmel.com>
References: <1430907955-28665-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The runtime pm resume/suspend will enable/disable pclk (ISI peripheral
clock).
And we need to call runtime_pm_get_sync()/runtime_pm_put() when we need
access ISI registers.

In the meantime, as clock_start()/clock_stop() is used to control the
mclk not ISI peripheral clock. So move this to start[stop]_streaming()
function.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

Changes in v3: None
Changes in v2:
- merged v1 two patch into one.
- use runtime_pm_put() instead of runtime_pm_put_sync()
- enable peripheral clock before access ISI registers.

 drivers/media/platform/soc_camera/atmel-isi.c | 51 +++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 31254b4..2b05f89 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
 #include <media/atmel-isi.h>
@@ -384,6 +385,8 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct atmel_isi *isi = ici->priv;
 	int ret;
 
+	pm_runtime_get_sync(ici->v4l2_dev.dev);
+
 	/* Reset ISI */
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
 	if (ret < 0) {
@@ -441,6 +444,8 @@ static void stop_streaming(struct vb2_queue *vq)
 	ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
 	if (ret < 0)
 		dev_err(icd->parent, "Disable ISI timed out\n");
+
+	pm_runtime_put(ici->v4l2_dev.dev);
 }
 
 static struct vb2_ops isi_video_qops = {
@@ -509,7 +514,13 @@ static int isi_camera_set_fmt(struct soc_camera_device *icd,
 	if (mf.code != xlate->code)
 		return -EINVAL;
 
+	/* Enable PM and peripheral clock before operate isi registers */
+	pm_runtime_get_sync(ici->v4l2_dev.dev);
+
 	ret = configure_geometry(isi, pix->width, pix->height, xlate->code);
+
+	pm_runtime_put(ici->v4l2_dev.dev);
+
 	if (ret < 0)
 		return ret;
 
@@ -722,14 +733,9 @@ static int isi_camera_clock_start(struct soc_camera_host *ici)
 	struct atmel_isi *isi = ici->priv;
 	int ret;
 
-	ret = clk_prepare_enable(isi->pclk);
-	if (ret)
-		return ret;
-
 	if (!IS_ERR(isi->mck)) {
 		ret = clk_prepare_enable(isi->mck);
 		if (ret) {
-			clk_disable_unprepare(isi->pclk);
 			return ret;
 		}
 	}
@@ -744,7 +750,6 @@ static void isi_camera_clock_stop(struct soc_camera_host *ici)
 
 	if (!IS_ERR(isi->mck))
 		clk_disable_unprepare(isi->mck);
-	clk_disable_unprepare(isi->pclk);
 }
 
 static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
@@ -841,8 +846,13 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
 
 	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
 
+	/* Enable PM and peripheral clock before operate isi registers */
+	pm_runtime_get_sync(ici->v4l2_dev.dev);
+
 	isi_writel(isi, ISI_CFG1, cfg1);
 
+	pm_runtime_put(ici->v4l2_dev.dev);
+
 	return 0;
 }
 
@@ -1039,6 +1049,9 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	soc_host->v4l2_dev.dev	= &pdev->dev;
 	soc_host->nr		= pdev->id;
 
+	pm_suspend_ignore_children(&pdev->dev, true);
+	pm_runtime_enable(&pdev->dev);
+
 	if (isi->pdata.asd_sizes) {
 		soc_host->asd = isi->pdata.asd;
 		soc_host->asd_sizes = isi->pdata.asd_sizes;
@@ -1052,6 +1065,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	return 0;
 
 err_register_soc_camera_host:
+	pm_runtime_disable(&pdev->dev);
 err_req_irq:
 err_ioremap:
 	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
@@ -1064,6 +1078,30 @@ err_alloc_ctx:
 	return ret;
 }
 
+static int atmel_isi_runtime_suspend(struct device *dev)
+{
+	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
+	struct atmel_isi *isi = container_of(soc_host,
+					struct atmel_isi, soc_host);
+
+	clk_disable_unprepare(isi->pclk);
+
+	return 0;
+}
+static int atmel_isi_runtime_resume(struct device *dev)
+{
+	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
+	struct atmel_isi *isi = container_of(soc_host,
+					struct atmel_isi, soc_host);
+
+	return clk_prepare_enable(isi->pclk);
+}
+
+static const struct dev_pm_ops atmel_isi_dev_pm_ops = {
+	SET_RUNTIME_PM_OPS(atmel_isi_runtime_suspend,
+				atmel_isi_runtime_resume, NULL)
+};
+
 static const struct of_device_id atmel_isi_of_match[] = {
 	{ .compatible = "atmel,at91sam9g45-isi" },
 	{ }
@@ -1075,6 +1113,7 @@ static struct platform_driver atmel_isi_driver = {
 	.driver		= {
 		.name = "atmel_isi",
 		.of_match_table = of_match_ptr(atmel_isi_of_match),
+		.pm	= &atmel_isi_dev_pm_ops,
 	},
 };
 
-- 
1.9.1

