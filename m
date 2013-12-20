Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41767 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3LTWYT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 17:24:19 -0500
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/6] exynos4-is: Activate mipi-csis in probe() if runtime PM is disabled
Date: Fri, 20 Dec 2013 23:23:23 +0100
Message-Id: <1387578207-17625-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
References: <1387578207-17625-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devices should also operate normally when runtime PM is not enabled.
In case runtime PM is disabled activate the device already in probe().
Any related power domain needs to be then left permanently in active
state by the platform.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 31dfc50..f3c3591 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -790,6 +790,7 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 #define s5pcsis_parse_dt(pdev, state) (-ENOSYS)
 #endif
 
+static int s5pcsis_pm_resume(struct device *dev, bool runtime);
 static const struct of_device_id s5pcsis_of_match[];
 
 static int s5pcsis_probe(struct platform_device *pdev)
@@ -902,13 +903,21 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	/* .. and a pointer to the subdev. */
 	platform_set_drvdata(pdev, &state->sd);
 	memcpy(state->events, s5pcsis_events, sizeof(state->events));
+
 	pm_runtime_enable(dev);
+	if (!pm_runtime_enabled(dev)) {
+		ret = s5pcsis_pm_resume(dev, true);
+		if (ret < 0)
+			goto e_m_ent;
+	}
 
 	dev_info(&pdev->dev, "lanes: %d, hs_settle: %d, wclk: %d, freq: %u\n",
 		 state->num_lanes, state->hs_settle, state->wclk_ext,
 		 state->clk_frequency);
 	return 0;
 
+e_m_ent:
+	media_entity_cleanup(&state->sd.entity);
 e_clkdis:
 	clk_disable(state->clock[CSIS_CLK_MUX]);
 e_clkput:
@@ -1014,7 +1023,7 @@ static int s5pcsis_remove(struct platform_device *pdev)
 	struct csis_state *state = sd_to_csis_state(sd);
 
 	pm_runtime_disable(&pdev->dev);
-	s5pcsis_pm_suspend(&pdev->dev, false);
+	s5pcsis_pm_suspend(&pdev->dev, true);
 	clk_disable(state->clock[CSIS_CLK_MUX]);
 	pm_runtime_set_suspended(&pdev->dev);
 	s5pcsis_clk_put(state);
-- 
1.7.4.1

