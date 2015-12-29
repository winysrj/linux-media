Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59408 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbbL2OLy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 09:11:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] v4l: omap3isp: Fix data lane shift configuration
Date: Tue, 29 Dec 2015 16:11:51 +0200
Message-Id: <1451398311-3964-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The data-shift DT property speficies the number of bits to be shifted,
but the driver still interprets the value as a multiple of two bits as
used by now removed platform data support. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c      | 2 +-
 drivers/media/platform/omap3isp/ispccdc.c  | 2 +-
 drivers/media/platform/omap3isp/omap3isp.h | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 6952d3604e52..1af6a4359706 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -449,7 +449,7 @@ void omap3isp_configure_bridge(struct isp_device *isp,
 	case CCDC_INPUT_PARALLEL:
 		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
 		ispctrl_val |= parcfg->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
-		shift += parcfg->data_lane_shift * 2;
+		shift += parcfg->data_lane_shift;
 		break;
 
 	case CCDC_INPUT_CSI2A:
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 203323ce7dd4..5cf410949dbc 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2453,7 +2453,7 @@ static int ccdc_link_validate(struct v4l2_subdev *sd,
 			&((struct isp_bus_cfg *)
 			  media_entity_to_v4l2_subdev(link->source->entity)
 			  ->host_priv)->bus.parallel;
-		parallel_shift = parcfg->data_lane_shift * 2;
+		parallel_shift = parcfg->data_lane_shift;
 	} else {
 		parallel_shift = 0;
 	}
diff --git a/drivers/media/platform/omap3isp/omap3isp.h b/drivers/media/platform/omap3isp/omap3isp.h
index 190e259a6a2d..443e8f7673e2 100644
--- a/drivers/media/platform/omap3isp/omap3isp.h
+++ b/drivers/media/platform/omap3isp/omap3isp.h
@@ -33,9 +33,9 @@ enum isp_interface_type {
  * struct isp_parallel_cfg - Parallel interface configuration
  * @data_lane_shift: Data lane shifter
  *		0 - CAMEXT[13:0] -> CAM[13:0]
- *		1 - CAMEXT[13:2] -> CAM[11:0]
- *		2 - CAMEXT[13:4] -> CAM[9:0]
- *		3 - CAMEXT[13:6] -> CAM[7:0]
+ *		2 - CAMEXT[13:2] -> CAM[11:0]
+ *		4 - CAMEXT[13:4] -> CAM[9:0]
+ *		6 - CAMEXT[13:6] -> CAM[7:0]
  * @clk_pol: Pixel clock polarity
  *		0 - Sample on rising edge, 1 - Sample on falling edge
  * @hs_pol: Horizontal synchronization polarity
@@ -48,7 +48,7 @@ enum isp_interface_type {
  *		0 - Normal, 1 - One's complement
  */
 struct isp_parallel_cfg {
-	unsigned int data_lane_shift:2;
+	unsigned int data_lane_shift:3;
 	unsigned int clk_pol:1;
 	unsigned int hs_pol:1;
 	unsigned int vs_pol:1;
-- 
Regards,

Laurent Pinchart

