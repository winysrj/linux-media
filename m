Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34017 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbcFKLPY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 07:15:24 -0400
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	mchehab@osg.samsung.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH v2 2/2] media: et8ek8: Add documentation
Date: Sat, 11 Jun 2016 14:14:40 +0300
Message-Id: <1465643680-21866-3-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1465643680-21866-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <1465643680-21866-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT bindings description

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 .../bindings/media/i2c/toshiba,et8ek8.txt          | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
new file mode 100644
index 0000000..997d268
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
@@ -0,0 +1,50 @@
+Toshiba et8ek8 5MP sensor
+
+Toshiba et8ek8 5MP sensor is an image sensor found in Nokia N900 device
+
+More detailed documentation can be found in
+Documentation/devicetree/bindings/media/video-interfaces.txt .
+
+
+Mandatory properties
+--------------------
+
+- compatible: "toshiba,et8ek8"
+- reg: I2C address (0x3e, or an alternative address)
+- vana-supply: Analogue voltage supply (VANA), 2.8 volts
+- clocks: External clock to the sensor
+- clock-frequency: Frequency of the external clock to the sensor
+- reset-gpios: XSHUTDOWN GPIO
+
+
+Endpoint node mandatory properties
+----------------------------------
+
+- remote-endpoint: A phandle to the bus receiver's endpoint node.
+
+Endpoint node optional properties
+----------------------------------
+
+- clock-lanes: <0>
+- data-lanes: <1..n>
+
+Example
+-------
+
+&i2c3 {
+	clock-frequency = <400000>;
+
+	cam1: camera@3e {
+		compatible = "toshiba,et8ek8";
+		reg = <0x3e>;
+		vana-supply = <&vaux4>;
+		clocks = <&isp 0>;
+		clock-frequency = <9600000>;
+		reset-gpio = <&gpio4 6 GPIO_ACTIVE_HIGH>; /* 102 */
+		port {
+			csi_cam1: endpoint {
+				remote-endpoint = <&csi_out1>;
+			};
+		};
+	};
+};
-- 
1.9.1

