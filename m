Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52966 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbbKOXIh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 18:08:37 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch v3 2/2] media: v4l: ti-vpe: Document CAL driver
Date: Sun, 15 Nov 2015 17:08:23 -0600
Message-ID: <1447628903-9276-3-git-send-email-bparrot@ti.com>
In-Reply-To: <1447628903-9276-1-git-send-email-bparrot@ti.com>
References: <1447628903-9276-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device Tree bindings for the Camera Adaptation Layer (CAL) driver

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 Documentation/devicetree/bindings/media/ti-cal.txt | 70 ++++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt

diff --git a/Documentation/devicetree/bindings/media/ti-cal.txt b/Documentation/devicetree/bindings/media/ti-cal.txt
new file mode 100644
index 000000000000..680efadb6208
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti-cal.txt
@@ -0,0 +1,70 @@
+Texas Instruments DRA72x CAMERA ADAPTATION LAYER (CAL)
+------------------------------------------------------
+
+The Camera Adaptation Layer (CAL) is a key component for image capture
+applications. The capture module provides the system interface and the
+processing capability to connect CSI2 image-sensor modules to the
+DRA72x device.
+
+Required properties:
+- compatible: must be "ti,cal"
+- reg:	physical base address and length of the registers set for the 4
+	memory regions required;
+- reg-names: name associated with the memory regions described is <reg>;
+- interrupts: should contain IRQ line for the CAL;
+
+CAL supports 2 camera port nodes on MIPI bus. Each CSI2 camera port nodes
+should contain a 'port' child node with child 'endpoint' node. Please
+refer to the bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+	cal: cal@4845b000 {
+		compatible = "ti,cal";
+		ti,hwmods = "cal";
+		reg = <0x4845B000 0x400>,
+		      <0x4845B800 0x40>,
+		      <0x4845B900 0x40>,
+		      <0x4A002e94 0x4>;
+		reg-names = "cal_top",
+			    "cal_rx_core0",
+			    "cal_rx_core1",
+			    "camerrx_control";
+		interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		csi2_0: port@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+			endpoint {
+				slave-mode;
+				remote-endpoint = <&ar0330_1>;
+			};
+		};
+		csi2_1: port@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>;
+		};
+	};
+
+	i2c5: i2c@4807c000 {
+		ar0330@10 {
+			compatible = "ti,ar0330";
+			reg = <0x10>;
+
+			port {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				ar0330_1: endpoint {
+					reg = <0>;
+					clock-lanes = <1>;
+					data-lanes = <0 2 3 4>;
+					remote-endpoint = <&csi2_0>;
+				};
+			};
+		};
+	};
-- 
1.8.5.1

