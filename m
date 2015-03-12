Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:62117 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381AbbCLPpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 11:45:47 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v13 01/13] leds: flash: Fix the size of sysfs_groups array
Date: Thu, 12 Mar 2015 16:45:02 +0100
Message-id: <1426175114-14876-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
References: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LED_FLASH_MAX_SYSFS_GROUPS macro had value that was relevant for
previous version of the patches introducing LED Flash class. Currently
it is required to reserve the room for maximum 4 sysfs groups.
Since the last element of the struct attribute_group array passed to
the function device_create_with_groups has to be NULL, the size of the
array has to be greater by one than maximum allowed number of groups.
Therefore, the name of the macro is being changed to
LED_FLASH_SYSFS_GROUPS_SIZE, to make it more accurrate.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 include/linux/led-class-flash.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
index 21ec91e..e97966d 100644
--- a/include/linux/led-class-flash.h
+++ b/include/linux/led-class-flash.h
@@ -32,7 +32,7 @@ struct led_classdev_flash;
 #define LED_FAULT_LED_OVER_TEMPERATURE	(1 << 8)
 #define LED_NUM_FLASH_FAULTS		9
 
-#define LED_FLASH_MAX_SYSFS_GROUPS 7
+#define LED_FLASH_SYSFS_GROUPS_SIZE	5
 
 struct led_flash_ops {
 	/* set flash brightness */
@@ -80,7 +80,7 @@ struct led_classdev_flash {
 	struct led_flash_setting timeout;
 
 	/* LED Flash class sysfs groups */
-	const struct attribute_group *sysfs_groups[LED_FLASH_MAX_SYSFS_GROUPS];
+	const struct attribute_group *sysfs_groups[LED_FLASH_SYSFS_GROUPS_SIZE];
 };
 
 static inline struct led_classdev_flash *lcdev_to_flcdev(
-- 
1.7.9.5

