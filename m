Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:56837 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbaE3Lba (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 07:31:30 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com, m@bues.ch,
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
	linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	patches@opensource.wolfsonmicro.com, linux-input@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-samsungsoc@vger.kernel.org, spear-devel@list.st.com,
	platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
	devel@driverdev.osuosl.org
Cc: abdoulaye berthe <berthe.ab@gmail.com>
Subject: [PATCH 2/2] gpio: gpiolib: set gpiochip_remove retval to void
Date: Fri, 30 May 2014 13:30:54 +0200
Message-Id: <1401449454-30895-2-git-send-email-berthe.ab@gmail.com>
In-Reply-To: <1401449454-30895-1-git-send-email-berthe.ab@gmail.com>
References: <20140530094025.3b78301e@canb.auug.org.au>
 <1401449454-30895-1-git-send-email-berthe.ab@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This avoids handling gpiochip remove error in device
remove handler.

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/gpio/gpiolib.c      | 24 +++++++-----------------
 include/linux/gpio/driver.h |  2 +-
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f48817d..022543f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1263,10 +1263,9 @@ static void gpiochip_irqchip_remove(struct gpio_chip *gpiochip);
  *
  * A gpio_chip with any GPIOs still requested may not be removed.
  */
-int gpiochip_remove(struct gpio_chip *chip)
+void gpiochip_remove(struct gpio_chip *chip)
 {
 	unsigned long	flags;
-	int		status = 0;
 	unsigned	id;
 
 	acpi_gpiochip_remove(chip);
@@ -1278,24 +1277,15 @@ int gpiochip_remove(struct gpio_chip *chip)
 	of_gpiochip_remove(chip);
 
 	for (id = 0; id < chip->ngpio; id++) {
-		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags)) {
-			status = -EBUSY;
-			break;
-		}
-	}
-	if (status == 0) {
-		for (id = 0; id < chip->ngpio; id++)
-			chip->desc[id].chip = NULL;
-
-		list_del(&chip->list);
+		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags))
+			panic("gpio: removing gpiochip with gpios still requested\n");
 	}
+	for (id = 0; id < chip->ngpio; id++)
+		chip->desc[id].chip = NULL;
 
+	list_del(&chip->list);
 	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	if (status == 0)
-		gpiochip_unexport(chip);
-
-	return status;
+	gpiochip_unexport(chip);
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
 
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 1827b43..72ed256 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -138,7 +138,7 @@ extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
-extern int __must_check gpiochip_remove(struct gpio_chip *chip);
+void gpiochip_remove(struct gpio_chip *chip);
 extern struct gpio_chip *gpiochip_find(void *data,
 			      int (*match)(struct gpio_chip *chip, void *data));
 
-- 
1.8.3.2

