Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40000 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3FHHLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jun 2013 03:11:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2] omap3isp: ccp2: Don't ignore the regulator_enable() return value
Date: Sat,  8 Jun 2013 09:11:42 +0200
Message-Id: <1370675502-3136-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check the return value and catch errors correctly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccp2.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

Changes since v1:

- Call omap3isp_csiphy_release() only when ccp2->phy is not NULL

diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index c5d84c9..9ec9387 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -158,13 +158,17 @@ static void ccp2_pwr_cfg(struct isp_ccp2_device *ccp2)
  * @ccp2: pointer to ISP CCP2 device
  * @enable: enable/disable flag
  */
-static void ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
+static int ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
 {
 	struct isp_device *isp = to_isp_device(ccp2);
+	int ret;
 	int i;
 
-	if (enable && ccp2->vdds_csib)
-		regulator_enable(ccp2->vdds_csib);
+	if (enable && ccp2->vdds_csib) {
+		ret = regulator_enable(ccp2->vdds_csib);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Enable/Disable all the LCx channels */
 	for (i = 0; i < CCP2_LCx_CHANS_NUM; i++)
@@ -179,6 +183,8 @@ static void ccp2_if_enable(struct isp_ccp2_device *ccp2, u8 enable)
 
 	if (!enable && ccp2->vdds_csib)
 		regulator_disable(ccp2->vdds_csib);
+
+	return 0;
 }
 
 /*
@@ -851,7 +857,12 @@ static int ccp2_s_stream(struct v4l2_subdev *sd, int enable)
 		ccp2_print_status(ccp2);
 
 		/* Enable CSI1/CCP2 interface */
-		ccp2_if_enable(ccp2, 1);
+		ret = ccp2_if_enable(ccp2, 1);
+		if (ret < 0) {
+			if (ccp2->phy)
+				omap3isp_csiphy_release(ccp2->phy);
+			return ret;
+		}
 		break;
 
 	case ISP_PIPELINE_STREAM_SINGLESHOT:
-- 
Regards,

Laurent Pinchart

