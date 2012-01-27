Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:46122 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2A0JGB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 04:06:01 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, ohad@wizery.com
Subject: [PATCH 1/1] omap3isp: Prevent crash at module unload
Date: Fri, 27 Jan 2012 11:05:55 +0200
Message-Id: <1327655155-6038-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

iommu_domain_free() was called in isp_remove() before omap3isp_put().
omap3isp_put() must not save the context if the IOMMU no longer is there.
Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
The issue only seems to affect the staging/for_v3.4 branch in
media-tree.git.

 drivers/media/video/omap3isp/isp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 12d5f92..c3ff142 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -1112,7 +1112,8 @@ isp_restore_context(struct isp_device *isp, struct isp_reg *reg_list)
 static void isp_save_ctx(struct isp_device *isp)
 {
 	isp_save_context(isp, isp_reg_list);
-	omap_iommu_save_ctx(isp->dev);
+	if (isp->domain)
+		omap_iommu_save_ctx(isp->dev);
 }
 
 /*
@@ -1981,6 +1982,7 @@ static int isp_remove(struct platform_device *pdev)
 	omap3isp_get(isp);
 	iommu_detach_device(isp->domain, &pdev->dev);
 	iommu_domain_free(isp->domain);
+	isp->domain = NULL;
 	omap3isp_put(isp);
 
 	free_irq(isp->irq_num, isp);
-- 
1.7.2.5

