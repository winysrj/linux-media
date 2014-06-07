Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63889 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaFGV5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:34 -0400
Received: by mail-pd0-f169.google.com with SMTP id w10so3833478pde.14
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:34 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 32/43] ARM: dts: imx: sabrelite: add video capture ports and endpoints
Date: Sat,  7 Jun 2014 14:56:34 -0700
Message-Id: <1402178205-22697-33-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Defines the host v4l2-capture device node and an OV5642 camera sensor
node on i2c2. The host capture device is a child of ipu1. An OV5642
parallel-bus endpoint is defined that connects to the host parallel-bus
endpoint on CSI0, using the OF graph bindings described in
Documentation/devicetree/bindings/media/video-interfaces.txt.

Note there is a pin conflict with GPIO6. This pin functions as a power
input pin to the OV5642, but ENET requires it to wake-up the ARM cores
on normal RX and TX packet done events (see 6261c4c8). So by default,
capture is disabled, enable by uncommenting __OV5642_CAPTURE__ macro.
Ethernet will still work just not quite as well.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |   91 ++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index abc3080..90d19f8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -90,6 +90,7 @@ nvidia	NVIDIA
 nxp	NXP Semiconductors
 onnn	ON Semiconductor Corp.
 opencores	OpenCores.org
+ovti	OmniVision Technologies, Inc
 panasonic	Panasonic Corporation
 phytec	PHYTEC Messtechnik GmbH
 picochip	Picochip Ltd
diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index 3bec128..ea5bd9c 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -12,6 +12,15 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 
+/*
+ * Uncomment the following macro to enable OV5642 video capture
+ * support. There is a pin conflict for GPIO6 between ENET wake-up
+ * interrupt function and power-down pin function for the OV5642.
+ * ENET will still work when enabling OV5642 capture, just not
+ * quite as well.
+ */
+/* #define __OV5642_CAPTURE__ */
+
 / {
 	memory {
 		reg = <0x10000000 0x40000000>;
@@ -164,8 +173,10 @@
 	txd1-skew-ps = <0>;
 	txd2-skew-ps = <0>;
 	txd3-skew-ps = <0>;
+#ifndef __OV5642_CAPTURE__
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
+#endif
 	status = "okay";
 };
 
@@ -193,6 +204,12 @@
 			fsl,pins = <
 				/* SGTL5000 sys_mclk */
 				MX6QDL_PAD_GPIO_0__CCM_CLKO1    0x030b0
+#ifdef __OV5642_CAPTURE__
+				MX6QDL_PAD_SD1_DAT0__GPIO1_IO16 0x80000000
+				MX6QDL_PAD_GPIO_6__GPIO1_IO06 0x80000000
+				MX6QDL_PAD_GPIO_8__GPIO1_IO08 0x80000000
+				MX6QDL_PAD_GPIO_3__CCM_CLKO2 0x80000000
+#endif
 			>;
 		};
 
@@ -233,7 +250,9 @@
 				MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL	0x1b0b0
 				/* Phy reset */
 				MX6QDL_PAD_EIM_D23__GPIO3_IO23		0x000b0
+#ifndef __OV5642_CAPTURE__
 				MX6QDL_PAD_GPIO_6__ENET_IRQ		0x000b1
+#endif
 			>;
 		};
 
@@ -261,6 +280,13 @@
 			>;
 		};
 
+		pinctrl_i2c2: i2c2grp {
+			fsl,pins = <
+				MX6QDL_PAD_KEY_COL3__I2C2_SCL           0x4001b8b1
+				MX6QDL_PAD_KEY_ROW3__I2C2_SDA           0x4001b8b1
+			>;
+		};
+
 		pinctrl_pwm1: pwm1grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD1_DAT3__PWM1_OUT 0x1b0b1
@@ -421,3 +447,68 @@
 	vmmc-supply = <&reg_3p3v>;
 	status = "okay";
 };
+
+#ifdef __OV5642_CAPTURE__
+
+&i2c2 {
+	status = "okay";
+	clock-frequency = <100000>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_i2c2>;
+
+	camera: ov5642@3c {
+		compatible = "ovti,ov5642";
+		clocks = <&clks 200>;
+		clock-names = "xclk";
+		reg = <0x3c>;
+		xclk = <24000000>;
+		reset-gpios = <&gpio1 8 0>;
+		pwdn-gpios = <&gpio1 6 0>;
+		gp-gpios = <&gpio1 16 0>;
+
+		port {
+			/* With 1 endpoint per port no need for addresses. */
+			ov5642_1: endpoint {
+				remote-endpoint = <&csi0>;
+				bus-width = <12>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+	};
+};
+
+&ipu1 {
+	status = "okay";
+
+	v4l2-capture {
+		compatible = "fsl,imx6-v4l2-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
+		pinctrl-names = "default";
+		pinctrl-0 = <
+			&pinctrl_ipu1_csi0_1
+			&pinctrl_ipu1_csi0_data_en
+		>;
+
+		/* CSI0 */
+		port@0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0>;
+
+			/* Parallel bus */
+			csi0: endpoint@0 {
+				reg = <0>;
+				remote-endpoint = <&ov5642_1>;
+				bus-width = <12>;
+				data-shift = <8>; /* Lines 19:8 used */
+				hsync-active = <1>;
+				vync-active = <1>;
+			};
+		};
+	};
+};
+
+#endif /* __OV5642_CAPTURE__ */
-- 
1.7.9.5

