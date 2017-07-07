Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59719 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbdGGJwC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:52:02 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 3/6] [media] rc: gpio-ir-tx: add new driver
Date: Fri,  7 Jul 2017 10:51:59 +0100
Message-Id: <92a66fd9852c3143d5726eb3869d58e28d841c84.1499419624.git.sean@mess.org>
In-Reply-To: <cover.1499419624.git.sean@mess.org>
References: <cover.1499419624.git.sean@mess.org>
In-Reply-To: <cover.1499419624.git.sean@mess.org>
References: <cover.1499419624.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a simple bit-banging GPIO IR TX driver.

Signed-off-by: Sean Young <sean@mess.org>
---
 MAINTAINERS                   |   6 ++
 drivers/media/rc/Kconfig      |  11 +++
 drivers/media/rc/Makefile     |   1 +
 drivers/media/rc/gpio-ir-tx.c | 189 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 207 insertions(+)
 create mode 100644 drivers/media/rc/gpio-ir-tx.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c4be6d4..8a37c2f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5667,6 +5667,12 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/goodix.c
 
+GPIO IR Transmitter
+M:	Sean Young <sean@mess.org>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/rc/gpio-ir-tx.c
+
 GPIO MOCKUP DRIVER
 M:	Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
 L:	linux-gpio@vger.kernel.org
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index b6433c5..ef767d1 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -399,6 +399,17 @@ config IR_GPIO_CIR
 	   To compile this driver as a module, choose M here: the module will
 	   be called gpio-ir-recv.
 
+config IR_GPIO_TX
+	tristate "GPIO IR bit banging transmitter"
+	depends on RC_CORE
+	depends on LIRC
+	---help---
+	   Say Y if you want to a GPIO based IR transmitter. This is a
+	   bit banging driver.
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called gpio-ir-tx.
+
 config RC_ST
 	tristate "ST remote control receiver"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 245e2c2..3e64a4e 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
 obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
 obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
 obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
+obj-$(CONFIG_IR_GPIO_TX) += gpio-ir-tx.o
 obj-$(CONFIG_IR_IGORPLUGUSB) += igorplugusb.o
 obj-$(CONFIG_IR_IGUANA) += iguanair.o
 obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
new file mode 100644
index 0000000..7a5371d
--- /dev/null
+++ b/drivers/media/rc/gpio-ir-tx.c
@@ -0,0 +1,189 @@
+/*
+ * Copyright (C) 2017 Sean Young <sean@mess.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <media/rc-core.h>
+
+#define DRIVER_NAME	"gpio-ir-tx"
+#define DEVICE_NAME	"GPIO Bit Banging IR Transmitter"
+
+struct gpio_ir {
+	int gpio_nr;
+	bool active_low;
+	unsigned int carrier;
+	unsigned int duty_cycle;
+	/* we need a spinlock to hold the cpu while transmitting */
+	spinlock_t lock;
+};
+
+static const struct of_device_id gpio_ir_tx_of_match[] = {
+	{ .compatible = "gpio-ir-tx", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, gpio_ir_tx_of_match);
+
+static int gpio_ir_tx_set_duty_cycle(struct rc_dev *dev, u32 duty_cycle)
+{
+	struct gpio_ir *gpio_ir = dev->priv;
+
+	gpio_ir->duty_cycle = duty_cycle;
+
+	return 0;
+}
+
+static int gpio_ir_tx_set_carrier(struct rc_dev *dev, u32 carrier)
+{
+	struct gpio_ir *gpio_ir = dev->priv;
+
+	if (!carrier)
+		return -EINVAL;
+
+	gpio_ir->carrier = carrier;
+
+	return 0;
+}
+
+static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
+		      unsigned int count)
+{
+	struct gpio_ir *gpio_ir = dev->priv;
+	unsigned long flags;
+	ktime_t edge;
+	/*
+	 * delta should never exceed 0.5 seconds (IR_MAX_DURATION) and on
+	 * m68k ndelay(s64) does not compile; so use s32 rather than s64.
+	 */
+	s32 delta;
+	int i;
+	unsigned int pulse, space;
+
+	/* Ensure the dividend fits into 32 bit */
+	pulse = DIV_ROUND_CLOSEST(gpio_ir->duty_cycle * (NSEC_PER_SEC / 100),
+				  gpio_ir->carrier);
+	space = DIV_ROUND_CLOSEST((100 - gpio_ir->duty_cycle) *
+				  (NSEC_PER_SEC / 100), gpio_ir->carrier);
+
+	spin_lock_irqsave(&gpio_ir->lock, flags);
+
+	edge = ktime_get();
+
+	for (i = 0; i < count; i++) {
+		if (i % 2) {
+			// space
+			edge = ktime_add_us(edge, txbuf[i]);
+			delta = ktime_us_delta(edge, ktime_get());
+			if (delta > 10) {
+				spin_unlock_irqrestore(&gpio_ir->lock, flags);
+				usleep_range(delta, delta + 10);
+				spin_lock_irqsave(&gpio_ir->lock, flags);
+			} else if (delta > 0) {
+				udelay(delta);
+			}
+		} else {
+			// pulse
+			ktime_t last = ktime_add_us(edge, txbuf[i]);
+
+			while (ktime_get() < last) {
+				gpio_set_value(gpio_ir->gpio_nr,
+					       gpio_ir->active_low);
+				edge += pulse;
+				delta = edge - ktime_get();
+				if (delta > 0)
+					ndelay(delta);
+				gpio_set_value(gpio_ir->gpio_nr,
+					       !gpio_ir->active_low);
+				edge += space;
+				delta = edge - ktime_get();
+				if (delta > 0)
+					ndelay(delta);
+			}
+
+			edge = last;
+		}
+	}
+
+	spin_unlock_irqrestore(&gpio_ir->lock, flags);
+
+	return count;
+}
+
+static int gpio_ir_tx_probe(struct platform_device *pdev)
+{
+	struct gpio_ir *gpio_ir;
+	struct rc_dev *rcdev;
+	enum of_gpio_flags flags;
+	int rc, gpio;
+
+	gpio = of_get_gpio_flags(pdev->dev.of_node, 0, &flags);
+	if (gpio < 0) {
+		if (gpio != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get gpio flags (%d)\n",
+				gpio);
+		return -EINVAL;
+	}
+
+	gpio_ir = devm_kmalloc(&pdev->dev, sizeof(*gpio_ir), GFP_KERNEL);
+	if (!gpio_ir)
+		return -ENOMEM;
+
+	rcdev = devm_rc_allocate_device(&pdev->dev, RC_DRIVER_IR_RAW_TX);
+	if (!rcdev)
+		return -ENOMEM;
+
+	rcdev->priv = gpio_ir;
+	rcdev->driver_name = DRIVER_NAME;
+	rcdev->device_name = DEVICE_NAME;
+	rcdev->tx_ir = gpio_ir_tx;
+	rcdev->s_tx_duty_cycle = gpio_ir_tx_set_duty_cycle;
+	rcdev->s_tx_carrier = gpio_ir_tx_set_carrier;
+
+	gpio_ir->gpio_nr = gpio;
+	gpio_ir->active_low = (flags & OF_GPIO_ACTIVE_LOW) != 0;
+	gpio_ir->carrier = 38000;
+	gpio_ir->duty_cycle = 50;
+	spin_lock_init(&gpio_ir->lock);
+
+	rc = devm_gpio_request(&pdev->dev, gpio, "gpio-ir-tx");
+	if (rc < 0)
+		return rc;
+
+	rc = gpio_direction_output(gpio, !gpio_ir->active_low);
+	if (rc < 0)
+		return rc;
+
+	rc = devm_rc_register_device(&pdev->dev, rcdev);
+	if (rc < 0)
+		dev_err(&pdev->dev, "failed to register rc device\n");
+
+	return rc;
+}
+
+static struct platform_driver gpio_ir_tx_driver = {
+	.probe	= gpio_ir_tx_probe,
+	.driver = {
+		.name	= DRIVER_NAME,
+		.of_match_table = of_match_ptr(gpio_ir_tx_of_match),
+	},
+};
+module_platform_driver(gpio_ir_tx_driver);
+
+MODULE_DESCRIPTION("GPIO Bit Banging IR Transmitter");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_LICENSE("GPL");
-- 
2.9.4
