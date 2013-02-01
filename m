Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1815 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3BAMRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:17:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/6] tm6000: convert to the control framework.
Date: Fri,  1 Feb 2013 13:17:17 +0100
Message-Id: <3904363e692a65e4f6fabeb9d1a37177d4b0c57a.1359720708.git.hans.verkuil@cisco.com>
In-Reply-To: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
References: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
References: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tm6000/tm6000-video.c |  232 +++++++++----------------------
 drivers/media/usb/tm6000/tm6000.h       |    3 +
 2 files changed, 68 insertions(+), 167 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 7a653b2..4329fbc 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -63,71 +63,6 @@ static bool keep_urb;			/* keep urb buffers allocated */
 int tm6000_debug;
 EXPORT_SYMBOL_GPL(tm6000_debug);
 
-static const struct v4l2_queryctrl no_ctrl = {
-	.name  = "42",
-	.flags = V4L2_CTRL_FLAG_DISABLED,
-};
-
-/* supported controls */
-static struct v4l2_queryctrl tm6000_qctrl[] = {
-	{
-		.id            = V4L2_CID_BRIGHTNESS,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Brightness",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 1,
-		.default_value = 54,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_CONTRAST,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Contrast",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 0x1,
-		.default_value = 119,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_SATURATION,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Saturation",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 0x1,
-		.default_value = 112,
-		.flags         = 0,
-	}, {
-		.id            = V4L2_CID_HUE,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-		.name          = "Hue",
-		.minimum       = -128,
-		.maximum       = 127,
-		.step          = 0x1,
-		.default_value = 0,
-		.flags         = 0,
-	},
-		/* --- audio --- */
-	{
-		.id            = V4L2_CID_AUDIO_MUTE,
-		.name          = "Mute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	}, {
-		.id            = V4L2_CID_AUDIO_VOLUME,
-		.name          = "Volume",
-		.minimum       = -15,
-		.maximum       = 15,
-		.step          = 1,
-		.default_value = 0,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	}
-};
-
-static const unsigned int CTRLS = ARRAY_SIZE(tm6000_qctrl);
-static int qctl_regs[ARRAY_SIZE(tm6000_qctrl)];
-
 static struct tm6000_fmt format[] = {
 	{
 		.name     = "4:2:2, packed, YVY2",
@@ -144,16 +79,6 @@ static struct tm6000_fmt format[] = {
 	}
 };
 
-static const struct v4l2_queryctrl *ctrl_by_id(unsigned int id)
-{
-	unsigned int i;
-
-	for (i = 0; i < CTRLS; i++)
-		if (tm6000_qctrl[i].id == id)
-			return tm6000_qctrl+i;
-	return NULL;
-}
-
 /* ------------------------------------------------------------------
  *	DMA and thread functions
  * ------------------------------------------------------------------
@@ -1215,79 +1140,40 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 }
 
 /* --- controls ---------------------------------------------- */
-static int vidioc_queryctrl(struct file *file, void *priv,
-				struct v4l2_queryctrl *qc)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(tm6000_qctrl); i++)
-		if (qc->id && qc->id == tm6000_qctrl[i].id) {
-			memcpy(qc, &(tm6000_qctrl[i]),
-				sizeof(*qc));
-			return 0;
-		}
-
-	return -EINVAL;
-}
 
-static int vidioc_g_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
+static int tm6000_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct tm6000_fh  *fh = priv;
-	struct tm6000_core *dev    = fh->dev;
-	int  val;
+	struct tm6000_core *dev = container_of(ctrl->handler, struct tm6000_core, ctrl_handler);
+	u8  val = ctrl->val;
 
-	/* FIXME: Probably, those won't work! Maybe we need shadow regs */
 	switch (ctrl->id) {
 	case V4L2_CID_CONTRAST:
-		val = tm6000_get_reg(dev, TM6010_REQ07_R08_LUMA_CONTRAST_ADJ, 0);
-		break;
+		tm6000_set_reg(dev, TM6010_REQ07_R08_LUMA_CONTRAST_ADJ, val);
+		return 0;
 	case V4L2_CID_BRIGHTNESS:
-		val = tm6000_get_reg(dev, TM6010_REQ07_R09_LUMA_BRIGHTNESS_ADJ, 0);
+		tm6000_set_reg(dev, TM6010_REQ07_R09_LUMA_BRIGHTNESS_ADJ, val);
 		return 0;
 	case V4L2_CID_SATURATION:
-		val = tm6000_get_reg(dev, TM6010_REQ07_R0A_CHROMA_SATURATION_ADJ, 0);
+		tm6000_set_reg(dev, TM6010_REQ07_R0A_CHROMA_SATURATION_ADJ, val);
 		return 0;
 	case V4L2_CID_HUE:
-		val = tm6000_get_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, 0);
-		return 0;
-	case V4L2_CID_AUDIO_MUTE:
-		val = dev->ctl_mute;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		val = dev->ctl_volume;
+		tm6000_set_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, val);
 		return 0;
-	default:
-		return -EINVAL;
 	}
+	return -EINVAL;
+}
 
-	if (val < 0)
-		return val;
-
-	ctrl->value = val;
+static const struct v4l2_ctrl_ops tm6000_ctrl_ops = {
+	.s_ctrl = tm6000_s_ctrl,
+};
 
-	return 0;
-}
-static int vidioc_s_ctrl(struct file *file, void *priv,
-				struct v4l2_control *ctrl)
+static int tm6000_radio_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct tm6000_fh   *fh  = priv;
-	struct tm6000_core *dev = fh->dev;
-	u8  val = ctrl->value;
+	struct tm6000_core *dev = container_of(ctrl->handler,
+			struct tm6000_core, radio_ctrl_handler);
+	u8  val = ctrl->val;
 
 	switch (ctrl->id) {
-	case V4L2_CID_CONTRAST:
-		tm6000_set_reg(dev, TM6010_REQ07_R08_LUMA_CONTRAST_ADJ, val);
-		return 0;
-	case V4L2_CID_BRIGHTNESS:
-		tm6000_set_reg(dev, TM6010_REQ07_R09_LUMA_BRIGHTNESS_ADJ, val);
-		return 0;
-	case V4L2_CID_SATURATION:
-		tm6000_set_reg(dev, TM6010_REQ07_R0A_CHROMA_SATURATION_ADJ, val);
-		return 0;
-	case V4L2_CID_HUE:
-		tm6000_set_reg(dev, TM6010_REQ07_R0B_CHROMA_HUE_PHASE_ADJ, val);
-		return 0;
 	case V4L2_CID_AUDIO_MUTE:
 		dev->ctl_mute = val;
 		tm6000_tvaudio_set_mute(dev, val);
@@ -1300,6 +1186,10 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	return -EINVAL;
 }
 
+static const struct v4l2_ctrl_ops tm6000_radio_ctrl_ops = {
+	.s_ctrl = tm6000_radio_s_ctrl,
+};
+
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
@@ -1418,23 +1308,6 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *c)
-{
-	const struct v4l2_queryctrl *ctrl;
-
-	if (c->id <  V4L2_CID_BASE ||
-	    c->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		ctrl = ctrl_by_id(c->id);
-		*c = *ctrl;
-	} else
-		*c = no_ctrl;
-
-	return 0;
-}
-
 /* ------------------------------------------------------------------
 	File operations for the device
    ------------------------------------------------------------------*/
@@ -1445,7 +1318,7 @@ static int __tm6000_open(struct file *file)
 	struct tm6000_core *dev = video_drvdata(file);
 	struct tm6000_fh *fh;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	int i, rc;
+	int rc;
 	int radio = 0;
 
 	dprintk(dev, V4L2_DEBUG_OPEN, "tm6000: open called (dev=%s)\n",
@@ -1505,13 +1378,7 @@ static int __tm6000_open(struct file *file)
 	if (rc < 0)
 		return rc;
 
-	if (dev->mode != TM6000_MODE_ANALOG) {
-		/* Put all controls at a sane state */
-		for (i = 0; i < ARRAY_SIZE(tm6000_qctrl); i++)
-			qctl_regs[i] = tm6000_qctrl[i].default_value;
-
-		dev->mode = TM6000_MODE_ANALOG;
-	}
+	dev->mode = TM6000_MODE_ANALOG;
 
 	if (!fh->radio) {
 		videobuf_queue_vmalloc_init(&fh->vb_vidq, &tm6000_video_qops,
@@ -1678,9 +1545,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input        = vidioc_enum_input,
 	.vidioc_g_input           = vidioc_g_input,
 	.vidioc_s_input           = vidioc_s_input,
-	.vidioc_queryctrl         = vidioc_queryctrl,
-	.vidioc_g_ctrl            = vidioc_g_ctrl,
-	.vidioc_s_ctrl            = vidioc_s_ctrl,
 	.vidioc_g_tuner           = vidioc_g_tuner,
 	.vidioc_s_tuner           = vidioc_s_tuner,
 	.vidioc_g_frequency       = vidioc_g_frequency,
@@ -1713,9 +1577,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 	.vidioc_g_tuner		= radio_g_tuner,
 	.vidioc_s_tuner		= radio_s_tuner,
-	.vidioc_queryctrl	= radio_queryctrl,
-	.vidioc_g_ctrl		= vidioc_g_ctrl,
-	.vidioc_s_ctrl		= vidioc_s_ctrl,
 	.vidioc_g_frequency	= vidioc_g_frequency,
 	.vidioc_s_frequency	= vidioc_s_frequency,
 };
@@ -1755,15 +1616,41 @@ static struct video_device *vdev_init(struct tm6000_core *dev,
 
 int tm6000_v4l2_register(struct tm6000_core *dev)
 {
-	int ret = -1;
+	int ret = 0;
+
+	v4l2_ctrl_handler_init(&dev->ctrl_handler, 6);
+	v4l2_ctrl_handler_init(&dev->radio_ctrl_handler, 2);
+	v4l2_ctrl_new_std(&dev->radio_ctrl_handler, &tm6000_radio_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&dev->radio_ctrl_handler, &tm6000_radio_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, -15, 15, 1, 0);
+	v4l2_ctrl_new_std(&dev->ctrl_handler, &tm6000_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 54);
+	v4l2_ctrl_new_std(&dev->ctrl_handler, &tm6000_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 119);
+	v4l2_ctrl_new_std(&dev->ctrl_handler, &tm6000_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 112);
+	v4l2_ctrl_new_std(&dev->ctrl_handler, &tm6000_ctrl_ops,
+			V4L2_CID_HUE, -128, 127, 1, 0);
+	v4l2_ctrl_add_handler(&dev->ctrl_handler,
+			&dev->radio_ctrl_handler, NULL);
+
+	if (dev->radio_ctrl_handler.error)
+		ret = dev->radio_ctrl_handler.error;
+	if (!ret && dev->ctrl_handler.error)
+		ret = dev->ctrl_handler.error;
+	if (ret)
+		goto free_ctrl;
 
 	dev->vfd = vdev_init(dev, &tm6000_template, "video");
 
 	if (!dev->vfd) {
 		printk(KERN_INFO "%s: can't register video device\n",
 		       dev->name);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_ctrl;
 	}
+	dev->vfd->ctrl_handler = &dev->ctrl_handler;
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
@@ -1774,7 +1661,9 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	if (ret < 0) {
 		printk(KERN_INFO "%s: can't register video device\n",
 		       dev->name);
-		return ret;
+		video_device_release(dev->vfd);
+		dev->vfd = NULL;
+		goto free_ctrl;
 	}
 
 	printk(KERN_INFO "%s: registered device %s\n",
@@ -1787,15 +1676,17 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 			printk(KERN_INFO "%s: can't register radio device\n",
 			       dev->name);
 			ret = -ENXIO;
-			return ret; /* FIXME release resource */
+			goto unreg_video;
 		}
 
+		dev->radio_dev->ctrl_handler = &dev->radio_ctrl_handler;
 		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr);
 		if (ret < 0) {
 			printk(KERN_INFO "%s: can't register radio device\n",
 			       dev->name);
-			return ret; /* FIXME release resource */
+			video_device_release(dev->radio_dev);
+			goto unreg_video;
 		}
 
 		printk(KERN_INFO "%s: registered device %s\n",
@@ -1804,6 +1695,13 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
+
+unreg_video:
+	video_unregister_device(dev->vfd);
+free_ctrl:
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_ctrl_handler_free(&dev->radio_ctrl_handler);
+	return ret;
 }
 
 int tm6000_v4l2_unregister(struct tm6000_core *dev)
diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
index 173dcd7..a9ac262 100644
--- a/drivers/media/usb/tm6000/tm6000.h
+++ b/drivers/media/usb/tm6000/tm6000.h
@@ -27,6 +27,7 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 
 #include <linux/dvb/frontend.h>
 #include "dvb_demux.h"
@@ -222,6 +223,8 @@ struct tm6000_core {
 	struct video_device		*radio_dev;
 	struct tm6000_dmaqueue		vidq;
 	struct v4l2_device		v4l2_dev;
+	struct v4l2_ctrl_handler	ctrl_handler;
+	struct v4l2_ctrl_handler	radio_ctrl_handler;
 
 	int				input;
 	struct tm6000_input		vinput[3];	/* video input */
-- 
1.7.10.4

