Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56387 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752491AbbCYW6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 18:58:38 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 04/15] omap3isp: DT support for clocks
Date: Thu, 26 Mar 2015 00:57:28 +0200
Message-Id: <1427324259-18438-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index f694615..82499cd 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -279,9 +279,21 @@ static const struct clk_init_data isp_xclk_init_data = {
 	.num_parents = 1,
 };
 
+static struct clk *isp_xclk_src_get(struct of_phandle_args *clkspec, void *data)
+{
+	unsigned int idx = clkspec->args[0];
+	struct isp_device *isp = data;
+
+	if (idx >= ARRAY_SIZE(isp->xclks))
+		return ERR_PTR(-ENOENT);
+
+	return isp->xclks[idx].clk;
+}
+
 static int isp_xclk_init(struct isp_device *isp)
 {
 	struct isp_platform_data *pdata = isp->pdata;
+	struct device_node *np = isp->dev->of_node;
 	struct clk_init_data init;
 	unsigned int i;
 
@@ -312,6 +324,12 @@ static int isp_xclk_init(struct isp_device *isp)
 		if (IS_ERR(xclk->clk))
 			return PTR_ERR(xclk->clk);
 
+		/* When instantiated from DT we don't need to register clock
+		 * aliases.
+		 */
+		if (np)
+			continue;
+
 		if (pdata->xclks[i].con_id == NULL &&
 		    pdata->xclks[i].dev_id == NULL)
 			continue;
@@ -327,13 +345,20 @@ static int isp_xclk_init(struct isp_device *isp)
 		clkdev_add(xclk->lookup);
 	}
 
+	if (np)
+		of_clk_add_provider(np, isp_xclk_src_get, isp);
+
 	return 0;
 }
 
 static void isp_xclk_cleanup(struct isp_device *isp)
 {
+	struct device_node *np = isp->dev->of_node;
 	unsigned int i;
 
+	if (np)
+		of_clk_del_provider(np);
+
 	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
 		struct isp_xclk *xclk = &isp->xclks[i];
 
-- 
1.7.10.4

