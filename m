Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44168 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751414AbdGQWBT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:01:19 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: pavel@ucw.cz, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 4/7] omap3isp: Return -EPROBE_DEFER if the required regulators can't be obtained
Date: Tue, 18 Jul 2017 01:01:13 +0300
Message-Id: <20170717220116.17886-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pavel Machek <pavel@ucw.cz>

If regulator returns -EPROBE_DEFER, we need to return it too, so that
omap3isp will be re-probed when regulator is ready.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c     | 3 ++-
 drivers/media/platform/omap3isp/ispccp2.c | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 80ed5a5f862a..4e6ba7f90e35 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1880,7 +1880,8 @@ static int isp_initialize_modules(struct isp_device *isp)
 
 	ret = omap3isp_ccp2_init(isp);
 	if (ret < 0) {
-		dev_err(isp->dev, "CCP2 initialization failed\n");
+		if (ret != -EPROBE_DEFER)
+			dev_err(isp->dev, "CCP2 initialization failed\n");
 		goto error_ccp2;
 	}
 
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 4f8fd0c00748..47210b102bcb 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1140,6 +1140,11 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 	if (isp->revision == ISP_REVISION_2_0) {
 		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
 		if (IS_ERR(ccp2->vdds_csib)) {
+			if (PTR_ERR(ccp2->vdds_csib) == -EPROBE_DEFER) {
+				dev_dbg(isp->dev,
+					"Can't get regulator vdds_csib, deferring probing\n");
+				return -EPROBE_DEFER;
+			}
 			dev_dbg(isp->dev,
 				"Could not get regulator vdds_csib\n");
 			ccp2->vdds_csib = NULL;
-- 
2.11.0
