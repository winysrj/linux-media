Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:40628 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaIVPXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 11:23:10 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v6 1/6] Documentation: leds: Add description of LED Flash
 Class extension
Date: Mon, 22 Sep 2014 17:22:51 +0200
Message-id: <1411399376-16497-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1411399376-16497-1-git-send-email-j.anaszewski@samsung.com>
References: <1411399376-16497-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation being added contains overall description of the
LED Flash Class and the related sysfs attributes. There are also
chapters devoted specifically to the Flash Manager feature.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class-flash.txt |   51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/leds/leds-class-flash.txt

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
new file mode 100644
index 0000000..0cf5449a
--- /dev/null
+++ b/Documentation/leds/leds-class-flash.txt
@@ -0,0 +1,51 @@
+
+Flash LED handling under Linux
+==============================
+
+Some LED devices support two modes - torch and flash. In order to enable
+support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol must be defined
+in the kernel config. A flash LED driver must register in the LED subsystem
+with led_classdev_flash_register to gain flash capabilities.
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
+
+A LED subsystem driver can be controlled also from the level of VideoForLinux2
+subsystem. In order to enable this CONFIG_V4L2_FLASH_LED_CLASS symbol has to
+be defined in the kernel config. The driver must call v4l2_flash_init function
+to get registered in the V4L2 subsystem. On remove v4l2_flash_release function
+has to be called (see <media/v4l2-flash.h>).
+
+After proper initialization V4L2 Flash sub-device is created. The sub-device
+exposes a number of V4L2 controls. When the V4L2_CID_FLASH_LED_MODE control
+is set to V4L2_FLASH_LED_MODE_TORCH or V4L2_FLASH_LED_MODE_FLASH the
+LED subsystem sysfs interface becomes unavailable. The interface can be
+unlocked by setting the mode back to V4L2_FLASH_LED_MODE_NONE.
-- 
1.7.9.5

