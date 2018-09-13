Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44705 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbeIMUBw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 16:01:52 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v10 4/5] dt-bindings: media: Document bindings for the Cedrus VPU driver
Date: Thu, 13 Sep 2018 16:51:54 +0200
Message-Id: <20180913145155.1636-5-maxime.ripard@bootlin.com>
In-Reply-To: <20180913145155.1636-1-maxime.ripard@bootlin.com>
References: <20180913145155.1636-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

This adds a device-tree binding document that specifies the properties
used by the Cedrus VPU driver, as well as examples.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 .../devicetree/bindings/media/cedrus.txt      | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cedrus.txt

diff --git a/Documentation/devicetree/bindings/media/cedrus.txt b/Documentation/devicetree/bindings/media/cedrus.txt
new file mode 100644
index 000000000000..a089a0c1ff05
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/cedrus.txt
@@ -0,0 +1,54 @@
+Device-tree bindings for the VPU found in Allwinner SoCs, referred to as the
+Video Engine (VE) in Allwinner literature.
+
+The VPU can only access the first 256 MiB of DRAM, that are DMA-mapped starting
+from the DRAM base. This requires specific memory allocation and handling.
+
+Required properties:
+- compatible		: must be one of the following compatibles:
+			- "allwinner,sun4i-a10-video-engine"
+			- "allwinner,sun5i-a13-video-engine"
+			- "allwinner,sun7i-a20-video-engine"
+			- "allwinner,sun8i-a33-video-engine"
+			- "allwinner,sun8i-h3-video-engine"
+- reg			: register base and length of VE;
+- clocks		: list of clock specifiers, corresponding to entries in
+			  the clock-names property;
+- clock-names		: should contain "ahb", "mod" and "ram" entries;
+- resets		: phandle for reset;
+- interrupts		: VE interrupt number;
+- allwinner,sram	: SRAM region to use with the VE.
+
+Optional properties:
+- memory-region		: CMA pool to use for buffers allocation instead of the
+			  default CMA pool.
+
+Example:
+
+reserved-memory {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	/* Address must be kept in the lower 256 MiBs of DRAM for VE. */
+	cma_pool: cma@4a000000 {
+		compatible = "shared-dma-pool";
+		size = <0x6000000>;
+		alloc-ranges = <0x4a000000 0x6000000>;
+		reusable;
+		linux,cma-default;
+	};
+};
+
+video-codec@1c0e000 {
+	compatible = "allwinner,sun7i-a20-video-engine";
+	reg = <0x01c0e000 0x1000>;
+
+	clocks = <&ccu CLK_AHB_VE>, <&ccu CLK_VE>,
+		 <&ccu CLK_DRAM_VE>;
+	clock-names = "ahb", "mod", "ram";
+
+	resets = <&ccu RST_VE>;
+	interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
+	allwinner,sram = <&ve_sram 1>;
+};
-- 
2.17.1
