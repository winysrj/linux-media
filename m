Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35834 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3LAVGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 16:06:22 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so8210595eae.5
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 13:06:21 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/7] em28xx: prepare for supporting multiple LEDs
Date: Sun,  1 Dec 2013 22:06:55 +0100
Message-Id: <1385932017-2276-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce a LED role and store all LEDs in an array.
Also provide a helper function to retrieve a specific LED.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   31 ++++++++++++++++++++++++-------
 drivers/media/usb/em28xx/em28xx.h      |   10 +++++++++-
 2 Dateien geändert, 33 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 31d6ab2..4a8179a 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -600,6 +600,22 @@ int em28xx_colorlevels_set_default(struct em28xx *dev)
 	return em28xx_write_reg(dev, EM28XX_R1A_BOFFSET, 0x00);
 }
 
+const struct em28xx_led *em28xx_find_led(struct em28xx *dev,
+					 enum em28xx_led_role role)
+{
+	if (dev->board.leds) {
+		u8 k = 0;
+		while (dev->board.leds[k].role >= 0 &&
+			       dev->board.leds[k].role < EM28XX_NUM_LED_ROLES) {
+			if (dev->board.leds[k].role == role)
+				return &dev->board.leds[k];
+			k++;
+		}
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(em28xx_find_led);
+
 int em28xx_capture_start(struct em28xx *dev, int start)
 {
 	int rc;
@@ -645,13 +661,14 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 		return rc;
 
 	/* Switch (explicitly controlled) analog capturing LED on/off */
-	if ((dev->mode == EM28XX_ANALOG_MODE)
-	    && dev->board.analog_capturing_led) {
-		struct em28xx_led *led = dev->board.analog_capturing_led;
-		em28xx_write_reg_bits(dev, led->gpio_reg,
-				      (!start ^ led->inverted) ?
-				      ~led->gpio_mask : led->gpio_mask,
-				      led->gpio_mask);
+	if (dev->mode == EM28XX_ANALOG_MODE) {
+		const struct em28xx_led *led;
+		led = em28xx_find_led(dev, EM28XX_LED_ANALOG_CAPTURING);
+		if (led)
+			em28xx_write_reg_bits(dev, led->gpio_reg,
+					      (!start ^ led->inverted) ?
+					      ~led->gpio_mask : led->gpio_mask,
+					      led->gpio_mask);
 	}
 
 	return rc;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index df828c6..f60f236 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -377,7 +377,13 @@ enum em28xx_adecoder {
 	EM28XX_TVAUDIO,
 };
 
+enum em28xx_led_role {
+	EM28XX_LED_ANALOG_CAPTURING = 0,
+	EM28XX_NUM_LED_ROLES, /* must be the last */
+};
+
 struct em28xx_led {
+	enum em28xx_led_role role;
 	u8 gpio_reg;
 	u8 gpio_mask;
 	bool inverted;
@@ -433,7 +439,7 @@ struct em28xx_board {
 	char			  *ir_codes;
 
 	/* LEDs that need to be controlled explicitly */
-	struct em28xx_led	  *analog_capturing_led;
+	struct em28xx_led	  *leds;
 
 	/* Buttons */
 	struct em28xx_button	  *buttons;
@@ -711,6 +717,8 @@ int em28xx_audio_analog_set(struct em28xx *dev);
 int em28xx_audio_setup(struct em28xx *dev);
 
 int em28xx_colorlevels_set_default(struct em28xx *dev);
+const struct em28xx_led *em28xx_find_led(struct em28xx *dev,
+					 enum em28xx_led_role role);
 int em28xx_capture_start(struct em28xx *dev, int start);
 int em28xx_vbi_supported(struct em28xx *dev);
 int em28xx_set_outfmt(struct em28xx *dev);
-- 
1.7.10.4

