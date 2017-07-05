Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42002 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752307AbdGEXAZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 8/8] omap3isp: Destroy CSI-2 phy mutexes in error and module removal
Date: Thu,  6 Jul 2017 02:00:19 +0300
Message-Id: <20170705230019.5461-9-sakari.ailus@linux.intel.com>
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI-2 phy driver did initialise mutexes in its init function but there
was no corresponding cleanup function destroying them. Fix that. Also
clean up ISP module initialisation a little.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c       | 6 ++++--
 drivers/media/platform/omap3isp/ispcsiphy.c | 6 ++++++
 drivers/media/platform/omap3isp/ispcsiphy.h | 1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 0676be725d7c..7028bbe13b69 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1859,6 +1859,7 @@ static void isp_cleanup_modules(struct isp_device *isp)
 	omap3isp_ccdc_cleanup(isp);
 	omap3isp_ccp2_cleanup(isp);
 	omap3isp_csi2_cleanup(isp);
+	omap3isp_csiphy_cleanup(isp);
 }
 
 static int isp_initialize_modules(struct isp_device *isp)
@@ -1868,7 +1869,7 @@ static int isp_initialize_modules(struct isp_device *isp)
 	ret = omap3isp_csiphy_init(isp);
 	if (ret < 0) {
 		dev_err(isp->dev, "CSI PHY initialization failed\n");
-		goto error_csiphy;
+		return ret;
 	}
 
 	ret = omap3isp_csi2_init(isp);
@@ -1937,7 +1938,8 @@ static int isp_initialize_modules(struct isp_device *isp)
 error_ccp2:
 	omap3isp_csi2_cleanup(isp);
 error_csi2:
-error_csiphy:
+	omap3isp_csiphy_cleanup(isp);
+
 	return ret;
 }
 
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index 871d4fe09c7f..83940e9d8291 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -345,3 +345,9 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 
 	return 0;
 }
+
+void omap3isp_csiphy_cleanup(struct isp_device *isp)
+{
+	mutex_destroy(&isp->isp_csiphy1.mutex);
+	mutex_destroy(&isp->isp_csiphy2.mutex);
+}
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.h b/drivers/media/platform/omap3isp/ispcsiphy.h
index 28b63b28f9f7..978ca5c80a6c 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.h
+++ b/drivers/media/platform/omap3isp/ispcsiphy.h
@@ -39,5 +39,6 @@ struct isp_csiphy {
 int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
 void omap3isp_csiphy_release(struct isp_csiphy *phy);
 int omap3isp_csiphy_init(struct isp_device *isp);
+void omap3isp_csiphy_cleanup(struct isp_device *isp);
 
 #endif	/* OMAP3_ISP_CSI_PHY_H */
-- 
2.11.0
