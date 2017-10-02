Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtpa11-08.prod.phx3.secureserver.net ([68.178.252.109]:60825
        "EHLO p3plsmtpa11-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751204AbdJBUeN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Oct 2017 16:34:13 -0400
From: Leon Luo <leonl@leopardimaging.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, leonl@leopardimaging.com,
        soren.brinkmann@xilinx.com
Subject: [PATCH v7 1/2] media:imx274 device tree binding file
Date: Mon,  2 Oct 2017 13:26:48 -0700
Message-Id: <20171002202649.10897-1-leonl@leopardimaging.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The binding file for imx274 CMOS sensor V4l2 driver

Signed-off-by: Leon Luo <leonl@leopardimaging.com>
Acked-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v7:
 - no changes
v6:
 - no changes
v5:
 - add 'port' and 'endpoint' information
v4:
 - no changes
v3:
 - remove redundant properties and references
 - document 'reg' property
v2:
 - no changes
---
 .../devicetree/bindings/media/i2c/imx274.txt       | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imx274.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/imx274.txt b/Documentation/devicetree/bindings/media/i2c/imx274.txt
new file mode 100644
index 000000000000..80f2e89568e1
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/imx274.txt
@@ -0,0 +1,33 @@
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
+The imx274 device node should contain one 'port' child node with
+an 'endpoint' subnode. For further reading on port node refer to
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
2.14.0.rc1
