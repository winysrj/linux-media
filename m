Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40181 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752175AbaK3Q07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Nov 2014 11:26:59 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org
Subject: [REVIEW PATCH v2.1 08/11] of: smiapp: Add documentation
Date: Sun, 30 Nov 2014 18:26:48 +0200
Message-Id: <1417364809-4693-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289426-804-9-git-send-email-sakari.ailus@iki.fi>
References: <1416289426-804-9-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the smiapp device tree properties.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
since v2:
- Cleanups
- Removed clock-names property documentation
- Port node documentation was really endpoint node documentation
- Added remote-endpoint as mandatory endpoint node properties

 .../devicetree/bindings/media/i2c/nokia,smia.txt   |   64 ++++++++++++++++++++
 MAINTAINERS                                        |    1 +
 2 files changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
new file mode 100644
index 0000000..2114a4d
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
@@ -0,0 +1,64 @@
+SMIA/SMIA++ sensor
+
+SMIA (Standard Mobile Imaging Architecture) is an image sensor standard
+defined jointly by Nokia and ST. SMIA++, defined by Nokia, is an extension
+of that. These definitions are valid for both types of sensors.
+
+More detailed documentation can be found in
+Documentation/devicetree/bindings/media/video-interfaces.txt .
+
+
+Mandatory properties
+--------------------
+
+- compatible: "nokia,smia"
+- reg: I2C address (0x10, or an alternative address)
+- vana-supply: Analogue voltage supply (VANA), typically 2,8 volts (sensor
+  dependent).
+- clocks: External clock phandle
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
+
+Endpoint node mandatory properties
+----------------------------------
+
+- clock-lanes: <0>
+- data-lanes: <1..n>
+- remote-endpoint: A phandle to the bus receiver's endpoint node.
+
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
index 2378a5f..285c1ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8619,6 +8619,7 @@ F:	include/media/smiapp.h
 F:	drivers/media/i2c/smiapp-pll.c
 F:	drivers/media/i2c/smiapp-pll.h
 F:	include/uapi/linux/smiapp.h
+F:	Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
 
 SMM665 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
-- 
1.7.10.4

