Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailoutvs7.siol.net ([213.250.19.138]:55733 "EHLO mail.siol.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751648AbdITUIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 16:08:42 -0400
From: Jernej Skrabec <jernej.skrabec@siol.net>
To: maxime.ripard@free-electrons.com, wens@csie.org
Cc: Laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        narmstrong@baylibre.com, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        icenowy@aosc.io, linux-sunxi@googlegroups.com,
        linux-media@vger.kernel.org
Subject: [RESEND RFC PATCH 6/7] ARM: sun8i: h3: Add DesignWare HDMI controller node
Date: Wed, 20 Sep 2017 22:01:23 +0200
Message-Id: <20170920200124.20457-7-jernej.skrabec@siol.net>
In-Reply-To: <20170920200124.20457-1-jernej.skrabec@siol.net>
References: <20170920200124.20457-1-jernej.skrabec@siol.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Icenowy Zheng <icenowy@aosc.io>

The H3 SoC has a DesignWare HDMI controller with some Allwinner-specific
glue and custom PHY.

Since H3 and H5 have same HDMI controller, add related device node in
shared dtsi file.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 arch/arm/boot/dts/sun8i-h3.dtsi    |  5 +++++
 arch/arm/boot/dts/sunxi-h3-h5.dtsi | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index 75ad7b65a7fc..b01f5ac60059 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -197,6 +197,11 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 					reg = <1>;
+
+					tcon0_out_hdmi: endpoint@1 {
+						reg = <1>;
+						remote-endpoint = <&hdmi_in_tcon0>;
+					};
 				};
 			};
 		};
diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
index d38282b9e5d4..28f4df82300e 100644
--- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
+++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
@@ -592,6 +592,42 @@
 			interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 		};
 
+		hdmi: hdmi@1ee0000 {
+			compatible = "allwinner,sun8i-h3-dw-hdmi";
+			reg = <0x01ee0000 0x10000>,
+			      <0x01ef0000 0x10000>;
+			reg-io-width = <1>;
+			interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_HDMI>, <&ccu CLK_HDMI>,
+				 <&ccu CLK_HDMI_DDC>;
+			clock-names = "iahb", "isfr", "ddc";
+			resets = <&ccu RST_BUS_HDMI0>, <&ccu RST_BUS_HDMI1>;
+			reset-names = "hdmi", "ddc";
+			status = "disabled";
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				hdmi_in: port@0 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					reg = <0>;
+
+					hdmi_in_tcon0: endpoint@0 {
+						reg = <0>;
+						remote-endpoint = <&tcon0_out_hdmi>;
+					};
+				};
+
+				hdmi_out: port@1 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					reg = <1>;
+				};
+			};
+		};
+
 		rtc: rtc@01f00000 {
 			compatible = "allwinner,sun6i-a31-rtc";
 			reg = <0x01f00000 0x54>;
-- 
2.14.1
