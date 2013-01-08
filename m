Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42123 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3AHHHC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 02:07:02 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so63328pbc.17
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 23:07:01 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-csis: Use devm_regulator_bulk_get API
Date: Tue,  8 Jan 2013 12:28:51 +0530
Message-Id: <1357628331-18955-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_regulator_bulk_get is device managed and saves some cleanup
and exit code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index cde510f..7e36ad9 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -743,7 +743,7 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	for (i = 0; i < CSIS_NUM_SUPPLIES; i++)
 		state->supplies[i].supply = csis_supply_name[i];
 
-	ret = regulator_bulk_get(&pdev->dev, CSIS_NUM_SUPPLIES,
+	ret = devm_regulator_bulk_get(&pdev->dev, CSIS_NUM_SUPPLIES,
 				 state->supplies);
 	if (ret)
 		return ret;
@@ -762,7 +762,7 @@ static int s5pcsis_probe(struct platform_device *pdev)
 			       0, dev_name(&pdev->dev), state);
 	if (ret) {
 		dev_err(&pdev->dev, "Interrupt request failed\n");
-		goto e_regput;
+		goto e_clkput;
 	}
 
 	v4l2_subdev_init(&state->sd, &s5pcsis_subdev_ops);
@@ -793,8 +793,6 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	return 0;
 
-e_regput:
-	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
 e_clkput:
 	clk_disable(state->clock[CSIS_CLK_MUX]);
 	s5pcsis_clk_put(state);
@@ -903,7 +901,6 @@ static int s5pcsis_remove(struct platform_device *pdev)
 	clk_disable(state->clock[CSIS_CLK_MUX]);
 	pm_runtime_set_suspended(&pdev->dev);
 	s5pcsis_clk_put(state);
-	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
 
 	media_entity_cleanup(&state->sd.entity);
 
-- 
1.7.4.1

