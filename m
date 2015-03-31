Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55003 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbbCaNzB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 09:55:01 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	devicetree@vger.kernel.org
Subject: [PATCH v4 07/12] DT: Add documentation for the Skyworks AAT1290
Date: Tue, 31 Mar 2015 15:52:43 +0200
Message-id: <1427809965-25540-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree binding documentation for
1.5A Step-Up Current Regulator for Flash LEDs.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   40 ++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..6893eb1
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,40 @@
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
+- flash-max-microamp : Maximum intensity in microamperes of the flash LED -
+		       it can be calculated using following formula:
+		       I = 1A * 162kohm / Rset.
+- flash-timeout-us : Maximum flash timeout in microseconds -
+		     it can be calculated using following formula:
+		     T = 8.82 * 10^9 * Ct.
+
+Optional properties of the LED child node:
+- label : see Documentation/devicetree/bindings/leds/common.txt
+
+Example (by Ct = 220nF, Rset = 160kohm and exynos4412-trats2 board with
+a switch that allows for routing strobe signal either from host or from ISP):
+
+aat1290 {
+	compatible = "skyworks,aat1290";
+	flen-gpios = <&gpj1 1 GPIO_ACTIVE_HIGH>;
+	enset-gpios = <&gpj1 2 GPIO_ACTIVE_HIGH>;
+
+	camera_flash: flash-led {
+		label = "aat1290-flash";
+		flash-max-microamp = <1012500>;
+		flash-timeout-us = <1940000>;
+	};
+};
-- 
1.7.9.5

