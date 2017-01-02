Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:60929 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932906AbdABNYJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 08:24:09 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, Philipp Zabel <philipp.zabel@gmail.com>,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v3 1/7] [media] dt-bindings: Add a binding for Video Data Order Adapter
Date: Mon,  2 Jan 2017 14:23:46 +0100
Message-Id: <20170102132352.23669-2-m.tretter@pengutronix.de>
In-Reply-To: <20170102132352.23669-1-m.tretter@pengutronix.de>
References: <20170102132352.23669-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

Add a DT binding documentation for the Video Data Order Adapter (VDOA)
of the Freescale i.MX6 SoC.

Also, add the compatible property and correct clock to the device tree
to match the documentation.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 .../devicetree/bindings/media/fsl-vdoa.txt          | 21 +++++++++++++++++++++
 arch/arm/boot/dts/imx6qdl.dtsi                      |  2 ++
 2 files changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-vdoa.txt

diff --git a/Documentation/devicetree/bindings/media/fsl-vdoa.txt b/Documentation/devicetree/bindings/media/fsl-vdoa.txt
new file mode 100644
index 000000000000..6c5628530bb7
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/fsl-vdoa.txt
@@ -0,0 +1,21 @@
+Freescale Video Data Order Adapter
+==================================
+
+The Video Data Order Adapter (VDOA) is present on the i.MX6q. Its sole purpose
+is to reorder video data from the macroblock tiled order produced by the CODA
+960 VPU to the conventional raster-scan order for scanout.
+
+Required properties:
+- compatible: must be "fsl,imx6q-vdoa"
+- reg: the register base and size for the device registers
+- interrupts: the VDOA interrupt
+- clocks: the vdoa clock
+
+Example:
+
+vdoa@21e4000 {
+        compatible = "fsl,imx6q-vdoa";
+        reg = <0x021e4000 0x4000>;
+        interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clks IMX6QDL_CLK_VDOA>;
+};
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 53e6e63cbb02..61569c86d28e 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1157,8 +1157,10 @@
 			};
 
 			vdoa@021e4000 {
+				compatible = "fsl,imx6q-vdoa";
 				reg = <0x021e4000 0x4000>;
 				interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX6QDL_CLK_VDOA>;
 			};
 
 			uart2: serial@021e8000 {
-- 
2.11.0

