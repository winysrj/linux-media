Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0043.outbound.protection.outlook.com ([104.47.34.43]:20305
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751419AbdH1PQE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 11:16:04 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <hans.verkuil@cisco.com>, <sakari.ailus@linux.intel.com>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Leon Luo <leonl@leopardimaging.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/2] media:imx274 device tree binding file
Date: Mon, 28 Aug 2017 08:15:33 -0700
Message-ID: <20170828151534.13045-1-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Leon Luo <leonl@leopardimaging.com>

The binding file for imx274 CMOS sensor V4l2 driver

Signed-off-by: Leon Luo <leonl@leopardimaging.com>
Acked-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
---
 .../devicetree/bindings/media/i2c/imx274.txt       | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imx274.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/imx274.txt b/Documentation/devicetree/bindings/media/i2c/imx274.txt
new file mode 100644
index 000000000000..9154666d1149
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/imx274.txt
@@ -0,0 +1,32 @@
+* Sony 1/2.5-Inch 8.51Mp CMOS Digital Image Sensor
+
+The Sony imx274 is a 1/2.5-inch CMOS active pixel digital image sensor with
+an active array size of 3864H x 2202V. It is programmable through I2C
+interface. The I2C address is fixed to 0x1a as per sensor data sheet.
+Image data is sent through MIPI CSI-2, which is configured as 4 lanes
+at 1440 Mbps.
+
+
+Required Properties:
+- compatible: value should be "sony,imx274" for imx274 sensor
+
+Optional Properties:
+- reset-gpios: Sensor reset GPIO
+
+For further reading on port node refer to
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+	imx274: sensor@1a{
+		compatible = "sony,imx274";
+		reg = <0x1a>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reset-gpios = <&gpio_sensor 0 0>;
+		port@0 {
+			reg = <0>;
+			sensor_out: endpoint {
+				remote-endpoint = <&csiss_in>;
+			};
+		};
+	};
-- 
2.14.1.3.g5766cf452
