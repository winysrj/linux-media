Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33586 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753229AbcL2W2F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Dec 2016 17:28:05 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        linus.walleij@linaro.org, gnurou@gmail.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 05/20] ARM: dts: imx6-sabresd: add OV5642 and OV5640 camera sensors
Date: Thu, 29 Dec 2016 14:27:20 -0800
Message-Id: <1483050455-10683-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483050455-10683-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483050455-10683-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables the OV5642 parallel-bus sensor, and the OV5640 MIPI CSI-2 sensor.

The OV5642 connects to the parallel-bus mux input port on ipu1_csi0_mux.

The OV5640 connects to the input port on the MIPI CSI-2 receiver on
mipi_csi. It is set to transmit over MIPI virtual channel 1.

Until the OV5652 sensor module compatible with the SabreSD becomes
available for testing, the ov5642 node is currently disabled.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6dl-sabresd.dts   |   5 ++
 arch/arm/boot/dts/imx6q-sabresd.dts    |   5 ++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 114 ++++++++++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl-sabresd.dts b/arch/arm/boot/dts/imx6dl-sabresd.dts
index 1e45f2f..6cf7a50 100644
--- a/arch/arm/boot/dts/imx6dl-sabresd.dts
+++ b/arch/arm/boot/dts/imx6dl-sabresd.dts
@@ -15,3 +15,8 @@
 	model = "Freescale i.MX6 DualLite SABRE Smart Device Board";
 	compatible = "fsl,imx6dl-sabresd", "fsl,imx6dl";
 };
+
+&ipu1_csi1_from_ipu1_csi1_mux {
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
+};
diff --git a/arch/arm/boot/dts/imx6q-sabresd.dts b/arch/arm/boot/dts/imx6q-sabresd.dts
index 9cbdfe7..8c1d7ad 100644
--- a/arch/arm/boot/dts/imx6q-sabresd.dts
+++ b/arch/arm/boot/dts/imx6q-sabresd.dts
@@ -23,3 +23,8 @@
 &sata {
 	status = "okay";
 };
+
+&ipu1_csi1_from_mipi_vc1 {
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
+};
diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index 55ef535..39b4228 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -10,6 +10,7 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
+#include <dt-bindings/clock/imx6qdl-clock.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 
@@ -146,6 +147,33 @@
 	};
 };
 
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
+&ipu1_csi0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_ipu1_csi0>;
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
+};
+
 &audmux {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_audmux>;
@@ -214,7 +242,33 @@
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
+						rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		pwdn-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>; /* SD1_DAT0 */
+		reset-gpios = <&gpio1 17 GPIO_ACTIVE_LOW>; /* SD1_DAT1 */
+		status = "disabled";
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
@@ -322,6 +376,34 @@
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
+						rev B board is VGEN5 */
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
@@ -426,6 +508,36 @@
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
2.7.4

