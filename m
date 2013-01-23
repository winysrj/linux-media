Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:36128 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab3AWTil (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 14:38:41 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH300EB3FWGIBD0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 04:38:40 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MH3005Z9FW81A60@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Jan 2013 04:38:40 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-csis: Check return value of clk_enable/clk_set_rate
Date: Wed, 23 Jan 2013 20:38:29 +0100
Message-id: <1358969909-20566-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_set_rate(), clk_enable() functions can fail, so check the return
values to avoid surprises. While at it fix the error path and use
ERR_PTR() value to indicate invalid clock.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |   29 ++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index c25dbc4..b9eea8e 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -365,11 +365,11 @@ static void s5pcsis_clk_put(struct csis_state *state)
 	int i;

 	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
-		if (IS_ERR_OR_NULL(state->clock[i]))
+		if (IS_ERR(state->clock[i]))
 			continue;
 		clk_unprepare(state->clock[i]);
 		clk_put(state->clock[i]);
-		state->clock[i] = NULL;
+		state->clock[i] = ERR_PTR(-EINVAL);
 	}
 }

@@ -378,14 +378,19 @@ static int s5pcsis_clk_get(struct csis_state *state)
 	struct device *dev = &state->pdev->dev;
 	int i, ret;

+	for (i = 0; i < NUM_CSIS_CLOCKS; i++)
+		state->clock[i] = ERR_PTR(-EINVAL);
+
 	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
 		state->clock[i] = clk_get(dev, csi_clock_name[i]);
-		if (IS_ERR(state->clock[i]))
+		if (IS_ERR(state->clock[i])) {
+			ret = PTR_ERR(state->clock[i]);
 			goto err;
+		}
 		ret = clk_prepare(state->clock[i]);
 		if (ret < 0) {
 			clk_put(state->clock[i]);
-			state->clock[i] = NULL;
+			state->clock[i] = ERR_PTR(-EINVAL);
 			goto err;
 		}
 	}
@@ -393,7 +398,7 @@ static int s5pcsis_clk_get(struct csis_state *state)
 err:
 	s5pcsis_clk_put(state);
 	dev_err(dev, "failed to get clock: %s\n", csi_clock_name[i]);
-	return -ENXIO;
+	return ret;
 }

 static void dump_regs(struct csis_state *state, const char *label)
@@ -825,19 +830,25 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)

 	ret = s5pcsis_clk_get(state);
 	if (ret)
-		goto e_clkput;
+		goto e_regput;

-	clk_enable(state->clock[CSIS_CLK_MUX]);
 	if (state->clk_frequency)
-		clk_set_rate(state->clock[CSIS_CLK_MUX], state->clk_frequency);
+		ret = clk_set_rate(state->clock[CSIS_CLK_MUX],
+				   state->clk_frequency);
 	else
 		dev_WARN(dev, "No clock frequency specified!\n");
+	if (ret < 0)
+		goto e_clkput;
+
+	ret = clk_enable(state->clock[CSIS_CLK_MUX]);
+	if (ret < 0)
+		goto e_clkput;

 	ret = devm_request_irq(dev, state->irq, s5pcsis_irq_handler,
 			       0, dev_name(dev), state);
 	if (ret) {
 		dev_err(dev, "Interrupt request failed\n");
-		goto e_regput;
+		goto e_clkput;
 	}

 	v4l2_subdev_init(&state->sd, &s5pcsis_subdev_ops);
--
1.7.9.5

