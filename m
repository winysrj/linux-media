Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56638 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033131AbeEXUg7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 16:36:59 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 06/20] omap4iss: Add vb2_queue lock
Date: Thu, 24 May 2018 17:35:06 -0300
Message-Id: <20180524203520.1598-7-ezequiel@collabora.com>
In-Reply-To: <20180524203520.1598-1-ezequiel@collabora.com>
References: <20180524203520.1598-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_queue lock is now mandatory. Add it, remove driver ad-hoc
locks, and implement wait_{prepare, finish}.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index a3a83424a926..d919bae83828 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -873,8 +873,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (type != video->type)
 		return -EINVAL;
 
-	mutex_lock(&video->stream_lock);
-
 	/*
 	 * Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
@@ -978,8 +976,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	media_graph_walk_cleanup(&graph);
 
-	mutex_unlock(&video->stream_lock);
-
 	return 0;
 
 err_omap4iss_set_stream:
@@ -996,8 +992,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 err_graph_walk_init:
 	media_entity_enum_cleanup(&pipe->ent_enum);
 
-	mutex_unlock(&video->stream_lock);
-
 	return ret;
 }
 
@@ -1013,10 +1007,8 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (type != video->type)
 		return -EINVAL;
 
-	mutex_lock(&video->stream_lock);
-
 	if (!vb2_is_streaming(&vfh->queue))
-		goto done;
+		return 0;
 
 	/* Update the pipeline state. */
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -1041,8 +1033,6 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 		video->iss->pdata->set_constraints(video->iss, false);
 	media_pipeline_stop(&video->video.entity);
 
-done:
-	mutex_unlock(&video->stream_lock);
 	return 0;
 }
 
@@ -1137,6 +1127,7 @@ static int iss_video_open(struct file *file)
 	q->buf_struct_size = sizeof(struct iss_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->dev = video->iss->dev;
+	q->lock = &video->stream_lock;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
-- 
2.16.3
