Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:54181 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932707AbcLHPlz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 10:41:55 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 3/9] ARM: dts: imx6qdl: Add VDOA phandle to CODA node
Date: Thu,  8 Dec 2016 16:24:10 +0100
Message-Id: <20161208152416.16031-3-m.tretter@pengutronix.de>
In-Reply-To: <20161208152416.16031-1-m.tretter@pengutronix.de>
References: <20161208152416.16031-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CODA driver should use the VDOA to transform the tiled format to
raster-ordered format, if the platform has a VDOA. Link the CODA and
VDOA nodes to tell the CODA driver that it can use the VDOA.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 Documentation/devicetree/bindings/media/coda.txt | 2 ++
 arch/arm/boot/dts/imx6qdl.dtsi                   | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
index 2865d04..7900788 100644
--- a/Documentation/devicetree/bindings/media/coda.txt
+++ b/Documentation/devicetree/bindings/media/coda.txt
@@ -17,6 +17,7 @@ Required properties:
   determined by the clock-names property.
 - clock-names : Should be "ahb", "per"
 - iram : phandle pointing to the SRAM device node
+- vdoa : phandle pointing to the VDOA device node
 
 Example:
 
@@ -27,4 +28,5 @@ vpu: vpu@63ff4000 {
 	clocks = <&clks 63>, <&clks 63>;
 	clock-names = "ahb", "per";
 	iram = <&ocram>;
+	vdoa = <&vdoa>;
 };
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 69e3668..7bf3429 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -427,6 +427,7 @@
 				power-domains = <&gpc 1>;
 				resets = <&src 1>;
 				iram = <&ocram>;
+				vdoa = <&vdoa>;
 			};
 
 			aipstz@0207c000 { /* AIPSTZ1 */
@@ -1152,7 +1153,7 @@
 				};
 			};
 
-			vdoa@021e4000 {
+			vdoa: vdoa@021e4000 {
 				compatible = "fsl,imx6q-vdoa";
 				reg = <0x021e4000 0x4000>;
 				interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.10.2

