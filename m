Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:53375 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030313AbbCLPqm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 11:46:42 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v13 10/13] Documentation: leds: Add description of
 v4l2-flash sub-device
Date: Thu, 12 Mar 2015 16:45:11 +0100
Message-id: <1426175114-14876-11-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
References: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch extends LED Flash class documention by
the description of interactions with v4l2-flash sub-device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
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

