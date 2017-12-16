Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35468 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756762AbdLPCtZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 21:49:25 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [RFC 5/5] ARM: dts: sun8i: a83t: bananapi-m3: Enable IR controller
Date: Sat, 16 Dec 2017 03:49:14 +0100
Message-Id: <20171216024914.7550-6-embed3d@gmail.com>
In-Reply-To: <20171216024914.7550-1-embed3d@gmail.com>
References: <20171216024914.7550-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Bananapi M3 has an onboard IR receiver.
This enables the onboard IR receiver subnode.
Other than the other IR receivers this one needs a base clock frequency
of 3000000 Hz (3 MHz), to be able to work.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
---
 arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts | 7 +++++++
 arch/arm/boot/dts/sun8i-a83t.dtsi            | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
index c606af3dbfed..2c92c501cd59 100644
--- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
+++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
@@ -88,6 +88,13 @@
 	/* TODO GL830 USB-to-SATA bridge downstream w/ GPIO power controls */
 };
 
+&ir {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ir_pins_a>;
+	base-clk-frequency = <3000000>;
+	status = "okay";
+};
+
 &mmc0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc0_pins>;
diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index 5dbf2f0891c1..679ce3a66b4b 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -470,7 +470,7 @@
 			#reset-cells = <1>;
 		};
 
-		ir: ir@01f02000 {
+		ir: ir@1f02000 {
 			compatible = "allwinner,sun5i-a13-ir";
 			clocks = <&r_ccu CLK_APB0_IR>, <&r_ccu CLK_IR>;
 			clock-names = "apb", "ir";
-- 
2.11.0
