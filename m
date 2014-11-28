Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26907 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaK1JTP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 04:19:15 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED Flash
 class extension
Date: Fri, 28 Nov 2014 10:17:54 +0100
Message-id: <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation being added contains overall description of the
LED Flash Class and the related sysfs attributes.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class-flash.txt |   48 +++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/leds/leds-class-flash.txt

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
new file mode 100644
index 0000000..d68565c
--- /dev/null
+++ b/Documentation/leds/leds-class-flash.txt
@@ -0,0 +1,48 @@
+
+Flash LED handling under Linux
+==============================
+
+Some LED devices support two modes - torch and flash. The modes are
+supported by the LED class (see Documentation/leds/leds-class.txt)
+and LED Flash class respectively.
+
+In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
+must be defined in the kernel config. A flash LED driver must register
+in the LED subsystem with led_classdev_flash_register to gain flash
+capabilities.
+
+Following sysfs attributes are exposed for controlling flash led devices:
+
+	- flash_brightness - flash LED brightness in microamperes (RW)
+	- max_flash_brightness - maximum available flash LED brightness (RO)
+	- indicator_brightness - privacy LED brightness in microamperes (RW)
+	- max_indicator_brightness - maximum privacy LED brightness in
+				     microamperes (RO)
+	- flash_timeout - flash strobe duration in microseconds (RW)
+	- max_flash_timeout - maximum available flash strobe duration (RO)
+	- flash_strobe - flash strobe state (RW)
+	- flash_sync_strobe - one flash device can control more than one
+			      sub-led; when this atrribute is set to 1
+			      the flash led will be strobed synchronously
+			      with the other ones controlled by the same
+			      device (RW)
+	- flash_fault - bitmask of flash faults that may have occurred,
+			possible flags are:
+		* 0x01 - flash controller voltage to the flash LED has exceeded
+			 the limit specific to the flash controller
+		* 0x02 - the flash strobe was still on when the timeout set by
+			 the user has expired; not all flash controllers may
+			 set this in all such conditions
+		* 0x04 - the flash controller has overheated
+		* 0x08 - the short circuit protection of the flash controller
+			 has been triggered
+		* 0x10 - current in the LED power supply has exceeded the limit
+			 specific to the flash controller
+		* 0x40 - flash controller voltage to the flash LED has been
+			 below the minimum limit specific to the flash
+		* 0x80 - the input voltage of the flash controller is below
+			 the limit under which strobing the flash at full
+			 current will not be possible. The condition persists
+			 until this flag is no longer set
+		* 0x100 - the temperature of the LED has exceeded its allowed
+			  upper limit
-- 
1.7.9.5

