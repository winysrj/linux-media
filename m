Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52577 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3LNJjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 04:39:20 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so1294025eae.13
        for <linux-media@vger.kernel.org>; Sat, 14 Dec 2013 01:39:18 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2] em28xx: reduce the polling interval for GPI connected buttons
Date: Sat, 14 Dec 2013 10:40:11 +0100
Message-Id: <1387014011-3062-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For GPI-connected buttons without (hardware) debouncing, the polling interval
needs to be reduced to detect button presses properly.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |   21 ++++++++++++++-------
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 2 Dateien geändert, 15 Zeilen hinzugefügt(+), 7 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index e0acc92..4ff67729 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -30,8 +30,9 @@
 
 #include "em28xx.h"
 
-#define EM28XX_SNAPSHOT_KEY KEY_CAMERA
-#define EM28XX_BUTTONS_QUERY_INTERVAL 500
+#define EM28XX_SNAPSHOT_KEY				KEY_CAMERA
+#define EM28XX_BUTTONS_DEBOUNCED_QUERY_INTERVAL		500 /* [ms] */
+#define EM28XX_BUTTONS_VOLATILE_QUERY_INTERVAL		100 /* [ms] */
 
 static unsigned int ir_debug;
 module_param(ir_debug, int, 0644);
@@ -545,7 +546,7 @@ static void em28xx_query_buttons(struct work_struct *work)
 	}
 	/* Schedule next poll */
 	schedule_delayed_work(&dev->buttons_query_work,
-			      msecs_to_jiffies(EM28XX_BUTTONS_QUERY_INTERVAL));
+			      msecs_to_jiffies(dev->button_polling_interval));
 }
 
 static int em28xx_register_snapshot_button(struct em28xx *dev)
@@ -593,6 +594,7 @@ static void em28xx_init_buttons(struct em28xx *dev)
 	u8  i = 0, j = 0;
 	bool addr_new = 0;
 
+	dev->button_polling_interval = EM28XX_BUTTONS_DEBOUNCED_QUERY_INTERVAL;
 	while (dev->board.buttons[i].role >= 0 &&
 			 dev->board.buttons[i].role < EM28XX_NUM_BUTTON_ROLES) {
 		struct em28xx_button *button = &dev->board.buttons[i];
@@ -608,18 +610,18 @@ static void em28xx_init_buttons(struct em28xx *dev)
 		if (addr_new && dev->num_button_polling_addresses
 					   >= EM28XX_NUM_BUTTON_ADDRESSES_MAX) {
 			WARN_ONCE(1, "BUG: maximum number of button polling addresses exceeded.");
-			addr_new = 0;
+			goto next_button;
 		}
 		/* Button role specific checks and actions */
 		if (button->role == EM28XX_BUTTON_SNAPSHOT) {
 			/* Register input device */
 			if (em28xx_register_snapshot_button(dev) < 0)
-				addr_new = 0;
+				goto next_button;
 		} else if (button->role == EM28XX_BUTTON_ILLUMINATION) {
 			/* Check sanity */
 			if (!em28xx_find_led(dev, EM28XX_LED_ILLUMINATION)) {
 				em28xx_errdev("BUG: illumination button defined, but no illumination LED.\n");
-				addr_new = 0;
+				goto next_button;
 			}
 		}
 		/* Add read address to list of polling addresses */
@@ -628,6 +630,11 @@ static void em28xx_init_buttons(struct em28xx *dev)
 			dev->button_polling_addresses[index] = button->reg_r;
 			dev->num_button_polling_addresses++;
 		}
+		/* Reduce polling interval if necessary */
+		if (!button->reg_clearing)
+			dev->button_polling_interval =
+					 EM28XX_BUTTONS_VOLATILE_QUERY_INTERVAL;
+next_button:
 		/* Next button */
 		i++;
 	}
@@ -639,7 +646,7 @@ static void em28xx_init_buttons(struct em28xx *dev)
 		INIT_DELAYED_WORK(&dev->buttons_query_work,
 							  em28xx_query_buttons);
 		schedule_delayed_work(&dev->buttons_query_work,
-			       msecs_to_jiffies(EM28XX_BUTTONS_QUERY_INTERVAL));
+			       msecs_to_jiffies(dev->button_polling_interval));
 	}
 }
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 6e26fba..27652d4 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -680,6 +680,7 @@ struct em28xx {
 	u8 button_polling_addresses[EM28XX_NUM_BUTTON_ADDRESSES_MAX];
 	u8 button_polling_last_values[EM28XX_NUM_BUTTON_ADDRESSES_MAX];
 	u8 num_button_polling_addresses;
+	u16 button_polling_interval; /* [ms] */
 	/* Snapshot button input device */
 	char snapshot_button_path[30];	/* path of the input dev */
 	struct input_dev *sbutton_input_dev;
-- 
1.7.10.4

