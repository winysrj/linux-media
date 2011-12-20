Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:53514 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1LTU2S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 15:28:18 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com
Subject: [RFC 14/17] omap3isp: Use pixelrate from sensor media bus frameformat
Date: Tue, 20 Dec 2011 22:28:06 +0200
Message-Id: <1324412889-17961-14-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4EF0EFC9.6080501@maxwell.research.nokia.com>
References: <4EF0EFC9.6080501@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Configure the ISP based on the pixelrate in media bus frame format.
Previously the same was configured from the board code.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.c |   24 +++++++++++++++++++++---
 drivers/media/video/omap3isp/isp.h |    1 -
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 6020fd7..92f9716 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -749,10 +749,14 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 
 	entity = &pipe->output->video.entity;
 	while (1) {
-		pad = &entity->pads[0];
-		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+		/*
+		 * Is this an external subdev connected to us? If so,
+		 * we're done.
+		 */
+		if (subdev && subdev->host_priv)
 			break;
 
+		pad = &entity->pads[0];
 		pad = media_entity_remote_source(pad);
 		if (pad == NULL ||
 		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
@@ -762,6 +766,21 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 		prev_subdev = subdev;
 		subdev = media_entity_to_v4l2_subdev(entity);
 
+		/* Configure CCDC pixel clock */
+		if (subdev->host_priv) {
+			struct v4l2_subdev_format fmt;
+
+			fmt.pad = pad->index;
+			fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+			ret = v4l2_subdev_call(subdev, pad, get_fmt,
+					       NULL, &fmt);
+			if (ret < 0)
+				return -EINVAL;
+
+			isp_set_pixel_clock(isp,
+					    fmt.format.pixelrate * 1000);
+		}
+
 		/* Configure CSI-2 receiver based on sensor format. */
 		if (prev_subdev == &isp->isp_csi2a.subdev
 		    || prev_subdev == &isp->isp_csi2c.subdev) {
@@ -2102,7 +2121,6 @@ static int isp_probe(struct platform_device *pdev)
 
 	isp->autoidle = autoidle;
 	isp->platform_cb.set_xclk = isp_set_xclk;
-	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
 
 	mutex_init(&isp->isp_mutex);
 	spin_lock_init(&isp->stat_lock);
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index c5935ae..7d73a39 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -126,7 +126,6 @@ struct isp_reg {
 
 struct isp_platform_callback {
 	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
-	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
 };
 
 /*
-- 
1.7.2.5

