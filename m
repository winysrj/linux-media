Return-path: <linux-media-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([148.251.95.138]:37710 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbdIFIPp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 04:15:45 -0400
Received: (from localhost user: 'ladis' uid#1021 fake: STDIN
        (ladis@eddie.linux-mips.org)) by eddie.linux-mips.org
        id S23990506AbdIFIPoDE8a4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Sep 2017 10:15:44 +0200
Date: Wed, 6 Sep 2017 10:15:30 +0200
From: Ladislav Michl <ladis@linux-mips.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH 10/10] media: rc: gpio-ir-recv: use gpiolib API
Message-ID: <20170906081530.ya3rs56vfathcvh7@lenoch>
References: <20170906080748.wgxbmunfsu33bd6x@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170906080748.wgxbmunfsu33bd6x@lenoch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use of gpiolib API simplifies driver a bit.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/media/rc/Kconfig        |  1 +
 drivers/media/rc/gpio-ir-recv.c | 64 +++++++++++++++++------------------------
 2 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 5e83b76495f7..852bf639f1ca 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -382,6 +382,7 @@ config RC_LOOPBACK
 config IR_GPIO_CIR
 	tristate "GPIO IR remote control"
 	depends on RC_CORE
+	depends on (OF && GPIOLIB) || COMPILE_TEST
 	---help---
 	   Say Y if you want to use GPIO based IR Receiver.
 
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 77498d0c8970..c87f085226f2 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -26,39 +26,34 @@
 
 struct gpio_rc_dev {
 	struct rc_dev *rcdev;
-	int gpio_nr;
-	bool active_low;
+	struct gpio_desc *gpiod;
+	int irq;
 	struct timer_list flush_timer;
 };
 
 static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
 {
+	int val;
 	struct gpio_rc_dev *gpio_dev = dev_id;
-	int gval;
-	int rc = 0;
 	enum raw_event_type type = IR_SPACE;
 
-	gval = gpio_get_value(gpio_dev->gpio_nr);
+	val = gpiod_get_value(gpio_dev->gpiod);
+	if (val < 0)
+		goto err;
 
-	if (gval < 0)
-		goto err_get_value;
-
-	if (gpio_dev->active_low)
-		gval = !gval;
-
-	if (gval == 1)
+	if (val)
 		type = IR_PULSE;
 
-	rc = ir_raw_event_store_edge(gpio_dev->rcdev, type);
-	if (rc < 0)
-		goto err_get_value;
+	val = ir_raw_event_store_edge(gpio_dev->rcdev, type);
+	if (val < 0)
+		goto err;
 
 	mod_timer(&gpio_dev->flush_timer,
 		  jiffies + nsecs_to_jiffies(gpio_dev->rcdev->timeout));
 
 	ir_raw_event_handle(gpio_dev->rcdev);
 
-err_get_value:
+err:
 	return IRQ_HANDLED;
 }
 
@@ -76,7 +71,6 @@ static void flush_timer(unsigned long arg)
 static int gpio_ir_recv_probe(struct platform_device *pdev)
 {
 	int rc;
-	enum of_gpio_flags flags;
 	struct rc_dev *rcdev;
 	struct gpio_rc_dev *gpio_dev;
 	struct device *dev = &pdev->dev;
@@ -89,15 +83,17 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	if (!gpio_dev)
 		return -ENOMEM;
 
-	rc = of_get_gpio_flags(np, 0, &flags);
-	if (rc < 0) {
+	gpio_dev->gpiod = devm_gpiod_get(dev, NULL, GPIOD_IN);
+	if (IS_ERR(gpio_dev->gpiod)) {
+		rc = PTR_ERR(gpio_dev->gpiod);
+		/* Just try again if this happens */
 		if (rc != -EPROBE_DEFER)
-			dev_err(dev, "Failed to get gpio flags (%d)\n", rc);
+			dev_err(dev, "error getting gpio (%d)\n", rc);
 		return rc;
 	}
-
-	gpio_dev->gpio_nr = rc;
-	gpio_dev->active_low = (flags & OF_GPIO_ACTIVE_LOW);
+	gpio_dev->irq = gpiod_to_irq(gpio_dev->gpiod);
+	if (gpio_dev->irq < 0)
+		return gpio_dev->irq;
 
 	rcdev = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
 	if (!rcdev)
@@ -125,11 +121,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	setup_timer(&gpio_dev->flush_timer, flush_timer,
 		    (unsigned long)gpio_dev);
 
-	rc = devm_gpio_request_one(dev, gpio_dev->gpio_nr, GPIOF_DIR_IN,
-					"gpio-ir-recv");
-	if (rc < 0)
-		return rc;
-
 	rc = devm_rc_register_device(dev, rcdev);
 	if (rc < 0) {
 		dev_err(dev, "failed to register rc device\n");
@@ -138,8 +129,7 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, gpio_dev);
 
-	return devm_request_irq(dev, gpio_to_irq(gpio_dev->gpio_nr),
-				gpio_ir_recv_irq,
+	return devm_request_irq(dev, gpio_dev->irq, gpio_ir_recv_irq,
 				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 				"gpio-ir-recv-irq", gpio_dev);
 }
@@ -155,26 +145,24 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int gpio_ir_recv_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
+	struct gpio_rc_dev *gpio_dev = dev_get_drvdata(dev);
 
 	if (device_may_wakeup(dev))
-		enable_irq_wake(gpio_to_irq(gpio_dev->gpio_nr));
+		enable_irq_wake(gpio_dev->irq);
 	else
-		disable_irq(gpio_to_irq(gpio_dev->gpio_nr));
+		disable_irq(gpio_dev->irq);
 
 	return 0;
 }
 
 static int gpio_ir_recv_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
+	struct gpio_rc_dev *gpio_dev = dev_get_drvdata(dev);
 
 	if (device_may_wakeup(dev))
-		disable_irq_wake(gpio_to_irq(gpio_dev->gpio_nr));
+		disable_irq_wake(gpio_dev->irq);
 	else
-		enable_irq(gpio_to_irq(gpio_dev->gpio_nr));
+		enable_irq(gpio_dev->irq);
 
 	return 0;
 }
-- 
2.11.0
