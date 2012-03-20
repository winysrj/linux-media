Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39587 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab2CTKjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 06:39:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M1600FCHIXBPL70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:11 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M16004PRIX72C@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:07 +0000 (GMT)
Date: Tue, 20 Mar 2012 11:39:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/6] s5p-fimc: Remove unneeded fields from struct fimc_dev
In-reply-to: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1332239945-32711-6-git-send-email-s.nawrocki@samsung.com>
References: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

irq is used only locally and num_clocks is constant, so remove them.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    8 +++-----
 drivers/media/video/s5p-fimc/fimc-core.h |    4 ----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 21691e4..4d6b867 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1559,7 +1559,7 @@ void fimc_unregister_m2m_device(struct fimc_dev *fimc)
 static void fimc_clk_put(struct fimc_dev *fimc)
 {
 	int i;
-	for (i = 0; i < fimc->num_clocks; i++) {
+	for (i = 0; i < MAX_FIMC_CLOCKS; i++) {
 		if (IS_ERR_OR_NULL(fimc->clock[i]))
 			continue;
 		clk_unprepare(fimc->clock[i]);
@@ -1572,7 +1572,7 @@ static int fimc_clk_get(struct fimc_dev *fimc)
 {
 	int i, ret;
 
-	for (i = 0; i < fimc->num_clocks; i++) {
+	for (i = 0; i < MAX_FIMC_CLOCKS; i++) {
 		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
 		if (IS_ERR(fimc->clock[i]))
 			goto err;
@@ -1672,9 +1672,7 @@ static int fimc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to get IRQ resource\n");
 		return -ENXIO;
 	}
-	fimc->irq = res->start;
 
-	fimc->num_clocks = MAX_FIMC_CLOCKS;
 	ret = fimc_clk_get(fimc);
 	if (ret)
 		return ret;
@@ -1683,7 +1681,7 @@ static int fimc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, fimc);
 
-	ret = devm_request_irq(&pdev->dev, fimc->irq, fimc_irq_handler,
+	ret = devm_request_irq(&pdev->dev, res->start, fimc_irq_handler,
 			       0, pdev->name, fimc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 101c930..193e8f6 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -429,10 +429,8 @@ struct fimc_ctx;
  * @pdata:	pointer to the device platform data
  * @variant:	the IP variant information
  * @id:		FIMC device index (0..FIMC_MAX_DEVS)
- * @num_clocks: the number of clocks managed by this device instance
  * @clock:	clocks required for FIMC operation
  * @regs:	the mapped hardware registers
- * @irq:	FIMC interrupt number
  * @irq_queue:	interrupt handler waitqueue
  * @v4l2_dev:	root v4l2_device
  * @m2m:	memory-to-memory V4L2 device information
@@ -448,10 +446,8 @@ struct fimc_dev {
 	struct s5p_platform_fimc	*pdata;
 	struct samsung_fimc_variant	*variant;
 	u16				id;
-	u16				num_clocks;
 	struct clk			*clock[MAX_FIMC_CLOCKS];
 	void __iomem			*regs;
-	int				irq;
 	wait_queue_head_t		irq_queue;
 	struct v4l2_device		*v4l2_dev;
 	struct fimc_m2m_device		m2m;
-- 
1.7.9.2

