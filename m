Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:38732 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbdHCKIk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Aug 2017 06:08:40 -0400
Date: Thu, 3 Aug 2017 12:08:38 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] rc: gpio-ir-tx: switch to gpiod, fix inverted
 polarity
Message-ID: <20170803100837.r7pxmyvpyflg552i@camel2.lan>
References: <cover.1499419624.git.sean@mess.org>
 <92a66fd9852c3143d5726eb3869d58e28d841c84.1499419624.git.sean@mess.org>
 <20170721141245.3uv55fqxa557dmnt@camel2.lan>
 <20170731202908.hk7dpclt5m5lhpdd@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170731202908.hk7dpclt5m5lhpdd@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manual handling of gpio output polarity was inverted.
Switch to using gpiod, this allows us to simplify the code,
delegate polarity handling to gpiod and remove the buggy local
polarity handling code.

Signed-off-by: Matthias Reichl <hias@horus.com>
---

This patch is against [PATCH v2 3/6] [media] rc: gpio-ir-tx:
add new driver.

Feel free to squash these two patches into one for v3.

so long,

Hias

 drivers/media/rc/gpio-ir-tx.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
index 7a5371dbb360..ca6834d09467 100644
--- a/drivers/media/rc/gpio-ir-tx.c
+++ b/drivers/media/rc/gpio-ir-tx.c
@@ -13,11 +13,10 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <media/rc-core.h>
 
@@ -25,8 +24,7 @@
 #define DEVICE_NAME	"GPIO Bit Banging IR Transmitter"
 
 struct gpio_ir {
-	int gpio_nr;
-	bool active_low;
+	struct gpio_desc *gpio;
 	unsigned int carrier;
 	unsigned int duty_cycle;
 	/* we need a spinlock to hold the cpu while transmitting */
@@ -101,14 +99,12 @@ static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 			ktime_t last = ktime_add_us(edge, txbuf[i]);
 
 			while (ktime_get() < last) {
-				gpio_set_value(gpio_ir->gpio_nr,
-					       gpio_ir->active_low);
+				gpiod_set_value(gpio_ir->gpio, 1);
 				edge += pulse;
 				delta = edge - ktime_get();
 				if (delta > 0)
 					ndelay(delta);
-				gpio_set_value(gpio_ir->gpio_nr,
-					       !gpio_ir->active_low);
+				gpiod_set_value(gpio_ir->gpio, 0);
 				edge += space;
 				delta = edge - ktime_get();
 				if (delta > 0)
@@ -128,16 +124,7 @@ static int gpio_ir_tx_probe(struct platform_device *pdev)
 {
 	struct gpio_ir *gpio_ir;
 	struct rc_dev *rcdev;
-	enum of_gpio_flags flags;
-	int rc, gpio;
-
-	gpio = of_get_gpio_flags(pdev->dev.of_node, 0, &flags);
-	if (gpio < 0) {
-		if (gpio != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "Failed to get gpio flags (%d)\n",
-				gpio);
-		return -EINVAL;
-	}
+	int rc;
 
 	gpio_ir = devm_kmalloc(&pdev->dev, sizeof(*gpio_ir), GFP_KERNEL);
 	if (!gpio_ir)
@@ -147,6 +134,14 @@ static int gpio_ir_tx_probe(struct platform_device *pdev)
 	if (!rcdev)
 		return -ENOMEM;
 
+	gpio_ir->gpio = devm_gpiod_get(&pdev->dev, NULL, GPIOD_OUT_LOW);
+	if (IS_ERR(gpio_ir->gpio)) {
+		if (PTR_ERR(gpio_ir->gpio) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get gpio (%ld)\n",
+				PTR_ERR(gpio_ir->gpio));
+		return PTR_ERR(gpio_ir->gpio);
+	}
+
 	rcdev->priv = gpio_ir;
 	rcdev->driver_name = DRIVER_NAME;
 	rcdev->device_name = DEVICE_NAME;
@@ -154,20 +149,10 @@ static int gpio_ir_tx_probe(struct platform_device *pdev)
 	rcdev->s_tx_duty_cycle = gpio_ir_tx_set_duty_cycle;
 	rcdev->s_tx_carrier = gpio_ir_tx_set_carrier;
 
-	gpio_ir->gpio_nr = gpio;
-	gpio_ir->active_low = (flags & OF_GPIO_ACTIVE_LOW) != 0;
 	gpio_ir->carrier = 38000;
 	gpio_ir->duty_cycle = 50;
 	spin_lock_init(&gpio_ir->lock);
 
-	rc = devm_gpio_request(&pdev->dev, gpio, "gpio-ir-tx");
-	if (rc < 0)
-		return rc;
-
-	rc = gpio_direction_output(gpio, !gpio_ir->active_low);
-	if (rc < 0)
-		return rc;
-
 	rc = devm_rc_register_device(&pdev->dev, rcdev);
 	if (rc < 0)
 		dev_err(&pdev->dev, "failed to register rc device\n");
-- 
2.11.0
