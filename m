Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44172 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751318AbdGQWBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:01:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: pavel@ucw.cz, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 5/7] omap3isp: Always initialise isp and mutex for csiphy1
Date: Tue, 18 Jul 2017 01:01:14 +0300
Message-Id: <20170717220116.17886-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PHY is still relevant for CCP2.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/ispcsiphy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index addc6efbb033..2028bb519108 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -345,13 +345,14 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 	phy2->phy_regs = OMAP3_ISP_IOMEM_CSIPHY2;
 	mutex_init(&phy2->mutex);
 
+	phy1->isp = isp;
+	mutex_init(&phy1->mutex);
+
 	if (isp->revision == ISP_REVISION_15_0) {
-		phy1->isp = isp;
 		phy1->csi2 = &isp->isp_csi2c;
 		phy1->num_data_lanes = ISP_CSIPHY1_NUM_DATA_LANES;
 		phy1->cfg_regs = OMAP3_ISP_IOMEM_CSI2C_REGS1;
 		phy1->phy_regs = OMAP3_ISP_IOMEM_CSIPHY1;
-		mutex_init(&phy1->mutex);
 	}
 
 	return 0;
-- 
2.11.0
