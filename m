Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36155 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935205AbeBMM37 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 07:29:59 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [RESEND PATCH v5 1/6] media: rc: update sunxi-ir driver to get base clock frequency from devicetree
Date: Tue, 13 Feb 2018 13:29:47 +0100
Message-Id: <20180213122952.8420-2-embed3d@gmail.com>
In-Reply-To: <20180213122952.8420-1-embed3d@gmail.com>
References: <20180213122952.8420-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch updates the sunxi-ir driver to set the base clock frequency from
devicetree.

This is necessary since there are different ir receivers on the
market, that operate with different frequencies. So this value could be
set if the attached ir receiver needs a different base clock frequency,
than the default 8 MHz.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
Reviewed-by: Andi Shyti <andi.shyti@samsung.com>
Acked-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sunxi-cir.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index 97f367b446c4..f500cea228a9 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -72,12 +72,8 @@
 /* CIR_REG register idle threshold */
 #define REG_CIR_ITHR(val)    (((val) << 8) & (GENMASK(15, 8)))
 
-/* Required frequency for IR0 or IR1 clock in CIR mode */
+/* Required frequency for IR0 or IR1 clock in CIR mode (default) */
 #define SUNXI_IR_BASE_CLK     8000000
-/* Frequency after IR internal divider  */
-#define SUNXI_IR_CLK          (SUNXI_IR_BASE_CLK / 64)
-/* Sample period in ns */
-#define SUNXI_IR_SAMPLE       (1000000000ul / SUNXI_IR_CLK)
 /* Noise threshold in samples  */
 #define SUNXI_IR_RXNOISE      1
 /* Idle Threshold in samples */
@@ -122,7 +118,8 @@ static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
 			/* for each bit in fifo */
 			dt = readb(ir->base + SUNXI_IR_RXFIFO_REG);
 			rawir.pulse = (dt & 0x80) != 0;
-			rawir.duration = ((dt & 0x7f) + 1) * SUNXI_IR_SAMPLE;
+			rawir.duration = ((dt & 0x7f) + 1) *
+					 ir->rc->rx_resolution;
 			ir_raw_event_store_with_filter(ir->rc, &rawir);
 		}
 	}
@@ -148,6 +145,7 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 	struct device_node *dn = dev->of_node;
 	struct resource *res;
 	struct sunxi_ir *ir;
+	u32 b_clk_freq = SUNXI_IR_BASE_CLK;
 
 	ir = devm_kzalloc(dev, sizeof(struct sunxi_ir), GFP_KERNEL);
 	if (!ir)
@@ -172,6 +170,9 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 		return PTR_ERR(ir->clk);
 	}
 
+	/* Base clock frequency (optional) */
+	of_property_read_u32(dn, "clock-frequency", &b_clk_freq);
+
 	/* Reset (optional) */
 	ir->rst = devm_reset_control_get_optional_exclusive(dev, NULL);
 	if (IS_ERR(ir->rst))
@@ -180,11 +181,12 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
+	ret = clk_set_rate(ir->clk, b_clk_freq);
 	if (ret) {
 		dev_err(dev, "set ir base clock failed!\n");
 		goto exit_reset_assert;
 	}
+	dev_dbg(dev, "set base clock frequency to %d Hz.\n", b_clk_freq);
 
 	if (clk_prepare_enable(ir->apb_clk)) {
 		dev_err(dev, "try to enable apb_ir_clk failed\n");
@@ -225,7 +227,8 @@ static int sunxi_ir_probe(struct platform_device *pdev)
 	ir->rc->map_name = ir->map_name ?: RC_MAP_EMPTY;
 	ir->rc->dev.parent = dev;
 	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
-	ir->rc->rx_resolution = SUNXI_IR_SAMPLE;
+	/* Frequency after IR internal divider with sample period in ns */
+	ir->rc->rx_resolution = (1000000000ul / (b_clk_freq / 64));
 	ir->rc->timeout = MS_TO_NS(SUNXI_IR_TIMEOUT);
 	ir->rc->driver_name = SUNXI_IR_DEV;
 
-- 
2.11.0
