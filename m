Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:50984 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbD1HVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 03:21:04 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	devicetree@vger.kernel.org
Subject: [PATCH v6 04/10] DT: Add documentation for the Skyworks AAT1290
Date: Tue, 28 Apr 2015 09:18:44 +0200
Message-id: <1430205530-20873-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
References: <1430205530-20873-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree binding documentation for
1.5A Step-Up Current Regulator for Flash LEDs.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   41 ++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..ef88b9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,41 @@
+* Skyworks Solutions, Inc. AAT1290 Current Regulator for Flash LEDs
+
+The device is controlled through two pins: FL_EN and EN_SET. The pins when,
+asserted high, enable flash strobe and movie mode (max 1/2 of flash current)
+respectively.
+
+Required properties:
+
+- compatible : Must be "skyworks,aat1290".
+- flen-gpios : Must be device tree identifier of the flash device FL_EN pin.
+- enset-gpios : Must be device tree identifier of the flash device EN_SET pin.
+
+A discrete LED element connected to the device must be represented by a child
+node - see Documentation/devicetree/bindings/leds/common.txt.
+
+Required properties of the LED child node:
+- led-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
+                       Maximum flash LED supply current can be calculated using
+                       following formula: I = 1A * 162kohm / Rset.
+- flash-timeout-us : see Documentation/devicetree/bindings/leds/common.txt
+                     Maximum flash timeout can be calculated using following
+                     formula: T = 8.82 * 10^9 * Ct.
+
+Optional properties of the LED child node:
+- label : see Documentation/devicetree/bindings/leds/common.txt
+
+Example (by Ct = 220nF, Rset = 160kohm):
+
+aat1290 {
+	compatible = "skyworks,aat1290";
+	flen-gpios = <&gpj1 1 GPIO_ACTIVE_HIGH>;
+	enset-gpios = <&gpj1 2 GPIO_ACTIVE_HIGH>;
+
+	camera_flash: flash-led {
+		label = "aat1290-flash";
+		led-max-microamp = <520833>;
+		flash-max-microamp = <1012500>;
+		flash-timeout-us = <1940000>;
+	};
+};
-- 
1.7.9.5

