Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34021 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbeHJRsw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 13:48:52 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 1/3] dt-bindings: media: Add i.MX Pixel Pipeline binding
Date: Fri, 10 Aug 2018 17:18:20 +0200
Message-Id: <20180810151822.18650-2-p.zabel@pengutronix.de>
In-Reply-To: <20180810151822.18650-1-p.zabel@pengutronix.de>
References: <20180810151822.18650-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT binding documentation for the Pixel Pipeline (PXP) found on
various NXP i.MX SoCs.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 .../devicetree/bindings/media/fsl-pxp.txt     | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-pxp.txt

diff --git a/Documentation/devicetree/bindings/media/fsl-pxp.txt b/Documentation/devicetree/bindings/media/fsl-pxp.txt
new file mode 100644
index 000000000000..2477e7f87381
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/fsl-pxp.txt
@@ -0,0 +1,26 @@
+Freescale Pixel Pipeline
+========================
+
+The Pixel Pipeline (PXP) is a memory-to-memory graphics processing engine
+that supports scaling, colorspace conversion, alpha blending, rotation, and
+pixel conversion via lookup table. Different versions are present on various
+i.MX SoCs from i.MX23 to i.MX7.
+
+Required properties:
+- compatible: should be "fsl,<soc>-pxp", where SoC can be one of imx23, imx28,
+  imx6dl, imx6sl, imx6ul, imx6sx, imx6ull, or imx7d.
+- reg: the register base and size for the device registers
+- interrupts: the PXP interrupt, two interrupts for imx6ull and imx7d.
+- clock-names: should be "axi"
+- clocks: the PXP AXI clock
+
+Example:
+
+pxp@21cc000 {
+	compatible = "fsl,imx6ull-pxp";
+	reg = <0x021cc000 0x4000>;
+	interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
+	clock-names = "axi";
+	clocks = <&clks IMX6UL_CLK_PXP>;
+};
-- 
2.18.0
