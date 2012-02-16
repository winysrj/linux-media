Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28462 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2BPRWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 12:22:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZH007IGXKYXT80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZH00JKQXKY6C@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Date: Thu, 16 Feb 2012 18:22:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/6] s5p-fimc: convert to clk_prepare()/clk_unprepare()
In-reply-to: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329412925-5872-2-git-send-email-s.nawrocki@samsung.com>
References: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   29 ++++++++++++++++++++---------
 drivers/media/video/s5p-fimc/mipi-csis.c |   28 +++++++++++++++++++---------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 81bcbb9..a6b4580 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1602,24 +1602,35 @@ static void fimc_clk_put(struct fimc_dev *fimc)
 {
 	int i;
 	for (i = 0; i < fimc->num_clocks; i++) {
-		if (fimc->clock[i])
-			clk_put(fimc->clock[i]);
+		if (IS_ERR_OR_NULL(fimc->clock[i]))
+			continue;
+		clk_unprepare(fimc->clock[i]);
+		clk_put(fimc->clock[i]);
+		fimc->clock[i] = NULL;
 	}
 }
 
 static int fimc_clk_get(struct fimc_dev *fimc)
 {
-	int i;
+	int i, ret;
+
 	for (i = 0; i < fimc->num_clocks; i++) {
 		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
-		if (!IS_ERR_OR_NULL(fimc->clock[i]))
-			continue;
-		dev_err(&fimc->pdev->dev, "failed to get fimc clock: %s\n",
-			fimc_clocks[i]);
-		return -ENXIO;
+		if (IS_ERR(fimc->clock[i]))
+			goto err;
+		ret = clk_prepare(fimc->clock[i]);
+		if (ret < 0) {
+			clk_put(fimc->clock[i]);
+			fimc->clock[i] = NULL;
+			goto err;
+		}
 	}
-
 	return 0;
+err:
+	fimc_clk_put(fimc);
+	dev_err(&fimc->pdev->dev, "failed to get clock: %s\n",
+		fimc_clocks[i]);
+	return -ENXIO;
 }
 
 static int fimc_m2m_suspend(struct fimc_dev *fimc)
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 130335c..58c4075 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -258,26 +258,36 @@ static void s5pcsis_clk_put(struct csis_state *state)
 {
 	int i;
 
-	for (i = 0; i < NUM_CSIS_CLOCKS; i++)
-		if (!IS_ERR_OR_NULL(state->clock[i]))
-			clk_put(state->clock[i]);
+	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
+		if (IS_ERR_OR_NULL(state->clock[i]))
+			continue;
+		clk_unprepare(state->clock[i]);
+		clk_put(state->clock[i]);
+		state->clock[i] = NULL;
+	}
 }
 
 static int s5pcsis_clk_get(struct csis_state *state)
 {
 	struct device *dev = &state->pdev->dev;
-	int i;
+	int i, ret;
 
 	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
 		state->clock[i] = clk_get(dev, csi_clock_name[i]);
-		if (IS_ERR(state->clock[i])) {
-			s5pcsis_clk_put(state);
-			dev_err(dev, "failed to get clock: %s\n",
-				csi_clock_name[i]);
-			return -ENXIO;
+		if (IS_ERR(state->clock[i]))
+			goto err;
+		ret = clk_prepare(state->clock[i]);
+		if (ret < 0) {
+			clk_put(state->clock[i]);
+			state->clock[i] = NULL;
+			goto err;
 		}
 	}
 	return 0;
+err:
+	s5pcsis_clk_put(state);
+	dev_err(dev, "failed to get clock: %s\n", csi_clock_name[i]);
+	return -ENXIO;
 }
 
 static int s5pcsis_s_power(struct v4l2_subdev *sd, int on)
-- 
1.7.9

