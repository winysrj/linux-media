Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53034 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751329AbeGJICN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:13 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v5 17/22] dt-bindings: media: Document bindings for the Sunxi-Cedrus VPU driver
Date: Tue, 10 Jul 2018 10:01:09 +0200
Message-Id: <20180710080114.31469-18-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a device-tree binding document that specifies the properties
used by the Sunxi-Cedurs VPU driver, as well as examples.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/media/sunxi-cedrus.txt           | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt

diff --git a/Documentation/devicetree/bindings/media/sunxi-cedrus.txt b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
new file mode 100644
index 000000000000..a089a0c1ff05
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
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
