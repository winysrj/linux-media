Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1559 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3A2Qdc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 09/20] cx231xx: convert to the control framework.
Date: Tue, 29 Jan 2013 17:33:02 +0100
Message-Id: <719958622e679648f408f007ca0e019024181c74.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is needed to resolve the v4l2-compliance complaints about the control
ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c |    4 -
 drivers/media/usb/cx231xx/cx231xx-cards.c |    2 -
 drivers/media/usb/cx231xx/cx231xx-video.c |  244 +++--------------------------
 drivers/media/usb/cx231xx/cx231xx.h       |   13 +-
 4 files changed, 27 insertions(+), 236 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index b4c99c7..b40360b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -449,9 +449,6 @@ static int snd_cx231xx_capture_open(struct snd_pcm_substream *substream)
 		return -ENODEV;
 	}
 
-	/* Sets volume, mute, etc */
-	dev->mute = 0;
-
 	/* set alternate setting for audio interface */
 	/* 1 - 48000 samples per sec */
 	mutex_lock(&dev->lock);
@@ -503,7 +500,6 @@ static int snd_cx231xx_pcm_close(struct snd_pcm_substream *substream)
 		return ret;
 	}
 
-	dev->mute = 1;
 	dev->adev.users--;
 	mutex_unlock(&dev->lock);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 8d52956..d6acb1e 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -846,8 +846,6 @@ void cx231xx_card_setup(struct cx231xx *dev)
 int cx231xx_config(struct cx231xx *dev)
 {
 	/* TBD need to add cx231xx specific code */
-	dev->mute = 1;		/* maybe not the right place... */
-	dev->volume = 0x1f;
 
 	return 0;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 18789c1..d3595c4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -100,125 +100,6 @@ static struct cx231xx_fmt format[] = {
 	 },
 };
 
-/* supported controls */
-/* Common to all boards */
-
-/* ------------------------------------------------------------------- */
-
-static const struct v4l2_queryctrl no_ctl = {
-	.name = "42",
-	.flags = V4L2_CTRL_FLAG_DISABLED,
-};
-
-static struct cx231xx_ctrl cx231xx_ctls[] = {
-	/* --- video --- */
-	{
-		.v = {
-			.id = V4L2_CID_BRIGHTNESS,
-			.name = "Brightness",
-			.minimum = 0x00,
-			.maximum = 0xff,
-			.step = 1,
-			.default_value = 0x7f,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off = 128,
-		.reg = LUMA_CTRL,
-		.mask = 0x00ff,
-		.shift = 0,
-	}, {
-		.v = {
-			.id = V4L2_CID_CONTRAST,
-			.name = "Contrast",
-			.minimum = 0,
-			.maximum = 0xff,
-			.step = 1,
-			.default_value = 0x3f,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off = 0,
-		.reg = LUMA_CTRL,
-		.mask = 0xff00,
-		.shift = 8,
-	}, {
-		.v = {
-			.id = V4L2_CID_HUE,
-			.name = "Hue",
-			.minimum = 0,
-			.maximum = 0xff,
-			.step = 1,
-			.default_value = 0x7f,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off = 128,
-		.reg = CHROMA_CTRL,
-		.mask = 0xff0000,
-		.shift = 16,
-	}, {
-	/* strictly, this only describes only U saturation.
-	* V saturation is handled specially through code.
-	*/
-		.v = {
-			.id = V4L2_CID_SATURATION,
-			.name = "Saturation",
-			.minimum = 0,
-			.maximum = 0xff,
-			.step = 1,
-			.default_value = 0x7f,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off = 0,
-		.reg = CHROMA_CTRL,
-		.mask = 0x00ff,
-		.shift = 0,
-	}, {
-		/* --- audio --- */
-		.v = {
-			.id = V4L2_CID_AUDIO_MUTE,
-			.name = "Mute",
-			.minimum = 0,
-			.maximum = 1,
-			.default_value = 1,
-			.type = V4L2_CTRL_TYPE_BOOLEAN,
-		},
-		.reg = PATH1_CTL1,
-		.mask = (0x1f << 24),
-		.shift = 24,
-	}, {
-		.v = {
-			.id = V4L2_CID_AUDIO_VOLUME,
-			.name = "Volume",
-			.minimum = 0,
-			.maximum = 0x3f,
-			.step = 1,
-			.default_value = 0x3f,
-			.type = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.reg = PATH1_VOL_CTL,
-		.mask = 0xff,
-		.shift = 0,
-	}
-};
-static const int CX231XX_CTLS = ARRAY_SIZE(cx231xx_ctls);
-
-static const u32 cx231xx_user_ctrls[] = {
-	V4L2_CID_USER_CLASS,
-	V4L2_CID_BRIGHTNESS,
-	V4L2_CID_CONTRAST,
-	V4L2_CID_SATURATION,
-	V4L2_CID_HUE,
-	V4L2_CID_AUDIO_VOLUME,
-#if 0
-	V4L2_CID_AUDIO_BALANCE,
-#endif
-	V4L2_CID_AUDIO_MUTE,
-	0
-};
-
-static const u32 *ctrl_classes[] = {
-	cx231xx_user_ctrls,
-	NULL
-};
 
 /* ------------------------------------------------------------------
 	Video buffer and parser functions
@@ -1233,78 +1114,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
-{
-	struct cx231xx_fh *fh = priv;
-	struct cx231xx *dev = fh->dev;
-	int id = qc->id;
-	int i;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	qc->id = v4l2_ctrl_next(ctrl_classes, qc->id);
-	if (unlikely(qc->id == 0))
-		return -EINVAL;
-
-	memset(qc, 0, sizeof(*qc));
-
-	qc->id = id;
-
-	if (qc->id < V4L2_CID_BASE || qc->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-
-	for (i = 0; i < CX231XX_CTLS; i++)
-		if (cx231xx_ctls[i].v.id == qc->id)
-			break;
-
-	if (i == CX231XX_CTLS) {
-		*qc = no_ctl;
-		return 0;
-	}
-	*qc = cx231xx_ctls[i].v;
-
-	call_all(dev, core, queryctrl, qc);
-
-	if (qc->type)
-		return 0;
-	else
-		return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct cx231xx_fh *fh = priv;
-	struct cx231xx *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	call_all(dev, core, g_ctrl, ctrl);
-	return rc;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct cx231xx_fh *fh = priv;
-	struct cx231xx *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	call_all(dev, core, s_ctrl, ctrl);
-	return rc;
-}
-
 static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct cx231xx_fh *fh = priv;
@@ -2010,26 +1819,6 @@ static int radio_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	return 0;
 }
 
-static int radio_queryctrl(struct file *file, void *priv,
-			   struct v4l2_queryctrl *c)
-{
-	int i;
-
-	if (c->id < V4L2_CID_BASE || c->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		for (i = 0; i < CX231XX_CTLS; i++) {
-			if (cx231xx_ctls[i].v.id == c->id)
-				break;
-		}
-		if (i == CX231XX_CTLS)
-			return -EINVAL;
-		*c = cx231xx_ctls[i].v;
-	} else
-		*c = no_ctl;
-	return 0;
-}
-
 /*
  * cx231xx_v4l2_open()
  * inits the device and starts isoc transfer
@@ -2178,6 +1967,8 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 			video_device_release(dev->vdev);
 		dev->vdev = NULL;
 	}
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	v4l2_ctrl_handler_free(&dev->radio_ctrl_handler);
 }
 
 /*
@@ -2400,9 +2191,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input             = vidioc_enum_input,
 	.vidioc_g_input                = vidioc_g_input,
 	.vidioc_s_input                = vidioc_s_input,
-	.vidioc_queryctrl              = vidioc_queryctrl,
-	.vidioc_g_ctrl                 = vidioc_g_ctrl,
-	.vidioc_s_ctrl                 = vidioc_s_ctrl,
 	.vidioc_streamon               = vidioc_streamon,
 	.vidioc_streamoff              = vidioc_streamoff,
 	.vidioc_g_tuner                = vidioc_g_tuner,
@@ -2437,9 +2225,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap    = vidioc_querycap,
 	.vidioc_g_tuner     = radio_g_tuner,
 	.vidioc_s_tuner     = radio_s_tuner,
-	.vidioc_queryctrl   = radio_queryctrl,
-	.vidioc_g_ctrl      = vidioc_g_ctrl,
-	.vidioc_s_ctrl      = vidioc_s_ctrl,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_g_chip_ident = vidioc_g_chip_ident,
@@ -2504,9 +2289,21 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* Set the initial input */
 	video_mux(dev, dev->video_input);
 
-	/* Audio defaults */
-	dev->mute = 1;
-	dev->volume = 0x1f;
+	v4l2_ctrl_handler_init(&dev->ctrl_handler, 10);
+	v4l2_ctrl_handler_init(&dev->radio_ctrl_handler, 5);
+
+	if (dev->sd_cx25840) {
+		v4l2_ctrl_add_handler(&dev->ctrl_handler,
+				dev->sd_cx25840->ctrl_handler, NULL);
+		v4l2_ctrl_add_handler(&dev->radio_ctrl_handler,
+				dev->sd_cx25840->ctrl_handler,
+				v4l2_ctrl_radio_filter);
+	}
+
+	if (dev->ctrl_handler.error)
+		return dev->ctrl_handler.error;
+	if (dev->radio_ctrl_handler.error)
+		return dev->radio_ctrl_handler.error;
 
 	/* enable vbi capturing */
 	/* write code here...  */
@@ -2518,6 +2315,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 		return -ENODEV;
 	}
 
+	dev->vdev->ctrl_handler = &dev->ctrl_handler;
 	/* register v4l2 video video_device */
 	ret = video_register_device(dev->vdev, VFL_TYPE_GRABBER,
 				    video_nr[dev->devno]);
@@ -2537,6 +2335,11 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* Allocate and fill vbi video_device struct */
 	dev->vbi_dev = cx231xx_vdev_init(dev, &cx231xx_vbi_template, "vbi");
 
+	if (!dev->vbi_dev) {
+		cx231xx_errdev("cannot allocate video_device.\n");
+		return -ENODEV;
+	}
+	dev->vbi_dev->ctrl_handler = &dev->ctrl_handler;
 	/* register v4l2 vbi video_device */
 	ret = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[dev->devno]);
@@ -2555,6 +2358,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 			cx231xx_errdev("cannot allocate video_device.\n");
 			return -ENODEV;
 		}
+		dev->radio_dev->ctrl_handler = &dev->radio_ctrl_handler;
 		ret = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 3e11462..53408ce 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -33,6 +33,7 @@
 
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
 #include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/videobuf-dvb.h>
@@ -516,14 +517,6 @@ struct cx231xx_tvnorm {
 	u32		cxoformat;
 };
 
-struct cx231xx_ctrl {
-	struct v4l2_queryctrl v;
-	u32 off;
-	u32 reg;
-	u32 mask;
-	u32 shift;
-};
-
 enum TRANSFER_TYPE {
 	Raw_Video = 0,
 	Audio,
@@ -631,6 +624,8 @@ struct cx231xx {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_subdev *sd_cx25840;
 	struct v4l2_subdev *sd_tuner;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl_handler radio_ctrl_handler;
 
 	struct work_struct wq_trigger;		/* Trigger to start/stop audio for alsa module */
 	atomic_t	   stream_started;	/* stream should be running if true */
@@ -653,8 +648,6 @@ struct cx231xx {
 	v4l2_std_id norm;	/* selected tv norm */
 	int ctl_freq;		/* selected frequency */
 	unsigned int ctl_ainput;	/* selected audio input */
-	int mute;
-	int volume;
 
 	/* frame properties */
 	int width;		/* current frame width */
-- 
1.7.10.4

