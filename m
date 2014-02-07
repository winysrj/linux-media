Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:38982 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaBGQQu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 11:16:50 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 07/15] media: rc: img-ir: add base driver
Date: Fri, 7 Feb 2014 16:16:29 +0000
Message-ID: <1391789789-30841-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1389967140-20704-8-git-send-email-james.hogan@imgtec.com>
References: <1389967140-20704-8-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add base driver for the ImgTec Infrared decoder block. The driver is
split into separate components for raw (software) decode and hardware
decoder which are in following commits.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
---
v3:
- Use new compatible string "img,ir-rev1"
v2:
- Use new DT binding, with a different compatibility string and get core
  clock by name.
- Remove next pointer from struct img_ir_priv. This is related to the
  removal of dynamic registration/unregistration of protocol decode
  timings from later patches.
- Add io.h include to img-ir.h.
---
 drivers/media/rc/img-ir/img-ir-core.c | 176 ++++++++++++++++++++++++++++++++++
 drivers/media/rc/img-ir/img-ir.h      | 166 ++++++++++++++++++++++++++++++++
 2 files changed, 342 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-core.c
 create mode 100644 drivers/media/rc/img-ir/img-ir.h

diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/img-ir/img-ir-core.c
new file mode 100644
index 000000000000..6b7834834fb8
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-core.c
@@ -0,0 +1,176 @@
+/*
+ * ImgTec IR Decoder found in PowerDown Controller.
+ *
+ * Copyright 2010-2014 Imagination Technologies Ltd.
+ *
+ * This contains core img-ir code for setting up the driver. The two interfaces
+ * (raw and hardware decode) are handled separately.
+ */
+
+#include <linux/clk.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include "img-ir.h"
+
+static irqreturn_t img_ir_isr(int irq, void *dev_id)
+{
+	struct img_ir_priv *priv = dev_id;
+	u32 irq_status;
+
+	spin_lock(&priv->lock);
+	/* we have to clear irqs before reading */
+	irq_status = img_ir_read(priv, IMG_IR_IRQ_STATUS);
+	img_ir_write(priv, IMG_IR_IRQ_CLEAR, irq_status);
+
+	/* don't handle valid data irqs if we're only interested in matches */
+	irq_status &= img_ir_read(priv, IMG_IR_IRQ_ENABLE);
+
+	/* hand off edge interrupts to raw decode handler */
+	if (irq_status & IMG_IR_IRQ_EDGE && img_ir_raw_enabled(&priv->raw))
+		img_ir_isr_raw(priv, irq_status);
+
+	/* hand off hardware match interrupts to hardware decode handler */
+	if (irq_status & (IMG_IR_IRQ_DATA_MATCH |
+			  IMG_IR_IRQ_DATA_VALID |
+			  IMG_IR_IRQ_DATA2_VALID) &&
+	    img_ir_hw_enabled(&priv->hw))
+		img_ir_isr_hw(priv, irq_status);
+
+	spin_unlock(&priv->lock);
+	return IRQ_HANDLED;
+}
+
+static void img_ir_setup(struct img_ir_priv *priv)
+{
+	/* start off with interrupts disabled */
+	img_ir_write(priv, IMG_IR_IRQ_ENABLE, 0);
+
+	img_ir_setup_raw(priv);
+	img_ir_setup_hw(priv);
+
+	if (!IS_ERR(priv->clk))
+		clk_prepare_enable(priv->clk);
+}
+
+static void img_ir_ident(struct img_ir_priv *priv)
+{
+	u32 core_rev = img_ir_read(priv, IMG_IR_CORE_REV);
+
+	dev_info(priv->dev,
+		 "IMG IR Decoder (%d.%d.%d.%d) probed successfully\n",
+		 (core_rev & IMG_IR_DESIGNER) >> IMG_IR_DESIGNER_SHIFT,
+		 (core_rev & IMG_IR_MAJOR_REV) >> IMG_IR_MAJOR_REV_SHIFT,
+		 (core_rev & IMG_IR_MINOR_REV) >> IMG_IR_MINOR_REV_SHIFT,
+		 (core_rev & IMG_IR_MAINT_REV) >> IMG_IR_MAINT_REV_SHIFT);
+	dev_info(priv->dev, "Modes:%s%s\n",
+		 img_ir_hw_enabled(&priv->hw) ? " hardware" : "",
+		 img_ir_raw_enabled(&priv->raw) ? " raw" : "");
+}
+
+static int img_ir_probe(struct platform_device *pdev)
+{
+	struct img_ir_priv *priv;
+	struct resource *res_regs;
+	int irq, error, error2;
+
+	/* Get resources from platform device */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "cannot find IRQ resource\n");
+		return irq;
+	}
+
+	/* Private driver data */
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "cannot allocate device data\n");
+		return -ENOMEM;
+	}
+	platform_set_drvdata(pdev, priv);
+	priv->dev = &pdev->dev;
+	spin_lock_init(&priv->lock);
+
+	/* Ioremap the registers */
+	res_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->reg_base = devm_ioremap_resource(&pdev->dev, res_regs);
+	if (IS_ERR(priv->reg_base))
+		return PTR_ERR(priv->reg_base);
+
+	/* Get core clock */
+	priv->clk = devm_clk_get(&pdev->dev, "core");
+	if (IS_ERR(priv->clk))
+		dev_warn(&pdev->dev, "cannot get core clock resource\n");
+	/*
+	 * The driver doesn't need to know about the system ("sys") or power
+	 * modulation ("mod") clocks yet
+	 */
+
+	/* Set up raw & hw decoder */
+	error = img_ir_probe_raw(priv);
+	error2 = img_ir_probe_hw(priv);
+	if (error && error2)
+		return (error == -ENODEV) ? error2 : error;
+
+	/* Get the IRQ */
+	priv->irq = irq;
+	error = request_irq(priv->irq, img_ir_isr, 0, "img-ir", priv);
+	if (error) {
+		dev_err(&pdev->dev, "cannot register IRQ %u\n",
+			priv->irq);
+		error = -EIO;
+		goto err_irq;
+	}
+
+	img_ir_ident(priv);
+	img_ir_setup(priv);
+
+	return 0;
+
+err_irq:
+	img_ir_remove_hw(priv);
+	img_ir_remove_raw(priv);
+	return error;
+}
+
+static int img_ir_remove(struct platform_device *pdev)
+{
+	struct img_ir_priv *priv = platform_get_drvdata(pdev);
+
+	free_irq(priv->irq, img_ir_isr);
+	img_ir_remove_hw(priv);
+	img_ir_remove_raw(priv);
+
+	if (!IS_ERR(priv->clk))
+		clk_disable_unprepare(priv->clk);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(img_ir_pmops, img_ir_suspend, img_ir_resume);
+
+static const struct of_device_id img_ir_match[] = {
+	{ .compatible = "img,ir-rev1" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, img_ir_match);
+
+static struct platform_driver img_ir_driver = {
+	.driver = {
+		.name = "img-ir",
+		.owner	= THIS_MODULE,
+		.of_match_table	= img_ir_match,
+		.pm = &img_ir_pmops,
+	},
+	.probe = img_ir_probe,
+	.remove = img_ir_remove,
+};
+
+module_platform_driver(img_ir_driver);
+
+MODULE_AUTHOR("Imagination Technologies Ltd.");
+MODULE_DESCRIPTION("ImgTec IR");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/img-ir/img-ir.h b/drivers/media/rc/img-ir/img-ir.h
new file mode 100644
index 000000000000..afb189394af9
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir.h
@@ -0,0 +1,166 @@
+/*
+ * ImgTec IR Decoder found in PowerDown Controller.
+ *
+ * Copyright 2010-2014 Imagination Technologies Ltd.
+ */
+
+#ifndef _IMG_IR_H_
+#define _IMG_IR_H_
+
+#include <linux/io.h>
+#include <linux/spinlock.h>
+
+#include "img-ir-raw.h"
+#include "img-ir-hw.h"
+
+/* registers */
+
+/* relative to the start of the IR block of registers */
+#define IMG_IR_CONTROL		0x00
+#define IMG_IR_STATUS		0x04
+#define IMG_IR_DATA_LW		0x08
+#define IMG_IR_DATA_UP		0x0c
+#define IMG_IR_LEAD_SYMB_TIMING	0x10
+#define IMG_IR_S00_SYMB_TIMING	0x14
+#define IMG_IR_S01_SYMB_TIMING	0x18
+#define IMG_IR_S10_SYMB_TIMING	0x1c
+#define IMG_IR_S11_SYMB_TIMING	0x20
+#define IMG_IR_FREE_SYMB_TIMING	0x24
+#define IMG_IR_POW_MOD_PARAMS	0x28
+#define IMG_IR_POW_MOD_ENABLE	0x2c
+#define IMG_IR_IRQ_MSG_DATA_LW	0x30
+#define IMG_IR_IRQ_MSG_DATA_UP	0x34
+#define IMG_IR_IRQ_MSG_MASK_LW	0x38
+#define IMG_IR_IRQ_MSG_MASK_UP	0x3c
+#define IMG_IR_IRQ_ENABLE	0x40
+#define IMG_IR_IRQ_STATUS	0x44
+#define IMG_IR_IRQ_CLEAR	0x48
+#define IMG_IR_IRCORE_ID	0xf0
+#define IMG_IR_CORE_REV		0xf4
+#define IMG_IR_CORE_DES1	0xf8
+#define IMG_IR_CORE_DES2	0xfc
+
+
+/* field masks */
+
+/* IMG_IR_CONTROL */
+#define IMG_IR_DECODEN		0x40000000
+#define IMG_IR_CODETYPE		0x30000000
+#define IMG_IR_CODETYPE_SHIFT		28
+#define IMG_IR_HDRTOG		0x08000000
+#define IMG_IR_LDRDEC		0x04000000
+#define IMG_IR_DECODINPOL	0x02000000	/* active high */
+#define IMG_IR_BITORIEN		0x01000000	/* MSB first */
+#define IMG_IR_D1VALIDSEL	0x00008000
+#define IMG_IR_BITINV		0x00000040	/* don't invert */
+#define IMG_IR_DECODEND2	0x00000010
+#define IMG_IR_BITORIEND2	0x00000002	/* MSB first */
+#define IMG_IR_BITINVD2		0x00000001	/* don't invert */
+
+/* IMG_IR_STATUS */
+#define IMG_IR_RXDVALD2		0x00001000
+#define IMG_IR_IRRXD		0x00000400
+#define IMG_IR_TOGSTATE		0x00000200
+#define IMG_IR_RXDVAL		0x00000040
+#define IMG_IR_RXDLEN		0x0000003f
+#define IMG_IR_RXDLEN_SHIFT		0
+
+/* IMG_IR_LEAD_SYMB_TIMING, IMG_IR_Sxx_SYMB_TIMING */
+#define IMG_IR_PD_MAX		0xff000000
+#define IMG_IR_PD_MAX_SHIFT		24
+#define IMG_IR_PD_MIN		0x00ff0000
+#define IMG_IR_PD_MIN_SHIFT		16
+#define IMG_IR_W_MAX		0x0000ff00
+#define IMG_IR_W_MAX_SHIFT		8
+#define IMG_IR_W_MIN		0x000000ff
+#define IMG_IR_W_MIN_SHIFT		0
+
+/* IMG_IR_FREE_SYMB_TIMING */
+#define IMG_IR_MAXLEN		0x0007e000
+#define IMG_IR_MAXLEN_SHIFT		13
+#define IMG_IR_MINLEN		0x00001f00
+#define IMG_IR_MINLEN_SHIFT		8
+#define IMG_IR_FT_MIN		0x000000ff
+#define IMG_IR_FT_MIN_SHIFT		0
+
+/* IMG_IR_POW_MOD_PARAMS */
+#define IMG_IR_PERIOD_LEN	0x3f000000
+#define IMG_IR_PERIOD_LEN_SHIFT		24
+#define IMG_IR_PERIOD_DUTY	0x003f0000
+#define IMG_IR_PERIOD_DUTY_SHIFT	16
+#define IMG_IR_STABLE_STOP	0x00003f00
+#define IMG_IR_STABLE_STOP_SHIFT	8
+#define IMG_IR_STABLE_START	0x0000003f
+#define IMG_IR_STABLE_START_SHIFT	0
+
+/* IMG_IR_POW_MOD_ENABLE */
+#define IMG_IR_POWER_OUT_EN	0x00000002
+#define IMG_IR_POWER_MOD_EN	0x00000001
+
+/* IMG_IR_IRQ_ENABLE, IMG_IR_IRQ_STATUS, IMG_IR_IRQ_CLEAR */
+#define IMG_IR_IRQ_DEC2_ERR	0x00000080
+#define IMG_IR_IRQ_DEC_ERR	0x00000040
+#define IMG_IR_IRQ_ACT_LEVEL	0x00000020
+#define IMG_IR_IRQ_FALL_EDGE	0x00000010
+#define IMG_IR_IRQ_RISE_EDGE	0x00000008
+#define IMG_IR_IRQ_DATA_MATCH	0x00000004
+#define IMG_IR_IRQ_DATA2_VALID	0x00000002
+#define IMG_IR_IRQ_DATA_VALID	0x00000001
+#define IMG_IR_IRQ_ALL		0x000000ff
+#define IMG_IR_IRQ_EDGE		(IMG_IR_IRQ_FALL_EDGE | IMG_IR_IRQ_RISE_EDGE)
+
+/* IMG_IR_CORE_ID */
+#define IMG_IR_CORE_ID		0x00ff0000
+#define IMG_IR_CORE_ID_SHIFT		16
+#define IMG_IR_CORE_CONFIG	0x0000ffff
+#define IMG_IR_CORE_CONFIG_SHIFT	0
+
+/* IMG_IR_CORE_REV */
+#define IMG_IR_DESIGNER		0xff000000
+#define IMG_IR_DESIGNER_SHIFT		24
+#define IMG_IR_MAJOR_REV	0x00ff0000
+#define IMG_IR_MAJOR_REV_SHIFT		16
+#define IMG_IR_MINOR_REV	0x0000ff00
+#define IMG_IR_MINOR_REV_SHIFT		8
+#define IMG_IR_MAINT_REV	0x000000ff
+#define IMG_IR_MAINT_REV_SHIFT		0
+
+struct device;
+struct clk;
+
+/**
+ * struct img_ir_priv - Private driver data.
+ * @dev:		Platform device.
+ * @irq:		IRQ number.
+ * @clk:		Input clock.
+ * @reg_base:		Iomem base address of IR register block.
+ * @lock:		Protects IR registers and variables in this struct.
+ * @raw:		Driver data for raw decoder.
+ * @hw:			Driver data for hardware decoder.
+ */
+struct img_ir_priv {
+	struct device		*dev;
+	int			irq;
+	struct clk		*clk;
+	void __iomem		*reg_base;
+	spinlock_t		lock;
+
+	struct img_ir_priv_raw	raw;
+	struct img_ir_priv_hw	hw;
+};
+
+/* Hardware access */
+
+static inline void img_ir_write(struct img_ir_priv *priv,
+				unsigned int reg_offs, unsigned int data)
+{
+	iowrite32(data, priv->reg_base + reg_offs);
+}
+
+static inline unsigned int img_ir_read(struct img_ir_priv *priv,
+				       unsigned int reg_offs)
+{
+	return ioread32(priv->reg_base + reg_offs);
+}
+
+#endif /* _IMG_IR_H_ */
-- 
1.8.1.2


