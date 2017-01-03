Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33973 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759337AbdACU5x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:57:53 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 09/19] ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
Date: Tue,  3 Jan 2017 12:57:19 -0800
Message-Id: <1483477049-19056-10-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables the ADV7180 decoder sensor. The ADV7180 connects to the
parallel-bus mux input on ipu1_csi0_mux.

On the sabreauto, two analog video inputs are routed to the ADV7180,
composite on Ain1, and composite on Ain3. Those inputs are defined
via inputs and input-names under the ADV7180 node. The ADV7180 power
pin is via max7310_b port expander.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 56 ++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 83ac2ff..30ee378 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -147,10 +147,42 @@
 				gpio-controller;
 				#gpio-cells = <2>;
 			};
+
+			camera: adv7180@21 {
+				compatible = "adi,adv7180";
+				reg = <0x21>;
+				powerdown-gpios = <&max7310_b 2 GPIO_ACTIVE_LOW>;
+				interrupt-parent = <&gpio1>;
+				interrupts = <27 0x8>;
+				inputs = <0x00 0x02>;
+				input-names = "ADV7180 Composite on Ain1",
+						"ADV7180 Composite on Ain3";
+
+				port {
+					adv7180_to_ipu1_csi0_mux: endpoint {
+						remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+						bus-width = <8>;
+					};
+				};
+			};
 		};
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
+};
+
 &clks {
 	assigned-clocks = <&clks IMX6QDL_PLL4_BYPASS_SRC>,
 			  <&clks IMX6QDL_PLL4_BYPASS>,
@@ -451,6 +483,30 @@
 			>;
 		};
 
+		pinctrl_ipu1_csi0: ipu1grp-csi0 {
+			fsl,pins = <
+				MX6QDL_PAD_CSI0_DAT4__IPU1_CSI0_DATA04   0x80000000
+				MX6QDL_PAD_CSI0_DAT5__IPU1_CSI0_DATA05   0x80000000
+				MX6QDL_PAD_CSI0_DAT6__IPU1_CSI0_DATA06   0x80000000
+				MX6QDL_PAD_CSI0_DAT7__IPU1_CSI0_DATA07   0x80000000
+				MX6QDL_PAD_CSI0_DAT8__IPU1_CSI0_DATA08   0x80000000
+				MX6QDL_PAD_CSI0_DAT9__IPU1_CSI0_DATA09   0x80000000
+				MX6QDL_PAD_CSI0_DAT10__IPU1_CSI0_DATA10  0x80000000
+				MX6QDL_PAD_CSI0_DAT11__IPU1_CSI0_DATA11  0x80000000
+				MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12  0x80000000
+				MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13  0x80000000
+				MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14  0x80000000
+				MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15  0x80000000
+				MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16  0x80000000
+				MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17  0x80000000
+				MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18  0x80000000
+				MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19  0x80000000
+				MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK 0x80000000
+				MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC    0x80000000
+				MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC   0x80000000
+			>;
+		};
+
 		pinctrl_pwm3: pwm1grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD4_DAT1__PWM3_OUT		0x1b0b1
-- 
2.7.4

