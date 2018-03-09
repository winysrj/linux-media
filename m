Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50004 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750939AbeCIKPz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:15:55 -0500
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
Subject: [PATCH 9/9] ARM: dts: sun7i: Add video engine support for the A20
Date: Fri,  9 Mar 2018 11:14:45 +0100
Message-Id: <20180309101445.16190-7-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thomas van Kleef <thomas@vitsch.nl>

The A20 has a video engine similare to the one in the A13.

Add the device node in the A20.

Signed-off-by: Thomas van Kleef <thomas@vitsch.nl>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 47 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index bd0cd3204273..b0d21208af87 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -53,6 +53,35 @@
 / {
 	interrupt-parent = <&gic>;
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/*
+		 * MUST TO BE IN THE LOWER 256MB of RAM for the VE!
+		 * Src: http://linux-sunxi.org/Sunxi-cedrus "A
+		 * limitation of the Allwinner's VPU is the need for
+		 * buffers in the lower 256M of RAM. In order to
+		 * allocate large sets of data in this area,
+		 * "sunxi-cedrus" reserves a DMA pool that is then
+		 * used by videobuf's dma-contig backend() to allocate
+		 * input and output buffers easily and integrate that
+		 * with the v4l QBUF/DQBUF APIs."
+		 *
+		 * The lower limit is 0x41000000 but the kernel has to
+		 * be moved somewhere else in order to use this
+		 * region.
+		 */
+
+		ve_reserved: cma {
+			compatible = "shared-dma-pool";
+			reg = <0x41000000 0x9000000>;
+			no-map;
+			linux,cma-default;
+		};
+	};
+
 	aliases {
 		ethernet0 = &gmac;
 	};
@@ -451,6 +480,24 @@
 			};
 		};
 
+		ve: video-engine@01c0e000 {
+			compatible = "allwinner,sun4i-a10-video-engine";
+			memory-region = <&ve_reserved>;
+
+			clocks = <&ccu CLK_AHB_VE>, <&ccu CLK_VE>,
+				 <&ccu CLK_DRAM_VE>;
+			clock-names = "ahb", "mod", "ram";
+
+			assigned-clocks = <&ccu CLK_VE>;
+			assigned-clock-rates = <320000000>;
+
+			resets = <&ccu RST_VE>;
+
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
+
+			reg = <0x01c0e000 0x1000>;
+		};
+
 		mmc0: mmc@1c0f000 {
 			compatible = "allwinner,sun7i-a20-mmc";
 			reg = <0x01c0f000 0x1000>;
-- 
2.16.2
