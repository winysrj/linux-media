Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56206 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaDRBY6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 21:24:58 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: m.chehab@samsung.com, felipensp@gmail.com, mkrufky@linuxtv.org,
	linux-media@vger.kernel.org
Cc: backports@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH 1/2] technisat-usb2: rename led enums to be specific to driver
Date: Thu, 17 Apr 2014 18:24:43 -0700
Message-Id: <1397784284-15946-2-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1397784284-15946-1-git-send-email-mcgrof@do-not-panic.com>
References: <1397784284-15946-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The current names clash with include/linux/leds.h namespace,
although there is no compile issue currently this does affect
backports. Drivers should also try to avoid generic namespaces
for things like this.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Felipe Pena <felipensp@gmail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/media/usb/dvb-usb/technisat-usb2.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 98d24ae..d947e03 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -214,10 +214,10 @@ static void technisat_usb2_frontend_reset(struct usb_device *udev)
 
 /* LED control */
 enum technisat_usb2_led_state {
-	LED_OFF,
-	LED_BLINK,
-	LED_ON,
-	LED_UNDEFINED
+	TECH_LED_OFF,
+	TECH_LED_BLINK,
+	TECH_LED_ON,
+	TECH_LED_UNDEFINED
 };
 
 static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum technisat_usb2_led_state state)
@@ -229,14 +229,14 @@ static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum techni
 		0
 	};
 
-	if (disable_led_control && state != LED_OFF)
+	if (disable_led_control && state != TECH_LED_OFF)
 		return 0;
 
 	switch (state) {
-	case LED_ON:
+	case TECH_LED_ON:
 		led[1] = 0x82;
 		break;
-	case LED_BLINK:
+	case TECH_LED_BLINK:
 		led[1] = 0x82;
 		if (red) {
 			led[2] = 0x02;
@@ -251,7 +251,7 @@ static int technisat_usb2_set_led(struct dvb_usb_device *d, int red, enum techni
 		break;
 
 	default:
-	case LED_OFF:
+	case TECH_LED_OFF:
 		led[1] = 0x80;
 		break;
 	}
@@ -310,11 +310,11 @@ static void technisat_usb2_green_led_control(struct work_struct *work)
 				goto schedule;
 
 			if (ber > 1000)
-				technisat_usb2_set_led(state->dev, 0, LED_BLINK);
+				technisat_usb2_set_led(state->dev, 0, TECH_LED_BLINK);
 			else
-				technisat_usb2_set_led(state->dev, 0, LED_ON);
+				technisat_usb2_set_led(state->dev, 0, TECH_LED_ON);
 		} else
-			technisat_usb2_set_led(state->dev, 0, LED_OFF);
+			technisat_usb2_set_led(state->dev, 0, TECH_LED_OFF);
 	}
 
 schedule:
@@ -365,9 +365,9 @@ static int technisat_usb2_power_ctrl(struct dvb_usb_device *d, int level)
 		return 0;
 
 	/* green led is turned off in any case - will be turned on when tuning */
-	technisat_usb2_set_led(d, 0, LED_OFF);
+	technisat_usb2_set_led(d, 0, TECH_LED_OFF);
 	/* red led is turned on all the time */
-	technisat_usb2_set_led(d, 1, LED_ON);
+	technisat_usb2_set_led(d, 1, TECH_LED_ON);
 	return 0;
 }
 
@@ -667,7 +667,7 @@ static int technisat_usb2_rc_query(struct dvb_usb_device *d)
 		return 0;
 
 	if (!disable_led_control)
-		technisat_usb2_set_led(d, 1, LED_BLINK);
+		technisat_usb2_set_led(d, 1, TECH_LED_BLINK);
 
 	return 0;
 }
-- 
1.9.1

