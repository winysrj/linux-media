Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaCDPiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 10:38:09 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] [media] em28xx: add support for DVB monitor led
Date: Tue,  4 Mar 2014 12:37:27 -0300
Message-Id: <1393947448-1738-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices have a LED to indicate when DVB capture started.
Add support for it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 26 ++++++++++++++------------
 drivers/media/usb/em28xx/em28xx.h      |  1 +
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 6de41c6a0770..523d7e92bf47 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -619,6 +619,7 @@ EXPORT_SYMBOL_GPL(em28xx_find_led);
 int em28xx_capture_start(struct em28xx *dev, int start)
 {
 	int rc;
+	const struct em28xx_led *led = NULL;
 
 	if (dev->chip_id == CHIP_ID_EM2874 ||
 	    dev->chip_id == CHIP_ID_EM2884 ||
@@ -643,6 +644,8 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 
 			/* Enable video capture */
 			rc = em28xx_write_reg(dev, 0x48, 0x00);
+			if (rc < 0)
+				return rc;
 
 			if (dev->mode == EM28XX_ANALOG_MODE)
 				rc = em28xx_write_reg(dev,
@@ -650,6 +653,8 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 			else
 				rc = em28xx_write_reg(dev,
 						    EM28XX_R12_VINENABLE, 0x37);
+			if (rc < 0)
+				return rc;
 
 			msleep(6);
 		} else {
@@ -658,19 +663,16 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 		}
 	}
 
-	if (rc < 0)
-		return rc;
-
-	/* Switch (explicitly controlled) analog capturing LED on/off */
-	if (dev->mode == EM28XX_ANALOG_MODE) {
-		const struct em28xx_led *led;
+	if (dev->mode == EM28XX_ANALOG_MODE)
 		led = em28xx_find_led(dev, EM28XX_LED_ANALOG_CAPTURING);
-		if (led)
-			em28xx_write_reg_bits(dev, led->gpio_reg,
-					      (!start ^ led->inverted) ?
-					      ~led->gpio_mask : led->gpio_mask,
-					      led->gpio_mask);
-	}
+	else
+		led = em28xx_find_led(dev, EM28XX_LED_DIGITAL_CAPTURING);
+
+	if (led)
+		em28xx_write_reg_bits(dev, led->gpio_reg,
+				      (!start ^ led->inverted) ?
+				      ~led->gpio_mask : led->gpio_mask,
+				      led->gpio_mask);
 
 	return rc;
 }
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 3b08556376e3..9e44f5bfc48b 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -401,6 +401,7 @@ enum em28xx_adecoder {
 
 enum em28xx_led_role {
 	EM28XX_LED_ANALOG_CAPTURING = 0,
+	EM28XX_LED_DIGITAL_CAPTURING,
 	EM28XX_LED_ILLUMINATION,
 	EM28XX_NUM_LED_ROLES, /* must be the last */
 };
-- 
1.8.5.3

