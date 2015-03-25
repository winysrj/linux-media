Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56404 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752508AbbCYW6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 18:58:39 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 08/15] omap3isp: Calculate vpclk_div for CSI-2
Date: Thu, 26 Mar 2015 00:57:32 +0200
Message-Id: <1427324259-18438-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video port clock is l3_ick divided by vpclk_div. This clock must be high
enough for the external pixel rate. The video port requires two clock cycles
to process a pixel.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispcsi2.c |    8 +++++++-
 include/media/omap3isp.h                  |    2 --
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 14d279d..97cdfeb 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -548,6 +548,7 @@ int omap3isp_csi2_reset(struct isp_csi2_device *csi2)
 
 static int csi2_configure(struct isp_csi2_device *csi2)
 {
+	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
 	const struct isp_bus_cfg *buscfg;
 	struct isp_device *isp = csi2->isp;
 	struct isp_csi2_timing_cfg *timing = &csi2->timing[0];
@@ -570,7 +571,12 @@ static int csi2_configure(struct isp_csi2_device *csi2)
 	csi2->frame_skip = 0;
 	v4l2_subdev_call(sensor, sensor, g_skip_frames, &csi2->frame_skip);
 
-	csi2->ctrl.vp_out_ctrl = buscfg->bus.csi2.vpclk_div;
+	csi2->ctrl.vp_out_ctrl =
+		clamp_t(unsigned int, pipe->l3_ick / pipe->external_rate - 1,
+			1, 3);
+	dev_dbg(isp->dev, "%s: l3_ick %lu, external_rate %u, vp_out_ctrl %u\n",
+		__func__, pipe->l3_ick,  pipe->external_rate,
+		csi2->ctrl.vp_out_ctrl);
 	csi2->ctrl.frame_mode = ISP_CSI2_FRAME_IMMEDIATE;
 	csi2->ctrl.ecc_enable = buscfg->bus.csi2.crc;
 
diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 39e0748..0f0c08b 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -129,11 +129,9 @@ struct isp_ccp2_cfg {
 /**
  * struct isp_csi2_cfg - CSI2 interface configuration
  * @crc: Enable the cyclic redundancy check
- * @vpclk_div: Video port output clock control
  */
 struct isp_csi2_cfg {
 	unsigned crc:1;
-	unsigned vpclk_div:2;
 	struct isp_csiphy_lanes_cfg lanecfg;
 };
 
-- 
1.7.10.4

