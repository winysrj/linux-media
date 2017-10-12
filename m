Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:34474 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752744AbdJLT1k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 15:27:40 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 6/6] ARM: dts: dra7: Add VPE dtsi node
Date: Thu, 12 Oct 2017 14:27:19 -0500
Message-ID: <20171012192719.15193-7-bparrot@ti.com>
In-Reply-To: <20171012192719.15193-1-bparrot@ti.com>
References: <20171012192719.15193-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the necessary node and configuration data for the VPE (Video
Processing Engine) hardware block on DRA7x.

The corresponding driver for this entry is in
drivers/media/platform/ti-vpe/vpe.c.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 02a136a4661a..f302d2e5eede 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -2018,6 +2018,32 @@
 			clocks = <&l3_iclk_div>;
 			clock-names = "fck";
 		};
+
+		vpe {
+			compatible = "ti,vpe";
+			ti,hwmods = "vpe";
+			clocks = <&dpll_core_h23x2_ck>;
+			clock-names = "fck";
+			reg = <0x489d0000 0x120>,
+			      <0x489d0300 0x20>,
+			      <0x489d0400 0x20>,
+			      <0x489d0500 0x20>,
+			      <0x489d0600 0x3c>,
+			      <0x489d0700 0x80>,
+			      <0x489d5700 0x18>,
+			      <0x489dd000 0x400>;
+			reg-names = "vpe_top",
+				    "vpe_chr_us0",
+				    "vpe_chr_us1",
+				    "vpe_chr_us2",
+				    "vpe_dei",
+				    "sc",
+				    "csc",
+				    "vpdma";
+			interrupts = <GIC_SPI 354 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
 	};
 
 	thermal_zones: thermal-zones {
-- 
2.9.0
