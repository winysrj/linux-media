Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34974 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753215AbdC1Alh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:41:37 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v6 09/39] ARM: dts: imx6-sabresd: add OV5642 and OV5640 camera sensors
Date: Mon, 27 Mar 2017 17:40:26 -0700
Message-Id: <1490661656-10318-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables the OV5642 parallel-bus sensor, and the OV5640 MIPI CSI-2 sensor.

The OV5642 connects to the parallel-bus mux input port on ipu1_csi0_mux.

The OV5640 connects to the input port on the MIPI CSI-2 receiver on
mipi_csi.

Until the OV5652 sensor module compatible with the SabreSD becomes
available for testing, the ov5642 node is currently disabled.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6dl-sabresd.dts   |   5 ++
 arch/arm/boot/dts/imx6q-sabresd.dts    |   5 ++
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 114 ++++++++++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl-sabresd.dts b/arch/arm/boot/dts/imx6dl-sabresd.dts
index 1e45f2f..9607afe 100644
--- a/arch/arm/boot/dts/imx6dl-sabresd.dts
+++ b/arch/arm/boot/dts/imx6dl-sabresd.dts
@@ -15,3 +15,8 @@
 	model = "Freescale i.MX6 DualLite SABRE Smart Device Board";
 	compatible = "fsl,imx6dl-sabresd", "fsl,imx6dl";
 };
+
+&ipu1_csi1_from_ipu1_csi1_mux {
+	clock-lanes = <0>;
+	data-lanes = <1 2>;
+};
diff --git a/arch/arm/boot/dts/imx6q-sabresd.dts b/arch/arm/boot/dts/imx6q-sabresd.dts
index 9cbdfe7..527772b 100644
--- a/arch/arm/boot/dts/imx6q-sabresd.dts
+++ b/arch/arm/boot/dts/imx6q-sabresd.dts
@@ -23,3 +23,8 @@
 &sata {
 	status = "okay";
 };
+
+&ipu1_csi1_from_mipi_vc1 {
+	clock-lanes = <0>;
+	data-lanes = <1 2>;
+};
diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index 63bf95e..643c1d4 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -10,6 +10,7 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
+#include <dt-bindings/clock/imx6qdl-clock.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 
@@ -146,6 +147,36 @@
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
+
+	port@0 {
+		reg = <0>;
+
+		mipi_csi2_in: endpoint {
+			remote-endpoint = <&ov5640_to_mipi_csi2>;
+			clock-lanes = <0>;
+			data-lanes = <1 2>;
+		};
+	};
+};
+
 &audmux {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_audmux>;
@@ -213,7 +244,32 @@
 			0x8014 /* 4:FN_DMICCDAT */
 			0x0000 /* 5:Default */
 		>;
-       };
+	};
+
+	ov5642: camera@3c {
+		compatible = "ovti,ov5642";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5642>;
+		clocks = <&clks IMX6QDL_CLK_CKO>;
+		clock-names = "xclk";
+		reg = <0x3c>;
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen3_reg>;  /* 2.8v, rev C board is VGEN3
+						rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		powerdown-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 17 GPIO_ACTIVE_LOW>;
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
@@ -222,6 +278,32 @@
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
 
+	ov5640: camera@3c {
+		compatible = "ovti,ov5640";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5640>;
+		reg = <0x3c>;
+		clocks = <&clks IMX6QDL_CLK_CKO>;
+		clock-names = "xclk";
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen3_reg>;  /* 2.8v, rev C board is VGEN3
+						rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		powerdown-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			ov5640_to_mipi_csi2: endpoint {
+				remote-endpoint = <&mipi_csi2_in>;
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+			};
+		};
+	};
+
 	pmic: pfuze100@08 {
 		compatible = "fsl,pfuze100";
 		reg = <0x08>;
@@ -425,6 +507,36 @@
 			>;
 		};
 
+		pinctrl_ipu1_csi0: ipu1csi0grp {
+			fsl,pins = <
+				MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12    0x1b0b0
+				MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13    0x1b0b0
+				MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14    0x1b0b0
+				MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15    0x1b0b0
+				MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16    0x1b0b0
+				MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17    0x1b0b0
+				MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18    0x1b0b0
+				MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19    0x1b0b0
+				MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK   0x1b0b0
+				MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC      0x1b0b0
+				MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC     0x1b0b0
+			>;
+		};
+
+		pinctrl_ov5640: ov5640grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT2__GPIO1_IO19 0x1b0b0
+				MX6QDL_PAD_SD1_CLK__GPIO1_IO20  0x1b0b0
+			>;
+		};
+
+		pinctrl_ov5642: ov5642grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT0__GPIO1_IO16 0x1b0b0
+				MX6QDL_PAD_SD1_DAT1__GPIO1_IO17 0x1b0b0
+			>;
+		};
+
 		pinctrl_pcie: pciegrp {
 			fsl,pins = <
 				MX6QDL_PAD_GPIO_17__GPIO7_IO12	0x1b0b0
-- 
2.7.4
