Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51301 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbeGaLC1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 07:02:27 -0400
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v6 2/4] ARM: dts: sun8i: a83t: Add support for the cir interface
Date: Tue, 31 Jul 2018 11:22:56 +0200
Message-Id: <20180731092258.2279-3-embed3d@gmail.com>
In-Reply-To: <20180731092258.2279-1-embed3d@gmail.com>
References: <20180731092258.2279-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cir interface is like on the H3 located at 0x01f02000 and is exactly
the same. This patch adds support for the ir interface on the A83T.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
---
 arch/arm/boot/dts/sun8i-a83t.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index afed6c0dea6f..31222a05a8f1 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -992,6 +992,18 @@
 			reg = <0x1f01c00 0x400>;
 		};
 
+		r_cir: ir@1f02000 {
+			compatible = "allwinner,sun5i-a13-ir";
+			clocks = <&r_ccu CLK_APB0_IR>, <&r_ccu CLK_IR>;
+			clock-names = "apb", "ir";
+			resets = <&r_ccu RST_APB0_IR>;
+			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x01f02000 0x400>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&r_cir_pin>;
+			status = "disabled";
+		};
+
 		r_pio: pinctrl@1f02c00 {
 			compatible = "allwinner,sun8i-a83t-r-pinctrl";
 			reg = <0x01f02c00 0x400>;
-- 
2.11.0
