Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:24095 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbBRQV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 11:21:29 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v11 01/20] leds: flash: document sysfs interface
Date: Wed, 18 Feb 2015 17:20:22 +0100
Message-id: <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a documentation of LED Flash class specific sysfs attributes.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/ABI/testing/sysfs-class-led-flash |  104 +++++++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-led-flash

diff --git a/Documentation/ABI/testing/sysfs-class-led-flash b/Documentation/ABI/testing/sysfs-class-led-flash
new file mode 100644
index 0000000..c941d21
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-led-flash
@@ -0,0 +1,104 @@
+What:		/sys/class/leds/<led>/flash_brightness
+Date:		February 2015
+KernelVersion:	3.20
+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
+Description:	read/write
+		Set the brightness of this LED in the flash strobe mode, in
+		microamperes. The file is created only for the flash LED devices
+		that support setting flash brightness.
+
+		The value is between 0 and
+		/sys/class/leds/<led>/max_flash_brightness.
+
+What:		/sys/class/leds/<led>/max_flash_brightness
+Date:		February 2015
+KernelVersion:	3.20
+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
+Description:	read only
+		Maximum brightness level for this LED in the flash strobe mode,
+		in microamperes.
+
+What:		/sys/class/leds/<led>/flash_timeout
+Date:		February 2015
+KernelVersion:	3.20
+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
+Description:	read/write
+		Hardware timeout for flash, in microseconds. The flash strobe
+		is stopped after this period of time has passed from the start
+		of the strobe. The file is created only for the flash LED
+		devices that support setting flash timeout.
+
+What:		/sys/class/leds/<led>/max_flash_timeout
+Date:		February 2015
+KernelVersion:	3.20
+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
+Description:	read only
+		Maximum flash timeout for this LED, in microseconds.
+
+What:		/sys/class/leds/<led>/flash_strobe
+Date:		February 2015
+KernelVersion:	3.20
+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
+Description:	read/write
+		Flash strobe state. When written with 1 it triggers flash strobe
+		and when written with 0 it turns the flash off.
+
+		On read 1 means that flash is currently strobing and 0 means
+		that flash is off.
+
+What:		/sys/class/leds/<led>/flash_sync_strobe
+Date:		February 2015
+KernelVersion:	3.20
+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
+Description:	read/write
+		Identifier of the LED to synchronize the flash strobe with.
+		0 stands for no synchronization. Usually the LEDs available for
+		flash strobing are driven by the same flash LED device. The LEDs
+		available for flash strobe synchronization can be obtained by
+		reading the /sys/class/leds/<led>/available_sync_leds attribute.
+
+		On read the currently selected LED is displayed in the format:
+		led_id.led_name
+
+What:		/sys/class/leds/<led>/available_sync_leds
+Date:		February 2015
+KernelVersion:	3.20
+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
+Description:	read/write
+		Space separated list of LEDs available for flash strobe
+		synchronization, displayed in the format:
+
+		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.
+
+What:		/sys/class/leds/<led>/flash_fault
+Date:		February 2015
+KernelVersion:	3.20
+Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
+Description:	read only
+		Space separated list of flash faults that may have occurred.
+		Flash faults are re-read after strobing the flash. Possible
+		flash faults:
+
+		* led-over-voltage - flash controller voltage to the flash LED
+			has exceeded the limit specific to the flash controller
+		* flash-timeout-exceeded - the flash strobe was still on when
+			the timeout set by the user has expired; not all flash
+			controllers may set this in all such conditions
+		* controller-over-temperature - the flash controller has
+			overheated
+		* controller-short-circuit - the short circuit protection
+			of the flash controller has been triggered
+		* led-power-supply-over-current - current in the LED power
+			supply has exceeded the limit specific to the flash
+			controller
+		* indicator-led-fault - the flash controller has detected
+			a short or open circuit condition on the indicator LED
+		* led-under-voltage - flash controller voltage to the flash
+			LED has been below the minimum limit specific to
+			the flash
+		* controller-under-voltage - the input voltage of the flash
+			controller is below the limit under which strobing the
+			flash at full current will not be possible;
+			the condition persists until this flag is no longer set
+		* led-over-temperature - the temperature of the LED has exceeded
+			its allowed upper limit
-- 
1.7.9.5

