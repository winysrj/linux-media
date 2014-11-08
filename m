Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53013 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751536AbaKHXJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:09:44 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org
Subject: [PATCH 07/10] of: smiapp: Add documentation
Date: Sun,  9 Nov 2014 01:09:28 +0200
Message-Id: <1415488171-27636-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
References: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the smiapp device tree properties.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/media/i2c/nokia,smia.txt   |   63 ++++++++++++++++++++
 MAINTAINERS                                        |    1 +
 2 files changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
new file mode 100644
index 0000000..d51d882
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
@@ -0,0 +1,63 @@
+SMIA/SMIA++ sensor
+
+SMIA (Standard Mobile Imaging Architecture) is an image sensor standard
+defined jointly by Nokia and ST. SMIA++, defined by Nokia, is an extension
+of that. These definitions are valid for both types of sensors.
+
+Mandatory properties
+--------------------
+
+- compatible: "nokia,smia"
+- reg: I2C address (0x10, or an alternative address)
+- vana-supply: Analogue voltage supply (VANA), typically 2,8 volts (sensor
+  dependent).
+- clocks: External clock phandle
+- clock-names: Name of the external clock
+- clock-frequency: Frequency of the external clock to the sensor
+- link-frequency: List of allowed data link frequencies. An array of 64-bit
+  elements.
+
+
+Optional properties
+-------------------
+
+- nokia,nvm-size: The size of the NVM, in bytes. If the size is not given,
+  the NVM contents will not be read.
+- reset-gpios: XSHUTDOWN GPIO
+
+Port node
+---------
+
+These properties are mandatory in the port node:
+
+- clock-lanes: <0>
+- data-lanes: <1..n>
+
+More detailed port node documentation can be found in
+Documentation/devicetree/bindings/media/video-interfaces.txt .
+
+Example
+-------
+
+&i2c2 {
+	clock-frequency = <400000>;
+
+	smiapp_1: camera@10 {
+		compatible = "nokia,smia";
+		reg = <0x10>;
+		reset-gpios = <&gpio3 20 0>;
+		vana-supply = <&vaux3>;
+		clocks = <&omap3_isp 0>;
+		clock-names = "ext_clk";
+		clock-frequency = <9600000>;
+		nokia,nvm-size = <512>; /* 8 * 64 */
+		link-frequency = /bits/ 64 <199200000 210000000 499200000>;
+		port {
+			smiapp_1_1: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+				remote-endpoint = <&csi2a_ep>;
+			};
+		};
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index 39e3f91..be15774 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8591,6 +8591,7 @@ F:	drivers/media/i2c/smiapp/
 F:	include/media/smiapp.h
 F:	drivers/media/i2c/smiapp-pll.c
 F:	drivers/media/i2c/smiapp-pll.h
+F:	Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
 
 SMM665 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
-- 
1.7.10.4

