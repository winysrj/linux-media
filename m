Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:37172 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab3LDRNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 12:13:09 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, jiada_wang@mentor.com,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v7 1/5] omap3isp: Modify clocks registration to avoid
 circular references
Date: Wed, 04 Dec 2013 18:12:03 +0100
Message-id: <1386177127-2894-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
References: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock core code is going to be modified so clk_get() takes
reference on the clock provider module. Until the potential circular
reference issue is properly addressed, we pass NULL as the first
argument to clk_register(), in order to disallow sub-devices taking
a reference on the ISP module back trough clk_get(). This should
prevent locking the modules in memory.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c |   22 ++++++++++++++++------
 drivers/media/platform/omap3isp/isp.h |    1 +
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1c36080..5910662 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -290,9 +290,11 @@ static int isp_xclk_init(struct isp_device *isp)
 	struct clk_init_data init;
 	unsigned int i;
 
+	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)
+		isp->xclks[i].clk = ERR_PTR(-EINVAL);
+
 	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
 		struct isp_xclk *xclk = &isp->xclks[i];
-		struct clk *clk;
 
 		xclk->isp = isp;
 		xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
@@ -305,10 +307,15 @@ static int isp_xclk_init(struct isp_device *isp)
 		init.num_parents = 1;
 
 		xclk->hw.init = &init;
-
-		clk = devm_clk_register(isp->dev, &xclk->hw);
-		if (IS_ERR(clk))
-			return PTR_ERR(clk);
+		/*
+		 * The first argument is NULL in order to avoid circular
+		 * reference, as this driver takes reference on the
+		 * sensor subdevice modules and the sensors would take
+		 * reference on this module through clk_get().
+		 */
+		xclk->clk = clk_register(NULL, &xclk->hw);
+		if (IS_ERR(xclk->clk))
+			return PTR_ERR(xclk->clk);
 
 		if (pdata->xclks[i].con_id == NULL &&
 		    pdata->xclks[i].dev_id == NULL)
@@ -320,7 +327,7 @@ static int isp_xclk_init(struct isp_device *isp)
 
 		xclk->lookup->con_id = pdata->xclks[i].con_id;
 		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
-		xclk->lookup->clk = clk;
+		xclk->lookup->clk = xclk->clk;
 
 		clkdev_add(xclk->lookup);
 	}
@@ -335,6 +342,9 @@ static void isp_xclk_cleanup(struct isp_device *isp)
 	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
 		struct isp_xclk *xclk = &isp->xclks[i];
 
+		if (!IS_ERR(xclk->clk))
+			clk_unregister(xclk->clk);
+
 		if (xclk->lookup)
 			clkdev_drop(xclk->lookup);
 	}
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index ce65d3a..d1e857e 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -135,6 +135,7 @@ struct isp_xclk {
 	struct isp_device *isp;
 	struct clk_hw hw;
 	struct clk_lookup *lookup;
+	struct clk *clk;
 	enum isp_xclk_id id;
 
 	spinlock_t lock;	/* Protects enabled and divider */
-- 
1.7.9.5

