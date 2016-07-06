Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35361 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbcGFXHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:40 -0400
Received: by mail-pf0-f194.google.com with SMTP id t190so96747pfb.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:40 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 17/28] gpio: pca953x: Add optional reset gpio control
Date: Wed,  6 Jul 2016 16:06:47 -0700
Message-Id: <1467846418-12913-18-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add optional reset-gpios pin control. If present, de-assert the
specified reset gpio pin to bring the chip out of reset.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpio/gpio-pca953x.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 5e3be32..8698815 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -21,6 +21,7 @@
 #include <asm/unaligned.h>
 #include <linux/of_platform.h>
 #include <linux/acpi.h>
+#include <linux/gpio/consumer.h>
 
 #define PCA953X_INPUT		0
 #define PCA953X_OUTPUT		1
@@ -111,6 +112,8 @@ struct pca953x_chip {
 	const char *const *names;
 	int	chip_type;
 	unsigned long driver_data;
+
+	struct gpio_desc *reset_gpio;
 };
 
 static int pca953x_read_single(struct pca953x_chip *chip, int reg, u32 *val,
@@ -759,6 +762,21 @@ static int pca953x_probe(struct i2c_client *client,
 	} else {
 		chip->gpio_start = -1;
 		irq_base = 0;
+
+		/* see if we need to de-assert a reset pin */
+		chip->reset_gpio = devm_gpiod_get_optional(&client->dev,
+							   "reset",
+							   GPIOD_OUT_LOW);
+		if (IS_ERR(chip->reset_gpio)) {
+			dev_err(&client->dev, "request for reset pin failed\n");
+			return PTR_ERR(chip->reset_gpio);
+		}
+
+		if (chip->reset_gpio) {
+			/* bring chip out of reset */
+			dev_info(&client->dev, "releasing reset\n");
+			gpiod_set_value(chip->reset_gpio, 0);
+		}
 	}
 
 	chip->client = client;
-- 
1.9.1

