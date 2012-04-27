Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14705 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760015Ab2D0JxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:22 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M34009Q9U4QCI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3400JZJU4R62@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:20 +0100 (BST)
Date: Fri, 27 Apr 2012 11:53:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 09/13] s5p-fimc: Make sure the interrupt is properly requested
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-10-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use dev_name() for requesting an interrupt so we don't get an interrupt
requested with same name for multiple device instances.

While at it, tidy up the driver data handling.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    9 +++------
 drivers/media/video/s5p-fimc/fimc-core.h |    2 ++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 2da6638..f67c3b6 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -792,15 +792,12 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
 
 static int fimc_probe(struct platform_device *pdev)
 {
+	struct fimc_drvdata *drv_data = fimc_get_drvdata(pdev);
+	struct s5p_platform_fimc *pdata;
 	struct fimc_dev *fimc;
 	struct resource *res;
-	struct fimc_drvdata *drv_data;
-	struct s5p_platform_fimc *pdata;
 	int ret = 0;
 
-	drv_data = (struct fimc_drvdata *)
-		platform_get_device_id(pdev)->driver_data;
-
 	if (pdev->id >= ARRAY_SIZE(drv_data->variant)) {
 		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
 			pdev->id);
@@ -844,7 +841,7 @@ static int fimc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, fimc);
 
 	ret = devm_request_irq(&pdev->dev, res->start, fimc_irq_handler,
-			       0, pdev->name, fimc);
+			       0, dev_name(&pdev->dev), fimc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
 		goto err_clk;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index e3078d3..cbd1137 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -401,6 +401,8 @@ struct fimc_drvdata {
 	unsigned long lclk_frequency;
 };
 
+#define fimc_get_drvdata(_pdev) \
+	((struct fimc_drvdata *) platform_get_device_id(_pdev)->driver_data)
 
 struct fimc_ctx;
 
-- 
1.7.10

