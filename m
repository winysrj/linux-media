Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34220 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758997AbcHYJk2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 05:40:28 -0400
From: Florent Revest <florent.revest@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: florent.revest@free-electrons.com, linux-sunxi@googlegroups.com,
        maxime.ripard@free-electrons.com, posciak@chromium.org,
        hans.verkuil@cisco.com, thomas.petazzoni@free-electrons.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org, wens@csie.org
Subject: [RFC 09/10] ARM: dts: sun5i: Use video-engine node
Date: Thu, 25 Aug 2016 11:39:48 +0200
Message-Id: <1472117989-21455-10-git-send-email-florent.revest@free-electrons.com>
In-Reply-To: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have a driver matching "allwinner,sun5i-a13-video-engine" we
can load it.

The "video-engine" node depends on the new sunxi-ng's CCU clock and
reset bindings. This patch also includes a ve_reserved DMA pool for
videobuf2 buffer allocations in sunxi-cedrus.

Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a13.dtsi | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 2afe05fb..384b645 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -69,6 +69,19 @@
 		};
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		ve_reserved: cma {
+			compatible = "shared-dma-pool";
+			reg = <0x43d00000 0x9000000>;
+			no-map;
+			linux,cma-default;
+		};
+	};
+
 	thermal-zones {
 		cpu_thermal {
 			/* milliseconds */
@@ -330,6 +343,24 @@
 			};
 		};
 
+		video-engine {
+			compatible = "allwinner,sun5i-a13-video-engine";
+			memory-region = <&ve_reserved>;
+
+			clocks = <&ahb_gates 32>, <&ccu CLK_VE>,
+				 <&dram_gates 0>;
+			clock-names = "ahb", "mod", "ram";
+
+			assigned-clocks = <&ccu CLK_VE>;
+			assigned-clock-rates = <320000000>;
+
+			resets = <&ccu RST_VE>;
+
+			interrupts = <53>;
+
+			reg = <0x01c0e000 4096>;
+		};
+
 		ccu: clock@01c20000 {
 			compatible = "allwinner,sun5i-a13-ccu";
 			reg = <0x01c20000 0x400>;
-- 
2.7.4

