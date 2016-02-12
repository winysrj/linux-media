Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52569 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbcBLCAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 21:00:35 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 2/9] clk: shmobile: r8a7795: Add LVDS module clock
Date: Fri, 12 Feb 2016 04:00:43 +0200
Message-Id: <1455242450-24493-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parent clock hasn't been validated yet.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clk/shmobile/r8a7795-cpg-mssr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/shmobile/r8a7795-cpg-mssr.c b/drivers/clk/shmobile/r8a7795-cpg-mssr.c
index ae5004ee7bdd..a301a5e14498 100644
--- a/drivers/clk/shmobile/r8a7795-cpg-mssr.c
+++ b/drivers/clk/shmobile/r8a7795-cpg-mssr.c
@@ -162,6 +162,7 @@ static const struct mssr_mod_clk r8a7795_mod_clks[] __initconst = {
 	DEF_MOD("du2",			 722,	R8A7795_CLK_S2D1),
 	DEF_MOD("du1",			 723,	R8A7795_CLK_S2D1),
 	DEF_MOD("du0",			 724,	R8A7795_CLK_S2D1),
+	DEF_MOD("lvds",			 727,	R8A7795_CLK_S2D1),
 	DEF_MOD("hdmi1",		 728,	R8A7795_CLK_HDMI),
 	DEF_MOD("hdmi0",		 729,	R8A7795_CLK_HDMI),
 	DEF_MOD("etheravb",		 812,	R8A7795_CLK_S3D2),
-- 
2.4.10

