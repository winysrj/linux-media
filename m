Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35646 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbcFNWvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:23 -0400
Received: by mail-pf0-f196.google.com with SMTP id t190so302245pfb.2
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:23 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 26/38] gpio: pca953x: Add reset-gpios property
Date: Tue, 14 Jun 2016 15:49:22 -0700
Message-Id: <1465944574-15745-27-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add optional reset-gpios property. If present, de-assert the
specified reset gpio pin to bring the chip out of reset.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpio/gpio-pca953x.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 5e3be32..475fa56 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -21,6 +21,7 @@
 #include <asm/unaligned.h>
 #include <linux/of_platform.h>
 #include <linux/acpi.h>
+#include <linux/of_gpio.h>
 
 #define PCA953X_INPUT		0
 #define PCA953X_OUTPUT		1
@@ -111,6 +112,11 @@ struct pca953x_chip {
 	const char *const *names;
 	int	chip_type;
 	unsigned long driver_data;
+
+#ifdef CONFIG_OF_GPIO
+	enum of_gpio_flags reset_gpio_flags;
+	int reset_gpio;
+#endif
 };
 
 static int pca953x_read_single(struct pca953x_chip *chip, int reg, u32 *val,
@@ -759,6 +765,28 @@ static int pca953x_probe(struct i2c_client *client,
 	} else {
 		chip->gpio_start = -1;
 		irq_base = 0;
+
+#ifdef CONFIG_OF_GPIO
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
+#endif
 	}
 
 	chip->client = client;
-- 
1.9.1

