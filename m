Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35641 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbcFNWvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:22 -0400
Received: by mail-pf0-f195.google.com with SMTP id t190so302207pfb.2
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:22 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 24/38] ARM: dts: imx6-sabreauto: add video capture ports and connections
Date: Tue, 14 Jun 2016 15:49:20 -0700
Message-Id: <1465944574-15745-25-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Defines the host video capture device node and the ADV7180 decoder
sensor. The host capture device connects to the ADV7180 via the
parallel-bus mux input on the ipu1_csi0_mux.

On the sabreauto, two analog video inputs are routed to the ADV7180,
composite on Ain1, and composite on Ain3. Those inputs are defined
via inputs and input-names under the endpoint node
ipu1_csi0_from_ipu1_csi0_mux. The ADV7180 power pin is via max7310_b
port expander.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 68 ++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 21af432..f962f51 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -153,10 +153,54 @@
 				pinctrl-0 = <&pinctrl_max7310>;
 				reset-gpios = <&gpio1 15 1>;
 			};
+
+			camera: adv7180@21 {
+				compatible = "adi,adv7180";
+				reg = <0x21>;
+				pwdn-gpio = <&max7310_b 2 0>;
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
+		};
+	};
+
+	ipucap0: ipucap0 {
+		compatible = "fsl,imx-video-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ipu1_csi0>;
+		ports = <&ipu1_csi0>;
+		status = "okay";
+
+		fim {
+			enable = <1>;
 		};
 	};
 };
 
+&ipu1_csi0_from_ipu1_csi0_mux {
+	bus-width = <8>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&adv7180_to_ipu1_csi0_mux>;
+	inputs = <0x00 0x02>;
+	input-names = "ADV7180 Composite on Ain1",
+			"ADV7180 Composite on Ain3";
+};
+
+&ipu1_csi0_mux {
+	status = "okay";
+};
+
 &clks {
 	assigned-clocks = <&clks IMX6QDL_PLL4_BYPASS_SRC>,
 			  <&clks IMX6QDL_PLL4_BYPASS>,
@@ -456,6 +500,30 @@
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
1.9.1

