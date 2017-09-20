Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:17634 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750859AbdITIj2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 04:39:28 -0400
To: Sean Young <sean@mess.org>, Mans Rullgard <mans@mansr.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Marc Gonzalez <marc_gonzalez@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Subject: [PATCH v2] media: rc: Add driver for tango IR decoder
Message-ID: <38397d63-f0db-6d8e-60cf-e8535447de63@free.fr>
Date: Wed, 20 Sep 2017 10:39:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mans Rullgard <mans@mansr.com>

The tango IR decoder supports NEC, RC-5, RC-6 protocols.

Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
---
Changes from v1 to v2
o Fixup a syntax error introduced by search & replace
o Bring back support for linux,rc-map-name property
o Provide binding description
---
 .../devicetree/bindings/media/tango-ir.txt         |  21 ++
 drivers/media/rc/Kconfig                           |   5 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/tango-ir.c                        | 265 +++++++++++++++++++++
 4 files changed, 292 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/tango-ir.txt
 create mode 100644 drivers/media/rc/tango-ir.c

diff --git a/Documentation/devicetree/bindings/media/tango-ir.txt b/Documentation/devicetree/bindings/media/tango-ir.txt
new file mode 100644
index 000000000000..a9f00c2bf897
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/tango-ir.txt
@@ -0,0 +1,21 @@
+Sigma Designs Tango IR NEC/RC-5/RC-6 decoder (SMP86xx and SMP87xx)
+
+Required properties:
+
+- compatible: "sigma,smp8642-ir"
+- reg: address/size of NEC+RC5 area, address/size of RC6 area
+- interrupts: spec for IR IRQ
+- clocks: spec for IR clock (typically the crystal oscillator)
+
+Optional properties:
+
+- linux,rc-map-name: see Documentation/devicetree/bindings/media/rc.txt
+
+Example:
+
+	ir@10518 {
+		compatible = "sigma,smp8642-ir";
+		reg = <0x10518 0x18>, <0x105e0 0x1c>;
+		interrupts = <21 IRQ_TYPE_EDGE_RISING>;
+		clocks = <&xtal>;
+	};
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index d9ce8ff55d0c..f84923289964 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -469,6 +469,11 @@ config IR_SIR
 	   To compile this driver as a module, choose M here: the module will
 	   be called sir-ir.
 
+config IR_TANGO
+	tristate "Sigma Designs SMP86xx IR decoder"
+	depends on RC_CORE
+	depends on ARCH_TANGO || COMPILE_TEST
+
 config IR_ZX
 	tristate "ZTE ZX IR remote control"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 9bc6a3980ed0..643797dc971b 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -44,3 +44,4 @@ obj-$(CONFIG_IR_SERIAL) += serial_ir.o
 obj-$(CONFIG_IR_SIR) += sir_ir.o
 obj-$(CONFIG_IR_MTK) += mtk-cir.o
 obj-$(CONFIG_IR_ZX) += zx-irdec.o
+obj-$(CONFIG_IR_TANGO) += tango-ir.o
diff --git a/drivers/media/rc/tango-ir.c b/drivers/media/rc/tango-ir.c
new file mode 100644
index 000000000000..fe19fd726aba
--- /dev/null
+++ b/drivers/media/rc/tango-ir.c
@@ -0,0 +1,265 @@
+/*
+ * Copyright (C) 2015 Mans Rullgard <mans@mansr.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <media/rc-core.h>
+
+#define IR_NEC_CTRL	0x00
+#define IR_NEC_DATA	0x04
+#define IR_CTRL		0x08
+#define IR_RC5_CLK_DIV	0x0c
+#define IR_RC5_DATA	0x10
+#define IR_INT		0x14
+
+#define NEC_TIME_BASE	560
+#define RC5_TIME_BASE	1778
+
+#define RC6_CTRL	0x00
+#define RC6_CLKDIV	0x04
+#define RC6_DATA0	0x08
+#define RC6_DATA1	0x0c
+#define RC6_DATA2	0x10
+#define RC6_DATA3	0x14
+#define RC6_DATA4	0x18
+
+#define RC6_CARRIER	36000
+#define RC6_TIME_BASE	16
+
+struct tango_ir {
+	void __iomem *rc5_base;
+	void __iomem *rc6_base;
+	struct rc_dev *rc;
+	struct clk *clk;
+};
+
+static void tango_ir_handle_nec(struct tango_ir *ir)
+{
+	u32 v, code;
+	enum rc_proto proto;
+
+	v = readl_relaxed(ir->rc5_base + IR_NEC_DATA);
+	if (!v) {
+		rc_repeat(ir->rc);
+		return;
+	}
+
+	code = ir_nec_bytes_to_scancode(v, v >> 8, v >> 16, v >> 24, &proto);
+	rc_keydown(ir->rc, proto, code, 0);
+}
+
+static void tango_ir_handle_rc5(struct tango_ir *ir)
+{
+	u32 data, field, toggle, addr, cmd, code;
+
+	data = readl_relaxed(ir->rc5_base + IR_RC5_DATA);
+	if (data & BIT(31))
+		return;
+
+	field = data >> 12 & 1;
+	toggle = data >> 11 & 1;
+	addr = data >> 6 & 0x1f;
+	cmd = (data & 0x3f) | (field ^ 1) << 6;
+
+	code = RC_SCANCODE_RC5(addr, cmd);
+	rc_keydown(ir->rc, RC_PROTO_RC5, code, toggle);
+}
+
+static void tango_ir_handle_rc6(struct tango_ir *ir)
+{
+	u32 data0, data1, toggle, mode, addr, cmd, code;
+
+	data0 = readl_relaxed(ir->rc6_base + RC6_DATA0);
+	data1 = readl_relaxed(ir->rc6_base + RC6_DATA1);
+
+	mode = data0 >> 1 & 7;
+	if (mode != 0)
+		return;
+
+	toggle = data0 & 1;
+	addr = data0 >> 16;
+	cmd = data1;
+
+	code = RC_SCANCODE_RC6_0(addr, cmd);
+	rc_keydown(ir->rc, RC_PROTO_RC6_0, code, toggle);
+}
+
+static irqreturn_t tango_ir_irq(int irq, void *dev_id)
+{
+	struct tango_ir *ir = dev_id;
+	unsigned int rc5_stat;
+	unsigned int rc6_stat;
+
+	rc5_stat = readl_relaxed(ir->rc5_base + IR_INT);
+	writel_relaxed(rc5_stat, ir->rc5_base + IR_INT);
+
+	rc6_stat = readl_relaxed(ir->rc6_base + RC6_CTRL);
+	writel_relaxed(rc6_stat, ir->rc6_base + RC6_CTRL);
+
+	if (!(rc5_stat & 3) && !(rc6_stat & BIT(31)))
+		return IRQ_NONE;
+
+	if (rc5_stat & BIT(0))
+		tango_ir_handle_rc5(ir);
+
+	if (rc5_stat & BIT(1))
+		tango_ir_handle_nec(ir);
+
+	if (rc6_stat & BIT(31))
+		tango_ir_handle_rc6(ir);
+
+	return IRQ_HANDLED;
+}
+
+#define DISABLE_NEC	(BIT(4) | BIT(8))
+#define ENABLE_RC5	(BIT(0) | BIT(9))
+#define ENABLE_RC6	(BIT(0) | BIT(7))
+
+static int tango_change_protocol(struct rc_dev *dev, u64 *rc_type)
+{
+	struct tango_ir *ir = dev->priv;
+	u32 rc5_ctrl = DISABLE_NEC;
+	u32 rc6_ctrl = 0;
+
+	if (*rc_type & RC_PROTO_BIT_NEC)
+		rc5_ctrl = 0;
+
+	if (*rc_type & RC_PROTO_BIT_RC5)
+		rc5_ctrl |= ENABLE_RC5;
+
+	if (*rc_type & RC_PROTO_BIT_RC6_0)
+		rc6_ctrl = ENABLE_RC6;
+
+	writel_relaxed(rc5_ctrl, ir->rc5_base + IR_CTRL);
+	writel_relaxed(rc6_ctrl, ir->rc6_base + RC6_CTRL);
+
+	return 0;
+}
+
+static int tango_ir_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct rc_dev *rc;
+	struct tango_ir *ir;
+	struct resource *rc5_res;
+	struct resource *rc6_res;
+	u64 clkrate, clkdiv;
+	int irq, err;
+
+	rc5_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!rc5_res)
+		return -EINVAL;
+
+	rc6_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!rc6_res)
+		return -EINVAL;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0)
+		return -EINVAL;
+
+	ir = devm_kzalloc(dev, sizeof(*ir), GFP_KERNEL);
+	if (!ir)
+		return -ENOMEM;
+
+	ir->rc5_base = devm_ioremap_resource(dev, rc5_res);
+	if (IS_ERR(ir->rc5_base))
+		return PTR_ERR(ir->rc5_base);
+
+	ir->rc6_base = devm_ioremap_resource(dev, rc6_res);
+	if (IS_ERR(ir->rc6_base))
+		return PTR_ERR(ir->rc6_base);
+
+	ir->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(ir->clk))
+		return PTR_ERR(ir->clk);
+
+	rc = devm_rc_allocate_device(dev, RC_DRIVER_SCANCODE);
+	if (!rc)
+		return -ENOMEM;
+
+	rc->driver_name = rc->device_name = "tango-ir";
+	rc->input_phys = "tango-ir/input0";
+	rc->map_name = RC_MAP_EMPTY;
+	rc->allowed_protocols = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_0 |
+		RC_PROTO_BIT_NEC | RC_PROTO_BIT_NECX | RC_PROTO_BIT_NEC32;
+	rc->change_protocol = tango_change_protocol;
+	rc->priv = ir;
+	ir->rc = rc;
+
+	of_property_read_string(dev->of_node, "linux,rc-map-name", &rc->map_name);
+
+	err = devm_rc_register_device(dev, rc);
+	if (err)
+		return err;
+
+	err = devm_request_irq(dev, irq, tango_ir_irq, IRQF_SHARED, dev_name(dev), ir);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(ir->clk);
+	if (err)
+		return err;
+
+	clkrate = clk_get_rate(ir->clk);
+
+	clkdiv = clkrate * NEC_TIME_BASE;
+	do_div(clkdiv, 1000000);
+
+	writel_relaxed(31 << 24 | 12 << 16 | clkdiv, ir->rc5_base + IR_NEC_CTRL);
+
+	clkdiv = clkrate * RC5_TIME_BASE;
+	do_div(clkdiv, 1000000);
+
+	writel_relaxed(0x110, ir->rc5_base + IR_CTRL);
+	writel_relaxed(clkdiv, ir->rc5_base + IR_RC5_CLK_DIV);
+	writel_relaxed(0x3, ir->rc5_base + IR_INT);
+
+	clkdiv = clkrate * RC6_TIME_BASE;
+	do_div(clkdiv, RC6_CARRIER);
+
+	writel_relaxed(0xc0000000, ir->rc6_base + RC6_CTRL);
+	writel_relaxed((clkdiv >> 2) << 18 | clkdiv, ir->rc6_base + RC6_CLKDIV);
+
+	platform_set_drvdata(pdev, ir);
+
+	return 0;
+}
+
+static int tango_ir_remove(struct platform_device *pdev)
+{
+	struct tango_ir *ir = platform_get_drvdata(pdev);
+	clk_disable_unprepare(ir->clk);
+	return 0;
+}
+
+static const struct of_device_id tango_ir_dt_ids[] = {
+	{ .compatible = "sigma,smp8642-ir" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tango_ir_dt_ids);
+
+static struct platform_driver tango_ir_driver = {
+	.probe	= tango_ir_probe,
+	.remove	= tango_ir_remove,
+	.driver	= {
+		.name		= "tango-ir",
+		.of_match_table	= tango_ir_dt_ids,
+	},
+};
+module_platform_driver(tango_ir_driver);
+
+MODULE_DESCRIPTION("SMP86xx IR decoder driver");
+MODULE_AUTHOR("Mans Rullgard <mans@mansr.com>");
+MODULE_LICENSE("GPL");
-- 
2.11.0
