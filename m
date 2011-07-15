Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33597 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1GOSYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 14:24:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: [PATCH 1/3] OMAP3: ISP: Add regulator control for omap34xx
Date: Fri, 15 Jul 2011 20:24:08 +0200
Message-Id: <1310754250-28788-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>

The current omap3isp driver is missing regulator handling
for CSIb complex in omap34xx based devices. This patch
adds a mechanism for this to the omap3isp driver.

Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccp2.c |   27 +++++++++++++++++++++++++--
 drivers/media/video/omap3isp/ispccp2.h |    1 +
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/video/omap3isp/ispccp2.c
index 0e16cab..ec9e395f 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
+#include <linux/regulator/consumer.h>
 
 #include "isp.h"
 #include "ispreg.h"
@@ -163,6 +164,9 @@ static void ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
 	int i;
 
+	if (enable && ccp2->vdds_csib)
+		regulator_enable(ccp2->vdds_csib);
+
 	/* Enable/Disable all the LCx channels */
 	for (i = 0; i < CCP2_LCx_CHANS_NUM; i++)
 		isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCP2, ISPCCP2_LCx_CTRL(i),
@@ -186,6 +190,9 @@ static void ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
 				    ISPCCP2_LC01_IRQENABLE,
 				    ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ);
 	}
+
+	if (!enable && ccp2->vdds_csib)
+		regulator_disable(ccp2->vdds_csib);
 }
 
 /*
@@ -1137,6 +1144,9 @@ error:
  */
 void omap3isp_ccp2_cleanup(struct isp_device *isp)
 {
+	struct isp_ccp2_device *ccp2 = &isp->isp_ccp2;
+
+	regulator_put(ccp2->vdds_csib);
 }
 
 /*
@@ -1151,14 +1161,27 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 
 	init_waitqueue_head(&ccp2->wait);
 
-	/* On the OMAP36xx, the CCP2 uses the CSI PHY1 or PHY2, shared with
+	/*
+	 * On the OMAP34xx the CSI1 receiver is operated in the CSIb IO
+	 * complex, which is powered by vdds_csib power rail. Hence the
+	 * request for the regulator.
+	 *
+	 * On the OMAP36xx, the CCP2 uses the CSI PHY1 or PHY2, shared with
 	 * the CSI2c or CSI2a receivers. The PHY then needs to be explicitly
 	 * configured.
 	 *
 	 * TODO: Don't hardcode the usage of PHY1 (shared with CSI2c).
 	 */
-	if (isp->revision == ISP_REVISION_15_0)
+	if (isp->revision == ISP_REVISION_2_0) {
+		ccp2->vdds_csib = regulator_get(isp->dev, "vdds_csib");
+		if (IS_ERR(ccp2->vdds_csib)) {
+			dev_dbg(isp->dev,
+				"Could not get regulator vdds_csib\n");
+			ccp2->vdds_csib = NULL;
+		}
+	} else if (isp->revision == ISP_REVISION_15_0) {
 		ccp2->phy = &isp->isp_csiphy1;
+	}
 
 	ret = ccp2_init_entities(ccp2);
 	if (ret < 0)
diff --git a/drivers/media/video/omap3isp/ispccp2.h b/drivers/media/video/omap3isp/ispccp2.h
index 5505a86..6674e9d 100644
--- a/drivers/media/video/omap3isp/ispccp2.h
+++ b/drivers/media/video/omap3isp/ispccp2.h
@@ -81,6 +81,7 @@ struct isp_ccp2_device {
 	struct isp_interface_mem_config mem_cfg;
 	struct isp_video video_in;
 	struct isp_csiphy *phy;
+	struct regulator *vdds_csib;
 	unsigned int error;
 	enum isp_pipeline_stream_state state;
 	wait_queue_head_t wait;
-- 
1.7.3.4

