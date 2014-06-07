Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39977 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaFGV5f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:35 -0400
Received: by mail-pb0-f54.google.com with SMTP id jt11so3867191pbb.41
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:35 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 33/43] ARM: dts: imx6-sabresd: add video capture ports and endpoints
Date: Sat,  7 Jun 2014 14:56:35 -0700
Message-Id: <1402178205-22697-34-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Defines the host v4l2-capture device node and two camera sensors:
parallel-bus OV5642 and MIPI CSI-2 OV5640. The host capture device
is a child of ipu1. The MIPI CSI-2 receiver device is also defined.

The OV5642 is connected to the host parallel-bus endpoint on CSI0,
and the OV5640 is connected to the host MIPI CSI-2 endpoint on CSI1,
over virtual channel 0.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi |  116 ++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index 0d816d3..2a932bb 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -164,6 +164,30 @@
 			0x0000 /* 5:Default */
 		>;
        };
+
+	camera: ov5642@3c {
+		compatible = "ovti,ov5642";
+		clocks = <&clks 201>;
+		clock-names = "xclk";
+		reg = <0x3c>;
+		xclk = <24000000>;
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
+						rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		pwdn-gpios = <&gpio1 16 GPIO_ACTIVE_LOW>;   /* SD1_DAT0 */
+		reset-gpios = <&gpio1 17 GPIO_ACTIVE_HIGH>; /* SD1_DAT1 */
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
 };
 
 &i2c2 {
@@ -270,6 +294,32 @@
 			};
 		};
 	};
+
+	mipi_camera: ov5640@3c {
+		compatible = "ovti,ov5640_mipi";
+		reg = <0x3c>;
+		clocks = <&clks 201>;
+		clock-names = "xclk";
+		xclk = <24000000>;
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
+						rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		pwdn-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>; /* SD1_DAT2 */
+		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>; /* SD1_CLK */
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			ov5640_1: endpoint@1 {
+				reg = <1>;
+				remote-endpoint = <&csi1_vc0>;
+				data-lanes = <0 1>;
+				clock-lanes = <2>;
+			};
+		};
+	};
 };
 
 &i2c3 {
@@ -303,6 +353,10 @@
 				MX6QDL_PAD_ENET_TXD1__GPIO1_IO29 0x80000000
 				MX6QDL_PAD_EIM_D22__GPIO3_IO22  0x80000000
 				MX6QDL_PAD_ENET_CRS_DV__GPIO1_IO25 0x80000000
+				MX6QDL_PAD_SD1_DAT0__GPIO1_IO16 0x80000000
+				MX6QDL_PAD_SD1_DAT1__GPIO1_IO17 0x80000000
+				MX6QDL_PAD_SD1_DAT2__GPIO1_IO19 0x80000000
+				MX6QDL_PAD_SD1_CLK__GPIO1_IO20 0x80000000
 			>;
 		};
 
@@ -496,3 +550,65 @@
 	wp-gpios = <&gpio2 1 0>;
 	status = "okay";
 };
+
+&mipi_csi2 {
+	status = "okay";
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	/* Incoming port from sensor */
+	port {
+		mipi_csi2_0: endpoint {
+			remote-endpoint = <&ov5640_1>;
+			data-lanes = <0 1>;
+			clock-lanes = <2>;
+		};
+	};
+};
+
+&ipu1 { /* IPU1 */
+	status = "okay";
+
+	v4l2-capture {
+		compatible = "fsl,imx6-v4l2-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
+		pinctrl-names = "default";
+		pinctrl-0 = <
+			&pinctrl_ipu1_csi0_2
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
+				bus-width = <8>;
+				data-shift = <12>; /* Lines 19:12 used */
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+
+		/* CSI1 */
+		port@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>;
+
+			/* MIPI CSI-2 virtual channel 0 */
+			csi1_vc0: endpoint@0 {
+				reg = <0>;
+				remote-endpoint = <&ov5640_1>;
+				data-lanes = <0 1>;
+				clock-lanes = <2>;
+			};
+		};
+	};
+};
-- 
1.7.9.5

