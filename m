Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:36160 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbCaNxr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 09:53:47 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	devicetree@vger.kernel.org
Subject: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs related
 properties
Date: Tue, 31 Mar 2015 15:52:37 +0200
Message-id: <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Description of flash LEDs related properties was not precise regarding
the state of corresponding settings in case a property is missing.
Add relevant statements.
Removed is also the requirement making the flash-max-microamp
property obligatory for flash LEDs. It was inconsistent as the property
is defined as optional. Devices which require the property will have
to assert this in their DT bindings.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/leds/common.txt |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
index 747c538..21a25e4 100644
--- a/Documentation/devicetree/bindings/leds/common.txt
+++ b/Documentation/devicetree/bindings/leds/common.txt
@@ -29,13 +29,15 @@ Optional properties for child nodes:
      "ide-disk" - LED indicates disk activity
      "timer" - LED flashes at a fixed, configurable rate
 
-- max-microamp : maximum intensity in microamperes of the LED
-		 (torch LED for flash devices)
-- flash-max-microamp : maximum intensity in microamperes of the
-                       flash LED; it is mandatory if the LED should
-		       support the flash mode
-- flash-timeout-us : timeout in microseconds after which the flash
-                     LED is turned off
+- max-microamp : Maximum intensity in microamperes of the LED
+		 (torch LED for flash devices). If omitted this will default
+		 to the maximum current allowed by the device.
+- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
+		       If omitted this will default to the maximum
+		       current allowed by the device.
+- flash-timeout-us : Timeout in microseconds after which the flash
+                     LED is turned off. If omitted this will default to the
+		     maximum timeout allowed by the device.
 
 
 Examples:
-- 
1.7.9.5

