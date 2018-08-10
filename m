Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34971 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbeHJRsx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 13:48:53 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 2/3] ARM: dts: imx6ull: add pxp support
Date: Fri, 10 Aug 2018 17:18:21 +0200
Message-Id: <20180810151822.18650-3-p.zabel@pengutronix.de>
In-Reply-To: <20180810151822.18650-1-p.zabel@pengutronix.de>
References: <20180810151822.18650-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the device node for the i.MX6ULL Pixel Pipeline (PXP).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx6ul.dtsi  | 8 ++++++++
 arch/arm/boot/dts/imx6ull.dtsi | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 47a3453a4211..e80a660c14f2 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -928,6 +928,14 @@
 				};
 			};
 
+			pxp: pxp@21cc000 {
+				compatible = "fsl,imx6ul-pxp";
+				reg = <0x021cc000 0x4000>;
+				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
+				clock-names = "axi";
+				clocks = <&clks IMX6UL_CLK_PXP>;
+			};
+
 			lcdif: lcdif@21c8000 {
 				compatible = "fsl,imx6ul-lcdif", "fsl,imx28-lcdif";
 				reg = <0x021c8000 0x4000>;
diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dtsi
index ebc25c98e5e1..91d2b6dd9b1b 100644
--- a/arch/arm/boot/dts/imx6ull.dtsi
+++ b/arch/arm/boot/dts/imx6ull.dtsi
@@ -75,3 +75,9 @@
 		};
 	};
 };
+
+&pxp {
+	compatible = "fsl,imx6ull-pxp";
+	interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.18.0
