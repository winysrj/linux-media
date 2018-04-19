Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42937 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753442AbeDSPq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 11:46:58 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH v2 08/10] dt-bindings: media: Document bindings for the Sunxi-Cedrus VPU driver
Date: Thu, 19 Apr 2018 17:45:34 +0200
Message-Id: <20180419154536.17846-4-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a device-tree binding document that specifies the properties
used by the Sunxi-Cedurs VPU driver, as well as examples.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 .../devicetree/bindings/media/sunxi-cedrus.txt     | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt

diff --git a/Documentation/devicetree/bindings/media/sunxi-cedrus.txt b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
new file mode 100644
index 000000000000..71ad3f9c3352
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
@@ -0,0 +1,50 @@
+Device-tree bindings for the VPU found in Allwinner SoCs, referred to as the
+Video Engine (VE) in Allwinner literature.
+
+The VPU can only access the first 256 MiB of DRAM, that are DMA-mapped starting
+from the DRAM base. This requires specific memory allocation and handling.
+
+Required properties:
+- compatible	        : "allwinner,sun4i-a10-video-engine";
+- memory-region         : DMA pool for buffers allocation;
+- clocks	        : list of clock specifiers, corresponding to entries in
+                          the clock-names property;
+- clock-names	        : should contain "ahb", "mod" and "ram" entries;
+- assigned-clocks       : list of clocks assigned to the VE;
+- assigned-clocks-rates : list of clock rates for the clocks assigned to the VE;
+- resets	        : phandle for reset;
+- interrupts	        : should contain VE interrupt number;
+- reg		        : should contain register base and length of VE.
+
+Example:
+
+reserved-memory {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	/* Address must be kept in the lower 256 MiBs of DRAM for VE. */
+	ve_memory: cma@4a000000 {
+		compatible = "shared-dma-pool";
+		reg = <0x4a000000 0x6000000>;
+		no-map;
+		linux,cma-default;
+	};
+};
+
+video-engine@1c0e000 {
+	compatible = "allwinner,sun4i-a10-video-engine";
+	reg = <0x01c0e000 0x1000>;
+	memory-region = <&ve_memory>;
+
+	clocks = <&ccu CLK_AHB_VE>, <&ccu CLK_VE>,
+		 <&ccu CLK_DRAM_VE>;
+	clock-names = "ahb", "mod", "ram";
+
+	assigned-clocks = <&ccu CLK_VE>;
+	assigned-clock-rates = <320000000>;
+
+	resets = <&ccu RST_VE>;
+
+	interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.16.3
