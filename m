Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47433 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab2IJPaQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 11:30:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 13/16] ARM i.MX5: Fix CODA7 clock lookup for device tree on i.MX51 and i.MX53
Date: Mon, 10 Sep 2012 17:29:57 +0200
Message-Id: <1347291000-340-14-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/mach-imx/clk-imx51-imx53.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
index 4bdcaa9..64f9ceb 100644
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -345,7 +345,7 @@ int __init mx51_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 
 	clk_register_clkdev(clk[hsi2c_gate], NULL, "imx-i2c.2");
 	clk_register_clkdev(clk[mx51_mipi], "mipi_hsp", NULL);
-	clk_register_clkdev(clk[vpu_gate], NULL, "imx51-vpu.0");
+	clk_register_clkdev(clk[vpu_gate], NULL, "83ff4000.vpu");
 	clk_register_clkdev(clk[fec_gate], NULL, "imx27-fec.0");
 	clk_register_clkdev(clk[ipu_gate], "bus", "imx51-ipu");
 	clk_register_clkdev(clk[ipu_di0_gate], "di0", "imx51-ipu");
@@ -432,7 +432,7 @@ int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 
 	mx5_clocks_common_init(rate_ckil, rate_osc, rate_ckih1, rate_ckih2);
 
-	clk_register_clkdev(clk[vpu_gate], NULL, "imx53-vpu.0");
+	clk_register_clkdev(clk[vpu_gate], NULL, "63ff4000.vpu");
 	clk_register_clkdev(clk[i2c3_gate], NULL, "imx-i2c.2");
 	clk_register_clkdev(clk[fec_gate], NULL, "imx25-fec.0");
 	clk_register_clkdev(clk[ipu_gate], "bus", "imx53-ipu");
-- 
1.7.10.4

