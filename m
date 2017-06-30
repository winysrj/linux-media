Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59769 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752047AbdF3OfV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 10:35:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Eric Anholt <eric@anholt.net>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/12] cec-gpio: add CEC GPIO driver
Date: Fri, 30 Jun 2017 16:35:07 +0200
Message-Id: <20170630143509.56029-11-hverkuil@xs4all.nl>
In-Reply-To: <20170630143509.56029-1-hverkuil@xs4all.nl>
References: <20170630143509.56029-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a simple CEC GPIO driver that sits on top of the cec-pin framework.

Mostly done, but is missing optional cec-notifier integration (that's
currently commented out).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig             |  10 ++
 drivers/media/platform/Makefile            |   2 +
 drivers/media/platform/cec-gpio/Makefile   |   1 +
 drivers/media/platform/cec-gpio/cec-gpio.c | 214 +++++++++++++++++++++++++++++
 4 files changed, 227 insertions(+)
 create mode 100644 drivers/media/platform/cec-gpio/Makefile
 create mode 100644 drivers/media/platform/cec-gpio/cec-gpio.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 1313cd533436..f570a2b3749c 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -536,6 +536,16 @@ menuconfig CEC_PLATFORM_DRIVERS
 
 if CEC_PLATFORM_DRIVERS
 
+config CEC_GPIO
+	tristate "Generic GPIO-based CEC driver"
+	depends on PREEMPT
+	select CEC_CORE
+	select CEC_PIN
+	---help---
+	  This is a generic GPIO-based CEC driver.
+	  The CEC bus is present in the HDMI connector and enables communication
+	  between compatible devices.
+
 config VIDEO_SAMSUNG_S5P_CEC
        tristate "Samsung S5P CEC driver"
        depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 9beadc760467..d01cc1886ad1 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -26,6 +26,8 @@ obj-$(CONFIG_VIDEO_CODA) 		+= coda/
 
 obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
 
+obj-$(CONFIG_CEC_GPIO)			+= cec-gpio/
+
 obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
 
 obj-$(CONFIG_VIDEO_MUX)			+= video-mux.o
diff --git a/drivers/media/platform/cec-gpio/Makefile b/drivers/media/platform/cec-gpio/Makefile
new file mode 100644
index 000000000000..e82b258afa55
--- /dev/null
+++ b/drivers/media/platform/cec-gpio/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_CEC_GPIO) += cec-gpio.o
diff --git a/drivers/media/platform/cec-gpio/cec-gpio.c b/drivers/media/platform/cec-gpio/cec-gpio.c
new file mode 100644
index 000000000000..dd08095d3ded
--- /dev/null
+++ b/drivers/media/platform/cec-gpio/cec-gpio.c
@@ -0,0 +1,214 @@
+/*
+ * Copyright 2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of_gpio.h>
+#include <media/cec-pin.h>
+
+struct cec_gpio {
+	struct cec_adapter	*adap;
+	struct device		*dev;
+	int gpio;
+	//struct cec_notifier	*notifier;
+	int			irq;
+	bool			is_low;
+	bool			have_irq;
+};
+
+static bool cec_gpio_read(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (cec->is_low)
+		return false;
+	return gpio_get_value(cec->gpio);
+}
+
+static void cec_gpio_high(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (!cec->is_low)
+		return;
+	cec->is_low = false;
+	gpio_direction_input(cec->gpio);
+}
+
+static void cec_gpio_low(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (cec->is_low)
+		return;
+	if (WARN_ON_ONCE(cec->have_irq))
+		free_irq(cec->irq, cec);
+	cec->have_irq = false;
+	cec->is_low = true;
+	gpio_direction_output(cec->gpio, 0);
+}
+
+static irqreturn_t cec_gpio_irq_handler(int irq, void *priv)
+{
+	struct cec_gpio *cec = priv;
+
+	cec_pin_changed(cec->adap, gpio_get_value(cec->gpio));
+	return IRQ_HANDLED;
+}
+
+static bool cec_gpio_enable_irq(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (request_irq(cec->irq, cec_gpio_irq_handler,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+			adap->name, cec))
+		return false;
+	cec->have_irq = true;
+	return true;
+}
+
+static void cec_gpio_disable_irq(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (cec->have_irq)
+		free_irq(cec->irq, cec);
+	cec->have_irq = false;
+}
+
+static void cec_gpio_status(struct cec_adapter *adap, struct seq_file *file)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	seq_printf(file, "mode:   %s\n", cec->is_low ? "low-drive" : "read");
+	if (cec->have_irq)
+		seq_printf(file, "using irq: %d\n", cec->irq);
+}
+
+static void cec_gpio_free(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (cec->have_irq)
+		cec_gpio_disable_irq(adap);
+}
+
+static const struct cec_pin_ops cec_gpio_pin_ops = {
+	.read = cec_gpio_read,
+	.low = cec_gpio_low,
+	.high = cec_gpio_high,
+	.enable_irq = cec_gpio_enable_irq,
+	.disable_irq = cec_gpio_disable_irq,
+	.status = cec_gpio_status,
+	.free = cec_gpio_free,
+};
+
+static int cec_gpio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	enum of_gpio_flags hpd_gpio_flags;
+	struct cec_gpio *cec;
+	//struct device_node *np;
+	//struct platform_device *hdmi_dev;
+	int ret;
+
+	cec = devm_kzalloc(dev, sizeof(*cec), GFP_KERNEL);
+	if (!cec)
+		return -ENOMEM;
+
+	cec->gpio = of_get_named_gpio_flags(dev->of_node,
+					    "gpio", 0, &hpd_gpio_flags);
+	if (cec->gpio < 0)
+		return cec->gpio;
+
+	cec->irq = gpio_to_irq(cec->gpio);
+	gpio_direction_input(cec->gpio);
+#if 0
+	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
+
+	if (!np) {
+		dev_err(&pdev->dev, "Failed to find hdmi node in device tree\n");
+		return -ENODEV;
+	}
+
+	hdmi_dev = of_find_device_by_node(np);
+	if (!hdmi_dev)
+		return -EPROBE_DEFER;
+
+	cec->notifier = cec_notifier_get(&hdmi_dev->dev);
+	if (!cec->notifier)
+		return -ENOMEM;
+#endif
+	cec->dev = dev;
+
+	cec->adap = cec_pin_allocate_adapter(&cec_gpio_pin_ops,
+		cec, pdev->name, CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC | CEC_CAP_MONITOR_ALL |
+		CEC_CAP_PHYS_ADDR | CEC_CAP_MONITOR_PIN);
+	ret = PTR_ERR_OR_ZERO(cec->adap);
+	if (ret)
+		return ret;
+
+	ret = cec_register_adapter(cec->adap, &pdev->dev);
+	if (ret) {
+		cec_delete_adapter(cec->adap);
+		return ret;
+	}
+
+	//cec_register_cec_notifier(cec->adap, cec->notifier);
+
+	platform_set_drvdata(pdev, cec);
+	return 0;
+}
+
+static int cec_gpio_remove(struct platform_device *pdev)
+{
+	struct cec_gpio *cec = platform_get_drvdata(pdev);
+
+	cec_unregister_adapter(cec->adap);
+	//cec_notifier_put(cec->notifier);
+
+	return 0;
+}
+
+static const struct of_device_id cec_gpio_match[] = {
+	{
+		.compatible	= "cec-gpio",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, cec_gpio_match);
+
+static struct platform_driver cec_gpio_pdrv = {
+	.probe	= cec_gpio_probe,
+	.remove = cec_gpio_remove,
+	.driver = {
+		.name		= "cec-gpio",
+		.of_match_table	= cec_gpio_match,
+	},
+};
+
+module_platform_driver(cec_gpio_pdrv);
+
+MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("GPIO CEC driver");
-- 
2.11.0
