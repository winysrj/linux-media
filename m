Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:41586 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032547AbeBOBQ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 20:16:56 -0500
Received: by mail-pl0-f68.google.com with SMTP id k8so9542696pli.8
        for <linux-media@vger.kernel.org>; Wed, 14 Feb 2018 17:16:56 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v11 8/8] ARM: dts: imx: Add TDA19971 HDMI Receiver to GW551x
Date: Wed, 14 Feb 2018 17:16:21 -0800
Message-Id: <1518657381-29519-9-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1518657381-29519-1-git-send-email-tharvey@gateworks.com>
References: <1518657381-29519-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
v5:
 - add missing audmux config

 arch/arm/boot/dts/imx6qdl-gw551x.dtsi | 138 ++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-gw551x.dtsi b/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
index 30d4662..749548a 100644
--- a/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw551x.dtsi
@@ -46,6 +46,8 @@
  */
 
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/media/tda1997x.h>
+#include <dt-bindings/sound/fsl-imx-audmux.h>
 
 / {
 	/* these are used by bootloader for disabling nodes */
@@ -98,6 +100,50 @@
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
 	};
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
+};
+
+&audmux {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_audmux>; /* AUD5<->tda1997x */
+	status = "okay";
+
+	ssi1 {
+		fsl,audmux-port = <0>;
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
+			IMX_AUDMUX_V2_PDCR_RXDSEL(0)>;
+	};
 };
 
 &can1 {
@@ -263,6 +309,60 @@
 		#gpio-cells = <2>;
 	};
 
+	tda1997x: tda1997x@48 {
+		compatible = "nxp,tda19971";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_tda1997x>;
+		reg = <0x48>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+		DOVDD-supply = <&reg_3p3>;
+		AVDD-supply = <&reg_1p8b>;
+		DVDD-supply = <&reg_1p8a>;
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
 
 &pcie {
@@ -320,6 +420,14 @@
 };
 
 &iomuxc {
+	pinctrl_audmux: audmuxgrp {
+		fsl,pins = <
+			MX6QDL_PAD_DISP0_DAT19__AUD5_RXD	0x130b0
+			MX6QDL_PAD_DISP0_DAT14__AUD5_RXC	0x130b0
+			MX6QDL_PAD_DISP0_DAT13__AUD5_RXFS	0x130b0
+		>;
+	};
+
 	pinctrl_flexcan1: flexcan1grp {
 		fsl,pins = <
 			MX6QDL_PAD_KEY_ROW2__FLEXCAN1_RX	0x1b0b1
@@ -375,6 +483,30 @@
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
 	pinctrl_pcie: pciegrp {
 		fsl,pins = <
 			MX6QDL_PAD_GPIO_0__GPIO1_IO00		0x1b0b0 /* PCIE RST */
@@ -399,6 +531,12 @@
 		>;
 	};
 
+	pinctrl_tda1997x: tda1997xgrp {
+		fsl,pins = <
+			MX6QDL_PAD_GPIO_7__GPIO1_IO07		0x1b0b0
+		>;
+	};
+
 	pinctrl_uart2: uart2grp {
 		fsl,pins = <
 			MX6QDL_PAD_SD4_DAT7__UART2_TX_DATA	0x1b0b1
-- 
2.7.4
