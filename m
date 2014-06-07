Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62028 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaFGV5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:39 -0400
Received: by mail-pb0-f48.google.com with SMTP id rr13so3920401pbb.21
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:39 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 37/43] ARM: imx6q: clk: Add video 27m clock
Date: Sat,  7 Jun 2014 14:56:39 -0700
Message-Id: <1402178205-22697-38-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds a 27MHz clock that is a fixed /20 from the pll3_pfd1_540m clock.
The MIPI CSI2 receiver depends on this clock for its D-PHY operation.
Based on ENGR00275483-1 from Freescale.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 .../devicetree/bindings/clock/imx6q-clock.txt      |    1 +
 arch/arm/mach-imx/clk-imx6q.c                      |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.txt b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
index 6aab72b..32dc74f 100644
--- a/Documentation/devicetree/bindings/clock/imx6q-clock.txt
+++ b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
@@ -220,6 +220,7 @@ clocks and IDs.
 	lvds2_sel		205
 	lvds1_gate		206
 	lvds2_gate		207
+	video_27m		208
 
 Examples:
 
diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 2b4d6ac..ca87984 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -107,7 +107,7 @@ enum mx6q_clks {
 	sata_ref, sata_ref_100m, pcie_ref, pcie_ref_125m, enet_ref, usbphy1_gate,
 	usbphy2_gate, pll4_post_div, pll5_post_div, pll5_video_div, eim_slow,
 	spdif, cko2_sel, cko2_podf, cko2, cko, vdoa, pll4_audio_div,
-	lvds1_sel, lvds2_sel, lvds1_gate, lvds2_gate, clk_max
+	lvds1_sel, lvds2_sel, lvds1_gate, lvds2_gate, video_27m, clk_max
 };
 
 static struct clk *clk[clk_max];
@@ -226,6 +226,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[pll3_80m]  = imx_clk_fixed_factor("pll3_80m",  "pll3_usb_otg",   1, 6);
 	clk[pll3_60m]  = imx_clk_fixed_factor("pll3_60m",  "pll3_usb_otg",   1, 8);
 	clk[twd]       = imx_clk_fixed_factor("twd",       "arm",            1, 2);
+	clk[video_27m] = imx_clk_fixed_factor("video_27m", "pll3_pfd1_540m", 1, 20);
 
 	clk[pll4_post_div] = clk_register_divider_table(NULL, "pll4_post_div", "pll4_audio", CLK_SET_RATE_PARENT, base + 0x70, 19, 2, 0, post_div_table, &imx_ccm_lock);
 	clk[pll4_audio_div] = clk_register_divider(NULL, "pll4_audio_div", "pll4_post_div", CLK_SET_RATE_PARENT, base + 0x170, 15, 1, 0, &imx_ccm_lock);
-- 
1.7.9.5

