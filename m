Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48337 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbdGBLGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Jul 2017 07:06:15 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: [PATCH 4/4] [media] rc: pwm-ir-tx: add new driver
Date: Sun,  2 Jul 2017 12:06:13 +0100
Message-Id: <88fa0219db3388fad7bcc7b20cf30dd41e763aee.1498992850.git.sean@mess.org>
In-Reply-To: <cover.1498992850.git.sean@mess.org>
References: <cover.1498992850.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is new driver which uses pwm, so it is more power-efficient
than the bit banging gpio-ir-tx driver.

Signed-off-by: Sean Young <sean@mess.org>
---
 .../devicetree/bindings/leds/irled/pwm-ir-tx.txt   |  13 ++
 drivers/media/rc/Kconfig                           |  12 ++
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/pwm-ir-tx.c                       | 165 +++++++++++++++++++++
 4 files changed, 191 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
 create mode 100644 drivers/media/rc/pwm-ir-tx.c

diff --git a/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
new file mode 100644
index 0000000..6887a71
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
@@ -0,0 +1,13 @@
+Device tree bindings for IR LED connected through pwm pin which is used as
+IR transmitter.
+
+Required properties:
+- compatible: should be "pwm-ir-tx".
+- pwms : PWM property to point to the PWM device (phandle)/port (id) and to
+  specify the period time to be used: <&phandle id period_ns>;
+
+Example:
+	irled {
+		compatible = "pwm-ir-tx";
+		pwms = <&pwm0 0 10000000>;
+	};
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index ad54011..c5338e3 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -399,6 +399,18 @@ config IR_GPIO_TX
 	   To compile this driver as a module, choose M here: the module will
 	   be called gpio-ir-tx.
 
+config IR_PWM_TX
+	tristate "PWM IR transmitter"
+	depends on RC_CORE
+	depends on LIRC
+	depends on PWM
+	---help---
+	   Say Y if you want to use a PWM based IR transmitter. This is
+	   more power efficient than the bit banging gpio driver.
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called pwm-ir-tx.
+
 config RC_ST
 	tristate "ST remote control receiver"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 3e64a4e..466c402 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
 obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
 obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
 obj-$(CONFIG_IR_GPIO_TX) += gpio-ir-tx.o
+obj-$(CONFIG_IR_PWM_TX) += pwm-ir-tx.o
 obj-$(CONFIG_IR_IGORPLUGUSB) += igorplugusb.o
 obj-$(CONFIG_IR_IGUANA) += iguanair.o
 obj-$(CONFIG_IR_TTUSBIR) += ttusbir.o
diff --git a/drivers/media/rc/pwm-ir-tx.c b/drivers/media/rc/pwm-ir-tx.c
new file mode 100644
index 0000000..1ab10b4
--- /dev/null
+++ b/drivers/media/rc/pwm-ir-tx.c
@@ -0,0 +1,165 @@
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
+#include <linux/pwm.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <media/rc-core.h>
+
+#define DRIVER_NAME	"pwm-ir-tx"
+#define DEVICE_NAME	"PWM IR Transmitter"
+
+struct pwm_ir {
+	struct pwm_device *pwm;
+	unsigned int carrier;
+	unsigned int duty_cycle;
+	/* One transmission at a time */
+	struct mutex lock;
+};
+
+static const struct of_device_id pwm_ir_of_match[] = {
+	{ .compatible = "pwm-ir-tx", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pwm_ir_of_match);
+
+static int pwm_ir_set_duty_cycle(struct rc_dev *dev, u32 duty_cycle)
+{
+	struct pwm_ir *pwm_ir = dev->priv;
+
+	pwm_ir->duty_cycle = duty_cycle;
+
+	return 0;
+}
+
+static int pwm_ir_set_carrier(struct rc_dev *dev, u32 carrier)
+{
+	struct pwm_ir *pwm_ir = dev->priv;
+
+	if (!carrier)
+		return -EINVAL;
+
+	pwm_ir->carrier = carrier;
+
+	return 0;
+}
+
+static int pwm_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
+		     unsigned int count)
+{
+	struct pwm_ir *pwm_ir = dev->priv;
+	struct pwm_device *pwm = pwm_ir->pwm;
+	int i, duty, period;
+	ktime_t edge;
+	s64 delta;
+
+	if (mutex_lock_interruptible(&pwm_ir->lock))
+		return -ERESTARTSYS;
+
+	period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, pwm_ir->carrier);
+	duty = DIV_ROUND_CLOSEST(pwm_ir->duty_cycle * period, 100);
+
+	pwm_config(pwm, duty, period);
+
+	edge = ktime_get();
+
+	for (i = 0; i < count; i++) {
+		if (i % 2) // space
+			pwm_disable(pwm);
+		else
+			pwm_enable(pwm);
+
+		edge = ktime_add_us(edge, txbuf[i]);
+		delta = ktime_us_delta(edge, ktime_get());
+		if (delta > 0)
+			usleep_range(delta, delta + 10);
+	}
+
+	pwm_disable(pwm);
+
+	mutex_unlock(&pwm_ir->lock);
+
+	return count;
+}
+
+static int pwm_ir_probe(struct platform_device *pdev)
+{
+	struct pwm_ir *pwm_ir;
+	struct rc_dev *rcdev;
+	int rc;
+
+	pwm_ir = devm_kzalloc(&pdev->dev, sizeof(*pwm_ir), GFP_KERNEL);
+	if (!pwm_ir)
+		return -ENOMEM;
+
+	pwm_ir->pwm = devm_pwm_get(&pdev->dev, NULL);
+	if (IS_ERR(pwm_ir->pwm))
+		return PTR_ERR(pwm_ir->pwm);
+
+	pwm_ir->carrier = 38000;
+	pwm_ir->duty_cycle = 50;
+	mutex_init(&pwm_ir->lock);
+
+	rcdev = devm_rc_allocate_device(&pdev->dev, RC_DRIVER_IR_RAW_TX);
+	if (!rcdev)
+		return -ENOMEM;
+
+	rcdev->priv = pwm_ir;
+	rcdev->driver_name = DRIVER_NAME;
+	rcdev->device_name = DEVICE_NAME;
+	rcdev->tx_ir = pwm_ir_tx;
+	rcdev->s_tx_duty_cycle = pwm_ir_set_duty_cycle;
+	rcdev->s_tx_carrier = pwm_ir_set_carrier;
+
+	rc = devm_rc_register_device(&pdev->dev, rcdev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "failed to register rc device\n");
+		return rc;
+	}
+
+	platform_set_drvdata(pdev, pwm_ir);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int pwm_ir_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct pwm_ir *pwm_ir = platform_get_drvdata(dev);
+
+	if (mutex_is_locked(&pwm_ir->lock))
+		return -EAGAIN;
+
+	return 0;
+}
+#else
+#define pwm_ir_suspend NULL
+#endif
+
+static struct platform_driver pwm_ir_driver = {
+	.probe = pwm_ir_probe,
+	.suspend = pwm_ir_suspend,
+	.driver = {
+		.name	= DRIVER_NAME,
+		.of_match_table = of_match_ptr(pwm_ir_of_match),
+	},
+};
+module_platform_driver(pwm_ir_driver);
+
+MODULE_DESCRIPTION("PWM IR Transmitter");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_LICENSE("GPL");
-- 
2.9.4
