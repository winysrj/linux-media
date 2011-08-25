Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63110 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1HYLnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 07:43:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQH00MJ1F8IWX80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Aug 2011 12:43:30 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQH00GXFF8HUB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Aug 2011 12:43:29 +0100 (BST)
Date: Thu, 25 Aug 2011 13:43:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2] s5p-csis: Handle all available power supplies
In-reply-to: <4E15B5E3.7050204@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1314272588-10620-1-git-send-email-s.nawrocki@samsung.com>
References: <4E15B5E3.7050204@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the SoCs this driver is intended to support the are three separate
pins to supply the MIPI-CSIS subsystem: 1.1V or 1.2V, 1.8V and power
supply for an internal PLL.
This patch adds support for two separate voltage supplies to cover
properly board configurations where PMIC requires to configure
independently each external supply of the MIPI-CSI device. The 1.8V
and PLL supply are assigned a single "vdd18" regulator supply name
as it seems more reasonable than creating separate regulator supplies
for them.

While at here stop using the 'fixed_phy_vdd' platform_data field.
It has been introduced for boards where the MIPI-CSIS supplies are
not controllable. However it is not needed as those boards can use
the dummy regulator.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
There is a minor change introduced in this patch comparing to the first
version - the not really needed fixed_phy_vdd platform data property is
killed which simplifies the code a bit. The struct s5p_platform_mipi_csis
definition will be cleaned in a subsequent patch.

---
 drivers/media/video/s5p-fimc/mipi-csis.c |   49 ++++++++++++++++--------------
 1 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index ef056d6..e34d4ba 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -81,6 +81,12 @@ static char *csi_clock_name[] = {
 };
 #define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
 
+static const char * const csis_supply_name[] = {
+	"vdd11", /* 1.1V or 1.2V (s5pc100) MIPI CSI suppply */
+	"vdd18", /* VDD 1.8V and MIPI CSI PLL supply */
+};
+#define CSIS_NUM_SUPPLIES ARRAY_SIZE(csis_supply_name)
+
 enum {
 	ST_POWERED	= 1,
 	ST_STREAMING	= 2,
@@ -109,9 +115,9 @@ struct csis_state {
 	struct platform_device *pdev;
 	struct resource *regs_res;
 	void __iomem *regs;
+	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
 	struct clk *clock[NUM_CSIS_CLOCKS];
 	int irq;
-	struct regulator *supply;
 	u32 flags;
 	const struct csis_pix_format *csis_fmt;
 	struct v4l2_mbus_framefmt format;
@@ -460,6 +466,7 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 	struct resource *regs_res;
 	struct csis_state *state;
 	int ret = -ENOMEM;
+	int i;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
@@ -519,14 +526,13 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 		goto e_clkput;
 	}
 
-	if (!pdata->fixed_phy_vdd) {
-		state->supply = regulator_get(&pdev->dev, "vdd");
-		if (IS_ERR(state->supply)) {
-			ret = PTR_ERR(state->supply);
-			state->supply = NULL;
-			goto e_clkput;
-		}
-	}
+	for (i = 0; i < CSIS_NUM_SUPPLIES; i++)
+		state->supplies[i].supply = csis_supply_name[i];
+
+	ret = regulator_bulk_get(&pdev->dev, CSIS_NUM_SUPPLIES,
+				 state->supplies);
+	if (ret)
+		goto e_clkput;
 
 	ret = request_irq(state->irq, s5pcsis_irq_handler, 0,
 			  dev_name(&pdev->dev), state);
@@ -561,8 +567,7 @@ static int __devinit s5pcsis_probe(struct platform_device *pdev)
 e_irqfree:
 	free_irq(state->irq, state);
 e_regput:
-	if (state->supply)
-		regulator_put(state->supply);
+	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
 e_clkput:
 	clk_disable(state->clock[CSIS_CLK_MUX]);
 	s5pcsis_clk_put(state);
@@ -592,11 +597,10 @@ static int s5pcsis_suspend(struct device *dev)
 		ret = pdata->phy_enable(state->pdev, false);
 		if (ret)
 			goto unlock;
-		if (state->supply) {
-			ret = regulator_disable(state->supply);
-			if (ret)
-				goto unlock;
-		}
+		ret = regulator_bulk_disable(CSIS_NUM_SUPPLIES,
+					     state->supplies);
+		if (ret)
+			goto unlock;
 		clk_disable(state->clock[CSIS_CLK_GATE]);
 		state->flags &= ~ST_POWERED;
 	}
@@ -622,16 +626,16 @@ static int s5pcsis_resume(struct device *dev)
 		goto unlock;
 
 	if (!(state->flags & ST_POWERED)) {
-		if (state->supply)
-			ret = regulator_enable(state->supply);
+		ret = regulator_bulk_enable(CSIS_NUM_SUPPLIES,
+					    state->supplies);
 		if (ret)
 			goto unlock;
-
 		ret = pdata->phy_enable(state->pdev, true);
 		if (!ret) {
 			state->flags |= ST_POWERED;
-		} else if (state->supply) {
-			regulator_disable(state->supply);
+		} else {
+			regulator_bulk_disable(CSIS_NUM_SUPPLIES,
+					       state->supplies);
 			goto unlock;
 		}
 		clk_enable(state->clock[CSIS_CLK_GATE]);
@@ -679,8 +683,7 @@ static int __devexit s5pcsis_remove(struct platform_device *pdev)
 	pm_runtime_set_suspended(&pdev->dev);
 
 	s5pcsis_clk_put(state);
-	if (state->supply)
-		regulator_put(state->supply);
+	regulator_bulk_free(CSIS_NUM_SUPPLIES, state->supplies);
 
 	media_entity_cleanup(&state->sd.entity);
 	free_irq(state->irq, state);
-- 
1.7.6

