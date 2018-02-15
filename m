Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37569 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426222AbeBOQj7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 11:39:59 -0500
Received: by mail-pg0-f65.google.com with SMTP id o1so174123pgn.4
        for <linux-media@vger.kernel.org>; Thu, 15 Feb 2018 08:39:59 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v12 7/8] ARM: dts: imx: Add TDA19971 HDMI Receiver to GW54xx
Date: Thu, 15 Feb 2018 08:39:26 -0800
Message-Id: <1518712767-21928-8-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1518712767-21928-1-git-send-email-tharvey@gateworks.com>
References: <1518712767-21928-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The GW54xx has a front-panel microHDMI connector routed to a TDA19971
which is connected the the IPU CSI when using IMX6Q.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
v5:
 - remove leading 0 from unit address
 - add newline between property list and child node

v4: no changes
v3: no changes

v2:
 - add HDMI audio input support

 arch/arm/boot/dts/imx6q-gw54xx.dts    | 105 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi |  29 +++++++++-
 2 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-gw54xx.dts b/arch/arm/boot/dts/imx6q-gw54xx.dts
index 56e5b50..0477120 100644
--- a/arch/arm/boot/dts/imx6q-gw54xx.dts
+++ b/arch/arm/boot/dts/imx6q-gw54xx.dts
@@ -12,10 +12,30 @@
 /dts-v1/;
 #include "imx6q.dtsi"
 #include "imx6qdl-gw54xx.dtsi"
+#include <dt-bindings/media/tda1997x.h>
 
 / {
 	model = "Gateworks Ventana i.MX6 Dual/Quad GW54XX";
 	compatible = "gw,imx6q-gw54xx", "gw,ventana", "fsl,imx6q";
+
+	sound-digital {
+		compatible = "simple-audio-card";
+		simple-audio-card,name = "tda1997x-audio";
+
+		simple-audio-card,dai-link@0 {
+			format = "i2s";
+
+			cpu {
+				sound-dai = <&ssi2>;
+			};
+
+			codec {
+				bitclock-master;
+				frame-master;
+				sound-dai = <&tda1997x>;
+			};
+		};
+	};
 };
 
 &i2c3 {
@@ -35,6 +55,61 @@
 			};
 		};
 	};
+
+	tda1997x: codec@48 {
+		compatible = "nxp,tda19971";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_tda1997x>;
+		reg = <0x48>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+		DOVDD-supply = <&reg_3p3v>;
+		AVDD-supply = <&sw4_reg>;
+		DVDD-supply = <&sw4_reg>;
+		#sound-dai-cells = <0>;
+		nxp,audout-format = "i2s";
+		nxp,audout-layout = <0>;
+		nxp,audout-width = <16>;
+		nxp,audout-mclk-fs = <128>;
+		/*
+		 * The 8bpp YUV422 semi-planar mode outputs CbCr[11:4]
+		 * and Y[11:4] across 16bits in the same cycle
+		 * which we map to VP[15:08]<->CSI_DATA[19:12]
+		 */
+		nxp,vidout-portcfg =
+			/*G_Y_11_8<->VP[15:12]<->CSI_DATA[19:16]*/
+			< TDA1997X_VP24_V15_12 TDA1997X_G_Y_11_8 >,
+			/*G_Y_7_4<->VP[11:08]<->CSI_DATA[15:12]*/
+			< TDA1997X_VP24_V11_08 TDA1997X_G_Y_7_4 >,
+			/*R_CR_CBCR_11_8<->VP[07:04]<->CSI_DATA[11:08]*/
+			< TDA1997X_VP24_V07_04 TDA1997X_R_CR_CBCR_11_8 >,
+			/*R_CR_CBCR_7_4<->VP[03:00]<->CSI_DATA[07:04]*/
+			< TDA1997X_VP24_V03_00 TDA1997X_R_CR_CBCR_7_4 >;
+
+		port {
+			tda1997x_to_ipu1_csi0_mux: endpoint {
+				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+				bus-width = <16>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+				data-active = <1>;
+			};
+		};
+	};
+};
+
+&ipu1_csi0_from_ipu1_csi0_mux {
+	bus-width = <16>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&tda1997x_to_ipu1_csi0_mux>;
+	bus-width = <16>;
+};
+
+&ipu1_csi0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_ipu1_csi0>;
 };
 
 &ipu2_csi1_from_ipu2_csi1_mux {
@@ -63,6 +138,30 @@
 		>;
 	};
 
+	pinctrl_ipu1_csi0: ipu1_csi0grp {
+		fsl,pins = <
+			MX6QDL_PAD_CSI0_DAT4__IPU1_CSI0_DATA04		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT5__IPU1_CSI0_DATA05		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT6__IPU1_CSI0_DATA06		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT7__IPU1_CSI0_DATA07		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT8__IPU1_CSI0_DATA08		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT9__IPU1_CSI0_DATA09		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT10__IPU1_CSI0_DATA10		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT11__IPU1_CSI0_DATA11		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18		0x1b0b0
+			MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19		0x1b0b0
+			MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC		0x1b0b0
+			MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK	0x1b0b0
+			MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC		0x1b0b0
+		>;
+	};
+
 	pinctrl_ipu2_csi1: ipu2_csi1grp {
 		fsl,pins = <
 			MX6QDL_PAD_EIM_EB2__IPU2_CSI1_DATA19    0x1b0b0
@@ -78,4 +177,10 @@
 			MX6QDL_PAD_EIM_A16__IPU2_CSI1_PIXCLK    0x1b0b0
 		>;
 	};
+
+	pinctrl_tda1997x: tda1997xgrp {
+		fsl,pins = <
+			MX6QDL_PAD_GPIO_7__GPIO1_IO07	0x1b0b0
+		>;
+	};
 };
diff --git a/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi b/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
index eab75f3..f9e1fb9 100644
--- a/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw54xx.dtsi
@@ -10,6 +10,7 @@
  */
 
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/sound/fsl-imx-audmux.h>
 
 / {
 	/* these are used by bootloader for disabling nodes */
@@ -114,12 +115,12 @@
 		};
 	};
 
-	sound {
+	sound-analog {
 		compatible = "fsl,imx6q-ventana-sgtl5000",
 			     "fsl,imx-audio-sgtl5000";
 		model = "sgtl5000-audio";
 		ssi-controller = <&ssi1>;
-		audio-codec = <&codec>;
+		audio-codec = <&sgtl5000>;
 		audio-routing =
 			"MIC_IN", "Mic Jack",
 			"Mic Jack", "Mic Bias",
@@ -133,6 +134,25 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_audmux>; /* AUD4<->sgtl5000 */
 	status = "okay";
+
+	ssi2 {
+		fsl,audmux-port = <1>;
+		fsl,port-config = <
+			(IMX_AUDMUX_V2_PTCR_TFSDIR |
+			IMX_AUDMUX_V2_PTCR_TFSEL(4+8) | /* RXFS */
+			IMX_AUDMUX_V2_PTCR_TCLKDIR |
+			IMX_AUDMUX_V2_PTCR_TCSEL(4+8) | /* RXC */
+			IMX_AUDMUX_V2_PTCR_SYN)
+			IMX_AUDMUX_V2_PDCR_RXDSEL(4)
+		>;
+	};
+
+	aud5 {
+		fsl,audmux-port = <4>;
+		fsl,port-config = <
+			IMX_AUDMUX_V2_PTCR_SYN
+			IMX_AUDMUX_V2_PDCR_RXDSEL(1)>;
+	};
 };
 
 &can1 {
@@ -331,7 +351,7 @@
 	pinctrl-0 = <&pinctrl_i2c3>;
 	status = "okay";
 
-	codec: sgtl5000@a {
+	sgtl5000: codec@a {
 		compatible = "fsl,sgtl5000";
 		reg = <0x0a>;
 		clocks = <&clks IMX6QDL_CLK_CKO>;
@@ -475,6 +495,9 @@
 			MX6QDL_PAD_SD2_DAT2__AUD4_TXD		0x110b0
 			MX6QDL_PAD_SD2_DAT1__AUD4_TXFS		0x130b0
 			MX6QDL_PAD_GPIO_0__CCM_CLKO1		0x130b0 /* AUD4_MCK */
+			MX6QDL_PAD_EIM_D25__AUD5_RXC            0x130b0
+			MX6QDL_PAD_DISP0_DAT19__AUD5_RXD        0x130b0
+			MX6QDL_PAD_EIM_D24__AUD5_RXFS           0x130b0
 		>;
 	};
 
-- 
2.7.4
