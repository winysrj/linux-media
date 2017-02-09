Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33997 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753892AbdBIQ6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 11:58:24 -0500
From: Avraham Shukron <avraham.shukron@gmail.com>
Subject: [PATCH v4 1/2] staging: omap4iss: fix multiline comment style
In-Reply-To: <20170209110621.GA11988@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Message-ID: <39b0f075-6b94-45bf-76cd-e3050b501da2@gmail.com>
Date: Thu, 9 Feb 2017 18:57:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed multi-line comments to their preferred style (First line empty)

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 38 ++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index bb0e3b4..e21811a 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -128,7 +128,8 @@ static unsigned int iss_video_mbus_to_pix(const struct iss_video *video,
 	pix->width = mbus->width;
 	pix->height = mbus->height;

-	/* Skip the last format in the loop so that it will be selected if no
+	/*
+	 * Skip the last format in the loop so that it will be selected if no
 	 * match is found.
 	 */
 	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
@@ -138,7 +139,8 @@ static unsigned int iss_video_mbus_to_pix(const struct iss_video *video,

 	min_bpl = pix->width * ALIGN(formats[i].bpp, 8) / 8;

-	/* Clamp the requested bytes per line value. If the maximum bytes per
+	/*
+	 * Clamp the requested bytes per line value. If the maximum bytes per
 	 * line value is zero, the module doesn't support user configurable line
 	 * sizes. Override the requested value with the minimum in that case.
 	 */
@@ -172,7 +174,8 @@ static void iss_video_pix_to_mbus(const struct v4l2_pix_format *pix,
 	mbus->width = pix->width;
 	mbus->height = pix->height;

-	/* Skip the last format in the loop so that it will be selected if no
+	/*
+	 * Skip the last format in the loop so that it will be selected if no
 	 * match is found.
 	 */
 	for (i = 0; i < ARRAY_SIZE(formats) - 1; ++i) {
@@ -360,7 +363,8 @@ static void iss_video_buf_queue(struct vb2_buffer *vb)

 	spin_lock_irqsave(&video->qlock, flags);

-	/* Mark the buffer is faulty and give it back to the queue immediately
+	/*
+	 * Mark the buffer is faulty and give it back to the queue immediately
 	 * if the video node has registered an error. vb2 will perform the same
 	 * check when preparing the buffer, but that is inherently racy, so we
 	 * need to handle the race condition with an authoritative check here.
@@ -443,7 +447,8 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)

 	buf->vb.vb2_buf.timestamp = ktime_get_ns();

-	/* Do frame number propagation only if this is the output video node.
+	/*
+	 * Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
 	 * incremented here if H3A is not active.
 	 * Note: There is no guarantee that the output buffer will finish
@@ -605,7 +610,8 @@ iss_video_set_format(struct file *file, void *fh, struct v4l2_format *format)

 	mutex_lock(&video->mutex);

-	/* Fill the bytesperline and sizeimage fields by converting to media bus
+	/*
+	 * Fill the bytesperline and sizeimage fields by converting to media bus
 	 * format and back to pixel format.
 	 */
 	iss_video_pix_to_mbus(&format->fmt.pix, &fmt);
@@ -678,8 +684,9 @@ iss_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 	if (subdev == NULL)
 		return -EINVAL;

-	/* Try the get selection operation first and fallback to get format if not
-	 * implemented.
+	/*
+	 * Try the get selection operation first and fallback to get format if
+	 * not implemented.
 	 */
 	sdsel.pad = pad;
 	ret = v4l2_subdev_call(subdev, pad, get_selection, NULL, &sdsel);
@@ -867,7 +874,8 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)

 	mutex_lock(&video->stream_lock);

-	/* Start streaming on the pipeline. No link touching an entity in the
+	/*
+	 * Start streaming on the pipeline. No link touching an entity in the
 	 * pipeline can be activated or deactivated once streaming is started.
 	 */
 	pipe = entity->pipe
@@ -895,7 +903,8 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	while ((entity = media_graph_walk_next(&graph)))
 		media_entity_enum_set(&pipe->ent_enum, entity);

-	/* Verify that the currently configured format matches the output of
+	/*
+	 * Verify that the currently configured format matches the output of
 	 * the connected subdev.
 	 */
 	ret = iss_video_check_format(video, vfh);
@@ -905,7 +914,8 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->bpl_padding = ret;
 	video->bpl_value = vfh->format.fmt.pix.bytesperline;

-	/* Find the ISS video node connected at the far end of the pipeline and
+	/*
+	 * Find the ISS video node connected at the far end of the pipeline and
 	 * update the pipeline.
 	 */
 	far_end = iss_video_far_end(video);
@@ -930,7 +940,8 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe->state |= state;
 	spin_unlock_irqrestore(&pipe->lock, flags);

-	/* Set the maximum time per frame as the value requested by userspace.
+	/*
+	 * Set the maximum time per frame as the value requested by userspace.
 	 * This is a soft limit that can be overridden if the hardware doesn't
 	 * support the request limit.
 	 */
@@ -946,7 +957,8 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto err_iss_video_check_format;

-	/* In sensor-to-memory mode, the stream can be started synchronously
+	/*
+	 * In sensor-to-memory mode, the stream can be started synchronously
 	 * to the stream on command. In memory-to-memory mode, it will be
 	 * started when buffers are queued on both the input and output.
 	 */
-- 
2.7.4
