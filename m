Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49957 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeCIKPy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:15:54 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Icenowy Zheng <icenowy@aosc.xyz>,
        Florent Revest <revestflo@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 6/9] sunxi-cedrus: Add device tree binding document
Date: Fri,  9 Mar 2018 11:14:42 +0100
Message-Id: <20180309101445.16190-4-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Florent Revest <florent.revest@free-electrons.com>

Device Tree bindings for the Allwinner's video engine

Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
---
 .../devicetree/bindings/media/sunxi-cedrus.txt     | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt

diff --git a/Documentation/devicetree/bindings/media/sunxi-cedrus.txt b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
new file mode 100644
index 000000000000..138581113c49
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
@@ -0,0 +1,44 @@
+Device-Tree bindings for SUNXI video engine found in sunXi SoC family
+
+Required properties:
+- compatible	    : "allwinner,sun4i-a10-video-engine";
+- memory-region     : DMA pool for buffers allocation;
+- clocks	    : list of clock specifiers, corresponding to
+		      entries in clock-names property;
+- clock-names	    : should contain "ahb", "mod" and "ram" entries;
+- resets	    : phandle for reset;
+- interrupts	    : should contain VE interrupt number;
+- reg		    : should contain register base and length of VE.
+
+Example:
+
+reserved-memory {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	ve_reserved: cma {
+		compatible = "shared-dma-pool";
+		reg = <0x43d00000 0x9000000>;
+		no-map;
+		linux,cma-default;
+	};
+};
+
+video-engine {
+	compatible = "allwinner,sun4i-a10-video-engine";
+	memory-region = <&ve_reserved>;
+
+	clocks = <&ahb_gates 32>, <&ccu CLK_VE>,
+		 <&dram_gates 0>;
+	clock-names = "ahb", "mod", "ram";
+
+	assigned-clocks = <&ccu CLK_VE>;
+	assigned-clock-rates = <320000000>;
+
+	resets = <&ccu RST_VE>;
+
+	interrupts = <53>;
+
+	reg = <0x01c0e000 4096>;
+};
-- 
2.16.2
