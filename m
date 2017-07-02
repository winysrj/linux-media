Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48337 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752183AbdGBLGN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Jul 2017 07:06:13 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 3/4] [media] rc: gpio-ir-tx: add new driver
Date: Sun,  2 Jul 2017 12:06:11 +0100
Message-Id: <616e336df6badc96ced14d14956ed7c080b39781.1498992850.git.sean@mess.org>
In-Reply-To: <cover.1498992850.git.sean@mess.org>
References: <cover.1498992850.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a simple bit-banging GPIO IR TX driver.

Signed-off-by: Sean Young <sean@mess.org>
---
 .../devicetree/bindings/leds/irled/gpio-ir-tx.txt  |  11 ++
 drivers/media/rc/Kconfig                           |  11 ++
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/gpio-ir-tx.c                      | 189 +++++++++++++++++++++
 4 files changed, 212 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
 create mode 100644 drivers/media/rc/gpio-ir-tx.c

diff --git a/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
new file mode 100644
index 0000000..bf4d4fb
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
@@ -0,0 +1,11 @@
+Device tree bindings for IR LED connected through gpio pin which is used as
+IR transmitter.
+
+Required properties:
+	- compatible: should be "gpio-ir-tx".
+
+Example:
+	irled@0 {
+		compatible = "gpio-ir-tx";
+		gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
+	};
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 5e83b76..ad54011 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -388,6 +388,17 @@ config IR_GPIO_CIR
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
index 0000000..c2ea002
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
+#define DEVICE_NAME	"GPIO IR Bit Banging Transmitter"
+
+struct gpio_rc_dev {
+	int gpio_nr;
+	unsigned int carrier;
+	unsigned int duty_cycle;
+	bool active_low;
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
+	struct gpio_rc_dev *gpio_dev = dev->priv;
+
+	gpio_dev->duty_cycle = duty_cycle;
+
+	return 0;
+}
+
+static int gpio_ir_tx_set_carrier(struct rc_dev *dev, u32 carrier)
+{
+	struct gpio_rc_dev *gpio_dev = dev->priv;
+
+	if (!carrier)
+		return -EINVAL;
+
+	gpio_dev->carrier = carrier;
+
+	return 0;
+}
+
+static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
+		      unsigned int count)
+{
+	struct gpio_rc_dev *gpio_dev = dev->priv;
+	unsigned long flags;
+	ktime_t edge;
+	s64 delta;
+	int i;
+	unsigned int pulse, space;
+
+	/* Ensure the dividend fits into 32 bit */
+	pulse = DIV_ROUND_CLOSEST(gpio_dev->duty_cycle * (NSEC_PER_SEC / 100),
+				  gpio_dev->carrier);
+	space = DIV_ROUND_CLOSEST((100l - gpio_dev->duty_cycle) *
+				  (NSEC_PER_SEC / 100), gpio_dev->carrier);
+
+	spin_lock_irqsave(&gpio_dev->lock, flags);
+
+	edge = ktime_get();
+
+	for (i = 0; i < count; i++) {
+		if (i % 2) {
+			// space
+			edge = ktime_add_us(edge, txbuf[i]);
+			delta = ktime_us_delta(edge, ktime_get());
+			if (delta > 10) {
+				spin_unlock_irqrestore(&gpio_dev->lock, flags);
+				usleep_range(delta - 10, delta + 10);
+				spin_lock_irqsave(&gpio_dev->lock, flags);
+			} else if (delta > 0) {
+				udelay(delta);
+			}
+		} else {
+			// pulse
+			ktime_t last = ktime_add_us(edge, txbuf[i]);
+
+			while (ktime_get() < last) {
+				gpio_set_value(gpio_dev->gpio_nr,
+					       gpio_dev->active_low);
+				edge += pulse;
+				delta = ktime_sub(edge, ktime_get());
+				if (delta > 0)
+					ndelay(delta);
+				gpio_set_value(gpio_dev->gpio_nr,
+					       !gpio_dev->active_low);
+				edge += space;
+				delta = ktime_sub(edge, ktime_get());
+				if (delta > 0)
+					ndelay(delta);
+			}
+
+			edge = last;
+		}
+	}
+
+	spin_unlock_irqrestore(&gpio_dev->lock, flags);
+
+	return count;
+}
+
+static int gpio_ir_tx_probe(struct platform_device *pdev)
+{
+	struct gpio_rc_dev *gpio_dev;
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
+	gpio_dev = devm_kzalloc(&pdev->dev, sizeof(*gpio_dev), GFP_KERNEL);
+	if (!gpio_dev)
+		return -ENOMEM;
+
+	rcdev = devm_rc_allocate_device(&pdev->dev, RC_DRIVER_IR_RAW_TX);
+	if (!rcdev)
+		return -ENOMEM;
+
+	rcdev->priv = gpio_dev;
+	rcdev->driver_name = DRIVER_NAME;
+	rcdev->device_name = DEVICE_NAME;
+	rcdev->tx_ir = gpio_ir_tx;
+	rcdev->s_tx_duty_cycle = gpio_ir_tx_set_duty_cycle;
+	rcdev->s_tx_carrier = gpio_ir_tx_set_carrier;
+
+	gpio_dev->gpio_nr = gpio;
+	gpio_dev->active_low = (flags & OF_GPIO_ACTIVE_LOW) != 0;
+	spin_lock_init(&gpio_dev->lock);
+	gpio_dev->carrier = 38000;
+	gpio_dev->duty_cycle = 50;
+
+	rc = devm_gpio_request(&pdev->dev, gpio, "gpio-ir-tx");
+	if (rc < 0)
+		return rc;
+
+	rc = gpio_direction_output(gpio, !gpio_dev->active_low);
+	if (rc < 0)
+		return rc;
+
+	rc = devm_rc_register_device(&pdev->dev, rcdev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "failed to register rc device\n");
+		return rc;
+	}
+
+	platform_set_drvdata(pdev, gpio_dev);
+
+	return 0;
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
+MODULE_DESCRIPTION("GPIO IR Bit Banging Transmitter");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_LICENSE("GPL");
-- 
2.9.4
