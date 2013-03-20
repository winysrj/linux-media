Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1955 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3CTSjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 14:39:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 04/11] hdpvr: remove hdpvr_fh and just use v4l2_fh.
Date: Wed, 20 Mar 2013 19:38:55 +0100
Message-Id: <1363804742-5355-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
References: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This prepares the driver for priority and control event handling.

This patch also checks for correct streaming ownership and it makes a
small improvement to the encoder_cmd ioctls: always zero 'flags' and
drop the memset of 'raw' as that is already done by the v4l2 core.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |  116 +++++++++++++--------------------
 drivers/media/usb/hdpvr/hdpvr.h       |    4 +-
 2 files changed, 46 insertions(+), 74 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 9f03add..873bb23 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -34,10 +34,6 @@
 			 list_size(&dev->free_buff_list),		\
 			 list_size(&dev->rec_buff_list)); }
 
-struct hdpvr_fh {
-	struct hdpvr_device	*dev;
-};
-
 static uint list_size(struct list_head *list)
 {
 	struct list_head *tmp;
@@ -357,55 +353,21 @@ static int hdpvr_stop_streaming(struct hdpvr_device *dev)
  * video 4 linux 2 file operations
  */
 
-static int hdpvr_open(struct file *file)
-{
-	struct hdpvr_device *dev;
-	struct hdpvr_fh *fh;
-	int retval = -ENOMEM;
-
-	dev = (struct hdpvr_device *)video_get_drvdata(video_devdata(file));
-	if (!dev) {
-		pr_err("open failing with with ENODEV\n");
-		retval = -ENODEV;
-		goto err;
-	}
-
-	fh = kzalloc(sizeof(struct hdpvr_fh), GFP_KERNEL);
-	if (!fh) {
-		v4l2_err(&dev->v4l2_dev, "Out of memory\n");
-		goto err;
-	}
-	/* lock the device to allow correctly handling errors
-	 * in resumption */
-	mutex_lock(&dev->io_mutex);
-	dev->open_count++;
-	mutex_unlock(&dev->io_mutex);
-
-	fh->dev = dev;
-
-	/* save our object in the file's private structure */
-	file->private_data = fh;
-
-	retval = 0;
-err:
-	return retval;
-}
-
 static int hdpvr_release(struct file *file)
 {
-	struct hdpvr_fh		*fh  = file->private_data;
-	struct hdpvr_device	*dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 
 	if (!dev)
 		return -ENODEV;
 
 	mutex_lock(&dev->io_mutex);
-	if (!(--dev->open_count) && dev->status == STATUS_STREAMING)
+	if (file->private_data == dev->owner) {
 		hdpvr_stop_streaming(dev);
-
+		dev->owner = NULL;
+	}
 	mutex_unlock(&dev->io_mutex);
 
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 /*
@@ -415,8 +377,7 @@ static int hdpvr_release(struct file *file)
 static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 			  loff_t *pos)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 	struct hdpvr_buffer *buf = NULL;
 	struct urb *urb;
 	unsigned int ret = 0;
@@ -439,6 +400,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 			mutex_unlock(&dev->io_mutex);
 			goto err;
 		}
+		dev->owner = file->private_data;
 		print_buffer_status();
 	}
 	mutex_unlock(&dev->io_mutex);
@@ -517,8 +479,7 @@ err:
 static unsigned int hdpvr_poll(struct file *filp, poll_table *wait)
 {
 	struct hdpvr_buffer *buf = NULL;
-	struct hdpvr_fh *fh = filp->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(filp);
 	unsigned int mask = 0;
 
 	mutex_lock(&dev->io_mutex);
@@ -533,6 +494,8 @@ static unsigned int hdpvr_poll(struct file *filp, poll_table *wait)
 			v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
 				 "start_streaming failed\n");
 			dev->status = STATUS_IDLE;
+		} else {
+			dev->owner = filp->private_data;
 		}
 
 		print_buffer_status();
@@ -554,7 +517,7 @@ static unsigned int hdpvr_poll(struct file *filp, poll_table *wait)
 
 static const struct v4l2_file_operations hdpvr_fops = {
 	.owner		= THIS_MODULE,
-	.open		= hdpvr_open,
+	.open		= v4l2_fh_open,
 	.release	= hdpvr_release,
 	.read		= hdpvr_read,
 	.poll		= hdpvr_poll,
@@ -583,8 +546,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 static int vidioc_s_std(struct file *file, void *private_data,
 			v4l2_std_id *std)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 	u8 std_type = 1;
 
 	if (*std & (V4L2_STD_NTSC | V4L2_STD_PAL_60))
@@ -602,8 +564,7 @@ static const char *iname[] = {
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *i)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 	unsigned int n;
 
 	n = i->index;
@@ -625,8 +586,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 static int vidioc_s_input(struct file *file, void *private_data,
 			  unsigned int index)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 	int retval;
 
 	if (index >= HDPVR_VIDEO_INPUTS)
@@ -645,8 +605,7 @@ static int vidioc_s_input(struct file *file, void *private_data,
 static int vidioc_g_input(struct file *file, void *private_data,
 			  unsigned int *index)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 
 	*index = dev->options.video_input;
 	return 0;
@@ -679,8 +638,7 @@ static int vidioc_enumaudio(struct file *file, void *priv,
 static int vidioc_s_audio(struct file *file, void *private_data,
 			  const struct v4l2_audio *audio)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 	int retval;
 
 	if (audio->index >= HDPVR_AUDIO_INPUTS)
@@ -699,8 +657,7 @@ static int vidioc_s_audio(struct file *file, void *private_data,
 static int vidioc_g_audio(struct file *file, void *private_data,
 			  struct v4l2_audio *audio)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 
 	audio->index = dev->options.audio_input;
 	audio->capability = V4L2_AUDCAP_STEREO;
@@ -832,8 +789,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *private_data,
 static int vidioc_g_fmt_vid_cap(struct file *file, void *private_data,
 				struct v4l2_format *f)
 {
-	struct hdpvr_fh *fh = file->private_data;
-	struct hdpvr_device *dev = fh->dev;
+	struct hdpvr_device *dev = video_drvdata(file);
 	struct hdpvr_video_info *vid_info;
 
 	if (!dev)
@@ -859,26 +815,43 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *private_data,
 static int vidioc_encoder_cmd(struct file *filp, void *priv,
 			       struct v4l2_encoder_cmd *a)
 {
-	struct hdpvr_fh *fh = filp->private_data;
-	struct hdpvr_device *dev = fh->dev;
-	int res;
+	struct hdpvr_device *dev = video_drvdata(filp);
+	int res = 0;
 
 	mutex_lock(&dev->io_mutex);
+	a->flags = 0;
 
-	memset(&a->raw, 0, sizeof(a->raw));
 	switch (a->cmd) {
-	case V4L2_ENC_CMD_START:
-		a->flags = 0;
+		if (dev->owner && filp->private_data != dev->owner) {
+			res = -EBUSY;
+			break;
+		}
+		if (dev->status == STATUS_STREAMING)
+			break;
 		res = hdpvr_start_streaming(dev);
+		if (!res)
+			dev->owner = filp->private_data;
+		else
+			dev->status = STATUS_IDLE;
 		break;
 	case V4L2_ENC_CMD_STOP:
+		if (dev->owner && filp->private_data != dev->owner) {
+			res = -EBUSY;
+			break;
+		}
+		if (dev->status == STATUS_IDLE)
+			break;
 		res = hdpvr_stop_streaming(dev);
+		if (!res)
+			dev->owner = NULL;
 		break;
 	default:
 		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
 			 "Unsupported encoder cmd %d\n", a->cmd);
 		res = -EINVAL;
+		break;
 	}
+
 	mutex_unlock(&dev->io_mutex);
 	return res;
 }
@@ -886,6 +859,7 @@ static int vidioc_encoder_cmd(struct file *filp, void *priv,
 static int vidioc_try_encoder_cmd(struct file *filp, void *priv,
 					struct v4l2_encoder_cmd *a)
 {
+	a->flags = 0;
 	switch (a->cmd) {
 	case V4L2_ENC_CMD_START:
 	case V4L2_ENC_CMD_STOP:
@@ -934,8 +908,6 @@ static void hdpvr_device_release(struct video_device *vdev)
 }
 
 static const struct video_device hdpvr_video_template = {
-/* 	.type			= VFL_TYPE_GRABBER, */
-/* 	.type2			= VID_TYPE_CAPTURE | VID_TYPE_MPEG_ENCODER, */
 	.fops			= &hdpvr_fops,
 	.release		= hdpvr_device_release,
 	.ioctl_ops 		= &hdpvr_ioctl_ops,
@@ -1030,9 +1002,9 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 		goto error;
 	}
 
-	*(dev->video_dev) = hdpvr_video_template;
+	*dev->video_dev = hdpvr_video_template;
 	strcpy(dev->video_dev->name, "Hauppauge HD PVR");
-	dev->video_dev->parent = parent;
+	dev->video_dev->v4l2_dev = &dev->v4l2_dev;
 	video_set_drvdata(dev->video_dev, dev);
 
 	res = video_register_device(dev->video_dev, VFL_TYPE_GRABBER, devnum);
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index 2a4deab..9450093 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -85,8 +85,6 @@ struct hdpvr_device {
 
 	/* holds the current device status */
 	__u8			status;
-	/* count the number of openers */
-	uint			open_count;
 
 	/* holds the cureent set options */
 	struct hdpvr_options	options;
@@ -107,6 +105,8 @@ struct hdpvr_device {
 	struct workqueue_struct	*workqueue;
 	/**/
 	struct work_struct	worker;
+	/* current stream owner */
+	struct v4l2_fh		*owner;
 
 	/* I2C adapter */
 	struct i2c_adapter	i2c_adapter;
-- 
1.7.10.4

