Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59618 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaFGV5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:38 -0400
Received: by mail-pd0-f171.google.com with SMTP id y13so3808678pdi.2
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:38 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 36/43] gpio: pca953x: Add reset-gpios property
Date: Sat,  7 Jun 2014 14:56:38 -0700
Message-Id: <1402178205-22697-37-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add optional reset-gpios property. If present, de-assert the
specified reset gpio pin to bring the chip out of reset.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpio/gpio-pca953x.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index d550d8e..6e212f7 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #ifdef CONFIG_OF_GPIO
 #include <linux/of_platform.h>
+#include <linux/of_gpio.h>
 #endif
 
 #define PCA953X_INPUT		0
@@ -98,6 +99,11 @@ struct pca953x_chip {
 	struct gpio_chip gpio_chip;
 	const char *const *names;
 	int	chip_type;
+
+#ifdef CONFIG_OF_GPIO
+	enum of_gpio_flags reset_gpio_flags;
+	int reset_gpio;
+#endif
 };
 
 static int pca953x_read_single(struct pca953x_chip *chip, int reg, u32 *val,
@@ -735,6 +741,26 @@ static int pca953x_probe(struct i2c_client *client,
 		/* If I2C node has no interrupts property, disable GPIO interrupts */
 		if (of_find_property(client->dev.of_node, "interrupts", NULL) == NULL)
 			irq_base = -1;
+
+		/* see if we need to de-assert a reset pin */
+		ret = of_get_named_gpio_flags(client->dev.of_node,
+					      "reset-gpios", 0,
+					      &chip->reset_gpio_flags);
+		if (gpio_is_valid(ret)) {
+			chip->reset_gpio = ret;
+			ret = devm_gpio_request_one(&client->dev,
+						    chip->reset_gpio,
+						    GPIOF_DIR_OUT,
+						    "pca953x_reset");
+			if (ret == 0) {
+				/* bring chip out of reset */
+				dev_info(&client->dev, "releasing reset\n");
+				gpio_set_value(chip->reset_gpio,
+					       (chip->reset_gpio_flags ==
+						OF_GPIO_ACTIVE_LOW) ? 1 : 0);
+			}
+		} else if (ret == -EPROBE_DEFER)
+			return ret;
 #endif
 	}
 
-- 
1.7.9.5

