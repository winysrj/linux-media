Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:56728 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbeIGDM2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 23:12:28 -0400
From: Paul Kocialkowski <contact@paulk.fr>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v9 6/9] ARM: dts: sun5i: Add Video Engine and reserved memory nodes
Date: Fri,  7 Sep 2018 00:24:39 +0200
Message-Id: <20180906222442.14825-7-contact@paulk.fr>
In-Reply-To: <20180906222442.14825-1-contact@paulk.fr>
References: <20180906222442.14825-1-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

This adds nodes for the Video Engine and the associated reserved memory
for sun5i-based platforms. Up to 96 MiB of memory are dedicated to the
CMA pool.

The VPU can only map the first 256 MiB of DRAM, so the reserved memory
pool has to be located in that area. Following Allwinner's decision in
downstream software, the last 96 MiB of the first 256 MiB of RAM are
reserved for this purpose.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 arch/arm/boot/dts/sun5i.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i.dtsi b/arch/arm/boot/dts/sun5i.dtsi
index 8bfb36651177..9cd65c46720b 100644
--- a/arch/arm/boot/dts/sun5i.dtsi
+++ b/arch/arm/boot/dts/sun5i.dtsi
@@ -108,6 +108,21 @@
 		};
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/* Address must be kept in the lower 256 MiBs of DRAM for VE. */
+		cma_pool: cma@4a000000 {
+			compatible = "shared-dma-pool";
+			size = <0x6000000>;
+			alloc-ranges = <0x4a000000 0x6000000>;
+			reusable;
+			linux,cma-default;
+		};
+	};
+
 	soc@1c00000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -294,6 +309,17 @@
 			};
 		};
 
+		video-codec@1c0e000 {
+			compatible = "allwinner,sun5i-a13-video-engine";
+			reg = <0x01c0e000 0x1000>;
+			clocks = <&ccu CLK_AHB_VE>, <&ccu CLK_VE>,
+				 <&ccu CLK_DRAM_VE>;
+			clock-names = "ahb", "mod", "ram";
+			resets = <&ccu RST_VE>;
+			interrupts = <53>;
+			allwinner,sram = <&ve_sram 1>;
+		};
+
 		mmc0: mmc@1c0f000 {
 			compatible = "allwinner,sun5i-a13-mmc";
 			reg = <0x01c0f000 0x1000>;
-- 
2.18.0
