Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48329 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3KDAG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 10/18] v4l: omap4iss: Remove iss_video streaming field
Date: Mon,  4 Nov 2013 01:06:35 +0100
Message-Id: <1383523603-3907-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2 queue already keeps track of the streaming state, there's no
need to duplicate that in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 9 ---------
 drivers/staging/media/omap4iss/iss_video.h | 3 ---
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index bab62d7..1cdfc43 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -743,11 +743,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	mutex_lock(&video->stream_lock);
 
-	if (video->streaming) {
-		mutex_unlock(&video->stream_lock);
-		return -EBUSY;
-	}
-
 	/* Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
@@ -842,9 +837,6 @@ err_media_entity_pipeline_start:
 		video->queue = NULL;
 	}
 
-	if (!ret)
-		video->streaming = 1;
-
 	mutex_unlock(&video->stream_lock);
 	return ret;
 }
@@ -882,7 +874,6 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	omap4iss_pipeline_set_stream(pipe, ISS_PIPELINE_STREAM_STOPPED);
 	vb2_streamoff(&vfh->queue, type);
 	video->queue = NULL;
-	video->streaming = 0;
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, false);
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 8cf1b35..35f14d8 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -156,9 +156,6 @@ struct iss_video {
 	unsigned int bpl_value;		/* bytes per line value */
 	unsigned int bpl_padding;	/* padding at end of line */
 
-	/* Entity video node streaming */
-	unsigned int streaming:1;
-
 	/* Pipeline state */
 	struct iss_pipeline pipe;
 	struct mutex stream_lock;	/* pipeline and stream states */
-- 
1.8.1.5

