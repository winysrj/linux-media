Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:38539 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731585AbeKOBDN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:03:13 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: [PATCH v2 3/4] ARM: dts: sun8i: Add the H3/H5 CSI controller
Date: Wed, 14 Nov 2018 15:59:33 +0100
Message-Id: <20181114145934.26855-4-maxime.ripard@bootlin.com>
In-Reply-To: <20181114145934.26855-1-maxime.ripard@bootlin.com>
References: <20181114145934.26855-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mylène Josserand <mylene.josserand@bootlin.com>

The H3 and H5 features the same CSI controller that was initially found on
the A31.

Add a DT node for it.

Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 arch/arm/boot/dts/sunxi-h3-h5.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
index 4b1530ebe427..8779ee750bd8 100644
--- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
+++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
@@ -393,6 +393,13 @@
 			interrupt-controller;
 			#interrupt-cells = <3>;
 
+			csi_pins: csi {
+				pins = "PE0", "PE1", "PE2", "PE3", "PE4",
+				       "PE5", "PE6", "PE7", "PE8", "PE9",
+				       "PE10", "PE11";
+				function = "csi";
+			};
+
 			emac_rgmii_pins: emac0 {
 				pins = "PD0", "PD1", "PD2", "PD3", "PD4",
 				       "PD5", "PD7", "PD8", "PD9", "PD10",
@@ -744,6 +751,21 @@
 			interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 		};
 
+		csi: camera@1cb0000 {
+			compatible = "allwinner,sun8i-h3-csi",
+				     "allwinner,sun6i-a31-csi";
+			reg = <0x01cb0000 0x1000>;
+			interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CSI>,
+				 <&ccu CLK_CSI_SCLK>,
+				 <&ccu CLK_DRAM_CSI>;
+			clock-names = "bus", "mod", "ram";
+			resets = <&ccu RST_BUS_CSI>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&csi_pins>;
+			status = "disabled";
+		};
+
 		hdmi: hdmi@1ee0000 {
 			compatible = "allwinner,sun8i-h3-dw-hdmi",
 				     "allwinner,sun8i-a83t-dw-hdmi";
-- 
2.19.1
