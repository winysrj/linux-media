Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47213 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3AHNmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 08:42:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 1/2] ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5
Date: Tue,  8 Jan 2013 14:43:53 +0100
Message-Id: <1357652634-17668-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cam_mclk clock is generated through the following clocks chain:

dpll4 -> dpll4_m5 -> dpll4_m5x2 -> cam_mclk

As dpll4_m5 and dpll4_m5x2 do not driver any clock other than cam_mclk,
back-propagate the cam_clk rate changes up to dpll4_m5.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/mach-omap2/cclock3xxx_data.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index bdf3948..326b6ad 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -426,6 +426,7 @@ static struct clk dpll4_m5x2_ck_3630 = {
 	.parent_names	= dpll4_m5x2_ck_parent_names,
 	.num_parents	= ARRAY_SIZE(dpll4_m5x2_ck_parent_names),
 	.ops		= &dpll4_m5x2_ck_3630_ops,
+	.flags		= CLK_SET_RATE_PARENT,
 };
 
 static struct clk cam_mclk;
@@ -443,7 +444,14 @@ static struct clk_hw_omap cam_mclk_hw = {
 	.clkdm_name	= "cam_clkdm",
 };
 
-DEFINE_STRUCT_CLK(cam_mclk, cam_mclk_parent_names, aes2_ick_ops);
+static struct clk cam_mclk = {
+	.name		= "cam_mclk",
+	.hw		= &cam_mclk_hw.hw,
+	.parent_names	= cam_mclk_parent_names,
+	.num_parents	= ARRAY_SIZE(cam_mclk_parent_names),
+	.ops		= &aes2_ick_ops,
+	.flags		= CLK_SET_RATE_PARENT,
+};
 
 static const struct clksel_rate clkout2_src_core_rates[] = {
 	{ .div = 1, .val = 0, .flags = RATE_IN_3XXX },
-- 
1.7.8.6

