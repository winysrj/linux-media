Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:37408 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373Ab1LOJuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:50:39 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC 4/4] omap3isp: Use pixel clock from sensor media bus frameformat
Date: Thu, 15 Dec 2011 11:50:35 +0200
Message-Id: <1323942635-13058-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111215095015.GC3677@valkosipuli.localdomain>
References: <20111215095015.GC3677@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Configure the ISP based on the pixel clock in media bus frame format.
Previously the same was configured from the board code.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/isp.c      |    3 +--
 drivers/media/video/omap3isp/isp.h      |    3 ++-
 drivers/media/video/omap3isp/ispvideo.c |    3 +++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index b818cac..c9bed37 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -344,7 +344,7 @@ void omap3isp_configure_bridge(struct isp_device *isp,
  * Set the average pixel clock required by the sensor. The ISP will use the
  * lowest possible memory bandwidth settings compatible with the clock.
  **/
-static void isp_set_pixel_clock(struct isp_device *isp, unsigned int pixelclk)
+void omap3isp_set_pixel_clock(struct isp_device *isp, unsigned int pixelclk)
 {
 	isp->isp_ccdc.vpcfg.pixelclk = pixelclk;
 }
@@ -2072,7 +2072,6 @@ static int isp_probe(struct platform_device *pdev)
 
 	isp->autoidle = autoidle;
 	isp->platform_cb.set_xclk = isp_set_xclk;
-	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
 
 	mutex_init(&isp->isp_mutex);
 	spin_lock_init(&isp->stat_lock);
diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
index c5935ae..dd7b303 100644
--- a/drivers/media/video/omap3isp/isp.h
+++ b/drivers/media/video/omap3isp/isp.h
@@ -126,7 +126,6 @@ struct isp_reg {
 
 struct isp_platform_callback {
 	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
-	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
 };
 
 /*
@@ -219,6 +218,8 @@ struct isp_device {
 #define v4l2_dev_to_isp_device(dev) \
 	container_of(dev, struct isp_device, v4l2_dev)
 
+void omap3isp_set_pixel_clock(struct isp_device *isp, unsigned int pixelclk);
+
 void omap3isp_hist_dma_done(struct isp_device *isp);
 
 void omap3isp_flush(struct isp_device *isp);
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index cdcf1d0..64f29ac 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -372,6 +372,9 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 				if (IS_ERR_VALUE(ret))
 					return -EPIPE;
 			}
+			omap3isp_set_pixel_clock(isp,
+						 fmt_source.format.pixel_clock
+						 * 1000);
 		}
 
 		if (subdev->host_priv) {
-- 
1.7.2.5

