Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:42566 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751328AbdIGXkB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 19:40:01 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23993950AbdIGXkAlmzOk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 01:40:00 +0200
Date: Fri, 8 Sep 2017 01:39:45 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH v2 09/10] media: rc: gpio-ir-recv: remove
 gpio_ir_recv_platform_data
Message-ID: <20170907233944.3mzvnusrkeit2akp@lenoch>
References: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907233355.bv3hsv3rfhcx52i3@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gpio_ir_recv_platform_data are not used anywhere in kernel tree,
so remove it.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 Changes:
 -v2: rebased to current linux.git

 drivers/media/rc/gpio-ir-recv.c                  | 98 +++++++-----------------
 include/linux/platform_data/media/gpio-ir-recv.h | 23 ------
 2 files changed, 29 insertions(+), 92 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index db193ad4b819..5c47661281e3 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -21,7 +21,6 @@
 #include <linux/platform_device.h>
 #include <linux/irq.h>
 #include <media/rc-core.h>
-#include <linux/platform_data/media/gpio-ir-recv.h>
 
 #define GPIO_IR_DEVICE_NAME	"gpio_ir_recv"
 
@@ -31,45 +30,6 @@ struct gpio_rc_dev {
 	bool active_low;
 };
 
-#ifdef CONFIG_OF
-/*
- * Translate OpenFirmware node properties into platform_data
- */
-static int gpio_ir_recv_get_devtree_pdata(struct device *dev,
-				  struct gpio_ir_recv_platform_data *pdata)
-{
-	struct device_node *np = dev->of_node;
-	enum of_gpio_flags flags;
-	int gpio;
-
-	gpio = of_get_gpio_flags(np, 0, &flags);
-	if (gpio < 0) {
-		if (gpio != -EPROBE_DEFER)
-			dev_err(dev, "Failed to get gpio flags (%d)\n", gpio);
-		return gpio;
-	}
-
-	pdata->gpio_nr = gpio;
-	pdata->active_low = (flags & OF_GPIO_ACTIVE_LOW);
-	/* probe() takes care of map_name == NULL or allowed_protos == 0 */
-	pdata->map_name = of_get_property(np, "linux,rc-map-name", NULL);
-	pdata->allowed_protos = 0;
-
-	return 0;
-}
-
-static const struct of_device_id gpio_ir_recv_of_match[] = {
-	{ .compatible = "gpio-ir-receiver", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
-
-#else /* !CONFIG_OF */
-
-#define gpio_ir_recv_get_devtree_pdata(dev, pdata)	(-ENOSYS)
-
-#endif
-
 static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 {
 	struct gpio_rc_dev *gpio_dev = dev_id;
@@ -94,33 +54,30 @@ static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 
 static int gpio_ir_recv_probe(struct platform_device *pdev)
 {
-	struct device *dev = &pdev->dev;
-	struct gpio_rc_dev *gpio_dev;
-	struct rc_dev *rcdev;
-	const struct gpio_ir_recv_platform_data *pdata = dev->platform_data;
 	int rc;
+	enum of_gpio_flags flags;
+	struct rc_dev *rcdev;
+	struct gpio_rc_dev *gpio_dev;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 
-	if (pdev->dev.of_node) {
-		struct gpio_ir_recv_platform_data *dtpdata =
-			devm_kzalloc(dev, sizeof(*dtpdata), GFP_KERNEL);
-		if (!dtpdata)
-			return -ENOMEM;
-		rc = gpio_ir_recv_get_devtree_pdata(dev, dtpdata);
-		if (rc)
-			return rc;
-		pdata = dtpdata;
-	}
-
-	if (!pdata)
-		return -EINVAL;
-
-	if (pdata->gpio_nr < 0)
-		return -EINVAL;
+	if (!np)
+		return -ENODEV;
 
 	gpio_dev = devm_kzalloc(dev, sizeof(struct gpio_rc_dev), GFP_KERNEL);
 	if (!gpio_dev)
 		return -ENOMEM;
 
+	rc = of_get_gpio_flags(np, 0, &flags);
+	if (rc < 0) {
+		if (rc != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get gpio flags (%d)\n", rc);
+		return rc;
+	}
+
+	gpio_dev->gpio_nr = rc;
+	gpio_dev->active_low = (flags & OF_GPIO_ACTIVE_LOW);
+
 	rcdev = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
 	if (!rcdev)
 		return -ENOMEM;
@@ -137,17 +94,14 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->min_timeout = 1;
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
 	rcdev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
-	if (pdata->allowed_protos)
-		rcdev->allowed_protocols = pdata->allowed_protos;
-	else
-		rcdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
-	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
+	rcdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
+	rcdev->map_name = of_get_property(np, "linux,rc-map-name", NULL);
+	if (!rcdev->map_name)
+		rcdev->map_name = RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
-	gpio_dev->gpio_nr = pdata->gpio_nr;
-	gpio_dev->active_low = pdata->active_low;
 
-	rc = devm_gpio_request_one(dev, pdata->gpio_nr, GPIOF_DIR_IN,
+	rc = devm_gpio_request_one(dev, gpio_dev->gpio_nr, GPIOF_DIR_IN,
 					"gpio-ir-recv");
 	if (rc < 0)
 		return rc;
@@ -160,7 +114,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, gpio_dev);
 
-	return devm_request_irq(dev, gpio_to_irq(pdata->gpio_nr),
+	return devm_request_irq(dev, gpio_to_irq(gpio_dev->gpio_nr),
 				gpio_ir_recv_irq,
 				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 				"gpio-ir-recv-irq", gpio_dev);
@@ -199,6 +153,12 @@ static const struct dev_pm_ops gpio_ir_recv_pm_ops = {
 };
 #endif
 
+static const struct of_device_id gpio_ir_recv_of_match[] = {
+	{ .compatible = "gpio-ir-receiver", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
+
 static struct platform_driver gpio_ir_recv_driver = {
 	.probe  = gpio_ir_recv_probe,
 	.driver = {
diff --git a/include/linux/platform_data/media/gpio-ir-recv.h b/include/linux/platform_data/media/gpio-ir-recv.h
deleted file mode 100644
index 0c298f569d5a..000000000000
--- a/include/linux/platform_data/media/gpio-ir-recv.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* Copyright (c) 2012, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __GPIO_IR_RECV_H__
-#define __GPIO_IR_RECV_H__
-
-struct gpio_ir_recv_platform_data {
-	int		gpio_nr;
-	bool		active_low;
-	u64		allowed_protos;
-	const char	*map_name;
-};
-
-#endif /* __GPIO_IR_RECV_H__ */
-- 
2.11.0
