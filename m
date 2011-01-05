Return-path: <mchehab@gaivota>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3669 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1AEQm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 11:42:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: nsekhar@ti.com, manjunath.hadli@ti.com
Subject: [RFC PATCH 2/2] davinci: convert vpif_display to core-assisted locking
Date: Wed,  5 Jan 2011 17:42:40 +0100
Message-Id: <b0d7c4ddcbafae4ea88f1f8bfe24357d83ca568a.1294245475.git.hverkuil@xs4all.nl>
In-Reply-To: <1294245760-2803-1-git-send-email-hverkuil@xs4all.nl>
References: <1294245760-2803-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <322ed2dee70fc3e42f144410eb822d2e4d84c1d8.1294245475.git.hverkuil@xs4all.nl>
References: <322ed2dee70fc3e42f144410eb822d2e4d84c1d8.1294245475.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

vpif_display now uses .unlocked_ioctl instead of .ioctl.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/davinci/vpif_display.c |   98 ++++++----------------------
 1 files changed, 20 insertions(+), 78 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 7cb70d9..cdf659a 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -652,9 +652,6 @@ static int vpif_release(struct file *filep)
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	/* if this instance is doing IO */
 	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
 		/* Reset io_usrs member of channel object */
@@ -677,8 +674,6 @@ static int vpif_release(struct file *filep)
 		    config_params.numbuffers[ch->channel_id];
 	}
 
-	mutex_unlock(&common->lock);
-
 	/* Decrement channel usrs counter */
 	atomic_dec(&ch->usrs);
 	/* If this file handle has initialize encoder device, reset it */
@@ -737,24 +732,15 @@ static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
 
 	/* Check the validity of the buffer type */
 	if (common->fmt.type != fmt->type)
 		return -EINVAL;
 
-	/* Fill in the information about format */
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	if (vpif_update_resolution(ch))
-		ret = -EINVAL;
-	else
-		*fmt = common->fmt;
-
-	mutex_unlock(&common->lock);
-
-	return ret;
+		return -EINVAL;
+	*fmt = common->fmt;
+	return 0;
 }
 
 static int vpif_s_fmt_vid_out(struct file *file, void *priv,
@@ -794,12 +780,7 @@ static int vpif_s_fmt_vid_out(struct file *file, void *priv,
 	/* store the pix format in the channel object */
 	common->fmt.fmt.pix = *pixfmt;
 	/* store the format in the channel object */
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	common->fmt = *fmt;
-	mutex_unlock(&common->lock);
-
 	return 0;
 }
 
@@ -829,7 +810,6 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	struct common_obj *common;
 	enum v4l2_field field;
 	u8 index = 0;
-	int ret = 0;
 
 	/* This file handle has not initialized the channel,
 	   It is not allowed to do settings */
@@ -847,18 +827,12 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	index = VPIF_VIDEO_INDEX;
 
 	common = &ch->common[index];
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
 
-	if (common->fmt.type != reqbuf->type) {
-		ret = -EINVAL;
-		goto reqbuf_exit;
-	}
+	if (common->fmt.type != reqbuf->type)
+		return -EINVAL;
 
-	if (0 != common->io_usrs) {
-		ret = -EBUSY;
-		goto reqbuf_exit;
-	}
+	if (0 != common->io_usrs)
+		return -EBUSY;
 
 	if (reqbuf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		if (common->fmt.fmt.pix.field == V4L2_FIELD_ANY)
@@ -875,7 +849,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
 					    &common->irqlock,
 					    reqbuf->type, field,
 					    sizeof(struct videobuf_buffer), fh,
-					    NULL);
+					    &common->lock);
 
 	/* Set io allowed member of file handle to TRUE */
 	fh->io_allowed[index] = 1;
@@ -886,11 +860,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	INIT_LIST_HEAD(&common->dma_queue);
 
 	/* Allocate buffers */
-	ret = videobuf_reqbufs(&common->buffer_queue, reqbuf);
-
-reqbuf_exit:
-	mutex_unlock(&common->lock);
-	return ret;
+	return videobuf_reqbufs(&common->buffer_queue, reqbuf);
 }
 
 static int vpif_querybuf(struct file *file, void *priv,
@@ -1011,25 +981,19 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 	}
 
 	/* Call encoder subdevice function to set the standard */
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	ch->video.stdid = *std_id;
 	ch->video.dv_preset = V4L2_DV_INVALID;
 	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
 
 	/* Get the information about the standard */
-	if (vpif_update_resolution(ch)) {
-		ret = -EINVAL;
-		goto s_std_exit;
-	}
+	if (vpif_update_resolution(ch))
+		return -EINVAL;
 
 	if ((ch->vpifparams.std_info.width *
 		ch->vpifparams.std_info.height * 2) >
 		config_params.channel_bufsize[ch->channel_id]) {
 		vpif_err("invalid std for this size\n");
-		ret = -EINVAL;
-		goto s_std_exit;
+		return -EINVAL;
 	}
 
 	common->fmt.fmt.pix.bytesperline = common->fmt.fmt.pix.width;
@@ -1040,16 +1004,13 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 						s_std_output, *std_id);
 	if (ret < 0) {
 		vpif_err("Failed to set output standard\n");
-		goto s_std_exit;
+		return ret;
 	}
 
 	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, core,
 							s_std, *std_id);
 	if (ret < 0)
 		vpif_err("Failed to set standard for sub devices\n");
-
-s_std_exit:
-	mutex_unlock(&common->lock);
 	return ret;
 }
 
@@ -1121,14 +1082,10 @@ static int vpif_streamon(struct file *file, void *priv,
 		return ret;
 	}
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	/* If buffer queue is empty, return error */
 	if (list_empty(&common->dma_queue)) {
 		vpif_err("buffer queue is empty\n");
-		ret = -EIO;
-		goto streamon_exit;
+		return -EIO;
 	}
 
 	/* Get the next frame from the buffer queue */
@@ -1154,8 +1111,7 @@ static int vpif_streamon(struct file *file, void *priv,
 			|| (!ch->vpifparams.std_info.frm_fmt
 			&& (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
 			vpif_err("conflict in field format and std format\n");
-			ret = -EINVAL;
-			goto streamon_exit;
+			return -EINVAL;
 		}
 
 		/* clock settings */
@@ -1164,13 +1120,13 @@ static int vpif_streamon(struct file *file, void *priv,
 						ch->vpifparams.std_info.hd_sd);
 		if (ret < 0) {
 			vpif_err("can't set clock\n");
-			goto streamon_exit;
+			return ret;
 		}
 
 		/* set the parameters and addresses */
 		ret = vpif_set_video_params(vpif, ch->channel_id + 2);
 		if (ret < 0)
-			goto streamon_exit;
+			return ret;
 
 		common->started = ret;
 		vpif_config_addr(ch, ret);
@@ -1195,9 +1151,6 @@ static int vpif_streamon(struct file *file, void *priv,
 		}
 		channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
 	}
-
-streamon_exit:
-	mutex_unlock(&common->lock);
 	return ret;
 }
 
@@ -1223,9 +1176,6 @@ static int vpif_streamoff(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		/* disable channel */
 		if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
@@ -1240,8 +1190,6 @@ static int vpif_streamoff(struct file *file, void *priv,
 	}
 
 	common->started = 0;
-	mutex_unlock(&common->lock);
-
 	return videobuf_streamoff(&common->buffer_queue);
 }
 
@@ -1288,13 +1236,9 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	if (common->started) {
 		vpif_err("Streaming in progress\n");
-		ret = -EBUSY;
-		goto s_output_exit;
+		return -EBUSY;
 	}
 
 	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, video,
@@ -1304,9 +1248,6 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 		vpif_err("Failed to set output standard\n");
 
 	vid_ch->output_id = i;
-
-s_output_exit:
-	mutex_unlock(&common->lock);
 	return ret;
 }
 
@@ -1658,7 +1599,7 @@ static const struct v4l2_file_operations vpif_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vpif_open,
 	.release	= vpif_release,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.mmap		= vpif_mmap,
 	.poll		= vpif_poll
 };
@@ -1842,6 +1783,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		v4l2_prio_init(&ch->prio);
 		ch->common[VPIF_VIDEO_INDEX].fmt.type =
 						V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		ch->video_dev->lock = &common->lock;
 
 		/* register video device */
 		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
-- 
1.7.0.4

