Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:59852 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZK0BeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 20:34:24 -0500
Subject: [IR-RFC PATCH v4 4/6] GPT driver for in-kernel IR support.
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
From: Jon Smirl <jonsmirl@gmail.com>
Date: Thu, 26 Nov 2009 20:34:27 -0500
Message-ID: <20091127013427.7671.52935.stgit@terra>
In-Reply-To: <20091127013217.7671.32355.stgit@terra>
References: <20091127013217.7671.32355.stgit@terra>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

GPT is a GPIO pin that is cable able of measuring the lenght of pulses.
GPTs are common on embedded systems
---
 drivers/input/ir/Kconfig  |    6 +
 drivers/input/ir/Makefile |    3 +
 drivers/input/ir/ir-gpt.c |  184 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 193 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/ir/ir-gpt.c

diff --git a/drivers/input/ir/Kconfig b/drivers/input/ir/Kconfig
index a6f3f25..172c0c6 100644
--- a/drivers/input/ir/Kconfig
+++ b/drivers/input/ir/Kconfig
@@ -12,4 +12,10 @@ menuconfig INPUT_IR
 
 if INPUT_IR
 
+config IR_GPT
+	tristate "GPT Based IR Receiver"
+	default m
+	help
+	  Driver for GPT-based IR receiver found on Digispeaker
+
 endif
diff --git a/drivers/input/ir/Makefile b/drivers/input/ir/Makefile
index 2ccdda3..ab0da3f 100644
--- a/drivers/input/ir/Makefile
+++ b/drivers/input/ir/Makefile
@@ -6,3 +6,6 @@
 obj-$(CONFIG_INPUT_IR)		+= ir.o
 ir-objs := ir-core.o ir-configfs.o
 
+
+obj-$(CONFIG_IR_GPT)		+= ir-gpt.o
+
diff --git a/drivers/input/ir/ir-gpt.c b/drivers/input/ir/ir-gpt.c
new file mode 100644
index 0000000..41d2fa6
--- /dev/null
+++ b/drivers/input/ir/ir-gpt.c
@@ -0,0 +1,184 @@
+/*
+ * GPT timer based IR device
+ *
+ * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>
+ */
+
+#define DEBUG
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/input.h>
+#include <asm/io.h>
+#include <asm/mpc52xx.h>
+
+struct ir_gpt {
+	struct input_dev *input;
+	int irq, previous;
+	struct mpc52xx_gpt __iomem *regs;
+};
+
+/*
+ * Interrupt handlers
+ */
+static irqreturn_t dpeak_ir_irq(int irq, void *_ir)
+{
+	struct ir_gpt *ir_gpt = _ir;
+	int sample, count, delta, bit, wrap;
+
+	sample = in_be32(&ir_gpt->regs->status);
+	out_be32(&ir_gpt->regs->status, 0xF);
+
+	count = sample >> 16;
+	wrap = (sample >> 12) & 7;
+	bit = (sample >> 8) & 1;
+
+	delta = count - ir_gpt->previous;
+	delta += wrap * 0x10000;
+
+	ir_gpt->previous = count;
+
+	if (bit)
+		delta = -delta;
+
+	input_ir_queue(ir_gpt->input, delta);
+
+	return IRQ_HANDLED;
+}
+
+
+/* ---------------------------------------------------------------------
+ * OF platform bus binding code:
+ * - Probe/remove operations
+ * - OF device match table
+ */
+static int __devinit ir_gpt_of_probe(struct of_device *op,
+				      const struct of_device_id *match)
+{
+	struct ir_gpt *ir_gpt;
+	struct resource res;
+	int ret, rc;
+
+	dev_dbg(&op->dev, "ir_gpt_of_probe\n");
+
+	/* Allocate and initialize the driver private data */
+	ir_gpt = kzalloc(sizeof *ir_gpt, GFP_KERNEL);
+	if (!ir_gpt)
+		return -ENOMEM;
+
+	ir_gpt->input = input_allocate_device();
+	if (!ir_gpt->input) {
+		ret = -ENOMEM;
+		goto free_mem;
+	}
+	ret = input_ir_create(ir_gpt->input, ir_gpt, NULL);
+	if (ret)
+		goto free_input;
+
+	ir_gpt->input->id.bustype = BUS_HOST;
+	ir_gpt->input->name = "GPT IR Receiver";
+
+	ir_gpt->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_36K);
+	ir_gpt->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_38K);
+	ir_gpt->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_40K);
+	ir_gpt->input->irbit[0] |= BIT_MASK(IR_CAP_RECEIVE_RAW);
+
+	ret = input_register_device(ir_gpt->input);
+	if (ret)
+		goto free_input;
+	ret = input_ir_register(ir_gpt->input);
+	if (ret)
+		goto free_input;
+
+	/* Fetch the registers and IRQ of the GPT */
+	if (of_address_to_resource(op->node, 0, &res)) {
+		dev_err(&op->dev, "Missing reg property\n");
+		ret = -ENODEV;
+		goto free_input;
+	}
+	ir_gpt->regs = ioremap(res.start, 1 + res.end - res.start);
+	if (!ir_gpt->regs) {
+		dev_err(&op->dev, "Could not map registers\n");
+		ret = -ENODEV;
+		goto free_input;
+	}
+	ir_gpt->irq = irq_of_parse_and_map(op->node, 0);
+	if (ir_gpt->irq == NO_IRQ) {
+		ret = -ENODEV;
+		goto free_input;
+	}
+	dev_dbg(&op->dev, "ir_gpt_of_probe irq=%d\n", ir_gpt->irq);
+
+	rc = request_irq(ir_gpt->irq, &dpeak_ir_irq, IRQF_SHARED,
+			 "gpt-ir", ir_gpt);
+	dev_dbg(&op->dev, "ir_gpt_of_probe request irq rc=%d\n", rc);
+
+	/* set prescale to ? */
+	out_be32(&ir_gpt->regs->count, 0x00870000);
+
+	/* Select input capture, enable the counter, and interrupt */
+	out_be32(&ir_gpt->regs->mode, 0x0);
+	out_be32(&ir_gpt->regs->mode, 0x00000501);
+
+	/* Save what we've done so it can be found again later */
+	dev_set_drvdata(&op->dev, ir_gpt);
+
+	printk("GPT IR Receiver driver\n");
+
+	return 0;
+
+free_input:
+	input_free_device(ir_gpt->input);
+free_mem:
+	kfree(ir_gpt);
+	return ret;
+}
+
+static int __devexit ir_gpt_of_remove(struct of_device *op)
+{
+	struct ir_gpt *ir_gpt = dev_get_drvdata(&op->dev);
+
+	dev_dbg(&op->dev, "ir_gpt_remove()\n");
+
+	input_unregister_device(ir_gpt->input);
+	kfree(ir_gpt);
+	dev_set_drvdata(&op->dev, NULL);
+
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id ir_gpt_match[] __devinitdata = {
+	{ .compatible = "gpt-ir", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, ir_gpt_match);
+
+static struct of_platform_driver ir_gpt_driver = {
+	.match_table = ir_gpt_match,
+	.probe = ir_gpt_of_probe,
+	.remove = __devexit_p(ir_gpt_of_remove),
+	.driver = {
+		.name = "ir-gpt",
+		.owner = THIS_MODULE,
+	},
+};
+
+/* ---------------------------------------------------------------------
+ * Module setup and teardown; simply register the of_platform driver
+ */
+static int __init ir_gpt_init(void)
+{
+	return of_register_platform_driver(&ir_gpt_driver);
+}
+module_init(ir_gpt_init);
+
+static void __exit ir_gpt_exit(void)
+{
+	of_unregister_platform_driver(&ir_gpt_driver);
+}
+module_exit(ir_gpt_exit);

