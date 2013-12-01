Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:63951 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3LAVGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 16:06:24 -0500
Received: by mail-ea0-f182.google.com with SMTP id o10so11215725eaj.13
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 13:06:22 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 6/7] em28xx: add support for illumination button and LED
Date: Sun,  1 Dec 2013 22:06:56 +0100
Message-Id: <1385932017-2276-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SpeedLink VAD Laplace webcam is equipped with an illumination button and
an illumination LED. When the button is pressed, the driver must toggle the
LED state via the corresponding GPO port.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c  |   19 +++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-input.c |   19 ++++++++++++++++++-
 drivers/media/usb/em28xx/em28xx.h       |    3 +++
 3 Dateien geändert, 40 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 4a8179a..fc82540 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -226,6 +226,25 @@ int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
 EXPORT_SYMBOL_GPL(em28xx_write_reg_bits);
 
 /*
+ * em28xx_toggle_reg_bits()
+ * toggles/inverts the bits (specified by bitmask) of a register
+ */
+int em28xx_toggle_reg_bits(struct em28xx *dev, u16 reg, u8 bitmask)
+{
+	int oldval;
+	u8 newval;
+
+	oldval = em28xx_read_reg(dev, reg);
+	if (oldval < 0)
+		return oldval;
+
+	newval = (~oldval & bitmask) | (oldval & ~bitmask);
+
+	return em28xx_write_reg(dev, reg, newval);
+}
+EXPORT_SYMBOL_GPL(em28xx_toggle_reg_bits);
+
+/*
  * em28xx_is_ac97_ready()
  * Checks if ac97 is ready
  */
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index c8f7ecb..d40fd34 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -480,6 +480,7 @@ static void em28xx_query_buttons(struct work_struct *work)
 	u8 i, j;
 	int regval;
 	bool is_pressed, was_pressed;
+	const struct em28xx_led *led;
 
 	/* Poll and evaluate all addresses */
 	for (i = 0; i < dev->num_button_polling_addresses; i++) {
@@ -524,6 +525,15 @@ static void em28xx_query_buttons(struct work_struct *work)
 				input_report_key(dev->sbutton_input_dev,
 						 EM28XX_SNAPSHOT_KEY, 0);
 				break;
+			case EM28XX_BUTTON_ILLUMINATION:
+				led = em28xx_find_led(dev,
+						      EM28XX_LED_ILLUMINATION);
+				/* Switch illumination LED on/off */
+				if (led)
+					em28xx_toggle_reg_bits(dev,
+							       led->gpio_reg,
+							       led->gpio_mask);
+				break;
 			default:
 				WARN_ONCE(1, "BUG: unhandled button role.");
 			}
@@ -600,10 +610,17 @@ static void em28xx_init_buttons(struct em28xx *dev)
 			WARN_ONCE(1, "BUG: maximum number of button polling addresses exceeded.");
 			addr_new = 0;
 		}
-		/* Register input device (if needed) */
+		/* Button role specific checks and actions */
 		if (button->role == EM28XX_BUTTON_SNAPSHOT) {
+			/* Register input device */
 			if (em28xx_register_snapshot_button(dev) < 0)
 				addr_new = 0;
+		} else if (button->role == EM28XX_BUTTON_ILLUMINATION) {
+			/* Check sanity */
+			if (!em28xx_find_led(dev, EM28XX_LED_ILLUMINATION)) {
+				em28xx_errdev("BUG: illumination button defined, but no illumination LED.\n");
+				addr_new = 0;
+			}
 		}
 		/* Add read address to list of polling addresses */
 		if (addr_new) {
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index f60f236..43e2968 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -379,6 +379,7 @@ enum em28xx_adecoder {
 
 enum em28xx_led_role {
 	EM28XX_LED_ANALOG_CAPTURING = 0,
+	EM28XX_LED_ILLUMINATION,
 	EM28XX_NUM_LED_ROLES, /* must be the last */
 };
 
@@ -391,6 +392,7 @@ struct em28xx_led {
 
 enum em28xx_button_role {
 	EM28XX_BUTTON_SNAPSHOT = 0,
+	EM28XX_BUTTON_ILLUMINATION,
 	EM28XX_NUM_BUTTON_ROLES, /* must be the last */
 };
 
@@ -709,6 +711,7 @@ int em28xx_write_regs(struct em28xx *dev, u16 reg, char *buf, int len);
 int em28xx_write_reg(struct em28xx *dev, u16 reg, u8 val);
 int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
 				 u8 bitmask);
+int em28xx_toggle_reg_bits(struct em28xx *dev, u16 reg, u8 bitmask);
 
 int em28xx_read_ac97(struct em28xx *dev, u8 reg);
 int em28xx_write_ac97(struct em28xx *dev, u8 reg, u16 val);
-- 
1.7.10.4

