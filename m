Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13690 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110AbbCDQQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 11:16:09 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v12 03/19] Documentation: leds: Add description of LED
 Flash class extension
Date: Wed, 04 Mar 2015 17:14:24 +0100
Message-id: <1425485680-8417-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation being added contains overall description of the
LED Flash Class and the related sysfs attributes.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class-flash.txt |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/leds/leds-class-flash.txt

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
new file mode 100644
index 0000000..19bb673
--- /dev/null
+++ b/Documentation/leds/leds-class-flash.txt
@@ -0,0 +1,22 @@
+
+Flash LED handling under Linux
+==============================
+
+Some LED devices provide two modes - torch and flash. In the LED subsystem
+those modes are supported by LED class (see Documentation/leds/leds-class.txt)
+and LED Flash class respectively. The torch mode related features are enabled
+by default and the flash ones only if a driver declares it by setting
+LED_DEV_CAP_FLASH flag.
+
+In order to enable the support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
+must be defined in the kernel config. A LED Flash class driver must be
+registered in the LED subsystem with led_classdev_flash_register function.
+
+Following sysfs attributes are exposed for controlling flash LED devices:
+(see Documentation/ABI/testing/sysfs-class-led-flash)
+	- flash_brightness
+	- max_flash_brightness
+	- flash_timeout
+	- max_flash_timeout
+	- flash_strobe
+	- flash_fault
-- 
1.7.9.5

