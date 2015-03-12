Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:26353 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbbCLPq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 11:46:28 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v13 07/13] DT: Add documentation for the Skyworks AAT1290
Date: Thu, 12 Mar 2015 16:45:08 +0100
Message-id: <1426175114-14876-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
References: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree binding documentation for
1.5A Step-Up Current Regulator for Flash LEDs.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   71 ++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..b2a1192
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,71 @@
+* Skyworks Solutions, Inc. AAT1290 Current Regulator for Flash LEDs
+
+The device is controlled through two pins: FL_EN and EN_SET. The pins when,
+asserted high, enable flash strobe and movie mode (max 1/2 of flash current)
+respectively. In order to add a capability of selecting the strobe signal source
+(e.g. GPIO or ISP) there is an additional switch required, independent of the
+flash chip. The switch is controlled with pin control.
+
+Required properties:
+
+- compatible : Must be "skyworks,aat1290".
+- flen-gpios : Must be device tree identifier of the flash device FL_EN pin.
+- enset-gpios : Must be device tree identifier of the flash device EN_SET pin.
+
+Optional properties:
+- pinctrl-names : Must contain entries: "default", "host", "isp". Entries
+		"default" and "host" must refer to the same pin configuration
+		node, which sets the host as a strobe signal provider. Entry
+		"isp" must refer to the pin configuration node, which sets the
+		ISP as a strobe signal provider.
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
+#include "exynos4412.dtsi"
+
+aat1290 {
+	compatible = "skyworks,aat1290";
+	gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+	flen-gpios = <&gpj1 1 GPIO_ACTIVE_HIGH>;
+	enset-gpios = <&gpj1 2 GPIO_ACTIVE_HIGH>;
+
+	pinctrl-names = "default", "host", "isp";
+	pinctrl-0 = <&camera_flash_host>;
+	pinctrl-1 = <&camera_flash_host>;
+	pinctrl-2 = <&camera_flash_isp>;
+
+	camera_flash: flash-led {
+		label = "aat1290-flash";
+		flash-max-microamp = <1012500>
+		flash-timeout-us = <1940000>;
+	};
+};
+
+&pinctrl_0 {
+	camera_flash_host: camera-flash-host {
+		samsung,pins = "gpj1-0";
+		samsung,pin-function = <1>;
+		samsung,pin-val = <0>;
+	};
+
+	camera_flash_isp: camera-flash-isp {
+		samsung,pins = "gpj1-0";
+		samsung,pin-function = <1>;
+		samsung,pin-val = <1>;
+	};
+};
-- 
1.7.9.5

