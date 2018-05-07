Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50936 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbeEGMrn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:47:43 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florent Revest <florent.revest@free-electrons.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v3 14/14] ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes
Date: Mon,  7 May 2018 14:45:00 +0200
Message-Id: <20180507124500.20434-15-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
References: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds nodes for the Video Engine and the associated reserved memory
for the A33. Up to 96 MiB of memory are dedicated to the CMA pool.

The VPU can only map the first 256 MiB of DRAM, so the reserved memory
pool has to be located in that area. Following Allwinner's decision in
downstream software, the last 96 MiB of the first 256 MiB of RAM are
reserved for this purpose.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 arch/arm/boot/dts/sun8i-a33.dtsi | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
index 97a976b3b1ef..5308a49601f6 100644
--- a/arch/arm/boot/dts/sun8i-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a33.dtsi
@@ -181,6 +181,21 @@
 		reg = <0x40000000 0x80000000>;
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
 	sound: sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,name = "sun8i-a33-audio";
@@ -262,6 +277,23 @@
 			};
 		};
 
+		vpu: video-codec@01c0e000 {
+			compatible = "allwinner,sun8i-a33-video-engine";
+			reg = <0x01c0e000 0x1000>;
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
+			allwinner,sram = <&ve_sram 1>;
+		};
+
 		crypto: crypto-engine@1c15000 {
 			compatible = "allwinner,sun4i-a10-crypto";
 			reg = <0x01c15000 0x1000>;
-- 
2.16.3
