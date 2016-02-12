Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52568 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbcBLCAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 21:00:33 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
Date: Fri, 12 Feb 2016 04:00:42 +0200
Message-Id: <1455242450-24493-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parent clock isn't documented in the datasheet, use S2D1 as a best
guess for now.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clk/shmobile/r8a7795-cpg-mssr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/clk/shmobile/r8a7795-cpg-mssr.c b/drivers/clk/shmobile/r8a7795-cpg-mssr.c
index 13e994772dfd..ae5004ee7bdd 100644
--- a/drivers/clk/shmobile/r8a7795-cpg-mssr.c
+++ b/drivers/clk/shmobile/r8a7795-cpg-mssr.c
@@ -130,6 +130,21 @@ static const struct mssr_mod_clk r8a7795_mod_clks[] __initconst = {
 	DEF_MOD("hscif2",		 518,	R8A7795_CLK_S3D1),
 	DEF_MOD("hscif1",		 519,	R8A7795_CLK_S3D1),
 	DEF_MOD("hscif0",		 520,	R8A7795_CLK_S3D1),
+	DEF_MOD("fcpvd3",		 600,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpvd2",		 601,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpvd1",		 602,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpvd0",		 603,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpvb1",		 606,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpvb0",		 607,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpvi2",		 609,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpvi1",		 610,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpvi0",		 611,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpf2",		 613,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpf1",		 614,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpf0",		 615,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpci1",		 616,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpci0",		 617,	R8A7795_CLK_S2D1),
+	DEF_MOD("fcpcs",		 619,	R8A7795_CLK_S2D1),
 	DEF_MOD("vspd3",		 620,	R8A7795_CLK_S2D1),
 	DEF_MOD("vspd2",		 621,	R8A7795_CLK_S2D1),
 	DEF_MOD("vspd1",		 622,	R8A7795_CLK_S2D1),
-- 
2.4.10

