Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:55780 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731533AbeGQOBx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 10:01:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] cec-gpio: support 5v testing
Date: Tue, 17 Jul 2018 15:29:09 +0200
Message-Id: <20180717132909.92158-6-hverkuil@xs4all.nl>
In-Reply-To: <20180717132909.92158-1-hverkuil@xs4all.nl>
References: <20180717132909.92158-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the new (optional) 5V gpio in order to debug 5V
changes. Some displays turn off CEC if the 5V is not detected,
so it is useful to be able to monitor this line.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/cec-gpio/cec-gpio.c | 54 ++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/media/platform/cec-gpio/cec-gpio.c b/drivers/media/platform/cec-gpio/cec-gpio.c
index 69f8242209c2..d2861749d640 100644
--- a/drivers/media/platform/cec-gpio/cec-gpio.c
+++ b/drivers/media/platform/cec-gpio/cec-gpio.c
@@ -23,6 +23,11 @@ struct cec_gpio {
 	int			hpd_irq;
 	bool			hpd_is_high;
 	ktime_t			hpd_ts;
+
+	struct gpio_desc	*v5_gpio;
+	int			v5_irq;
+	bool			v5_is_high;
+	ktime_t			v5_ts;
 };
 
 static bool cec_gpio_read(struct cec_adapter *adap)
@@ -65,6 +70,26 @@ static irqreturn_t cec_hpd_gpio_irq_handler_thread(int irq, void *priv)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t cec_5v_gpio_irq_handler(int irq, void *priv)
+{
+	struct cec_gpio *cec = priv;
+	bool is_high = gpiod_get_value(cec->v5_gpio);
+
+	if (is_high == cec->v5_is_high)
+		return IRQ_HANDLED;
+	cec->v5_ts = ktime_get();
+	cec->v5_is_high = is_high;
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t cec_5v_gpio_irq_handler_thread(int irq, void *priv)
+{
+	struct cec_gpio *cec = priv;
+
+	cec_queue_pin_5v_event(cec->adap, cec->v5_is_high, cec->v5_ts);
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t cec_hpd_gpio_irq_handler(int irq, void *priv)
 {
 	struct cec_gpio *cec = priv;
@@ -119,6 +144,9 @@ static void cec_gpio_status(struct cec_adapter *adap, struct seq_file *file)
 	if (cec->hpd_gpio)
 		seq_printf(file, "hpd: %s\n",
 			   cec->hpd_is_high ? "high" : "low");
+	if (cec->v5_gpio)
+		seq_printf(file, "5V: %s\n",
+			   cec->v5_is_high ? "high" : "low");
 }
 
 static int cec_gpio_read_hpd(struct cec_adapter *adap)
@@ -130,6 +158,15 @@ static int cec_gpio_read_hpd(struct cec_adapter *adap)
 	return gpiod_get_value(cec->hpd_gpio);
 }
 
+static int cec_gpio_read_5v(struct cec_adapter *adap)
+{
+	struct cec_gpio *cec = cec_get_drvdata(adap);
+
+	if (!cec->v5_gpio)
+		return -ENOTTY;
+	return gpiod_get_value(cec->v5_gpio);
+}
+
 static void cec_gpio_free(struct cec_adapter *adap)
 {
 	cec_gpio_disable_irq(adap);
@@ -144,6 +181,7 @@ static const struct cec_pin_ops cec_gpio_pin_ops = {
 	.status = cec_gpio_status,
 	.free = cec_gpio_free,
 	.read_hpd = cec_gpio_read_hpd,
+	.read_5v = cec_gpio_read_5v,
 };
 
 static int cec_gpio_probe(struct platform_device *pdev)
@@ -167,6 +205,10 @@ static int cec_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(cec->hpd_gpio))
 		return PTR_ERR(cec->hpd_gpio);
 
+	cec->v5_gpio = devm_gpiod_get_optional(dev, "v5", GPIOD_IN);
+	if (IS_ERR(cec->v5_gpio))
+		return PTR_ERR(cec->v5_gpio);
+
 	cec->adap = cec_pin_allocate_adapter(&cec_gpio_pin_ops,
 		cec, pdev->name, CEC_CAP_DEFAULTS | CEC_CAP_PHYS_ADDR |
 				 CEC_CAP_MONITOR_ALL | CEC_CAP_MONITOR_PIN);
@@ -185,6 +227,18 @@ static int cec_gpio_probe(struct platform_device *pdev)
 			return ret;
 	}
 
+	if (cec->v5_gpio) {
+		cec->v5_irq = gpiod_to_irq(cec->v5_gpio);
+		ret = devm_request_threaded_irq(dev, cec->v5_irq,
+			cec_5v_gpio_irq_handler,
+			cec_5v_gpio_irq_handler_thread,
+			IRQF_ONESHOT |
+			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			"v5-gpio", cec);
+		if (ret)
+			return ret;
+	}
+
 	ret = cec_register_adapter(cec->adap, &pdev->dev);
 	if (ret) {
 		cec_delete_adapter(cec->adap);
-- 
2.18.0
