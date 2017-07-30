Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbdG3NYt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 09:24:49 -0400
From: Shawn Guo <shawnguo@kernel.org>
To: Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>
Cc: Baoyou Xie <xie.baoyou@sanechips.com.cn>,
        Xin Zhou <zhou.xin8@sanechips.com.cn>,
        Jun Nie <jun.nie@linaro.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 3/3] rc: add zx-irdec remote control driver
Date: Sun, 30 Jul 2017 21:23:13 +0800
Message-Id: <1501420993-21977-4-git-send-email-shawnguo@kernel.org>
In-Reply-To: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
References: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shawn Guo <shawn.guo@linaro.org>

It adds the remote control driver and corresponding keymap file for
IRDEC block found on ZTE ZX family SoCs.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/media/rc/Kconfig               |  11 ++
 drivers/media/rc/Makefile              |   1 +
 drivers/media/rc/keymaps/Makefile      |   3 +-
 drivers/media/rc/keymaps/rc-zx-irdec.c |  79 ++++++++++++++
 drivers/media/rc/zx-irdec.c            | 183 +++++++++++++++++++++++++++++++++
 include/media/rc-map.h                 |   1 +
 6 files changed, 277 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/rc/keymaps/rc-zx-irdec.c
 create mode 100644 drivers/media/rc/zx-irdec.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 5e83b76495f7..c572d5da4b5f 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -435,4 +435,15 @@ config IR_SIR
 	   To compile this driver as a module, choose M here: the module will
 	   be called sir-ir.
 
+config IR_ZX
+	tristate "ZTE ZX IR remote control"
+	depends on RC_CORE
+	depends on ARCH_ZX || COMPILE_TEST
+	---help---
+	   Say Y if you want to use the IR remote control available
+	   on ZTE ZX family SoCs.
+
+	   To compile this driver as a module, choose M here: the
+	   module will be called zx-irdec.
+
 endif #RC_DEVICES
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 245e2c2d0b22..922c1a5620e9 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -41,3 +41,4 @@ obj-$(CONFIG_IR_IMG) += img-ir/
 obj-$(CONFIG_IR_SERIAL) += serial_ir.o
 obj-$(CONFIG_IR_SIR) += sir_ir.o
 obj-$(CONFIG_IR_MTK) += mtk-cir.o
+obj-$(CONFIG_IR_ZX) += zx-irdec.o
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 2945f99907b5..af6496d709fb 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -109,4 +109,5 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-videomate-tv-pvr.o \
 			rc-winfast.o \
 			rc-winfast-usbii-deluxe.o \
-			rc-su3000.o
+			rc-su3000.o \
+			rc-zx-irdec.o
diff --git a/drivers/media/rc/keymaps/rc-zx-irdec.c b/drivers/media/rc/keymaps/rc-zx-irdec.c
new file mode 100644
index 000000000000..cc889df47eb8
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-zx-irdec.c
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2017 Sanechips Technology Co., Ltd.
+ * Copyright 2017 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <media/rc-map.h>
+
+static struct rc_map_table zx_irdec_table[] = {
+	{ 0x01, KEY_1 },
+	{ 0x02, KEY_2 },
+	{ 0x03, KEY_3 },
+	{ 0x04, KEY_4 },
+	{ 0x05, KEY_5 },
+	{ 0x06, KEY_6 },
+	{ 0x07, KEY_7 },
+	{ 0x08, KEY_8 },
+	{ 0x09, KEY_9 },
+	{ 0x31, KEY_0 },
+	{ 0x16, KEY_DELETE },
+	{ 0x0a, KEY_MODE },		/* Input method */
+	{ 0x0c, KEY_VOLUMEUP },
+	{ 0x18, KEY_VOLUMEDOWN },
+	{ 0x0b, KEY_CHANNELUP },
+	{ 0x15, KEY_CHANNELDOWN },
+	{ 0x0d, KEY_PAGEUP },
+	{ 0x13, KEY_PAGEDOWN },
+	{ 0x46, KEY_FASTFORWARD },
+	{ 0x43, KEY_REWIND },
+	{ 0x44, KEY_PLAYPAUSE },
+	{ 0x45, KEY_STOP },
+	{ 0x49, KEY_OK },
+	{ 0x47, KEY_UP },
+	{ 0x4b, KEY_DOWN },
+	{ 0x48, KEY_LEFT },
+	{ 0x4a, KEY_RIGHT },
+	{ 0x4d, KEY_MENU },
+	{ 0x56, KEY_APPSELECT },	/* Application */
+	{ 0x4c, KEY_BACK },
+	{ 0x1e, KEY_INFO },
+	{ 0x4e, KEY_F1 },
+	{ 0x4f, KEY_F2 },
+	{ 0x50, KEY_F3 },
+	{ 0x51, KEY_F4 },
+	{ 0x1c, KEY_AUDIO },
+	{ 0x12, KEY_MUTE },
+	{ 0x11, KEY_DOT },		/* Location */
+	{ 0x1d, KEY_SETUP },
+	{ 0x40, KEY_POWER },
+};
+
+static struct rc_map_list zx_irdec_map = {
+	.map = {
+		.scan = zx_irdec_table,
+		.size = ARRAY_SIZE(zx_irdec_table),
+		.rc_type = RC_TYPE_NEC,
+		.name = RC_MAP_ZX_IRDEC,
+	}
+};
+
+static int __init init_rc_map_zx_irdec(void)
+{
+	return rc_map_register(&zx_irdec_map);
+}
+
+static void __exit exit_rc_map_zx_irdec(void)
+{
+	rc_map_unregister(&zx_irdec_map);
+}
+
+module_init(init_rc_map_zx_irdec)
+module_exit(exit_rc_map_zx_irdec)
+
+MODULE_AUTHOR("Shawn Guo <shawn.guo@linaro.org>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/rc/zx-irdec.c b/drivers/media/rc/zx-irdec.c
new file mode 100644
index 000000000000..3993aa0aeaa9
--- /dev/null
+++ b/drivers/media/rc/zx-irdec.c
@@ -0,0 +1,183 @@
+/*
+ * Copyright (C) 2017 Sanechips Technology Co., Ltd.
+ * Copyright 2017 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include <media/rc-core.h>
+
+#define DRIVER_NAME		"zx-irdec"
+
+#define ZX_IR_ENABLE		0x04
+#define ZX_IREN			BIT(0)
+#define ZX_IR_CTRL		0x08
+#define ZX_DEGL_MASK		GENMASK(21, 20)
+#define ZX_DEGL_VALUE(x)	(((x) << 20) & ZX_DEGL_MASK)
+#define ZX_WDBEGIN_MASK		GENMASK(18, 8)
+#define ZX_WDBEGIN_VALUE(x)	(((x) << 8) & ZX_WDBEGIN_MASK)
+#define ZX_IR_INTEN		0x10
+#define ZX_IR_INTSTCLR		0x14
+#define ZX_IR_CODE		0x30
+#define ZX_IR_CNUM		0x34
+#define ZX_NECRPT		BIT(16)
+
+struct zx_irdec {
+	void __iomem *base;
+	struct rc_dev *rcd;
+};
+
+static void zx_irdec_set_mask(struct zx_irdec *irdec, unsigned int reg,
+			      u32 mask, u32 value)
+{
+	u32 data;
+
+	data = readl(irdec->base + reg);
+	data &= ~mask;
+	data |= value & mask;
+	writel(data, irdec->base + reg);
+}
+
+static irqreturn_t zx_irdec_irq(int irq, void *dev_id)
+{
+	struct zx_irdec *irdec = dev_id;
+	u8 address, not_address;
+	u8 command, not_command;
+	u32 rawcode, scancode;
+	enum rc_type rc_type;
+
+	/* Clear interrupt */
+	writel(1, irdec->base + ZX_IR_INTSTCLR);
+
+	/* Check repeat frame */
+	if (readl(irdec->base + ZX_IR_CNUM) & ZX_NECRPT) {
+		rc_repeat(irdec->rcd);
+		goto done;
+	}
+
+	rawcode = readl(irdec->base + ZX_IR_CODE);
+	not_command = (rawcode >> 24) & 0xff;
+	command = (rawcode >> 16) & 0xff;
+	not_address = (rawcode >> 8) & 0xff;
+	address = rawcode & 0xff;
+
+	scancode = ir_nec_bytes_to_scancode(address, not_address,
+					    command, not_command,
+					    &rc_type);
+	rc_keydown(irdec->rcd, rc_type, scancode, 0);
+
+done:
+	return IRQ_HANDLED;
+}
+
+static int zx_irdec_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct zx_irdec *irdec;
+	struct resource *res;
+	struct rc_dev *rcd;
+	int irq;
+	int ret;
+
+	irdec = devm_kzalloc(dev, sizeof(*irdec), GFP_KERNEL);
+	if (!irdec)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irdec->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(irdec->base))
+		return PTR_ERR(irdec->base);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	rcd = devm_rc_allocate_device(dev, RC_DRIVER_SCANCODE);
+	if (!rcd) {
+		dev_err(dev, "failed to allocate rc device\n");
+		return -ENOMEM;
+	}
+
+	irdec->rcd = rcd;
+
+	rcd->priv = irdec;
+	rcd->input_name = DRIVER_NAME;
+	rcd->input_phys = DRIVER_NAME "/input0";
+	rcd->input_id.bustype = BUS_HOST;
+	rcd->map_name = RC_MAP_ZX_IRDEC;
+	rcd->allowed_protocols = RC_BIT_NEC | RC_BIT_NECX;
+	rcd->driver_name = DRIVER_NAME;
+
+	platform_set_drvdata(pdev, irdec);
+
+	ret = devm_rc_register_device(dev, rcd);
+	if (ret) {
+		dev_err(dev, "failed to register rc device\n");
+		return ret;
+	}
+
+	ret = devm_request_irq(dev, irq, zx_irdec_irq, 0, NULL, irdec);
+	if (ret) {
+		dev_err(dev, "failed to request irq\n");
+		return ret;
+	}
+
+	/*
+	 * Initialize deglitch level and watchdog counter beginner as
+	 * recommended by vendor BSP code.
+	 */
+	zx_irdec_set_mask(irdec, ZX_IR_CTRL, ZX_DEGL_MASK, ZX_DEGL_VALUE(0));
+	zx_irdec_set_mask(irdec, ZX_IR_CTRL, ZX_WDBEGIN_MASK,
+			  ZX_WDBEGIN_VALUE(0x21c));
+
+	/* Enable interrupt */
+	writel(1, irdec->base + ZX_IR_INTEN);
+
+	/* Enable the decoder */
+	zx_irdec_set_mask(irdec, ZX_IR_ENABLE, ZX_IREN, ZX_IREN);
+
+	return 0;
+}
+
+static int zx_irdec_remove(struct platform_device *pdev)
+{
+	struct zx_irdec *irdec = platform_get_drvdata(pdev);
+
+	/* Disable the decoder */
+	zx_irdec_set_mask(irdec, ZX_IR_ENABLE, ZX_IREN, 0);
+
+	/* Disable interrupt */
+	writel(0, irdec->base + ZX_IR_INTEN);
+
+	return 0;
+}
+
+static const struct of_device_id zx_irdec_match[] = {
+	{ .compatible = "zte,zx296718-irdec" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, zx_irdec_match);
+
+static struct platform_driver zx_irdec_driver = {
+	.probe = zx_irdec_probe,
+	.remove = zx_irdec_remove,
+	.driver = {
+		.name = DRIVER_NAME,
+		.of_match_table	= zx_irdec_match,
+	},
+};
+module_platform_driver(zx_irdec_driver);
+
+MODULE_DESCRIPTION("ZTE ZX IR remote control driver");
+MODULE_AUTHOR("Shawn Guo <shawn.guo@linaro.org>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 1a815a572fa1..c69482852f29 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -313,6 +313,7 @@ struct rc_map_list {
 #define RC_MAP_WINFAST                   "rc-winfast"
 #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
 #define RC_MAP_SU3000                    "rc-su3000"
+#define RC_MAP_ZX_IRDEC                  "rc-zx-irdec"
 
 /*
  * Please, do not just append newer Remote Controller names at the end.
-- 
1.9.1
