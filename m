Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36113 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbbDCVop (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 17:44:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v1.1 07/14] media: omap3isp: remove unused clkdev
Date: Sat,  4 Apr 2015 00:45:02 +0300
Message-Id: <1428097502-19593-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@arm.linux.org.uk>

No merged platform supplies xclks via platform data.  As we want to
slightly change the clkdev interface, rather than fixing this unused
code, remove it instead.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c | 24 ------------------------
 drivers/media/platform/omap3isp/isp.h |  1 -
 include/media/omap3isp.h              |  6 ------
 3 files changed, 31 deletions(-)

In case this would be helpful, I've rebased the original patch on top of the
linuxtv master branch scheduled for merge in v4.1.

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index ff51c4f..18d0a87 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -304,7 +304,6 @@ static struct clk *isp_xclk_src_get(struct of_phandle_args *clkspec, void *data)
 
 static int isp_xclk_init(struct isp_device *isp)
 {
-	struct isp_platform_data *pdata = isp->pdata;
 	struct device_node *np = isp->dev->of_node;
 	struct clk_init_data init;
 	unsigned int i;
@@ -335,26 +334,6 @@ static int isp_xclk_init(struct isp_device *isp)
 		xclk->clk = clk_register(NULL, &xclk->hw);
 		if (IS_ERR(xclk->clk))
 			return PTR_ERR(xclk->clk);
-
-		/* When instantiated from DT we don't need to register clock
-		 * aliases.
-		 */
-		if (np)
-			continue;
-
-		if (!pdata || (pdata->xclks[i].con_id == NULL &&
-			       pdata->xclks[i].dev_id == NULL))
-			continue;
-
-		xclk->lookup = kzalloc(sizeof(*xclk->lookup), GFP_KERNEL);
-		if (xclk->lookup == NULL)
-			return -ENOMEM;
-
-		xclk->lookup->con_id = pdata->xclks[i].con_id;
-		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
-		xclk->lookup->clk = xclk->clk;
-
-		clkdev_add(xclk->lookup);
 	}
 
 	if (np)
@@ -376,9 +355,6 @@ static void isp_xclk_cleanup(struct isp_device *isp)
 
 		if (!IS_ERR(xclk->clk))
 			clk_unregister(xclk->clk);
-
-		if (xclk->lookup)
-			clkdev_drop(xclk->lookup);
 	}
 }
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 431224e..e579943 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -132,7 +132,6 @@ enum isp_xclk_id {
 struct isp_xclk {
 	struct isp_device *isp;
 	struct clk_hw hw;
-	struct clk_lookup *lookup;
 	struct clk *clk;
 	enum isp_xclk_id id;
 
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 0f0c08b..048f8f9 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -150,13 +150,7 @@ struct isp_platform_subdev {
 	struct isp_bus_cfg *bus;
 };
 
-struct isp_platform_xclk {
-	const char *dev_id;
-	const char *con_id;
-};
-
 struct isp_platform_data {
-	struct isp_platform_xclk xclks[2];
 	struct isp_platform_subdev *subdevs;
 	void (*set_constraints)(struct isp_device *isp, bool enable);
 };
-- 
Regards,

Laurent Pinchart

