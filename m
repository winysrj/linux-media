Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:41141 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3LAVGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 16:06:22 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so8343821ead.34
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 13:06:21 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/7] em28xx: add debouncing mechanism for GPI-connected buttons
Date: Sun,  1 Dec 2013 22:06:53 +0100
Message-Id: <1385932017-2276-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So far, the driver only supports a snapshot button which is assigned to
register 0x0c bit 5. This special port has a built-in debouncing mechanism.
For buttons connected to ordinary GPI ports, this patch implements a software
debouncing mechanism.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |   30 +++++++++++++++++++-----------
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 2 Dateien geändert, 20 Zeilen hinzugefügt(+), 11 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 20c6a8a..ebc5387 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -479,7 +479,7 @@ static void em28xx_query_buttons(struct work_struct *work)
 		container_of(work, struct em28xx, buttons_query_work.work);
 	u8 i, j;
 	int regval;
-	bool pressed;
+	bool is_pressed, was_pressed;
 
 	/* Poll and evaluate all addresses */
 	for (i = 0; i < dev->num_button_polling_addresses; i++) {
@@ -497,12 +497,21 @@ static void em28xx_query_buttons(struct work_struct *work)
 				j++;
 				continue;
 			}
-			/* Determine if button is pressed */
-			pressed = regval & button->mask;
-			if (button->inverted)
-				pressed = !pressed;
+			/* Determine if button is and was pressed last time */
+			is_pressed = regval & button->mask;
+			was_pressed = dev->button_polling_last_values[i]
+				       & button->mask;
+			if (button->inverted) {
+				is_pressed = !is_pressed;
+				was_pressed = !was_pressed;
+			}
+			/* Clear button state (if needed) */
+			if (is_pressed && button->reg_clearing)
+				em28xx_write_reg(dev, button->reg_clearing,
+						 (~regval & button->mask)
+						    | (regval & ~button->mask));
 			/* Handle button state */
-			if (!pressed) {
+			if (!is_pressed || was_pressed) {
 				j++;
 				continue;
 			}
@@ -518,14 +527,11 @@ static void em28xx_query_buttons(struct work_struct *work)
 			default:
 				WARN_ONCE(1, "BUG: unhandled button role.");
 			}
-			/* Clear button state (if needed) */
-			if (button->reg_clearing)
-				em28xx_write_reg(dev, button->reg_clearing,
-						 (~regval & button->mask)
-						    | (regval & ~button->mask));
 			/* Next button */
 			j++;
 		}
+		/* Save current value for comparison during the next polling */
+		dev->button_polling_last_values[i] = regval;
 	}
 	/* Schedule next poll */
 	schedule_delayed_work(&dev->buttons_query_work,
@@ -611,6 +617,8 @@ static void em28xx_init_buttons(struct em28xx *dev)
 
 	/* Start polling */
 	if (dev->num_button_polling_addresses) {
+		memset(dev->button_polling_last_values, 0,
+					       EM28XX_NUM_BUTTON_ADDRESSES_MAX);
 		INIT_DELAYED_WORK(&dev->buttons_query_work,
 							  em28xx_query_buttons);
 		schedule_delayed_work(&dev->buttons_query_work,
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e185d00..df828c6 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -669,6 +669,7 @@ struct em28xx {
 	/* Button state polling */
 	struct delayed_work buttons_query_work;
 	u8 button_polling_addresses[EM28XX_NUM_BUTTON_ADDRESSES_MAX];
+	u8 button_polling_last_values[EM28XX_NUM_BUTTON_ADDRESSES_MAX];
 	u8 num_button_polling_addresses;
 	/* Snapshot button input device */
 	char snapshot_button_path[30];	/* path of the input dev */
-- 
1.7.10.4

