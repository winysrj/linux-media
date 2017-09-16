Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:33722 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751369AbdIPO2e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 10:28:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 4/5] cec-gpio: add HDMI CEC GPIO driver
Date: Sat, 16 Sep 2017 16:28:26 +0200
Message-Id: <20170916142827.5878-5-hverkuil@xs4all.nl>
In-Reply-To: <20170916142827.5878-1-hverkuil@xs4all.nl>
References: <20170916142827.5878-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a simple HDMI CEC GPIO driver that sits on top of the cec-pin framework.

While I have heard of SoCs that use the GPIO pin for CEC (apparently an
early RockChip SoC used that), the main use-case of this driver is to
function as a debugging tool.

By connecting the CEC line to a GPIO pin on a Raspberry Pi 3 for example
it turns it into a CEC debugger and protocol analyzer.

With 'cec-ctl --monitor-pin' the CEC traffic can be analyzed.

But of course it can also be used with any hardware project where the
HDMI CEC line is hooked up to a pull-up gpio line.

In addition this has (optional) support for tracing HPD changes if the
HPD is connected to a GPIO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Kconfig             |  10 ++
 drivers/media/platform/Makefile            |   2 +
 drivers/media/platform/cec-gpio/Makefile   |   1 +
 drivers/media/platform/cec-gpio/cec-gpio.c | 236 +++++++++++++++++++++++++++++
 4 files changed, 249 insertions(+)
 create mode 100644 drivers/media/platform/cec-gpio/Makefile
 create mode 100644 drivers/media/platform/cec-gpio/cec-gpio.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 7e7cc49b8674..e4c89a16a3e7 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -553,6 +553,16 @@ config VIDEO_MESON_AO_CEC
 	  This is a driver for Amlogic Meson SoCs AO CEC interface. It uses the
 	  generic CEC framework interface.
 	  CEC bus is present in the HDMI connector and enables communication
+
+config CEC_GPIO
+	tristate "Generic GPIO-based CEC driver"
+	depends on PREEMPT
+	select CEC_CORE
+	select CEC_PIN
+	select GPIOLIB
+	---help---
+	  This is a generic GPIO-based CEC driver.
+	  The CEC bus is present in the HDMI connector and enables communication
 	  between compatible devices.
 
 config VIDEO_SAMSUNG_S5P_CEC
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index c1ef946bf032..9bf48f118537 100644
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
index 000000000000..eb982bce99fc
--- /dev/null
+++ b/drivers/media/platform/cec-gpio/cec-gpio.c
@@ -0,0 +1,236 @@
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
+#include <linux/gpio/consumer.h>
+#include <media/cec-pin.h>
+
+struct cec_gpio {
+	struct cec_adapter	*adap;
+	struct device		*dev;
+
+	struct gpio_desc	*cec_gpio;
+	int			cec_irq;
+	bool			cec_is_low;
+	bool			cec_have_irq;
+
+	struct gpio_desc	*hpd_gpio;
+	int			hpd_irq;
+	bool			hpd_is_high;
+	ktime_t			hpd_ts;
+};
+
+static bool cec_gpio_read(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (cec->cec_is_low)
+		return false;
+	return gpiod_get_value(cec->cec_gpio);
+}
+
+static void cec_gpio_high(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (!cec->cec_is_low)
+		return;
+	cec->cec_is_low = false;
+	gpiod_set_value(cec->cec_gpio, 1);
+}
+
+static void cec_gpio_low(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (cec->cec_is_low)
+		return;
+	if (WARN_ON_ONCE(cec->cec_have_irq))
+		free_irq(cec->cec_irq, cec);
+	cec->cec_have_irq = false;
+	cec->cec_is_low = true;
+	gpiod_set_value(cec->cec_gpio, 0);
+}
+
+static irqreturn_t cec_hpd_gpio_irq_handler_thread(int irq, void *priv)
+{
+	struct cec_gpio *cec = priv;
+
+	cec_queue_pin_hpd_event(cec->adap, cec->hpd_is_high, cec->hpd_ts);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cec_hpd_gpio_irq_handler(int irq, void *priv)
+{
+	struct cec_gpio *cec = priv;
+
+	cec->hpd_ts = ktime_get();
+	cec->hpd_is_high = gpiod_get_value(cec->hpd_gpio);
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t cec_gpio_irq_handler(int irq, void *priv)
+{
+	struct cec_gpio *cec = priv;
+
+	cec_pin_changed(cec->adap, gpiod_get_value(cec->cec_gpio));
+	return IRQ_HANDLED;
+}
+
+static bool cec_gpio_enable_irq(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (cec->cec_have_irq)
+		return true;
+
+	if (request_irq(cec->cec_irq, cec_gpio_irq_handler,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+			adap->name, cec))
+		return false;
+	cec->cec_have_irq = true;
+	return true;
+}
+
+static void cec_gpio_disable_irq(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (cec->cec_have_irq)
+		free_irq(cec->cec_irq, cec);
+	cec->cec_have_irq = false;
+}
+
+static void cec_gpio_status(struct cec_adapter *adap, struct seq_file *file)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	seq_printf(file, "mode: %s\n", cec->cec_is_low ? "low-drive" : "read");
+	if (cec->cec_have_irq)
+		seq_printf(file, "using irq: %d\n", cec->cec_irq);
+	if (cec->hpd_gpio)
+		seq_printf(file, "hpd: %s\n",
+			   cec->hpd_is_high ? "high" : "low");
+}
+
+static int cec_gpio_read_hpd(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (!cec->hpd_gpio)
+		return -ENOTTY;
+	return gpiod_get_value(cec->hpd_gpio);
+}
+
+static void cec_gpio_free(struct cec_adapter *adap)
+{
+	cec_gpio_disable_irq(adap);
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
+	.read_hpd = cec_gpio_read_hpd,
+};
+
+static int cec_gpio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct cec_gpio *cec;
+	int ret;
+
+	cec = devm_kzalloc(dev, sizeof(*cec), GFP_KERNEL);
+	if (!cec)
+		return -ENOMEM;
+
+	cec->dev = dev;
+
+	cec->cec_gpio = devm_gpiod_get(dev, "cec", GPIOD_IN);
+	if (IS_ERR(cec->cec_gpio))
+		return PTR_ERR(cec->cec_gpio);
+	cec->cec_irq = gpiod_to_irq(cec->cec_gpio);
+
+	cec->hpd_gpio = devm_gpiod_get_optional(dev, "hpd", GPIOD_IN);
+	if (IS_ERR(cec->hpd_gpio))
+		return PTR_ERR(cec->hpd_gpio);
+
+	cec->adap = cec_pin_allocate_adapter(&cec_gpio_pin_ops,
+		cec, pdev->name, CEC_CAP_DEFAULTS | CEC_CAP_PHYS_ADDR |
+				 CEC_CAP_MONITOR_ALL | CEC_CAP_MONITOR_PIN);
+	if (IS_ERR(cec->adap))
+		return PTR_ERR(cec->adap);
+
+	if (cec->hpd_gpio) {
+		cec->hpd_irq = gpiod_to_irq(cec->hpd_gpio);
+		ret = devm_request_threaded_irq(dev, cec->hpd_irq,
+			cec_hpd_gpio_irq_handler,
+			cec_hpd_gpio_irq_handler_thread,
+			IRQF_ONESHOT |
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			"hpd-gpio", cec);
+		if (ret)
+			return ret;
+	}
+
+	ret = cec_register_adapter(cec->adap, &pdev->dev);
+	if (ret) {
+		cec_delete_adapter(cec->adap);
+		return ret;
+	}
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
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CEC GPIO driver");
-- 
2.14.1
