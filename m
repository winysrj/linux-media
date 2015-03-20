Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:42336 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbbCTPEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 11:04:15 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v1 08/11] Documentation: leds: Add description of v4l2-flash
 sub-device
Date: Fri, 20 Mar 2015 16:03:28 +0100
Message-id: <1426863811-12516-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch extends LED Flash class documention by
the description of interactions with v4l2-flash sub-device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class-flash.txt |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
index 19bb673..8623413 100644
--- a/Documentation/leds/leds-class-flash.txt
+++ b/Documentation/leds/leds-class-flash.txt
@@ -20,3 +20,16 @@ Following sysfs attributes are exposed for controlling flash LED devices:
 	- max_flash_timeout
 	- flash_strobe
 	- flash_fault
+
+A LED subsystem driver can be controlled also from the level of VideoForLinux2
+subsystem. In order to enable this CONFIG_V4L2_FLASH_LED_CLASS symbol has to
+be defined in the kernel config. The driver must call the v4l2_flash_init
+function to get registered in the V4L2 subsystem. On remove the
+v4l2_flash_release function has to be called (see <media/v4l2-flash.h>).
+
+After proper initialization a V4L2 Flash sub-device is created. The sub-device
+exposes a number of V4L2 controls, which allow for controlling a LED Flash class
+device with use of its internal kernel API.
+Opening the V4L2 Flash sub-device makes the LED subsystem sysfs interface
+unavailable. The interface is re-enabled after the V4L2 Flash sub-device
+is closed.
-- 
1.7.9.5

