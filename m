Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58321 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753830AbdCOLb4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 07:31:56 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 05/14] [media] rc: sunxi-cir: simplify optional reset handling
Date: Wed, 15 Mar 2017 12:31:38 +0100
Message-Id: <20170315113138.17242-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As of commit bb475230b8e5 ("reset: make optional functions really
optional"), the reset framework API calls use NULL pointers to describe
optional, non-present reset controls.

This allows to return errors from devm_reset_control_get_optional and to
call reset_control_(de)assert unconditionally.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/rc/sunxi-cir.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index 25b0061678102..4b785dd775c11 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -174,16 +174,11 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 
 	/* Reset (optional) */
 	ir->rst = devm_reset_control_get_optional(dev, NULL);
-	if (IS_ERR(ir->rst)) {
-		ret = PTR_ERR(ir->rst);
-		if (ret == -EPROBE_DEFER)
-			return ret;
-		ir->rst = NULL;
-	} else {
-		ret = reset_control_deassert(ir->rst);
-		if (ret)
-			return ret;
-	}
+	if (IS_ERR(ir->rst))
+		return PTR_ERR(ir->rst);
+	ret = reset_control_deassert(ir->rst);
+	if (ret)
+		return ret;
 
 	ret = clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
 	if (ret) {
@@ -291,8 +286,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 exit_clkdisable_apb_clk:
 	clk_disable_unprepare(ir->apb_clk);
 exit_reset_assert:
-	if (ir->rst)
-		reset_control_assert(ir->rst);
+	reset_control_assert(ir->rst);
 
 	return ret;
 }
@@ -304,8 +298,7 @@ static int sunxi_ir_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(ir->clk);
 	clk_disable_unprepare(ir->apb_clk);
-	if (ir->rst)
-		reset_control_assert(ir->rst);
+	reset_control_assert(ir->rst);
 
 	spin_lock_irqsave(&ir->ir_lock, flags);
 	/* disable IR IRQ */
-- 
2.11.0
