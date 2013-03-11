Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:58371 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3CKTA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:00:59 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 03/11] s5p-csis: Add parent clock setup
Date: Mon, 11 Mar 2013 20:00:18 +0100
Message-id: <1363028426-2771-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
References: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With this patch the driver will set "parent" clock as a parent
clock of "mux" clock. When the samsung clocks driver is reworked
to use new composite clock type, the "mux" clock can be removed.

"parent" clock should be set in relevant dtsi file and can be
overwritten in a board dts file. This way it is ensured the
SCLK_CSIS has correct parent clock set, and the parent clock
can be selected per each board if required.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |   66 ++++++++++++++++++---------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 4673625..6854c9e 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -108,13 +108,17 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 #define S5PCSIS_PKTDATA_SIZE		SZ_4K
 
 enum {
-	CSIS_CLK_MUX,
+	CSIS_CLK_BUS,
 	CSIS_CLK_GATE,
+	CSIS_CLK_MUX,
+	CSIS_CLK_PARENT,
 };
 
 static char *csi_clock_name[] = {
-	[CSIS_CLK_MUX]  = "sclk_csis",
+	[CSIS_CLK_BUS]  = "sclk_csis",
 	[CSIS_CLK_GATE] = "csis",
+	[CSIS_CLK_MUX] = "mux",
+	[CSIS_CLK_PARENT] = "parent",
 };
 #define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
 #define DEFAULT_SCLK_CSIS_FREQ	166000000UL
@@ -362,7 +366,7 @@ static void s5pcsis_set_params(struct csis_state *state)
 	s5pcsis_write(state, S5PCSIS_CTRL, val | S5PCSIS_CTRL_UPDATE_SHADOW);
 }
 
-static void s5pcsis_clk_put(struct csis_state *state)
+static void s5pcsis_put_clocks(struct csis_state *state)
 {
 	int i;
 
@@ -375,11 +379,16 @@ static void s5pcsis_clk_put(struct csis_state *state)
 	}
 }
 
-static int s5pcsis_clk_get(struct csis_state *state)
+static int s5pcsis_get_clocks(struct csis_state *state)
 {
 	struct device *dev = &state->pdev->dev;
+	unsigned int num_clocks = NUM_CSIS_CLOCKS;
 	int i, ret;
 
+	/* Skip parent and mux clocks for non-dt platforms */
+	if (!dev->of_node)
+		num_clocks -= 2;
+
 	for (i = 0; i < NUM_CSIS_CLOCKS; i++)
 		state->clock[i] = ERR_PTR(-EINVAL);
 
@@ -398,11 +407,32 @@ static int s5pcsis_clk_get(struct csis_state *state)
 	}
 	return 0;
 err:
-	s5pcsis_clk_put(state);
+	s5pcsis_put_clocks(state);
 	dev_err(dev, "failed to get clock: %s\n", csi_clock_name[i]);
 	return ret;
 }
 
+static int s5pcsis_setup_clocks(struct csis_state *state)
+{
+	int ret;
+
+	if (!IS_ERR(state->clock[CSIS_CLK_PARENT])) {
+		ret = clk_set_parent(state->clock[CSIS_CLK_MUX],
+				     state->clock[CSIS_CLK_PARENT]);
+		if (ret < 0) {
+			dev_err(&state->pdev->dev,
+				"%s(): failed to set parent: %d\n",
+				__func__, ret);
+			return ret;
+		}
+	}
+	ret = clk_set_rate(state->clock[CSIS_CLK_BUS],
+					state->clk_frequency);
+	if (ret < 0)
+		return ret;
+	return clk_enable(state->clock[CSIS_CLK_BUS]);
+}
+
 static void dump_regs(struct csis_state *state, const char *label)
 {
 	struct {
@@ -725,8 +755,10 @@ static int s5pcsis_get_platform_data(struct platform_device *pdev,
 		dev_err(&pdev->dev, "Platform data not specified\n");
 		return -EINVAL;
 	}
-
-	state->clk_frequency = pdata->clk_rate;
+	if (pdata->clk_rate)
+		state->clk_frequency = pdata->clk_rate;
+	else
+		state->clk_frequency = DEFAULT_SCLK_CSIS_FREQ;
 	state->num_lanes = pdata->lanes;
 	state->hs_settle = pdata->hs_settle;
 	state->index = max(0, pdev->id);
@@ -830,19 +862,11 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = s5pcsis_clk_get(state);
+	ret = s5pcsis_get_clocks(state);
 	if (ret < 0)
 		return ret;
 
-	if (state->clk_frequency)
-		ret = clk_set_rate(state->clock[CSIS_CLK_MUX],
-				   state->clk_frequency);
-	else
-		dev_WARN(dev, "No clock frequency specified!\n");
-	if (ret < 0)
-		goto e_clkput;
-
-	ret = clk_enable(state->clock[CSIS_CLK_MUX]);
+	ret = s5pcsis_setup_clocks(state);
 	if (ret < 0)
 		goto e_clkput;
 
@@ -885,9 +909,9 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	return 0;
 
 e_clkdis:
-	clk_disable(state->clock[CSIS_CLK_MUX]);
+	clk_disable(state->clock[CSIS_CLK_BUS]);
 e_clkput:
-	s5pcsis_clk_put(state);
+	s5pcsis_put_clocks(state);
 	return ret;
 }
 
@@ -990,9 +1014,9 @@ static int s5pcsis_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 	s5pcsis_pm_suspend(&pdev->dev, false);
-	clk_disable(state->clock[CSIS_CLK_MUX]);
+	clk_disable(state->clock[CSIS_CLK_BUS]);
 	pm_runtime_set_suspended(&pdev->dev);
-	s5pcsis_clk_put(state);
+	s5pcsis_put_clocks(state);
 
 	media_entity_cleanup(&state->sd.entity);
 
-- 
1.7.9.5

