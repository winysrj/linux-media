Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59958 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaHANzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:55:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: [PATCH 8/8] omap3isp: ccdc: Restart the CCDC immediately after an underrun in BT.656
Date: Fri,  1 Aug 2014 15:46:34 +0200
Message-Id: <1406900794-9871-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the CCDC doesn't generate interrupts when stopped in BT.656 mode,
restart it immediately when the next buffer after an underrun is queued
instead of relying on the interrupt handler to restart the CCDC.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index ec0a0e8..cabf46b 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1789,6 +1789,8 @@ int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
 static int ccdc_video_queue(struct isp_video *video, struct isp_buffer *buffer)
 {
 	struct isp_ccdc_device *ccdc = &video->isp->isp_ccdc;
+	unsigned long flags;
+	bool restart = false;
 
 	if (!(ccdc->output & CCDC_OUTPUT_MEMORY))
 		return -ENODEV;
@@ -1797,9 +1799,20 @@ static int ccdc_video_queue(struct isp_video *video, struct isp_buffer *buffer)
 
 	/* We now have a buffer queued on the output, restart the pipeline
 	 * on the next CCDC interrupt if running in continuous mode (or when
-	 * starting the stream).
+	 * starting the stream) in external sync mode, or immediately in BT.656
+	 * sync mode as no CCDC interrupt is generated when the CCDC is stopped
+	 * in that case.
 	 */
-	ccdc->underrun = 1;
+	spin_lock_irqsave(&ccdc->lock, flags);
+	if (ccdc->state == ISP_PIPELINE_STREAM_CONTINUOUS && !ccdc->running &&
+	    ccdc->bt656)
+		restart = 1;
+	else
+		ccdc->underrun = 1;
+	spin_unlock_irqrestore(&ccdc->lock, flags);
+
+	if (restart)
+		ccdc_enable(ccdc);
 
 	return 0;
 }
-- 
1.8.5.5

