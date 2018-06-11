Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1594 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932109AbeFKJeC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:34:02 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH] media: stm32-dcmi: add power saving support
Date: Mon, 11 Jun 2018 11:33:17 +0200
Message-ID: <1528709597-7734-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implements runtime & system sleep power management ops.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 80 ++++++++++++++++++++++++-------
 1 file changed, 64 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 2e1933d..68da9ec 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -22,6 +22,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/reset.h>
 #include <linux/videodev2.h>
@@ -578,9 +579,9 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	u32 val = 0;
 	int ret;
 
-	ret = clk_enable(dcmi->mclk);
+	ret = pm_runtime_get_sync(dcmi->dev);
 	if (ret) {
-		dev_err(dcmi->dev, "%s: Failed to start streaming, cannot enable clock\n",
+		dev_err(dcmi->dev, "%s: Failed to start streaming, cannot get sync\n",
 			__func__);
 		goto err_release_buffers;
 	}
@@ -590,7 +591,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret && ret != -ENOIOCTLCMD) {
 		dev_err(dcmi->dev, "%s: Failed to start streaming, subdev streamon error",
 			__func__);
-		goto err_disable_clock;
+		goto err_pm_put;
 	}
 
 	spin_lock_irq(&dcmi->irqlock);
@@ -675,8 +676,8 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 err_subdev_streamoff:
 	v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 0);
 
-err_disable_clock:
-	clk_disable(dcmi->mclk);
+err_pm_put:
+	pm_runtime_put(dcmi->dev);
 
 err_release_buffers:
 	spin_lock_irq(&dcmi->irqlock);
@@ -749,7 +750,7 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 	/* Stop all pending DMA operations */
 	dmaengine_terminate_all(dcmi->dma_chan);
 
-	clk_disable(dcmi->mclk);
+	pm_runtime_put(dcmi->dev);
 
 	if (dcmi->errors_count)
 		dev_warn(dcmi->dev, "Some errors found while streaming: errors=%d (overrun=%d), buffers=%d\n",
@@ -1751,12 +1752,6 @@ static int dcmi_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 	}
 
-	ret = clk_prepare(mclk);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to prepare mclk %p\n", mclk);
-		goto err_dma_release;
-	}
-
 	spin_lock_init(&dcmi->irqlock);
 	mutex_init(&dcmi->lock);
 	init_completion(&dcmi->complete);
@@ -1772,7 +1767,7 @@ static int dcmi_probe(struct platform_device *pdev)
 	/* Initialize the top-level structure */
 	ret = v4l2_device_register(&pdev->dev, &dcmi->v4l2_dev);
 	if (ret)
-		goto err_clk_unprepare;
+		goto err_dma_release;
 
 	dcmi->vdev = video_device_alloc();
 	if (!dcmi->vdev) {
@@ -1832,14 +1827,15 @@ static int dcmi_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "Probe done\n");
 
 	platform_set_drvdata(pdev, dcmi);
+
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
 err_device_release:
 	video_device_release(dcmi->vdev);
 err_device_unregister:
 	v4l2_device_unregister(&dcmi->v4l2_dev);
-err_clk_unprepare:
-	clk_unprepare(dcmi->mclk);
 err_dma_release:
 	dma_release_channel(dcmi->dma_chan);
 
@@ -1850,20 +1846,72 @@ static int dcmi_remove(struct platform_device *pdev)
 {
 	struct stm32_dcmi *dcmi = platform_get_drvdata(pdev);
 
+	pm_runtime_disable(&pdev->dev);
+
 	v4l2_async_notifier_unregister(&dcmi->notifier);
 	v4l2_device_unregister(&dcmi->v4l2_dev);
-	clk_unprepare(dcmi->mclk);
+
 	dma_release_channel(dcmi->dma_chan);
 
 	return 0;
 }
 
+static __maybe_unused int dcmi_runtime_suspend(struct device *dev)
+{
+	struct stm32_dcmi *dcmi = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(dcmi->mclk);
+
+	return 0;
+}
+
+static __maybe_unused int dcmi_runtime_resume(struct device *dev)
+{
+	struct stm32_dcmi *dcmi = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(dcmi->mclk);
+	if (ret)
+		dev_err(dev, "%s: Failed to prepare_enable clock\n", __func__);
+
+	return ret;
+}
+
+static __maybe_unused int dcmi_suspend(struct device *dev)
+{
+	/* disable clock */
+	pm_runtime_force_suspend(dev);
+
+	/* change pinctrl state */
+	pinctrl_pm_select_sleep_state(dev);
+
+	return 0;
+}
+
+static __maybe_unused int dcmi_resume(struct device *dev)
+{
+	/* restore pinctl default state */
+	pinctrl_pm_select_default_state(dev);
+
+	/* clock enable */
+	pm_runtime_force_resume(dev);
+
+	return 0;
+}
+
+static const struct dev_pm_ops dcmi_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dcmi_suspend, dcmi_resume)
+	SET_RUNTIME_PM_OPS(dcmi_runtime_suspend,
+			   dcmi_runtime_resume, NULL)
+};
+
 static struct platform_driver stm32_dcmi_driver = {
 	.probe		= dcmi_probe,
 	.remove		= dcmi_remove,
 	.driver		= {
 		.name = DRV_NAME,
 		.of_match_table = of_match_ptr(stm32_dcmi_of_match),
+		.pm = &dcmi_pm_ops,
 	},
 };
 
-- 
1.9.1
