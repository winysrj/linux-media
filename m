Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53103 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeIEOa3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 10:30:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH v2 2/4] ARM: dts: imx6ull: add pxp support
Date: Wed,  5 Sep 2018 12:00:16 +0200
Message-Id: <20180905100018.27556-3-p.zabel@pengutronix.de>
In-Reply-To: <20180905100018.27556-1-p.zabel@pengutronix.de>
References: <20180905100018.27556-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the device node for the i.MX6ULL Pixel Pipeline (PXP).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
- Fix node address order
---
 arch/arm/boot/dts/imx6ul.dtsi  | 8 ++++++++
 arch/arm/boot/dts/imx6ull.dtsi | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 6dc0b569acdf..051d42676160 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -945,6 +945,14 @@
 				status = "disabled";
 			};
 
+			pxp: pxp@21cc000 {
+				compatible = "fsl,imx6ul-pxp";
+				reg = <0x021cc000 0x4000>;
+				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
+				clock-names = "axi";
+				clocks = <&clks IMX6UL_CLK_PXP>;
+			};
+
 			qspi: qspi@21e0000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
diff --git a/arch/arm/boot/dts/imx6ull.dtsi b/arch/arm/boot/dts/imx6ull.dtsi
index cd1776a7015a..c0518490b58c 100644
--- a/arch/arm/boot/dts/imx6ull.dtsi
+++ b/arch/arm/boot/dts/imx6ull.dtsi
@@ -57,3 +57,9 @@
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
