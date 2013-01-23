Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:12968 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWTjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 14:39:01 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH300KZ4FX0TMR0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 04:39:00 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MH30050KFWS1A70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 04:39:00 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Check return value of clk_enable/clk_set_rate
Date: Wed, 23 Jan 2013 20:38:50 +0100
Message-id: <1358969930-20615-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_set_rate(), clk_enable() functions can fail, so check the return
values to avoid surprises. While at it use ERR_PTR() value to indicate
invalid clock.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 720ffee..8b54f2f 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -810,11 +810,11 @@ static void fimc_clk_put(struct fimc_dev *fimc)
 {
 	int i;
 	for (i = 0; i < MAX_FIMC_CLOCKS; i++) {
-		if (IS_ERR_OR_NULL(fimc->clock[i]))
+		if (IS_ERR(fimc->clock[i]))
 			continue;
 		clk_unprepare(fimc->clock[i]);
 		clk_put(fimc->clock[i]);
-		fimc->clock[i] = NULL;
+		fimc->clock[i] = ERR_PTR(-EINVAL);
 	}
 }

@@ -822,14 +822,19 @@ static int fimc_clk_get(struct fimc_dev *fimc)
 {
 	int i, ret;

+	for (i = 0; i < MAX_FIMC_CLOCKS; i++)
+		fimc->clock[i] = ERR_PTR(-EINVAL);
+
 	for (i = 0; i < MAX_FIMC_CLOCKS; i++) {
 		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
-		if (IS_ERR(fimc->clock[i]))
+		if (IS_ERR(fimc->clock[i])) {
+			ret = PTR_ERR(fimc->clock[i]);
 			goto err;
+		}
 		ret = clk_prepare(fimc->clock[i]);
 		if (ret < 0) {
 			clk_put(fimc->clock[i]);
-			fimc->clock[i] = NULL;
+			fimc->clock[i] = ERR_PTR(-EINVAL);
 			goto err;
 		}
 	}
@@ -939,8 +944,13 @@ static int fimc_probe(struct platform_device *pdev)
 	if (lclk_freq == 0)
 		lclk_freq = drv_data->lclk_frequency;

-	clk_set_rate(fimc->clock[CLK_BUS], lclk_freq);
-	clk_enable(fimc->clock[CLK_BUS]);
+	ret = clk_set_rate(fimc->clock[CLK_BUS], lclk_freq);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_enable(fimc->clock[CLK_BUS]);
+	if (ret)
+		return ret;

 	ret = devm_request_irq(dev, res->start, fimc_irq_handler,
 			       0, dev_name(dev), fimc);
--
1.7.9.5

