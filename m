Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53200 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933299AbeGJICV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:02:21 -0400
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
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v5 20/22] ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
Date: Tue, 10 Jul 2018 10:01:12 +0200
Message-Id: <20180710080114.31469-21-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds nodes for the Video Engine and the associated reserved memory
for the A20. Up to 96 MiB of memory are dedicated to the CMA pool.

The VPU can only map the first 256 MiB of DRAM, so the reserved memory
pool has to be located in that area. Following Allwinner's decision in
downstream software, the last 96 MiB of the first 256 MiB of RAM are
reserved for this purpose.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 38999d791cb5..cb6e10196118 100644
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
@@ -466,6 +481,19 @@
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
2.17.1
