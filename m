Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44806 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731695AbeJBUaU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 16:30:20 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v3 1/2] [media] imx214: device tree binding
Date: Tue,  2 Oct 2018 15:46:48 +0200
Message-Id: <20181002134648.14225-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document bindings for imx214 camera sensor

Cc: devicetree@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
Changelog from v2:
Laurent Pinchart:

-Spell checks
-Remove frequency
-Identation
-Data lanes order

Thanks!

 .../devicetree/bindings/media/i2c/imx214.txt  | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imx214.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/imx214.txt b/Documentation/devicetree/bindings/media/i2c/imx214.txt
new file mode 100644
index 000000000000..bf3cac731eca
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/imx214.txt
@@ -0,0 +1,52 @@
+* Sony 1/3.06-Inch 13.13Mp CMOS Digital Image Sensor
+
+The Sony imx214 is a 1/3.06-inch CMOS active pixel digital image sensor with
+an active array size of 4224H x 3200V. It is programmable through an I2C
+interface. The I2C address can be configured to to 0x1a or 0x10, depending on
+how the hardware is wired.
+Image data is sent through MIPI CSI-2, which is configured as 4 lanes
+at 1440 Mbps.
+
+
+Required Properties:
+- compatible: value should be "sony,imx214" for imx214 sensor
+- reg: I2C bus address of the device
+- enable-gpios: GPIO descriptor for the enable pin.
+- vdddo-supply: Chip digital IO regulator (1.8V).
+- vdda-supply: Chip analog regulator (2.7V).
+- vddd-supply: Chip digital core regulator (1.12V).
+- clocks = Reference to the xclk clock.
+- clock-names = Clock name, e.g. "xclk".
+- clock-frequency = Frequency of the xclk clock. (Currently the
+	driver only supports <24000000>).
+
+Optional Properties:
+- flash-leds: See ../video-interfaces.txt
+- lens-focus: See ../video-interfaces.txt
+
+The imx274 device node should contain one 'port' child node with
+an 'endpoint' subnode. For further reading on port node refer to
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	camera_rear@1a {
+		compatible = "sony,imx214";
+		reg = <0x1a>;
+		vdddo-supply = <&pm8994_lvs1>;
+		vddd-supply = <&camera_vddd_1v12>;
+		vdda-supply = <&pm8994_l17>;
+		lens-focus = <&ad5820>;
+		enable-gpios = <&msmgpio 25 GPIO_ACTIVE_HIGH>;
+		clocks = <&mmcc CAMSS_MCLK0_CLK>;
+		clock-names = "xclk";
+		clock-frequency = <24000000>;
+		port {
+			imx214_ep: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <1 2 3 4>;
+				link-frequencies = /bits/ 64 <480000000>;
+				remote-endpoint = <&csiphy0_ep>;
+			};
+		};
+	};
-- 
2.19.0
