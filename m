Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:16168 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752896AbdLDHEt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 02:04:49 -0500
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <devicetree@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v6 1/2] media: ov7740: Document device tree bindings
Date: Mon, 4 Dec 2017 14:58:57 +0800
Message-ID: <20171204065858.3138-2-wenyou.yang@microchip.com>
In-Reply-To: <20171204065858.3138-1-wenyou.yang@microchip.com>
References: <20171204065858.3138-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the device tree binding documentation for the ov7740 sensor driver.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
 - Explicitly document the "remote-endpoint" property.

Changes in v2: None

 .../devicetree/bindings/media/i2c/ov7740.txt       | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov7740.txt b/Documentation/devicetree/bindings/media/i2c/ov7740.txt
new file mode 100644
index 000000000000..af781c3a5f0e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov7740.txt
@@ -0,0 +1,47 @@
+* Omnivision OV7740 CMOS image sensor
+
+The Omnivision OV7740 image sensor supports multiple output image
+size, such as VGA, and QVGA, CIF and any size smaller. It also
+supports the RAW RGB and YUV output formats.
+
+The common video interfaces bindings (see video-interfaces.txt) should
+be used to specify link to the image data receiver. The OV7740 device
+node should contain one 'port' child node with an 'endpoint' subnode.
+
+Required Properties:
+- compatible:	"ovti,ov7740".
+- reg:		I2C slave address of the sensor.
+- clocks:	Reference to the xvclk input clock.
+- clock-names:	"xvclk".
+
+Optional Properties:
+- reset-gpios: Rreference to the GPIO connected to the reset_b pin,
+  if any. Active low with pull-ip resistor.
+- powerdown-gpios: Reference to the GPIO connected to the pwdn pin,
+  if any. Active high with pull-down resistor.
+
+Endpoint node mandatory properties:
+- remote-endpoint: A phandle to the bus receiver's endpoint node.
+
+Example:
+
+	i2c1: i2c@fc028000 {
+		ov7740: camera@21 {
+			compatible = "ovti,ov7740";
+			reg = <0x21>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_sensor_power &pinctrl_sensor_reset>;
+			clocks = <&isc>;
+			clock-names = "xvclk";
+			assigned-clocks = <&isc>;
+			assigned-clock-rates = <24000000>;
+			reset-gpios = <&pioA 43 GPIO_ACTIVE_LOW>;
+			powerdown-gpios = <&pioA 44 GPIO_ACTIVE_HIGH>;
+
+			port {
+				ov7740_0: endpoint {
+					remote-endpoint = <&isc_0>;
+				};
+			};
+		};
+	};
-- 
2.15.0
