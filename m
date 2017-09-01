Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtpa09-04.prod.phx3.secureserver.net ([173.201.193.233]:54548
        "EHLO p3plsmtpa09-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752423AbdIAUkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 16:40:47 -0400
From: Leon Luo <leonl@leopardimaging.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, leonl@leopardimaging.com,
        soren.brinkmann@xilinx.com
Subject: [PATCH v4 1/2] media:imx274 device tree binding file
Date: Fri,  1 Sep 2017 13:32:42 -0700
Message-Id: <20170901203243.25694-1-leonl@leopardimaging.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The binding file for imx274 CMOS sensor V4l2 driver

Signed-off-by: Leon Luo <leonl@leopardimaging.com>
---
v4:
 - no changes
v3:
 - remove redundant properties and references
 - document 'reg' property
v2:
 - no changes
---
 .../devicetree/bindings/media/i2c/imx274.txt       | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imx274.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/imx274.txt b/Documentation/devicetree/bindings/media/i2c/imx274.txt
new file mode 100644
index 000000000000..1f03256b35db
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
+- reg: I2C bus address of the device
+
+Optional Properties:
+- reset-gpios: Sensor reset GPIO
+
+For further reading on port node refer to
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+	sensor@1a {
+		compatible = "sony,imx274";
+		reg = <0x1a>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reset-gpios = <&gpio_sensor 0 0>;
+		port {
+			sensor_out: endpoint {
+				remote-endpoint = <&csiss_in>;
+			};
+		};
+	};
-- 
2.14.1.145.gb3622a4
