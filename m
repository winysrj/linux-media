Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42975 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753448AbeDSPq7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 11:46:59 -0400
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
Subject: [PATCH v2 10/10] ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes
Date: Thu, 19 Apr 2018 17:45:36 +0200
Message-Id: <20180419154536.17846-6-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds nodes for the Video Engine and the associated reserved memory
for the Allwinner A33. Up to 96 MiB of memory are dedicated to the VPU.

The VPU can only map the first 256 MiB of DRAM, so the reserved memory
pool has to be located in that area. Following Allwinner's decision in
downstream software, the last 96 MiB of the first 256 MiB of RAM are
reserved for this purpose.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 arch/arm/boot/dts/sun8i-a33.dtsi | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
index a21f2ed07a52..308b532aee1d 100644
--- a/arch/arm/boot/dts/sun8i-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a33.dtsi
@@ -181,6 +181,20 @@
 		reg = <0x40000000 0x80000000>;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/* Address must be kept in the lower 256 MiBs of DRAM for VE. */
+		ve_memory: cma@4a000000 {
+			compatible = "shared-dma-pool";
+			reg = <0x4a000000 0x6000000>;
+			no-map;
+			linux,cma-default;
+		};
+	};
+
 	sound: sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,name = "sun8i-a33-audio";
@@ -204,6 +218,11 @@
 	};
 
 	soc@1c00000 {
+		syscon: system-controller@01c00000 {
+			compatible = "allwinner,sun8i-a33-syscon", "syscon";
+			reg = <0x01c00000 0x1000>;
+		};
+
 		tcon0: lcd-controller@1c0c000 {
 			compatible = "allwinner,sun8i-a33-tcon";
 			reg = <0x01c0c000 0x1000>;
@@ -240,6 +259,25 @@
 			};
 		};
 
+		ve: video-engine@01c0e000 {
+			compatible = "allwinner,sun4i-a10-video-engine";
+			memory-region = <&ve_memory>;
+			syscon = <&syscon>;
+
+			clocks = <&ccu CLK_BUS_VE>, <&ccu CLK_VE>,
+				 <&ccu CLK_DRAM_VE>;
+			clock-names = "ahb", "mod", "ram";
+
+			assigned-clocks = <&ccu CLK_VE>;
+			assigned-clock-rates = <320000000>;
+
+			resets = <&ccu RST_BUS_VE>;
+
+			interrupts = <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
+
+			reg = <0x01c0e000 0x1000>;
+		};
+
 		crypto: crypto-engine@1c15000 {
 			compatible = "allwinner,sun4i-a10-crypto";
 			reg = <0x01c15000 0x1000>;
-- 
2.16.3
