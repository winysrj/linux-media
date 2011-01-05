Return-path: <mchehab@gaivota>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1172 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1AEQm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jan 2011 11:42:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: nsekhar@ti.com, manjunath.hadli@ti.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/2] davinci: convert vpif_capture to core-assisted locking
Date: Wed,  5 Jan 2011 17:42:39 +0100
Message-Id: <322ed2dee70fc3e42f144410eb822d2e4d84c1d8.1294245475.git.hverkuil@xs4all.nl>
In-Reply-To: <1294245760-2803-1-git-send-email-hverkuil@xs4all.nl>
References: <1294245760-2803-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now uses .unlocked_ioctl instead of .ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_capture.c |   90 ++++-----------------------
 1 files changed, 14 insertions(+), 76 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index f8e6590..d93ad74 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -752,7 +752,7 @@ static int vpif_open(struct file *filep)
 	struct video_obj *vid_ch;
 	struct channel_obj *ch;
 	struct vpif_fh *fh;
-	int i, ret = 0;
+	int i;
 
 	vpif_dbg(2, debug, "vpif_open\n");
 
@@ -761,9 +761,6 @@ static int vpif_open(struct file *filep)
 	vid_ch = &ch->video;
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	if (NULL == ch->curr_subdev_info) {
 		/**
 		 * search through the sub device to see a registered
@@ -780,8 +777,7 @@ static int vpif_open(struct file *filep)
 		}
 		if (i == config->subdev_count) {
 			vpif_err("No sub device registered\n");
-			ret = -ENOENT;
-			goto exit;
+			return -ENOENT;
 		}
 	}
 
@@ -789,8 +785,7 @@ static int vpif_open(struct file *filep)
 	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
 	if (NULL == fh) {
 		vpif_err("unable to allocate memory for file handle object\n");
-		ret = -ENOMEM;
-		goto exit;
+		return -ENOMEM;
 	}
 
 	/* store pointer to fh in private_data member of filep */
@@ -810,9 +805,7 @@ static int vpif_open(struct file *filep)
 	/* Initialize priority of this instance to default priority */
 	fh->prio = V4L2_PRIORITY_UNSET;
 	v4l2_prio_open(&ch->prio, &fh->prio);
-exit:
-	mutex_unlock(&common->lock);
-	return ret;
+	return 0;
 }
 
 /**
@@ -832,9 +825,6 @@ static int vpif_release(struct file *filep)
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	/* if this instance is doing IO */
 	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
 		/* Reset io_usrs member of channel object */
@@ -858,9 +848,6 @@ static int vpif_release(struct file *filep)
 	/* Decrement channel usrs counter */
 	ch->usrs--;
 
-	/* unlock mutex on channel object */
-	mutex_unlock(&common->lock);
-
 	/* Close the priority */
 	v4l2_prio_close(&ch->prio, fh->prio);
 
@@ -885,7 +872,6 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common;
 	u8 index = 0;
-	int ret = 0;
 
 	vpif_dbg(2, debug, "vpif_reqbufs\n");
 
@@ -908,13 +894,8 @@ static int vpif_reqbufs(struct file *file, void *priv,
 
 	common = &ch->common[index];
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
-	if (0 != common->io_usrs) {
-		ret = -EBUSY;
-		goto reqbuf_exit;
-	}
+	if (0 != common->io_usrs)
+		return -EBUSY;
 
 	/* Initialize videobuf queue as per the buffer type */
 	videobuf_queue_dma_contig_init(&common->buffer_queue,
@@ -923,7 +904,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
 					    reqbuf->type,
 					    common->fmt.fmt.pix.field,
 					    sizeof(struct videobuf_buffer), fh,
-					    NULL);
+					    &common->lock);
 
 	/* Set io allowed member of file handle to TRUE */
 	fh->io_allowed[index] = 1;
@@ -934,11 +915,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	INIT_LIST_HEAD(&common->dma_queue);
 
 	/* Allocate buffers */
-	ret = videobuf_reqbufs(&common->buffer_queue, reqbuf);
-
-reqbuf_exit:
-	mutex_unlock(&common->lock);
-	return ret;
+	return videobuf_reqbufs(&common->buffer_queue, reqbuf);
 }
 
 /**
@@ -1152,11 +1129,6 @@ static int vpif_streamon(struct file *file, void *priv,
 		return ret;
 	}
 
-	if (mutex_lock_interruptible(&common->lock)) {
-		ret = -ERESTARTSYS;
-		goto streamoff_exit;
-	}
-
 	/* If buffer queue is empty, return error */
 	if (list_empty(&common->dma_queue)) {
 		vpif_dbg(1, debug, "buffer queue is empty\n");
@@ -1235,13 +1207,10 @@ static int vpif_streamon(struct file *file, void *priv,
 		enable_channel1(1);
 	}
 	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
-	mutex_unlock(&common->lock);
 	return ret;
 
 exit:
-	mutex_unlock(&common->lock);
-streamoff_exit:
-	ret = videobuf_streamoff(&common->buffer_queue);
+	videobuf_streamoff(&common->buffer_queue);
 	return ret;
 }
 
@@ -1279,9 +1248,6 @@ static int vpif_streamoff(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	/* disable channel */
 	if (VPIF_CHANNEL0_VIDEO == ch->channel_id) {
 		enable_channel0(0);
@@ -1299,8 +1265,6 @@ static int vpif_streamoff(struct file *file, void *priv,
 	if (ret && (ret != -ENOIOCTLCMD))
 		vpif_dbg(1, debug, "stream off failed in subdev\n");
 
-	mutex_unlock(&common->lock);
-
 	return videobuf_streamoff(&common->buffer_queue);
 }
 
@@ -1376,21 +1340,16 @@ static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
 	vpif_dbg(2, debug, "vpif_querystd\n");
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	/* Call querystd function of decoder device */
 	ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], video,
 				querystd, std_id);
 	if (ret < 0)
 		vpif_dbg(1, debug, "Failed to set standard for sub devices\n");
 
-	mutex_unlock(&common->lock);
 	return ret;
 }
 
@@ -1446,18 +1405,14 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 	fh->initialized = 1;
 
 	/* Call encoder subdevice function to set the standard */
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	ch->video.stdid = *std_id;
 	ch->video.dv_preset = V4L2_DV_INVALID;
 	memset(&ch->video.bt_timings, 0, sizeof(ch->video.bt_timings));
 
 	/* Get the information about the standard */
 	if (vpif_update_std_info(ch)) {
-		ret = -EINVAL;
 		vpif_err("Error getting the standard info\n");
-		goto s_std_exit;
+		return -EINVAL;
 	}
 
 	/* Configure the default format information */
@@ -1468,9 +1423,6 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 				s_std, *std_id);
 	if (ret < 0)
 		vpif_dbg(1, debug, "Failed to set standard for sub devices\n");
-
-s_std_exit:
-	mutex_unlock(&common->lock);
 	return ret;
 }
 
@@ -1564,9 +1516,6 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 		return -EINVAL;
 	}
 
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	/* first setup input path from sub device to vpif */
 	if (config->setup_input_path) {
 		ret = config->setup_input_path(ch->channel_id,
@@ -1575,7 +1524,7 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 			vpif_dbg(1, debug, "couldn't setup input path for the"
 				" sub device %s, for input index %d\n",
 				subdev_info->name, index);
-			goto exit;
+			return ret;
 		}
 	}
 
@@ -1586,7 +1535,7 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 					input, output, 0);
 		if (ret < 0) {
 			vpif_dbg(1, debug, "Failed to set input\n");
-			goto exit;
+			return ret;
 		}
 	}
 	vid_ch->input_idx = index;
@@ -1597,9 +1546,6 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 
 	/* update tvnorms from the sub device input info */
 	ch->video_dev->tvnorms = chan_cfg->inputs[index].input.std;
-
-exit:
-	mutex_unlock(&common->lock);
 	return ret;
 }
 
@@ -1668,11 +1614,7 @@ static int vpif_g_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	/* Fill in the information about format */
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	*fmt = common->fmt;
-	mutex_unlock(&common->lock);
 	return 0;
 }
 
@@ -1720,12 +1662,7 @@ static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
 	if (ret)
 		return ret;
 	/* store the format in the channel object */
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-
 	common->fmt = *fmt;
-	mutex_unlock(&common->lock);
-
 	return 0;
 }
 
@@ -2145,7 +2082,7 @@ static struct v4l2_file_operations vpif_fops = {
 	.owner = THIS_MODULE,
 	.open = vpif_open,
 	.release = vpif_release,
-	.ioctl = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 	.mmap = vpif_mmap,
 	.poll = vpif_poll
 };
@@ -2288,6 +2225,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		common = &(ch->common[VPIF_VIDEO_INDEX]);
 		spin_lock_init(&common->irqlock);
 		mutex_init(&common->lock);
+		ch->video_dev->lock = &common->lock;
 		/* Initialize prio member of channel object */
 		v4l2_prio_init(&ch->prio);
 		err = video_register_device(ch->video_dev,
-- 
1.7.0.4

