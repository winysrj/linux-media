Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41755 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964808AbeFRPAi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 11:00:38 -0400
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v4 18/19] ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
Date: Mon, 18 Jun 2018 16:58:42 +0200
Message-Id: <20180618145843.14631-19-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
References: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds nodes for the Video Engine and the associated reserved memory
for the A20. Up to 96 MiB of memory are dedicated to the CMA pool.

The VPU can only map the first 256 MiB of DRAM, so the reserved memory
pool has to be located in that area. Following Allwinner's decision in
downstream software, the last 96 MiB of the first 256 MiB of RAM are
reserved for this purpose.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 9afd82f9ec79..479272f02686 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -161,6 +161,21 @@
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
 	timer {
 		compatible = "arm,armv7-timer";
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
@@ -464,6 +479,19 @@
 			};
 		};
 
+		vpu: video-codec@1c0e000 {
+			compatible = "allwinner,sun7i-a20-video-engine";
+			reg = <0x01c0e000 0x1000>;
+
+			clocks = <&ccu CLK_AHB_VE>, <&ccu CLK_VE>,
+				 <&ccu CLK_DRAM_VE>;
+			clock-names = "ahb", "mod", "ram";
+
+			resets = <&ccu RST_VE>;
+			interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
+			allwinner,sram = <&ve_sram 1>;
+		};
+
 		mmc0: mmc@1c0f000 {
 			compatible = "allwinner,sun7i-a20-mmc";
 			reg = <0x01c0f000 0x1000>;
-- 
2.17.0
