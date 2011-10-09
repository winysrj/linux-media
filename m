Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50774 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1JIChy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 22:37:54 -0400
Received: by wwf22 with SMTP id 22so7606530wwf.1
        for <linux-media@vger.kernel.org>; Sat, 08 Oct 2011 19:37:53 -0700 (PDT)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 1/2] omap3isp: video: Decouple buffer obtaining and set ISP entities format
Date: Sun,  9 Oct 2011 04:37:32 +0200
Message-Id: <1318127853-1879-2-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
References: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISP driver release the last buffer (waking up the pending process)
before returning the next buffer to the caller. This is done on the VD0
interrupt handler. But, by the time the CCDC is executing the VD0 interrupt
handler some ISP registers like CCDC_SDR_ADDR are shadowed which means that
the values written to it will not take effect until the next frame starts.

We have to configure the CCDC during the processing of the current frame in
the VD1 interrupt handler. This means the next buffer obtaining and the
last buffer releasing occur at different moments. So we have to decouple
these two actions.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/media/video/omap3isp/ispvideo.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index cc73375..c2d4cd9 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -635,10 +635,6 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video,
 	else
 		buf->vbuf.sequence = atomic_read(&pipe->frame_number);
 
-	buf->state = error ? ISP_BUF_STATE_ERROR : ISP_BUF_STATE_DONE;
-
-	wake_up(&buf->wait);
-
 	if (list_empty(&video->dmaqueue)) {
 		if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			state = ISP_PIPELINE_QUEUE_OUTPUT
-- 
1.7.4.1

