Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:35989 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbGQIsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 04:48:09 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cooloney@gmail.com,
	rpurdie@rpsys.net, stsp@users.sourceforge.net,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org
Subject: [PATCH/RFC 06/51] media: flash: use led_set_brightness_sync for torch
 brightness
Date: Fri, 17 Jul 2015 10:46:52 +0200
Message-id: <1437122857-6765-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1437122857-6765-1-git-send-email-j.anaszewski@samsung.com>
References: <1437122857-6765-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LED subsystem shifted responsibility for choosing between SYNC or ASYNC
way of setting brightness from drivers to the caller. Adapt the wrapper
to those changes.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org
---
 drivers/media/v4l2-core/v4l2-flash-led-class.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index 5bdfb8d..5d67335 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -107,10 +107,10 @@ static void v4l2_flash_set_led_brightness(struct v4l2_flash *v4l2_flash,
 		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_TORCH)
 			return;
 
-		led_set_brightness(&v4l2_flash->fled_cdev->led_cdev,
+		led_set_brightness_sync(&v4l2_flash->fled_cdev->led_cdev,
 					brightness);
 	} else {
-		led_set_brightness(&v4l2_flash->iled_cdev->led_cdev,
+		led_set_brightness_sync(&v4l2_flash->iled_cdev->led_cdev,
 					brightness);
 	}
 }
@@ -206,11 +206,11 @@ static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
 	case V4L2_CID_FLASH_LED_MODE:
 		switch (c->val) {
 		case V4L2_FLASH_LED_MODE_NONE:
-			led_set_brightness(led_cdev, LED_OFF);
+			led_set_brightness_sync(led_cdev, LED_OFF);
 			return led_set_flash_strobe(fled_cdev, false);
 		case V4L2_FLASH_LED_MODE_FLASH:
 			/* Turn the torch LED off */
-			led_set_brightness(led_cdev, LED_OFF);
+			led_set_brightness_sync(led_cdev, LED_OFF);
 			if (ctrls[STROBE_SOURCE]) {
 				external_strobe = (ctrls[STROBE_SOURCE]->val ==
 					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
-- 
1.7.9.5

