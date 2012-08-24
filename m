Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49346 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759811Ab2HXQSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 12:18:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 11/12] ARM i.MX5: Fix CODA7 clock lookup for device tree on i.MX51 and i.MX53
Date: Fri, 24 Aug 2012 18:17:57 +0200
Message-Id: <1345825078-3688-12-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/mach-imx/clk-imx51-imx53.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
index a2200c7..887ede9 100644
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -334,7 +334,7 @@ int __init mx51_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 
 	clk_register_clkdev(clk[hsi2c_gate], NULL, "imx-i2c.2");
 	clk_register_clkdev(clk[mx51_mipi], "mipi_hsp", NULL);
-	clk_register_clkdev(clk[vpu_gate], NULL, "imx51-vpu.0");
+	clk_register_clkdev(clk[vpu_gate], NULL, "83ff4000.vpu");
 	clk_register_clkdev(clk[fec_gate], NULL, "imx27-fec.0");
 	clk_register_clkdev(clk[gpc_dvfs], "gpc_dvfs", NULL);
 	clk_register_clkdev(clk[ipu_gate], "bus", "imx51-ipu");
@@ -422,7 +422,7 @@ int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 
 	mx5_clocks_common_init(rate_ckil, rate_osc, rate_ckih1, rate_ckih2);
 
-	clk_register_clkdev(clk[vpu_gate], NULL, "imx53-vpu.0");
+	clk_register_clkdev(clk[vpu_gate], NULL, "63ff4000.vpu");
 	clk_register_clkdev(clk[i2c3_gate], NULL, "imx-i2c.2");
 	clk_register_clkdev(clk[fec_gate], NULL, "imx25-fec.0");
 	clk_register_clkdev(clk[ipu_gate], "bus", "imx53-ipu");
-- 
1.7.10.4

