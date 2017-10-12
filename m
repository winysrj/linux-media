Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:34471 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdJLT1g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 15:27:36 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 4/6] dt-bindings: media: ti-vpe: Document VPE driver
Date: Thu, 12 Oct 2017 14:27:17 -0500
Message-ID: <20171012192719.15193-5-bparrot@ti.com>
In-Reply-To: <20171012192719.15193-1-bparrot@ti.com>
References: <20171012192719.15193-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device Tree bindings for the Video Processing Engine (VPE) driver.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 Documentation/devicetree/bindings/media/ti-vpe.txt | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti-vpe.txt

diff --git a/Documentation/devicetree/bindings/media/ti-vpe.txt b/Documentation/devicetree/bindings/media/ti-vpe.txt
new file mode 100644
index 000000000000..c2ef93d08417
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti-vpe.txt
@@ -0,0 +1,41 @@
+Texas Instruments DRA7x VIDEO PROCESSING ENGINE (VPE)
+------------------------------------------------------
+
+The Video Processing Engine (VPE) is a key component for image post
+processing applications. VPE consist of a single memory to memory
+path which can perform chroma up/down sampling, deinterlacing,
+scaling and color space conversion.
+
+Required properties:
+- compatible: must be "ti,vpe"
+- reg:	physical base address and length of the registers set for the 8
+	memory regions required;
+- reg-names: name associated with the memory regions described is <reg>;
+- interrupts: should contain IRQ line for VPE;
+
+Example:
+	vpe {
+		compatible = "ti,vpe";
+		ti,hwmods = "vpe";
+		clocks = <&dpll_core_h23x2_ck>;
+		clock-names = "fck";
+		reg =	<0x489d0000 0x120>,
+			<0x489d0300 0x20>,
+			<0x489d0400 0x20>,
+			<0x489d0500 0x20>,
+			<0x489d0600 0x3c>,
+			<0x489d0700 0x80>,
+			<0x489d5700 0x18>,
+			<0x489dd000 0x400>;
+		reg-names =	"vpe_top",
+				"vpe_chr_us0",
+				"vpe_chr_us1",
+				"vpe_chr_us2",
+				"vpe_dei",
+				"sc",
+				"csc",
+				"vpdma";
+		interrupts = <GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
-- 
2.9.0
