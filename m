Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:48595 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbcDOL6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 07:58:17 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Thaissa Falbo <thaissa.falbo@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for 4.6] davinci_vpfe: Revert "staging: media: davinci_vpfe:
 remove,unnecessary ret variable"
Message-ID: <5710D752.4040208@xs4all.nl>
Date: Fri, 15 Apr 2016 13:58:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit afa5d19a2b5fbf0bbcce34f3613bce2bc9479bb7.

This patch is completely bogus and messed up the code big time.

I'm not sure what was intended, but this isn't it.

Cc: Thaissa Falbo <thaissa.falbo@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Greg, this patch was never seen by us. Can you redirect patches for staging/media
to the linux-media mailinglist? We'd like to stay on top of what is happening there.

Thanks!

	Hans

---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 54 ++++++++++++++++---------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index df4f298..ea3ddec 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -172,9 +172,11 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 static int vpfe_update_pipe_state(struct vpfe_video_device *video)
 {
 	struct vpfe_pipeline *pipe = &video->pipe;
+	int ret;

-	if (vpfe_prepare_pipeline(video))
-		return vpfe_prepare_pipeline(video);
+	ret = vpfe_prepare_pipeline(video);
+	if (ret)
+		return ret;

 	/*
 	 * Find out if there is any input video
@@ -182,9 +184,10 @@ static int vpfe_update_pipe_state(struct vpfe_video_device *video)
 	 */
 	if (pipe->input_num == 0) {
 		pipe->state = VPFE_PIPELINE_STREAM_CONTINUOUS;
-		if (vpfe_update_current_ext_subdev(video)) {
+		ret = vpfe_update_current_ext_subdev(video);
+		if (ret) {
 			pr_err("Invalid external subdev\n");
-			return vpfe_update_current_ext_subdev(video);
+			return ret;
 		}
 	} else {
 		pipe->state = VPFE_PIPELINE_STREAM_SINGLESHOT;
@@ -667,6 +670,7 @@ static int vpfe_enum_fmt(struct file *file, void  *priv,
 	struct v4l2_subdev *subdev;
 	struct v4l2_format format;
 	struct media_pad *remote;
+	int ret;

 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_fmt\n");

@@ -695,10 +699,11 @@ static int vpfe_enum_fmt(struct file *file, void  *priv,
 	sd_fmt.pad = remote->index;
 	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	/* get output format of remote subdev */
-	if (v4l2_subdev_call(subdev, pad, get_fmt, NULL, &sd_fmt)) {
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &sd_fmt);
+	if (ret) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
 			 "invalid remote subdev for video node\n");
-		return v4l2_subdev_call(subdev, pad, get_fmt, NULL, &sd_fmt);
+		return ret;
 	}
 	/* convert to pix format */
 	mbus.code = sd_fmt.format.code;
@@ -725,6 +730,7 @@ static int vpfe_s_fmt(struct file *file, void *priv,
 	struct vpfe_video_device *video = video_drvdata(file);
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	struct v4l2_format format;
+	int ret;

 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_fmt\n");
 	/* If streaming is started, return error */
@@ -733,8 +739,9 @@ static int vpfe_s_fmt(struct file *file, void *priv,
 		return -EBUSY;
 	}
 	/* get adjacent subdev's output pad format */
-	if (__vpfe_video_get_format(video, &format))
-		return __vpfe_video_get_format(video, &format);
+	ret = __vpfe_video_get_format(video, &format);
+	if (ret)
+		return ret;
 	*fmt = format;
 	video->fmt = *fmt;
 	return 0;
@@ -757,11 +764,13 @@ static int vpfe_try_fmt(struct file *file, void *priv,
 	struct vpfe_video_device *video = video_drvdata(file);
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	struct v4l2_format format;
+	int ret;

 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_try_fmt\n");
 	/* get adjacent subdev's output pad format */
-	if (__vpfe_video_get_format(video, &format))
-		return __vpfe_video_get_format(video, &format);
+	ret = __vpfe_video_get_format(video, &format);
+	if (ret)
+		return ret;

 	*fmt = format;
 	return 0;
@@ -838,8 +847,9 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)

 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_input\n");

-	if (mutex_lock_interruptible(&video->lock))
-		return mutex_lock_interruptible(&video->lock);
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		return ret;
 	/*
 	 * If streaming is started return device busy
 	 * error
@@ -940,8 +950,9 @@ static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_std\n");

 	/* Call decoder driver function to set the standard */
-	if (mutex_lock_interruptible(&video->lock))
-		return mutex_lock_interruptible(&video->lock);
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		return ret;
 	sdinfo = video->current_ext_subdev;
 	/* If streaming is started, return device busy error */
 	if (video->started) {
@@ -1327,8 +1338,9 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 		return -EINVAL;
 	}

-	if (mutex_lock_interruptible(&video->lock))
-		return mutex_lock_interruptible(&video->lock);
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		return ret;

 	if (video->io_usrs != 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "Only one IO user allowed\n");
@@ -1354,10 +1366,11 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

-	if (vb2_queue_init(q)) {
+	ret = vb2_queue_init(q);
+	if (ret) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "vb2_queue_init() failed\n");
 		vb2_dma_contig_cleanup_ctx(vpfe_dev->pdev);
-		return vb2_queue_init(q);
+		return ret;
 	}

 	fh->io_allowed = 1;
@@ -1533,8 +1546,9 @@ static int vpfe_streamoff(struct file *file, void *priv,
 		return -EINVAL;
 	}

-	if (mutex_lock_interruptible(&video->lock))
-		return mutex_lock_interruptible(&video->lock);
+	ret = mutex_lock_interruptible(&video->lock);
+	if (ret)
+		return ret;

 	vpfe_stop_capture(video);
 	ret = vb2_streamoff(&video->buffer_queue, buf_type);
-- 
2.8.0.rc3

