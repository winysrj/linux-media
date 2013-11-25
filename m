Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39641 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3KYJ6x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:58:53 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT003M8D245C40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:58:52 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 06/16] s5p-jpeg: Fix clock resource management
Date: Mon, 25 Nov 2013 10:58:13 +0100
Message-id: <1385373503-1657-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Standard suspend/resume path is called after runtime resume
of the given device, so suspend/resume callbacks must do all
clock management done also by runtime pm to allow for proper
power domain shutdown. Moreover, JPEG clock is enabled from
probe function but is is not necessary. This patch also moves
control of jpeg clock to runtime_pm callbacks.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   35 +++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 32033e7..583fcdd 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1272,7 +1272,6 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		return ret;
 	}
 	dev_dbg(&pdev->dev, "clock source %p\n", jpeg->clk);
-	clk_prepare_enable(jpeg->clk);
 
 	/* v4l2 device */
 	ret = v4l2_device_register(&pdev->dev, &jpeg->v4l2_dev);
@@ -1380,7 +1379,6 @@ device_register_rollback:
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
 clk_get_rollback:
-	clk_disable_unprepare(jpeg->clk);
 	clk_put(jpeg->clk);
 
 	return ret;
@@ -1400,7 +1398,9 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 	v4l2_m2m_release(jpeg->m2m_dev);
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
-	clk_disable_unprepare(jpeg->clk);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		clk_disable_unprepare(jpeg->clk);
+
 	clk_put(jpeg->clk);
 
 	return 0;
@@ -1408,12 +1408,21 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
 
 static int s5p_jpeg_runtime_suspend(struct device *dev)
 {
+	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(jpeg->clk);
+
 	return 0;
 }
 
 static int s5p_jpeg_runtime_resume(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(jpeg->clk);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * JPEG IP allows storing two Huffman tables for each component
@@ -1427,9 +1436,25 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 	return 0;
 }
 
+static int s5p_jpeg_suspend(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return s5p_jpeg_runtime_suspend(dev);
+}
+
+static int s5p_jpeg_resume(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return s5p_jpeg_runtime_resume(dev);
+}
+
 static const struct dev_pm_ops s5p_jpeg_pm_ops = {
-	.runtime_suspend = s5p_jpeg_runtime_suspend,
-	.runtime_resume	 = s5p_jpeg_runtime_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(s5p_jpeg_suspend, s5p_jpeg_resume)
+	SET_RUNTIME_PM_OPS(s5p_jpeg_runtime_suspend, s5p_jpeg_runtime_resume, NULL)
 };
 
 #ifdef CONFIG_OF
-- 
1.7.9.5

