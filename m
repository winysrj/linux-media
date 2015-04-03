Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33778 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbbDCRNE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:13:04 -0400
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 07/14] media: omap3isp: remove unused clkdev
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Ye59O-0001BJ-Gq@rmk-PC.arm.linux.org.uk>
Date: Fri, 03 Apr 2015 18:12:58 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No merged platform supplies xclks via platform data.  As we want to
slightly change the clkdev interface, rather than fixing this unused
code, remove it instead.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/platform/omap3isp/isp.c | 18 ------------------
 drivers/media/platform/omap3isp/isp.h |  1 -
 include/media/omap3isp.h              |  6 ------
 3 files changed, 25 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index deca80903c3a..4d8078b9d010 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -281,7 +281,6 @@ static const struct clk_init_data isp_xclk_init_data = {
 
 static int isp_xclk_init(struct isp_device *isp)
 {
-	struct isp_platform_data *pdata = isp->pdata;
 	struct clk_init_data init;
 	unsigned int i;
 
@@ -311,20 +310,6 @@ static int isp_xclk_init(struct isp_device *isp)
 		xclk->clk = clk_register(NULL, &xclk->hw);
 		if (IS_ERR(xclk->clk))
 			return PTR_ERR(xclk->clk);
-
-		if (pdata->xclks[i].con_id == NULL &&
-		    pdata->xclks[i].dev_id == NULL)
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
 
 	return 0;
@@ -339,9 +324,6 @@ static void isp_xclk_cleanup(struct isp_device *isp)
 
 		if (!IS_ERR(xclk->clk))
 			clk_unregister(xclk->clk);
-
-		if (xclk->lookup)
-			clkdev_drop(xclk->lookup);
 	}
 }
 
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index cfdfc8714b6b..d41c98bbdfe7 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -122,7 +122,6 @@ enum isp_xclk_id {
 struct isp_xclk {
 	struct isp_device *isp;
 	struct clk_hw hw;
-	struct clk_lookup *lookup;
 	struct clk *clk;
 	enum isp_xclk_id id;
 
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 398279dd1922..a9798525d01e 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -152,13 +152,7 @@ struct isp_v4l2_subdevs_group {
 	} bus; /* gcc < 4.6.0 chokes on anonymous union initializers */
 };
 
-struct isp_platform_xclk {
-	const char *dev_id;
-	const char *con_id;
-};
-
 struct isp_platform_data {
-	struct isp_platform_xclk xclks[2];
 	struct isp_v4l2_subdevs_group *subdevs;
 	void (*set_constraints)(struct isp_device *isp, bool enable);
 };
-- 
1.8.3.1

