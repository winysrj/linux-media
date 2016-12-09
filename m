Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46685 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753244AbcLIQ7U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 11:59:20 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v2 1/7] ARM: dts: imx6qdl: Add VDOA compatible and clocks properties
Date: Fri,  9 Dec 2016 17:58:57 +0100
Message-Id: <20161209165903.1293-2-m.tretter@pengutronix.de>
In-Reply-To: <20161209165903.1293-1-m.tretter@pengutronix.de>
References: <20161209165903.1293-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

This adds a compatible property and the correct clock for the
i.MX6Q Video Data Order Adapter.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 .../devicetree/bindings/media/fsl-vdoa.txt          | 21 +++++++++++++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi                      |  2 ++
 2 files changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-vdoa.txt

diff --git a/Documentation/devicetree/bindings/media/fsl-vdoa.txt b/Documentation/devicetree/bindings/media/fsl-vdoa.txt
new file mode 100644
index 0000000..5e45f9b
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/fsl-vdoa.txt
@@ -0,0 +1,21 @@
+Freescale Video Data Order Adapter
+==================================
+
+The Video Data Order Adapter (VDOA) is present on the i.MX6q. Its sole purpose
+it to to reorder video data from the macroblock tiled order produced by the
+CODA 960 VPU to the conventional raster-scan order for scanout.
+
+Required properties:
+- compatible: must be "fsl,imx6q-vdoa"
+- reg: the register base and size for the device registers
+- interrupts: the VDOA interrupt
+- clocks: the vdoa clock
+
+Example:
+
+vdoa@021e4000 {
+        compatible = "fsl,imx6q-vdoa";
+        reg = <0x021e4000 0x4000>;
+        interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clks IMX6QDL_CLK_VDOA>;
+};
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index b13b0b2..69e3668 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1153,8 +1153,10 @@
 			};
 
 			vdoa@021e4000 {
+				compatible = "fsl,imx6q-vdoa";
 				reg = <0x021e4000 0x4000>;
 				interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX6QDL_CLK_VDOA>;
 			};
 
 			uart2: serial@021e8000 {
-- 
2.10.2

