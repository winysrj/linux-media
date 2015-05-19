Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56300 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751427AbbESXJD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 19:09:03 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/1] omap3isp: Fix async notifier registration order
Date: Wed, 20 May 2015 02:08:05 +0300
Message-Id: <1432076885-5107-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The async notifier was registered before the v4l2_device was registered and
before the notifier callbacks were set. This could lead to missing the
bound() and complete() callbacks and to attempting to spin_lock() and
uninitialised spin lock.

Also fix unregistering the async notifier in the case of an error --- the
function may not fail anymore after the notifier is registered.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 18d0a87..0fa95cc 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2423,10 +2423,6 @@ static int isp_probe(struct platform_device *pdev)
 		ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
 		if (ret < 0)
 			return ret;
-		ret = v4l2_async_notifier_register(&isp->v4l2_dev,
-						   &isp->notifier);
-		if (ret)
-			return ret;
 	} else {
 		isp->pdata = pdev->dev.platform_data;
 		isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
@@ -2557,18 +2553,27 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_iommu;
 
-	isp->notifier.bound = isp_subdev_notifier_bound;
-	isp->notifier.complete = isp_subdev_notifier_complete;
-
 	ret = isp_register_entities(isp);
 	if (ret < 0)
 		goto error_modules;
 
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+		isp->notifier.bound = isp_subdev_notifier_bound;
+		isp->notifier.complete = isp_subdev_notifier_complete;
+
+		ret = v4l2_async_notifier_register(&isp->v4l2_dev,
+						   &isp->notifier);
+		if (ret)
+			goto error_register_entities;
+	}
+
 	isp_core_init(isp, 1);
 	omap3isp_put(isp);
 
 	return 0;
 
+error_register_entities:
+	isp_unregister_entities(isp);
 error_modules:
 	isp_cleanup_modules(isp);
 error_iommu:
-- 
1.7.10.4

