Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4838 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaBGOLX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 09:11:23 -0500
Message-ID: <52F4E95A.7000301@xs4all.nl>
Date: Fri, 07 Feb 2014 15:10:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH v3] v4l2-subdev: Allow 32-bit compat ioctls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for 32-bit ioctls with v4l-subdev device nodes.

Rather than keep adding new ioctls to the list in v4l2-compat-ioctl32.c, just check
if the ioctl is a non-private V4L2 ioctl and if so, call the conversion code.

We keep forgetting to add new ioctls, so this is a more robust solution.

In addition extend the subdev API with support for a compat32 function to
convert custom v4l-subdev ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..1b18616 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1006,103 +1006,14 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	if (!file->f_op->unlocked_ioctl)
 		return ret;
 
-	switch (cmd) {
-	case VIDIOC_QUERYCAP:
-	case VIDIOC_RESERVED:
-	case VIDIOC_ENUM_FMT:
-	case VIDIOC_G_FMT32:
-	case VIDIOC_S_FMT32:
-	case VIDIOC_REQBUFS:
-	case VIDIOC_QUERYBUF32:
-	case VIDIOC_G_FBUF32:
-	case VIDIOC_S_FBUF32:
-	case VIDIOC_OVERLAY32:
-	case VIDIOC_QBUF32:
-	case VIDIOC_EXPBUF:
-	case VIDIOC_DQBUF32:
-	case VIDIOC_STREAMON32:
-	case VIDIOC_STREAMOFF32:
-	case VIDIOC_G_PARM:
-	case VIDIOC_S_PARM:
-	case VIDIOC_G_STD:
-	case VIDIOC_S_STD:
-	case VIDIOC_ENUMSTD32:
-	case VIDIOC_ENUMINPUT32:
-	case VIDIOC_G_CTRL:
-	case VIDIOC_S_CTRL:
-	case VIDIOC_G_TUNER:
-	case VIDIOC_S_TUNER:
-	case VIDIOC_G_AUDIO:
-	case VIDIOC_S_AUDIO:
-	case VIDIOC_QUERYCTRL:
-	case VIDIOC_QUERYMENU:
-	case VIDIOC_G_INPUT32:
-	case VIDIOC_S_INPUT32:
-	case VIDIOC_G_OUTPUT32:
-	case VIDIOC_S_OUTPUT32:
-	case VIDIOC_ENUMOUTPUT:
-	case VIDIOC_G_AUDOUT:
-	case VIDIOC_S_AUDOUT:
-	case VIDIOC_G_MODULATOR:
-	case VIDIOC_S_MODULATOR:
-	case VIDIOC_S_FREQUENCY:
-	case VIDIOC_G_FREQUENCY:
-	case VIDIOC_CROPCAP:
-	case VIDIOC_G_CROP:
-	case VIDIOC_S_CROP:
-	case VIDIOC_G_SELECTION:
-	case VIDIOC_S_SELECTION:
-	case VIDIOC_G_JPEGCOMP:
-	case VIDIOC_S_JPEGCOMP:
-	case VIDIOC_QUERYSTD:
-	case VIDIOC_TRY_FMT32:
-	case VIDIOC_ENUMAUDIO:
-	case VIDIOC_ENUMAUDOUT:
-	case VIDIOC_G_PRIORITY:
-	case VIDIOC_S_PRIORITY:
-	case VIDIOC_G_SLICED_VBI_CAP:
-	case VIDIOC_LOG_STATUS:
-	case VIDIOC_G_EXT_CTRLS32:
-	case VIDIOC_S_EXT_CTRLS32:
-	case VIDIOC_TRY_EXT_CTRLS32:
-	case VIDIOC_ENUM_FRAMESIZES:
-	case VIDIOC_ENUM_FRAMEINTERVALS:
-	case VIDIOC_G_ENC_INDEX:
-	case VIDIOC_ENCODER_CMD:
-	case VIDIOC_TRY_ENCODER_CMD:
-	case VIDIOC_DECODER_CMD:
-	case VIDIOC_TRY_DECODER_CMD:
-	case VIDIOC_DBG_S_REGISTER:
-	case VIDIOC_DBG_G_REGISTER:
-	case VIDIOC_S_HW_FREQ_SEEK:
-	case VIDIOC_S_DV_TIMINGS:
-	case VIDIOC_G_DV_TIMINGS:
-	case VIDIOC_DQEVENT:
-	case VIDIOC_DQEVENT32:
-	case VIDIOC_SUBSCRIBE_EVENT:
-	case VIDIOC_UNSUBSCRIBE_EVENT:
-	case VIDIOC_CREATE_BUFS32:
-	case VIDIOC_PREPARE_BUF32:
-	case VIDIOC_ENUM_DV_TIMINGS:
-	case VIDIOC_QUERY_DV_TIMINGS:
-	case VIDIOC_DV_TIMINGS_CAP:
-	case VIDIOC_ENUM_FREQ_BANDS:
-	case VIDIOC_SUBDEV_G_EDID32:
-	case VIDIOC_SUBDEV_S_EDID32:
+	if (_IOC_TYPE(cmd) == 'V' && _IOC_NR(cmd) < BASE_VIDIOC_PRIVATE)
 		ret = do_video_ioctl(file, cmd, arg);
-		break;
+	else if (vdev->fops->compat_ioctl32)
+		ret = vdev->fops->compat_ioctl32(file, cmd, arg);
 
-	default:
-		if (vdev->fops->compat_ioctl32)
-			ret = vdev->fops->compat_ioctl32(file, cmd, arg);
-
-		if (ret == -ENOIOCTLCMD)
-			printk(KERN_WARNING "compat_ioctl32: "
-				"unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
-				_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd),
-				cmd);
-		break;
-	}
+	if (ret == -ENOIOCTLCMD)
+		pr_warn("compat_ioctl32: unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
+			_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(v4l2_compat_ioctl32);
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..60d2550 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -368,6 +368,17 @@ static long subdev_ioctl(struct file *file, unsigned int cmd,
 	return video_usercopy(file, cmd, arg, subdev_do_ioctl);
 }
 
+#ifdef CONFIG_COMPAT
+static long subdev_compat_ioctl32(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
+
+	return v4l2_subdev_call(sd, core, compat_ioctl32, cmd, arg);
+}
+#endif
+
 static unsigned int subdev_poll(struct file *file, poll_table *wait)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -389,6 +400,9 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
 	.owner = THIS_MODULE,
 	.open = subdev_open,
 	.unlocked_ioctl = subdev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl32 = subdev_compat_ioctl32,
+#endif
 	.release = subdev_close,
 	.poll = subdev_poll,
 };
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d67210a..84b7cce 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -162,6 +162,9 @@ struct v4l2_subdev_core_ops {
 	int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
 	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
 	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
+#ifdef CONFIG_COMPAT
+	long (*compat_ioctl32)(struct v4l2_subdev *sd, unsigned int cmd, unsigned long arg);
+#endif
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
 	int (*s_register)(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg);
