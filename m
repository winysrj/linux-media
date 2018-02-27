Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-1.mail.aliyun.com ([115.124.20.1]:36668 "EHLO
        out20-1.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbeB0CI4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 21:08:56 -0500
From: Yong Deng <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Yong Deng <yong.deng@magewell.com>
Subject: [PATCH v8 1/2] dt-bindings: media: Add Allwinner V3s Camera Sensor Interface (CSI)
Date: Tue, 27 Feb 2018 10:07:36 +0800
Message-Id: <1519697256-32472-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add binding documentation for Allwinner V3s CSI.

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Yong Deng <yong.deng@magewell.com>
---
 .../devicetree/bindings/media/sun6i-csi.txt        | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt

diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
new file mode 100644
index 000000000000..2ff47a9507a6
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
@@ -0,0 +1,59 @@
+Allwinner V3s Camera Sensor Interface
+-------------------------------------
+
+Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
+interface and CSI1 is used for parallel interface.
+
+Required properties:
+  - compatible: value must be "allwinner,sun8i-v3s-csi"
+  - reg: base address and size of the memory-mapped region.
+  - interrupts: interrupt associated to this IP
+  - clocks: phandles to the clocks feeding the CSI
+    * bus: the CSI interface clock
+    * mod: the CSI module clock
+    * ram: the CSI DRAM clock
+  - clock-names: the clock names mentioned above
+  - resets: phandles to the reset line driving the CSI
+
+Each CSI node should contain one 'port' child node with one child 'endpoint'
+node, according to the bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt. As mentioned
+above, the endpoint's bus type should be MIPI CSI-2 for CSI0 and parallel or
+Bt656 for CSI1.
+
+Endpoint node properties for CSI1
+---------------------------------
+
+- remote-endpoint	: (required) a phandle to the bus receiver's endpoint
+			   node
+- bus-width:		: (required) must be 8, 10, 12 or 16
+- pclk-sample		: (optional) (default: sample on falling edge)
+- hsync-active		: (only required for parallel)
+- vsync-active		: (only required for parallel)
+
+Example:
+
+csi1: csi@1cb4000 {
+	compatible = "allwinner,sun8i-v3s-csi";
+	reg = <0x01cb4000 0x1000>;
+	interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&ccu CLK_BUS_CSI>,
+		 <&ccu CLK_CSI1_SCLK>,
+		 <&ccu CLK_DRAM_CSI>;
+	clock-names = "bus", "mod", "ram";
+	resets = <&ccu RST_BUS_CSI>;
+
+	port {
+		/* Parallel bus endpoint */
+		csi1_ep: endpoint {
+			remote-endpoint = <&adv7611_ep>;
+			bus-width = <16>;
+
+			/* If hsync-active/vsync-active are missing,
+			   embedded BT.656 sync is used */
+			hsync-active = <0>; /* Active low */
+			vsync-active = <0>; /* Active low */
+			pclk-sample = <1>;  /* Rising */
+		};
+	};
+};
-- 
1.8.3.1
