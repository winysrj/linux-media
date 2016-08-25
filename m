Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34209 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758962AbcHYJk0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 05:40:26 -0400
From: Florent Revest <florent.revest@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: florent.revest@free-electrons.com, linux-sunxi@googlegroups.com,
        maxime.ripard@free-electrons.com, posciak@chromium.org,
        hans.verkuil@cisco.com, thomas.petazzoni@free-electrons.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org, wens@csie.org
Subject: [RFC 10/10] sunxi-cedrus: Add device tree binding document
Date: Thu, 25 Aug 2016 11:39:49 +0200
Message-Id: <1472117989-21455-11-git-send-email-florent.revest@free-electrons.com>
In-Reply-To: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device Tree bindings for the Allwinner's video engine

Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
---
 .../devicetree/bindings/media/sunxi-cedrus.txt     | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-cedrus.txt

diff --git a/Documentation/devicetree/bindings/media/sunxi-cedrus.txt b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
new file mode 100644
index 0000000..26f2e09
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
@@ -0,0 +1,44 @@
+Device-Tree bindings for SUNXI video engine found in sunXi SoC family
+
+Required properties:
+- compatible	    : "allwinner,sun5i-a13-video-engine";
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
+	compatible = "allwinner,sun5i-a13-video-engine";
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
2.7.4

