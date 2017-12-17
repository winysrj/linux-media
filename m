Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36692 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757698AbdLQWp5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 17:45:57 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 4/5] arm: dts: sun8i: a83t: Add support for the ir interface
Date: Sun, 17 Dec 2017 23:45:46 +0100
Message-Id: <20171217224547.21481-5-embed3d@gmail.com>
In-Reply-To: <20171217224547.21481-1-embed3d@gmail.com>
References: <20171217224547.21481-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ir interface is like on the H3 located at 0x01f02000 and is exactly
the same. This patch adds support for the ir interface on the A83T.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
---
 arch/arm/boot/dts/sun8i-a83t.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index 954c2393325f..9e7ed3b9a6b8 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -503,6 +503,16 @@
 			#reset-cells = <1>;
 		};
 
+		ir: ir@01f02000 {
+			compatible = "allwinner,sun5i-a13-ir";
+			clocks = <&r_ccu CLK_APB0_IR>, <&r_ccu CLK_IR>;
+			clock-names = "apb", "ir";
+			resets = <&r_ccu RST_APB0_IR>;
+			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x01f02000 0x40>;
+			status = "disabled";
+		};
+
 		r_pio: pinctrl@1f02c00 {
 			compatible = "allwinner,sun8i-a83t-r-pinctrl";
 			reg = <0x01f02c00 0x400>;
-- 
2.11.0
