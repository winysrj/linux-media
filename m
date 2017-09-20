Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailoutvs7.siol.net ([213.250.19.138]:55726 "EHLO mail.siol.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751661AbdITUIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 16:08:42 -0400
From: Jernej Skrabec <jernej.skrabec@siol.net>
To: maxime.ripard@free-electrons.com, wens@csie.org
Cc: Laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        narmstrong@baylibre.com, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        icenowy@aosc.io, linux-sunxi@googlegroups.com,
        linux-media@vger.kernel.org
Subject: [RESEND RFC PATCH 3/7] clk: sunxi: Add CLK_SET_RATE_PARENT flag for H3 HDMI clock
Date: Wed, 20 Sep 2017 22:01:20 +0200
Message-Id: <20170920200124.20457-4-jernej.skrabec@siol.net>
In-Reply-To: <20170920200124.20457-1-jernej.skrabec@siol.net>
References: <20170920200124.20457-1-jernej.skrabec@siol.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When setting the HDMI clock of H3, the PLL_VIDEO clock needs to be set.

Add CLK_SET_RATE_PARENT flag for H3 HDMI clock.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
---
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
index 7a222ff1ad0a..36224ba93f9d 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-h3.c
@@ -474,7 +474,7 @@ static SUNXI_CCU_GATE(avs_clk,		"avs",		"osc24M",
 
 static const char * const hdmi_parents[] = { "pll-video" };
 static SUNXI_CCU_M_WITH_MUX_GATE(hdmi_clk, "hdmi", hdmi_parents,
-				 0x150, 0, 4, 24, 2, BIT(31), 0);
+				 0x150, 0, 4, 24, 2, BIT(31), CLK_SET_RATE_PARENT);
 
 static SUNXI_CCU_GATE(hdmi_ddc_clk,	"hdmi-ddc",	"osc24M",
 		      0x154, BIT(31), 0);
-- 
2.14.1
