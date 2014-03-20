Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:54066 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546AbaCTOvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:41 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC 3/8] Documentation: leds: Add description of flash mode
Date: Thu, 20 Mar 2014 15:51:05 +0100
Message-id: <1395327070-20215-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class.txt |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.txt
index 62261c0..d34d990 100644
--- a/Documentation/leds/leds-class.txt
+++ b/Documentation/leds/leds-class.txt
@@ -8,6 +8,31 @@ LED is defined in max_brightness file. The brightness file will set the brightne
 of the LED (taking a value 0-max_brightness). Most LEDs don't have hardware
 brightness support so will just be turned on for non-zero brightness settings.
 
+Some LED devices support two modes - torch and flash. A LED subsystem device
+driver can declare this by calling led_classdev_init_flash function and
+initializing flash field of the led_classdev structure (see <linux/leds.h>).
+There are five sysfs attributes dedicated specifically to the flash LED devices:
+
+	- flash_mode - sets/unsets the flash mode
+	- flash_timeout - determines duration of the flash blink in milliseconds
+	- max_flash_timeout - maximum flash blink duration that can be set (RO)
+	- flash_fault - bitmask of flash faults that may have occured, possible
+			flags are:
+		* 0x01 - Flash controller voltage to the flash LED has exceeded
+			 the limit specific to the flash controller.
+		* 0x02 - The flash strobe was still on when the timeout set by
+			 the user has expired. Not all flash controllers may set
+			 this in all such conditions.
+		* 0x04 - The flash controller has overheated.
+		* 0x08 - The short circuit protection of the flash controller
+			 has been triggered.
+		* 0x10 - Current in the LED power supply has exceeded the limit
+			 specific to the flash controller.
+	- hw_triggered - Some devices expose dedicated hardware pins for
+			 triggering a flash LED. The attribute allows to set
+			 this mode. After writting 1 the brightness has to be set
+			 to the desired value to arm a led.
+
 The class also introduces the optional concept of an LED trigger. A trigger
 is a kernel based source of led events. Triggers can either be simple or
 complex. A simple trigger isn't configurable and is designed to slot into
-- 
1.7.9.5

