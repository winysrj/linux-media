Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:58858 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbbBRQZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 11:25:36 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v11 13/20] DT: Add documentation for the Skyworks AAT1290
Date: Wed, 18 Feb 2015 17:20:34 +0100
Message-id: <1424276441-3969-14-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree binding documentation for
1.5A Step-Up Current Regulator for Flash LEDs.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   43 ++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..78aa7da
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,43 @@
+* Skyworks Solutions, Inc. AAT1290 Current Regulator for Flash LEDs
+
+The device is controlled through two pins: FL_EN and EN_SET. The pins when,
+asserted high, enable flash strobe and movie mode (max 1/2 of flash current)
+respectively. In order to add a capability of selecting the strobe signal source
+(e.g. GPIO or camera sensor) there is an additional switch required, independent
+of the flash chip.
+
+Such a switch is provided on the exynos4412-trats2 board. The switch is
+configured so that it is possible to change EN_SET and FL_EN signal sources
+simultaneously with one GPIO. This gpio can be provided in the third element
+of 'gpios ' property.
+
+Required properties:
+
+- compatible : Must be "skyworks,aat1290".
+- gpios : Two gpio pins in order FLEN, EN/SET, and optional third
+	  HW_FLASH_EN gpio for controlling the HW_FLASH_SW mux.
+
+The LED connected to the device must be represented by a child node -
+see Documentation/devicetree/bindings/leds/common.txt.
+
+Required properties of the LED child node:
+- label : see Documentation/devicetree/bindings/leds/common.txt
+- flash-max-microamp : Maximum intensity in microamperes of the flash LED -
+		       it can be calculated using following formula:
+		       I = 1A * 162kohm / Rset
+- flash-timeout-us : Maximum flash timeout in microseconds -
+		     it can be calculated using following formula:
+		     T = 8.82 * 10^9 * Ct.
+
+Example (by Ct = 220nF, Rset = 160kohm)
+
+aat1290 {
+	compatible = "skyworks,aat1290";
+	gpios = <&gpj1 1 0>, <&gpj1 2 0>, <&gpj1 0 0>;
+
+	camera_flash: flash-led {
+		label = "aat1290-flash";
+		flash-max-microamp = <1012500>
+		flash-timeout-us = <1940000>;
+	};
+};
-- 
1.7.9.5

