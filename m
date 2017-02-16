Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36612 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdBPCUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:20:38 -0500
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
Subject: [PATCH v4 11/36] ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
Date: Wed, 15 Feb 2017 18:19:13 -0800
Message-Id: <1487211578-11360-12-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables the ADV7180 decoder sensor. The ADV7180 connects to the
parallel-bus mux input on ipu1_csi0_mux.

The ADV7180 power pin is via max7310_b port expander.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 58 ++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 495709f..f03057b 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -124,6 +124,21 @@
 			#size-cells = <0>;
 			reg = <1>;
 
+			adv7180: camera@21 {
+				compatible = "adi,adv7180";
+				reg = <0x21>;
+				powerdown-gpios = <&max7310_b 2 GPIO_ACTIVE_LOW>;
+				interrupt-parent = <&gpio1>;
+				interrupts = <27 0x8>;
+
+				port {
+					adv7180_to_ipu1_csi0_mux: endpoint {
+						remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+						bus-width = <8>;
+					};
+				};
+			};
+
 			max7310_a: gpio@30 {
 				compatible = "maxim,max7310";
 				reg = <0x30>;
@@ -151,6 +166,25 @@
 	};
 };
 
+&ipu1_csi0_from_ipu1_csi0_mux {
+	bus-width = <8>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&adv7180_to_ipu1_csi0_mux>;
+	bus-width = <8>;
+};
+
+&ipu1_csi0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_ipu1_csi0>;
+
+	/* enable frame interval monitor on this port */
+	fim {
+		status = "okay";
+	};
+};
+
 &clks {
 	assigned-clocks = <&clks IMX6QDL_PLL4_BYPASS_SRC>,
 			  <&clks IMX6QDL_PLL4_BYPASS>,
@@ -445,6 +479,30 @@
 			>;
 		};
 
+		pinctrl_ipu1_csi0: ipu1csi0grp {
+			fsl,pins = <
+				MX6QDL_PAD_CSI0_DAT4__IPU1_CSI0_DATA04   0x1b0b0
+				MX6QDL_PAD_CSI0_DAT5__IPU1_CSI0_DATA05   0x1b0b0
+				MX6QDL_PAD_CSI0_DAT6__IPU1_CSI0_DATA06   0x1b0b0
+				MX6QDL_PAD_CSI0_DAT7__IPU1_CSI0_DATA07   0x1b0b0
+				MX6QDL_PAD_CSI0_DAT8__IPU1_CSI0_DATA08   0x1b0b0
+				MX6QDL_PAD_CSI0_DAT9__IPU1_CSI0_DATA09   0x1b0b0
+				MX6QDL_PAD_CSI0_DAT10__IPU1_CSI0_DATA10  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT11__IPU1_CSI0_DATA11  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18  0x1b0b0
+				MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19  0x1b0b0
+				MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK 0x1b0b0
+				MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC    0x1b0b0
+				MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC   0x1b0b0
+			>;
+		};
+
 		pinctrl_max7310: max7310grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD2_DAT0__GPIO1_IO15 0x1b0b0
-- 
2.7.4
