Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36001 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1HMQVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 12:21:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/2] omap3isp: video: Avoid crashes when pipeline set stream operation fails
Date: Sat, 13 Aug 2011 18:21:46 +0200
Message-Id: <1313252506-32376-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1313252506-32376-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1313252506-32376-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If streaming can't be enabled on the pipeline, the DMA buffers queue is
not emptied. If the buffers then get freed the queue will end up
referencing free memory. This is usually not an issue, as the DMA queue
will be reinitialized the next time streaming is enabled, before
enabling the hardware.

However, if the sensor connected at the pipeline input is free-running,
the CCDC will start generating interrupts as soon as it gets powered up,
before the streaming gets enabled on the hardware. This will make the
CCDC interrupt handler access freed memory, causing a crash.

Reinitialize the DMA buffers queue in isp_video_streamon() if the error
path to make sure this situation won't happen.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispvideo.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index fd94cdf..ba86f11 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -1056,6 +1056,14 @@ error:
 		if (video->isp->pdata->set_constraints)
 			video->isp->pdata->set_constraints(video->isp, false);
 		media_entity_pipeline_stop(&video->video.entity);
+		/* The DMA queue must be emptied here, otherwise CCDC interrupts
+		 * that will get triggered the next time the CCDC is powered up
+		 * will try to access buffers that might have been freed but
+		 * still present in the DMA queue. This can easily get triggered
+		 * if the above omap3isp_pipeline_set_stream() call fails on a
+		 * system with a free-running sensor.
+		 */
+		INIT_LIST_HEAD(&video->dmaqueue);
 		video->queue = NULL;
 	}
 
-- 
1.7.3.4

