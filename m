Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49826 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaEZTuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:50:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 08/11] omap3isp: ccdc: Simplify the ccdc_isr_buffer() function
Date: Mon, 26 May 2014 21:50:09 +0200
Message-Id: <1401133812-8745-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using goto statements to a single line return, return the
correct value immediately.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 8fbba95..76d4fd7 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1480,7 +1480,6 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	struct isp_device *isp = to_isp_device(ccdc);
 	struct isp_buffer *buffer;
-	int restart = 0;
 
 	/* The CCDC generates VD0 interrupts even when disabled (the datasheet
 	 * doesn't explicitly state if that's supposed to happen or not, so it
@@ -1489,30 +1488,27 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 	 * would thus not be enough, we need to handle the situation explicitly.
 	 */
 	if (list_empty(&ccdc->video_out.dmaqueue))
-		goto done;
+		return 0;
 
 	/* We're in continuous mode, and memory writes were disabled due to a
 	 * buffer underrun. Reenable them now that we have a buffer. The buffer
 	 * address has been set in ccdc_video_queue.
 	 */
 	if (ccdc->state == ISP_PIPELINE_STREAM_CONTINUOUS && ccdc->underrun) {
-		restart = 1;
 		ccdc->underrun = 0;
-		goto done;
+		return 1;
 	}
 
 	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
 		dev_info(isp->dev, "CCDC won't become idle!\n");
 		isp->crashed |= 1U << ccdc->subdev.entity.id;
 		omap3isp_pipeline_cancel_stream(pipe);
-		goto done;
+		return 0;
 	}
 
 	buffer = omap3isp_video_buffer_next(&ccdc->video_out);
-	if (buffer != NULL) {
+	if (buffer != NULL)
 		ccdc_set_outaddr(ccdc, buffer->dma);
-		restart = 1;
-	}
 
 	pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
 
@@ -1521,8 +1517,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		omap3isp_pipeline_set_stream(pipe,
 					ISP_PIPELINE_STREAM_SINGLESHOT);
 
-done:
-	return restart;
+	return buffer != NULL;
 }
 
 /*
-- 
1.8.5.5

