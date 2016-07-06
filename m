Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36017 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbcGFXh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:37:27 -0400
Received: by mail-pa0-f67.google.com with SMTP id ib6so144170pad.3
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:37:01 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 2/6] ARM: dts: imx6-sabresd: add video capture devices and connections
Date: Wed,  6 Jul 2016 16:36:39 -0700
Message-Id: <1467848203-14007-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467848203-14007-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Defines two host video capture devices and two camera sensors:
parallel-bus OV5642 and MIPI CSI-2 OV5640.

One host capture device connects to the OV5642 via the parallel-bus
mux input on the ipu1_csi0_mux.

The other host capture device connects to the OV5640 via the MIPI CSI-2
receiver (directly on virtual channel 1 to ipu1_csi1 on imx6q, and
indirectly via the ipu1_csi1_mux on imx6dl).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6dl-sabresd.dts   |  42 +++++++++++
 arch/arm/boot/dts/imx6q-sabresd.dts    |  14 ++++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 130 ++++++++++++++++++++++++++++++++-
 3 files changed, 185 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl-sabresd.dts b/arch/arm/boot/dts/imx6dl-sabresd.dts
index 1e45f2f..04ec884 100644
--- a/arch/arm/boot/dts/imx6dl-sabresd.dts
+++ b/arch/arm/boot/dts/imx6dl-sabresd.dts
@@ -15,3 +15,45 @@
 	model = "Freescale i.MX6 DualLite SABRE Smart Device Board";
 	compatible = "fsl,imx6dl-sabresd", "fsl,imx6dl";
 };
+
+&ipu1_csi1_from_ipu1_csi1_mux {
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
+};
+
+&ipu1_csi1_mux {
+	status = "okay";
+};
+
+/*
+ * when the OV5642 sensor is enabled, the ipu1_csi0_mux is also enabled,
+ * but we don't want to find the OV5640 through ipu1_csi0_mux path to the
+ * mipi-csi2 receiver, so shutdown the link to the mipi-csi2 receiver at
+ * all virtual channels.
+*/
+&ipu1_csi0_mux_from_mipi_vc0 {
+	remote-endpoint = <>;
+};
+&ipu1_csi0_mux_from_mipi_vc1 {
+	remote-endpoint = <>;
+};
+&ipu1_csi0_mux_from_mipi_vc2 {
+	remote-endpoint = <>;
+};
+&ipu1_csi0_mux_from_mipi_vc3 {
+	remote-endpoint = <>;
+};
+
+/*
+ * shutdown links to mipi-csi2 channels 0,2,3 through ipu1_csi1_mux. The
+ * OV5640 is on VC1, so it must be found only on that ipu1_csi1_mux input.
+ */
+&ipu1_csi1_mux_from_mipi_vc0 {
+	remote-endpoint = <>;
+};
+&ipu1_csi1_mux_from_mipi_vc2 {
+	remote-endpoint = <>;
+};
+&ipu1_csi1_mux_from_mipi_vc3 {
+	remote-endpoint = <>;
+};
diff --git a/arch/arm/boot/dts/imx6q-sabresd.dts b/arch/arm/boot/dts/imx6q-sabresd.dts
index 9cbdfe7..03ae085 100644
--- a/arch/arm/boot/dts/imx6q-sabresd.dts
+++ b/arch/arm/boot/dts/imx6q-sabresd.dts
@@ -23,3 +23,17 @@
 &sata {
 	status = "okay";
 };
+
+&ipu1_csi1_from_mipi_vc1 {
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
+};
+
+/*
+ * when the OV5642 sensor is enabled, the ipu1_csi0_mux is also enabled,
+ * but we don't want to find the OV5640 through ipu1_csi0_mux path, so
+ * shutdown the link to the mipi-csi2 receiver.
+*/
+&ipu1_csi0_mux_from_mipi_vc0 {
+	remote-endpoint = <>;
+};
diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index 5248e7b..3d39d4c 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -10,6 +10,7 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
+#include <dt-bindings/clock/imx6qdl-clock.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 
@@ -144,6 +145,50 @@
 			};
 		};
 	};
+
+	ipucap0: ipucap@0 {
+		compatible = "fsl,imx-video-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ipu1_csi0>;
+		ports = <&ipu1_csi0>;
+		status = "okay";
+	};
+
+	ipucap1: ipucap@1 {
+		compatible = "fsl,imx-video-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		ports = <&ipu1_csi1>;
+		status = "okay";
+	};
+};
+
+&ipu1_csi0_from_ipu1_csi0_mux {
+	bus-width = <8>;
+	data-shift = <12>; /* Lines 19:12 used */
+	hsync-active = <1>;
+	vsync-active = <1>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
+};
+
+&ipu1_csi0_mux {
+	status = "okay";
+};
+
+&mipi_csi {
+	status = "okay";
+};
+
+/* Incoming port from sensor */
+&mipi_csi_from_mipi_sensor {
+	remote-endpoint = <&ov5640_to_mipi_csi>;
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
 };
 
 &audmux {
@@ -214,7 +259,32 @@
 			0x8014 /* 4:FN_DMICCDAT */
 			0x0000 /* 5:Default */
 		>;
-       };
+	};
+
+	camera: ov5642@3c {
+		compatible = "ovti,ov5642";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5642>;
+		clocks = <&clks IMX6QDL_CLK_CKO>;
+		clock-names = "xclk";
+		reg = <0x3c>;
+		xclk = <24000000>;
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
+			      		     	rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		pwdn-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>; /* SD1_DAT0 */
+		reset-gpios = <&gpio1 17 GPIO_ACTIVE_LOW>; /* SD1_DAT1 */
+
+		port {
+			ov5642_to_ipu1_csi0_mux: endpoint {
+				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+				bus-width = <8>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+	};
 };
 
 &i2c2 {
@@ -322,6 +392,34 @@
 			};
 		};
 	};
+
+	mipi_camera: ov5640@3c {
+		compatible = "ovti,ov5640_mipi";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5640>;
+		reg = <0x3c>;
+		clocks = <&clks IMX6QDL_CLK_CKO>;
+		clock-names = "xclk";
+		xclk = <24000000>;
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
+			      		     	rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		pwdn-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>; /* SD1_DAT2 */
+		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>; /* SD1_CLK */
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			ov5640_to_mipi_csi: endpoint@1 {
+				reg = <1>;
+				remote-endpoint = <&mipi_csi_from_mipi_sensor>;
+				data-lanes = <0 1>;
+				clock-lanes = <2>;
+			};
+		};
+	};
 };
 
 &i2c3 {
@@ -426,6 +524,36 @@
 			>;
 		};
 
+		pinctrl_ov5640: ov5640grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT2__GPIO1_IO19 0x80000000
+				MX6QDL_PAD_SD1_CLK__GPIO1_IO20  0x80000000
+			>;
+		};
+
+		pinctrl_ov5642: ov5642grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT0__GPIO1_IO16 0x80000000
+				MX6QDL_PAD_SD1_DAT1__GPIO1_IO17 0x80000000
+			>;
+		};
+
+		pinctrl_ipu1_csi0: ipu1grp-csi0 {
+			fsl,pins = <
+				MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12    0x80000000
+				MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13    0x80000000
+				MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14    0x80000000
+				MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15    0x80000000
+				MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16    0x80000000
+				MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17    0x80000000
+				MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18    0x80000000
+				MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19    0x80000000
+				MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK   0x80000000
+				MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC      0x80000000
+				MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC     0x80000000
+			>;
+		};
+
 		pinctrl_pcie: pciegrp {
 			fsl,pins = <
 				MX6QDL_PAD_GPIO_17__GPIO7_IO12	0x1b0b0
-- 
1.9.1

