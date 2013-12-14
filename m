Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1844 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3LNL25 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:28:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 02/15] saa7134: convert to the control framework.
Date: Sat, 14 Dec 2013 12:28:24 +0100
Message-Id: <1387020517-26242-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
References: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-core.c    |   9 +-
 drivers/media/pci/saa7134/saa7134-empress.c | 140 ++--------
 drivers/media/pci/saa7134/saa7134-video.c   | 395 ++++++++--------------------
 drivers/media/pci/saa7134/saa7134.h         |  13 +-
 include/uapi/linux/v4l2-controls.h          |   4 +
 5 files changed, 162 insertions(+), 399 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index f442405..d3b4e56 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1009,13 +1009,13 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 
 	/* load i2c helpers */
 	if (card_is_empress(dev)) {
-		struct v4l2_subdev *sd =
+		dev->empress_sd =
 			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 				"saa6752hs",
 				saa7134_boards[dev->board].empress_addr, NULL);
 
-		if (sd)
-			sd->grp_id = GRP_EMPRESS;
+		if (dev->empress_sd)
+			dev->empress_sd->grp_id = GRP_EMPRESS;
 	}
 
 	if (saa7134_boards[dev->board].rds_addr) {
@@ -1047,6 +1047,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		printk(KERN_INFO "%s: Overlay support disabled.\n", dev->name);
 
 	dev->video_dev = vdev_init(dev,&saa7134_video_template,"video");
+	dev->video_dev->ctrl_handler = &dev->ctrl_handler;
 	err = video_register_device(dev->video_dev,VFL_TYPE_GRABBER,
 				    video_nr[dev->nr]);
 	if (err < 0) {
@@ -1058,6 +1059,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	       dev->name, video_device_node_name(dev->video_dev));
 
 	dev->vbi_dev = vdev_init(dev, &saa7134_video_template, "vbi");
+	dev->vbi_dev->ctrl_handler = &dev->ctrl_handler;
 
 	err = video_register_device(dev->vbi_dev,VFL_TYPE_VBI,
 				    vbi_nr[dev->nr]);
@@ -1068,6 +1070,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 
 	if (card_has_radio(dev)) {
 		dev->radio_dev = vdev_init(dev,&saa7134_radio_template,"radio");
+		dev->radio_dev->ctrl_handler = &dev->radio_ctrl_handler;
 		err = video_register_device(dev->radio_dev,VFL_TYPE_RADIO,
 					    radio_nr[dev->nr]);
 		if (err < 0)
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 3022eb2..7c24f44 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -316,113 +316,6 @@ static int empress_streamoff(struct file *file, void *priv,
 	return videobuf_streamoff(&dev->empress_tsq);
 }
 
-static int empress_s_ext_ctrls(struct file *file, void *priv,
-			       struct v4l2_ext_controls *ctrls)
-{
-	struct saa7134_dev *dev = file->private_data;
-	int err;
-
-	/* count == 0 is abused in saa6752hs.c, so that special
-		case is handled here explicitly. */
-	if (ctrls->count == 0)
-		return 0;
-
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-
-	err = saa_call_empress(dev, core, s_ext_ctrls, ctrls);
-	ts_init_encoder(dev);
-
-	return err;
-}
-
-static int empress_g_ext_ctrls(struct file *file, void *priv,
-			       struct v4l2_ext_controls *ctrls)
-{
-	struct saa7134_dev *dev = file->private_data;
-
-	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-	return saa_call_empress(dev, core, g_ext_ctrls, ctrls);
-}
-
-static int empress_g_ctrl(struct file *file, void *priv,
-					struct v4l2_control *c)
-{
-	struct saa7134_dev *dev = file->private_data;
-
-	return saa7134_g_ctrl_internal(dev, NULL, c);
-}
-
-static int empress_s_ctrl(struct file *file, void *priv,
-					struct v4l2_control *c)
-{
-	struct saa7134_dev *dev = file->private_data;
-
-	return saa7134_s_ctrl_internal(dev, NULL, c);
-}
-
-static int empress_queryctrl(struct file *file, void *priv,
-					struct v4l2_queryctrl *c)
-{
-	/* Must be sorted from low to high control ID! */
-	static const u32 user_ctrls[] = {
-		V4L2_CID_USER_CLASS,
-		V4L2_CID_BRIGHTNESS,
-		V4L2_CID_CONTRAST,
-		V4L2_CID_SATURATION,
-		V4L2_CID_HUE,
-		V4L2_CID_AUDIO_VOLUME,
-		V4L2_CID_AUDIO_MUTE,
-		V4L2_CID_HFLIP,
-		0
-	};
-
-	/* Must be sorted from low to high control ID! */
-	static const u32 mpeg_ctrls[] = {
-		V4L2_CID_MPEG_CLASS,
-		V4L2_CID_MPEG_STREAM_TYPE,
-		V4L2_CID_MPEG_STREAM_PID_PMT,
-		V4L2_CID_MPEG_STREAM_PID_AUDIO,
-		V4L2_CID_MPEG_STREAM_PID_VIDEO,
-		V4L2_CID_MPEG_STREAM_PID_PCR,
-		V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ,
-		V4L2_CID_MPEG_AUDIO_ENCODING,
-		V4L2_CID_MPEG_AUDIO_L2_BITRATE,
-		V4L2_CID_MPEG_VIDEO_ENCODING,
-		V4L2_CID_MPEG_VIDEO_ASPECT,
-		V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
-		V4L2_CID_MPEG_VIDEO_BITRATE,
-		V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
-		0
-	};
-	static const u32 *ctrl_classes[] = {
-		user_ctrls,
-		mpeg_ctrls,
-		NULL
-	};
-	struct saa7134_dev *dev = file->private_data;
-
-	c->id = v4l2_ctrl_next(ctrl_classes, c->id);
-	if (c->id == 0)
-		return -EINVAL;
-	if (c->id == V4L2_CID_USER_CLASS || c->id == V4L2_CID_MPEG_CLASS)
-		return v4l2_ctrl_query_fill(c, 0, 0, 0, 0);
-	if (V4L2_CTRL_ID2CLASS(c->id) != V4L2_CTRL_CLASS_MPEG)
-		return saa7134_queryctrl(file, priv, c);
-	return saa_call_empress(dev, core, queryctrl, c);
-}
-
-static int empress_querymenu(struct file *file, void *priv,
-					struct v4l2_querymenu *c)
-{
-	struct saa7134_dev *dev = file->private_data;
-
-	if (V4L2_CTRL_ID2CLASS(c->id) != V4L2_CTRL_CLASS_MPEG)
-		return -EINVAL;
-	return saa_call_empress(dev, core, querymenu, c);
-}
-
 static int empress_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
 	struct saa7134_dev *dev = file->private_data;
@@ -461,15 +354,9 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_dqbuf			= empress_dqbuf,
 	.vidioc_streamon		= empress_streamon,
 	.vidioc_streamoff		= empress_streamoff,
-	.vidioc_s_ext_ctrls		= empress_s_ext_ctrls,
-	.vidioc_g_ext_ctrls		= empress_g_ext_ctrls,
 	.vidioc_enum_input		= empress_enum_input,
 	.vidioc_g_input			= empress_g_input,
 	.vidioc_s_input			= empress_s_input,
-	.vidioc_queryctrl		= empress_queryctrl,
-	.vidioc_querymenu		= empress_querymenu,
-	.vidioc_g_ctrl			= empress_g_ctrl,
-	.vidioc_s_ctrl			= empress_s_ctrl,
 	.vidioc_s_std			= empress_s_std,
 	.vidioc_g_std			= empress_g_std,
 };
@@ -501,9 +388,26 @@ static void empress_signal_change(struct saa7134_dev *dev)
 	schedule_work(&dev->empress_workqueue);
 }
 
+static bool empress_ctrl_filter(const struct v4l2_ctrl *ctrl)
+{
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+	case V4L2_CID_HUE:
+	case V4L2_CID_CONTRAST:
+	case V4L2_CID_SATURATION:
+	case V4L2_CID_AUDIO_MUTE:
+	case V4L2_CID_AUDIO_VOLUME:
+	case V4L2_CID_PRIVATE_INVERT:
+	case V4L2_CID_PRIVATE_AUTOMUTE:
+		return true;
+	default:
+		return false;
+	}
+}
 
 static int empress_init(struct saa7134_dev *dev)
 {
+	struct v4l2_ctrl_handler *hdl = &dev->empress_ctrl_handler;
 	int err;
 
 	dprintk("%s: %s\n",dev->name,__func__);
@@ -516,6 +420,15 @@ static int empress_init(struct saa7134_dev *dev)
 	snprintf(dev->empress_dev->name, sizeof(dev->empress_dev->name),
 		 "%s empress (%s)", dev->name,
 		 saa7134_boards[dev->board].name);
+	v4l2_ctrl_handler_init(hdl, 21);
+	v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler, empress_ctrl_filter);
+	if (dev->empress_sd)
+		v4l2_ctrl_add_handler(hdl, dev->empress_sd->ctrl_handler, NULL);
+	if (hdl->error) {
+		video_device_release(dev->empress_dev);
+		return hdl->error;
+	}
+	dev->empress_dev->ctrl_handler = hdl;
 
 	INIT_WORK(&dev->empress_workqueue, empress_signal_update);
 
@@ -551,6 +464,7 @@ static int empress_fini(struct saa7134_dev *dev)
 		return 0;
 	flush_work(&dev->empress_workqueue);
 	video_unregister_device(dev->empress_dev);
+	v4l2_ctrl_handler_free(&dev->empress_ctrl_handler);
 	dev->empress_dev = NULL;
 	return 0;
 }
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 8f73058..7a52259 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -369,117 +369,6 @@ static struct saa7134_tvnorm tvnorms[] = {
 };
 #define TVNORMS ARRAY_SIZE(tvnorms)
 
-#define V4L2_CID_PRIVATE_INVERT      (V4L2_CID_PRIVATE_BASE + 0)
-#define V4L2_CID_PRIVATE_Y_ODD       (V4L2_CID_PRIVATE_BASE + 1)
-#define V4L2_CID_PRIVATE_Y_EVEN      (V4L2_CID_PRIVATE_BASE + 2)
-#define V4L2_CID_PRIVATE_AUTOMUTE    (V4L2_CID_PRIVATE_BASE + 3)
-#define V4L2_CID_PRIVATE_LASTP1      (V4L2_CID_PRIVATE_BASE + 4)
-
-static const struct v4l2_queryctrl no_ctrl = {
-	.name  = "42",
-	.flags = V4L2_CTRL_FLAG_DISABLED,
-};
-static const struct v4l2_queryctrl video_ctrls[] = {
-	/* --- video --- */
-	{
-		.id            = V4L2_CID_BRIGHTNESS,
-		.name          = "Brightness",
-		.minimum       = 0,
-		.maximum       = 255,
-		.step          = 1,
-		.default_value = 128,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_CONTRAST,
-		.name          = "Contrast",
-		.minimum       = 0,
-		.maximum       = 127,
-		.step          = 1,
-		.default_value = 68,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_SATURATION,
-		.name          = "Saturation",
-		.minimum       = 0,
-		.maximum       = 127,
-		.step          = 1,
-		.default_value = 64,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_HUE,
-		.name          = "Hue",
-		.minimum       = -128,
-		.maximum       = 127,
-		.step          = 1,
-		.default_value = 0,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_HFLIP,
-		.name          = "Mirror",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},
-	/* --- audio --- */
-	{
-		.id            = V4L2_CID_AUDIO_MUTE,
-		.name          = "Mute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_AUDIO_VOLUME,
-		.name          = "Volume",
-		.minimum       = -15,
-		.maximum       = 15,
-		.step          = 1,
-		.default_value = 0,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},
-	/* --- private --- */
-	{
-		.id            = V4L2_CID_PRIVATE_INVERT,
-		.name          = "Invert",
-		.minimum       = 0,
-		.maximum       = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	},{
-		.id            = V4L2_CID_PRIVATE_Y_ODD,
-		.name          = "y offset odd field",
-		.minimum       = 0,
-		.maximum       = 128,
-		.step          = 1,
-		.default_value = 0,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_PRIVATE_Y_EVEN,
-		.name          = "y offset even field",
-		.minimum       = 0,
-		.maximum       = 128,
-		.step          = 1,
-		.default_value = 0,
-		.type          = V4L2_CTRL_TYPE_INTEGER,
-	},{
-		.id            = V4L2_CID_PRIVATE_AUTOMUTE,
-		.name          = "automute",
-		.minimum       = 0,
-		.maximum       = 1,
-		.default_value = 1,
-		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	}
-};
-static const unsigned int CTRLS = ARRAY_SIZE(video_ctrls);
-
-static const struct v4l2_queryctrl* ctrl_by_id(unsigned int id)
-{
-	unsigned int i;
-
-	for (i = 0; i < CTRLS; i++)
-		if (video_ctrls[i].id == id)
-			return video_ctrls+i;
-	return NULL;
-}
-
 static struct saa7134_format* format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
@@ -868,7 +757,7 @@ static int verify_preview(struct saa7134_dev *dev, struct v4l2_window *win, bool
 	return 0;
 }
 
-static int start_preview(struct saa7134_dev *dev, struct saa7134_fh *fh)
+static int start_preview(struct saa7134_dev *dev)
 {
 	unsigned long base,control,bpl;
 	int err;
@@ -923,7 +812,7 @@ static int start_preview(struct saa7134_dev *dev, struct saa7134_fh *fh)
 	return 0;
 }
 
-static int stop_preview(struct saa7134_dev *dev, struct saa7134_fh *fh)
+static int stop_preview(struct saa7134_dev *dev)
 {
 	dev->ovenable = 0;
 	saa7134_set_dmabits(dev);
@@ -1114,133 +1003,56 @@ static struct videobuf_queue_ops video_qops = {
 
 /* ------------------------------------------------------------------ */
 
-int saa7134_g_ctrl_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, struct v4l2_control *c)
-{
-	const struct v4l2_queryctrl* ctrl;
-
-	ctrl = ctrl_by_id(c->id);
-	if (NULL == ctrl)
-		return -EINVAL;
-	switch (c->id) {
-	case V4L2_CID_BRIGHTNESS:
-		c->value = dev->ctl_bright;
-		break;
-	case V4L2_CID_HUE:
-		c->value = dev->ctl_hue;
-		break;
-	case V4L2_CID_CONTRAST:
-		c->value = dev->ctl_contrast;
-		break;
-	case V4L2_CID_SATURATION:
-		c->value = dev->ctl_saturation;
-		break;
-	case V4L2_CID_AUDIO_MUTE:
-		c->value = dev->ctl_mute;
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		c->value = dev->ctl_volume;
-		break;
-	case V4L2_CID_PRIVATE_INVERT:
-		c->value = dev->ctl_invert;
-		break;
-	case V4L2_CID_HFLIP:
-		c->value = dev->ctl_mirror;
-		break;
-	case V4L2_CID_PRIVATE_Y_EVEN:
-		c->value = dev->ctl_y_even;
-		break;
-	case V4L2_CID_PRIVATE_Y_ODD:
-		c->value = dev->ctl_y_odd;
-		break;
-	case V4L2_CID_PRIVATE_AUTOMUTE:
-		c->value = dev->ctl_automute;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(saa7134_g_ctrl_internal);
-
-static int saa7134_g_ctrl(struct file *file, void *priv, struct v4l2_control *c)
+static int saa7134_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct saa7134_fh *fh = priv;
-
-	return saa7134_g_ctrl_internal(fh->dev, fh, c);
-}
-
-int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, struct v4l2_control *c)
-{
-	const struct v4l2_queryctrl* ctrl;
+	struct saa7134_dev *dev = container_of(ctrl->handler, struct saa7134_dev, ctrl_handler);
 	unsigned long flags;
 	int restart_overlay = 0;
-	int err;
-
-	err = -EINVAL;
 
-	mutex_lock(&dev->lock);
-
-	ctrl = ctrl_by_id(c->id);
-	if (NULL == ctrl)
-		goto error;
-
-	dprintk("set_control name=%s val=%d\n",ctrl->name,c->value);
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_BOOLEAN:
-	case V4L2_CTRL_TYPE_MENU:
-	case V4L2_CTRL_TYPE_INTEGER:
-		if (c->value < ctrl->minimum)
-			c->value = ctrl->minimum;
-		if (c->value > ctrl->maximum)
-			c->value = ctrl->maximum;
-		break;
-	default:
-		/* nothing */;
-	}
-	switch (c->id) {
+	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
-		dev->ctl_bright = c->value;
-		saa_writeb(SAA7134_DEC_LUMA_BRIGHT, dev->ctl_bright);
+		dev->ctl_bright = ctrl->val;
+		saa_writeb(SAA7134_DEC_LUMA_BRIGHT, ctrl->val);
 		break;
 	case V4L2_CID_HUE:
-		dev->ctl_hue = c->value;
-		saa_writeb(SAA7134_DEC_CHROMA_HUE, dev->ctl_hue);
+		dev->ctl_hue = ctrl->val;
+		saa_writeb(SAA7134_DEC_CHROMA_HUE, ctrl->val);
 		break;
 	case V4L2_CID_CONTRAST:
-		dev->ctl_contrast = c->value;
+		dev->ctl_contrast = ctrl->val;
 		saa_writeb(SAA7134_DEC_LUMA_CONTRAST,
 			   dev->ctl_invert ? -dev->ctl_contrast : dev->ctl_contrast);
 		break;
 	case V4L2_CID_SATURATION:
-		dev->ctl_saturation = c->value;
+		dev->ctl_saturation = ctrl->val;
 		saa_writeb(SAA7134_DEC_CHROMA_SATURATION,
 			   dev->ctl_invert ? -dev->ctl_saturation : dev->ctl_saturation);
 		break;
 	case V4L2_CID_AUDIO_MUTE:
-		dev->ctl_mute = c->value;
+		dev->ctl_mute = ctrl->val;
 		saa7134_tvaudio_setmute(dev);
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
-		dev->ctl_volume = c->value;
+		dev->ctl_volume = ctrl->val;
 		saa7134_tvaudio_setvolume(dev,dev->ctl_volume);
 		break;
 	case V4L2_CID_PRIVATE_INVERT:
-		dev->ctl_invert = c->value;
+		dev->ctl_invert = ctrl->val;
 		saa_writeb(SAA7134_DEC_LUMA_CONTRAST,
 			   dev->ctl_invert ? -dev->ctl_contrast : dev->ctl_contrast);
 		saa_writeb(SAA7134_DEC_CHROMA_SATURATION,
 			   dev->ctl_invert ? -dev->ctl_saturation : dev->ctl_saturation);
 		break;
 	case V4L2_CID_HFLIP:
-		dev->ctl_mirror = c->value;
+		dev->ctl_mirror = ctrl->val;
 		restart_overlay = 1;
 		break;
 	case V4L2_CID_PRIVATE_Y_EVEN:
-		dev->ctl_y_even = c->value;
+		dev->ctl_y_even = ctrl->val;
 		restart_overlay = 1;
 		break;
 	case V4L2_CID_PRIVATE_Y_ODD:
-		dev->ctl_y_odd = c->value;
+		dev->ctl_y_odd = ctrl->val;
 		restart_overlay = 1;
 		break;
 	case V4L2_CID_PRIVATE_AUTOMUTE:
@@ -1250,7 +1062,7 @@ int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, str
 		tda9887_cfg.tuner = TUNER_TDA9887;
 		tda9887_cfg.priv = &dev->tda9887_conf;
 
-		dev->ctl_automute = c->value;
+		dev->ctl_automute = ctrl->val;
 		if (dev->tda9887_conf) {
 			if (dev->ctl_automute)
 				dev->tda9887_conf |= TDA9887_AUTOMUTE;
@@ -1262,27 +1074,15 @@ int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, str
 		break;
 	}
 	default:
-		goto error;
+		return -EINVAL;
 	}
-	if (restart_overlay && fh && res_check(fh, RESOURCE_OVERLAY)) {
-		spin_lock_irqsave(&dev->slock,flags);
-		stop_preview(dev,fh);
-		start_preview(dev,fh);
-		spin_unlock_irqrestore(&dev->slock,flags);
+	if (restart_overlay && res_locked(dev, RESOURCE_OVERLAY)) {
+		spin_lock_irqsave(&dev->slock, flags);
+		stop_preview(dev);
+		start_preview(dev);
+		spin_unlock_irqrestore(&dev->slock, flags);
 	}
-	err = 0;
-
-error:
-	mutex_unlock(&dev->lock);
-	return err;
-}
-EXPORT_SYMBOL_GPL(saa7134_s_ctrl_internal);
-
-static int saa7134_s_ctrl(struct file *file, void *f, struct v4l2_control *c)
-{
-	struct saa7134_fh *fh = f;
-
-	return saa7134_s_ctrl_internal(fh->dev, fh, c);
+	return 0;
 }
 
 /* ------------------------------------------------------------------ */
@@ -1434,7 +1234,7 @@ static int video_release(struct file *file)
 	/* turn off overlay */
 	if (res_check(fh, RESOURCE_OVERLAY)) {
 		spin_lock_irqsave(&dev->slock,flags);
-		stop_preview(dev,fh);
+		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock,flags);
 		res_free(dev,fh,RESOURCE_OVERLAY);
 	}
@@ -1703,8 +1503,8 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 
 	if (res_check(fh, RESOURCE_OVERLAY)) {
 		spin_lock_irqsave(&dev->slock, flags);
-		stop_preview(dev, fh);
-		start_preview(dev, fh);
+		stop_preview(dev);
+		start_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
 	}
 
@@ -1712,21 +1512,6 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 	return 0;
 }
 
-int saa7134_queryctrl(struct file *file, void *priv, struct v4l2_queryctrl *c)
-{
-	const struct v4l2_queryctrl *ctrl;
-
-	if ((c->id <  V4L2_CID_BASE ||
-	     c->id >= V4L2_CID_LASTP1) &&
-	    (c->id <  V4L2_CID_PRIVATE_BASE ||
-	     c->id >= V4L2_CID_PRIVATE_LASTP1))
-		return -EINVAL;
-	ctrl = ctrl_by_id(c->id);
-	*c = (NULL != ctrl) ? *ctrl : no_ctrl;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(saa7134_queryctrl);
-
 static int saa7134_enum_input(struct file *file, void *priv,
 					struct v4l2_input *i)
 {
@@ -1882,13 +1667,13 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
 	mutex_lock(&dev->lock);
 	if (fh && res_check(fh, RESOURCE_OVERLAY)) {
 		spin_lock_irqsave(&dev->slock, flags);
-		stop_preview(dev, fh);
+		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
 
 		set_tvnorm(dev, &tvnorms[i]);
 
 		spin_lock_irqsave(&dev->slock, flags);
-		start_preview(dev, fh);
+		start_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
 	} else
 		set_tvnorm(dev, &tvnorms[i]);
@@ -2157,14 +1942,14 @@ static int saa7134_overlay(struct file *file, void *f, unsigned int on)
 		if (!res_get(dev, fh, RESOURCE_OVERLAY))
 			return -EBUSY;
 		spin_lock_irqsave(&dev->slock, flags);
-		start_preview(dev, fh);
+		start_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
 	}
 	if (!on) {
 		if (!res_check(fh, RESOURCE_OVERLAY))
 			return -EINVAL;
 		spin_lock_irqsave(&dev->slock, flags);
-		stop_preview(dev, fh);
+		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
 		res_free(dev, fh, RESOURCE_OVERLAY);
 	}
@@ -2319,22 +2104,6 @@ static int radio_s_std(struct file *file, void *fh, v4l2_std_id norm)
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
-	return 0;
-}
-
 static const struct v4l2_file_operations video_fops =
 {
 	.owner	  = THIS_MODULE,
@@ -2369,9 +2138,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input		= saa7134_enum_input,
 	.vidioc_g_input			= saa7134_g_input,
 	.vidioc_s_input			= saa7134_s_input,
-	.vidioc_queryctrl		= saa7134_queryctrl,
-	.vidioc_g_ctrl			= saa7134_g_ctrl,
-	.vidioc_s_ctrl			= saa7134_s_ctrl,
 	.vidioc_streamon		= saa7134_streamon,
 	.vidioc_streamoff		= saa7134_streamoff,
 	.vidioc_g_tuner			= saa7134_g_tuner,
@@ -2405,10 +2171,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner		= radio_s_tuner,
 	.vidioc_s_input		= radio_s_input,
 	.vidioc_s_std		= radio_s_std,
-	.vidioc_queryctrl	= radio_queryctrl,
 	.vidioc_g_input		= radio_g_input,
-	.vidioc_g_ctrl		= saa7134_g_ctrl,
-	.vidioc_s_ctrl		= saa7134_s_ctrl,
 	.vidioc_g_frequency	= saa7134_g_frequency,
 	.vidioc_s_frequency	= saa7134_s_frequency,
 };
@@ -2429,8 +2192,55 @@ struct video_device saa7134_radio_template = {
 	.ioctl_ops 		= &radio_ioctl_ops,
 };
 
+static const struct v4l2_ctrl_ops saa7134_ctrl_ops = {
+	.s_ctrl = saa7134_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config saa7134_ctrl_invert = {
+	.ops = &saa7134_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_INVERT,
+	.name = "Invert",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config saa7134_ctrl_y_odd = {
+	.ops = &saa7134_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_Y_ODD,
+	.name = "Y Offset Odd Field",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 128,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config saa7134_ctrl_y_even = {
+	.ops = &saa7134_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_Y_EVEN,
+	.name = "Y Offset Even Field",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 128,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config saa7134_ctrl_automute = {
+	.ops = &saa7134_ctrl_ops,
+	.id = V4L2_CID_PRIVATE_AUTOMUTE,
+	.name = "Automute",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 1,
+};
+
 int saa7134_video_init1(struct saa7134_dev *dev)
 {
+	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
+
 	/* sanitycheck insmod options */
 	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
 		gbuffers = 2;
@@ -2438,17 +2248,38 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 		gbufsize = gbufsize_max;
 	gbufsize = (gbufsize + PAGE_SIZE - 1) & PAGE_MASK;
 
-	/* put some sensible defaults into the data structures ... */
-	dev->ctl_bright     = ctrl_by_id(V4L2_CID_BRIGHTNESS)->default_value;
-	dev->ctl_contrast   = ctrl_by_id(V4L2_CID_CONTRAST)->default_value;
-	dev->ctl_hue        = ctrl_by_id(V4L2_CID_HUE)->default_value;
-	dev->ctl_saturation = ctrl_by_id(V4L2_CID_SATURATION)->default_value;
-	dev->ctl_volume     = ctrl_by_id(V4L2_CID_AUDIO_VOLUME)->default_value;
-	dev->ctl_mute       = 1; // ctrl_by_id(V4L2_CID_AUDIO_MUTE)->default_value;
-	dev->ctl_invert     = ctrl_by_id(V4L2_CID_PRIVATE_INVERT)->default_value;
-	dev->ctl_automute   = ctrl_by_id(V4L2_CID_PRIVATE_AUTOMUTE)->default_value;
-
-	if (dev->tda9887_conf && dev->ctl_automute)
+	v4l2_ctrl_handler_init(hdl, 11);
+	v4l2_ctrl_new_std(hdl, &saa7134_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(hdl, &saa7134_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 127, 1, 68);
+	v4l2_ctrl_new_std(hdl, &saa7134_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 127, 1, 64);
+	v4l2_ctrl_new_std(hdl, &saa7134_ctrl_ops,
+			V4L2_CID_HUE, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, &saa7134_ctrl_ops,
+			V4L2_CID_HFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &saa7134_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(hdl, &saa7134_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, -15, 15, 1, 0);
+	v4l2_ctrl_new_custom(hdl, &saa7134_ctrl_invert, NULL);
+	v4l2_ctrl_new_custom(hdl, &saa7134_ctrl_y_odd, NULL);
+	v4l2_ctrl_new_custom(hdl, &saa7134_ctrl_y_even, NULL);
+	v4l2_ctrl_new_custom(hdl, &saa7134_ctrl_automute, NULL);
+	if (hdl->error)
+		return hdl->error;
+	if (card_has_radio(dev)) {
+		hdl = &dev->radio_ctrl_handler;
+		v4l2_ctrl_handler_init(hdl, 2);
+		v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler,
+				v4l2_ctrl_radio_filter);
+		if (hdl->error)
+			return hdl->error;
+	}
+	dev->ctl_mute       = 1;
+
+	if (dev->tda9887_conf && saa7134_ctrl_automute.def)
 		dev->tda9887_conf |= TDA9887_AUTOMUTE;
 	dev->automute       = 0;
 
@@ -2494,6 +2325,9 @@ void saa7134_video_fini(struct saa7134_dev *dev)
 	/* free stuff */
 	saa7134_pgtable_free(dev->pci, &dev->pt_cap);
 	saa7134_pgtable_free(dev->pci, &dev->pt_vbi);
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	if (card_has_radio(dev))
+		v4l2_ctrl_handler_free(&dev->radio_ctrl_handler);
 }
 
 int saa7134_videoport_init(struct saa7134_dev *dev)
@@ -2537,6 +2371,7 @@ int saa7134_video_init2(struct saa7134_dev *dev)
 	/* init video hw */
 	set_tvnorm(dev,&tvnorms[0]);
 	video_mux(dev,0);
+	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
 	saa7134_tvaudio_setmute(dev);
 	saa7134_tvaudio_setvolume(dev,dev->ctl_volume);
 	return 0;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 96b7ccf..e0e5c70 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -37,6 +37,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
 #include <media/tuner.h>
 #include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
@@ -410,6 +411,11 @@ struct saa7134_board {
 #define card(dev)             (saa7134_boards[dev->board])
 #define card_in(dev,n)        (saa7134_boards[dev->board].inputs[n])
 
+#define V4L2_CID_PRIVATE_INVERT      (V4L2_CID_USER_SAA7134_BASE + 0)
+#define V4L2_CID_PRIVATE_Y_ODD       (V4L2_CID_USER_SAA7134_BASE + 1)
+#define V4L2_CID_PRIVATE_Y_EVEN      (V4L2_CID_USER_SAA7134_BASE + 2)
+#define V4L2_CID_PRIVATE_AUTOMUTE    (V4L2_CID_USER_SAA7134_BASE + 3)
+
 /* ----------------------------------------------------------- */
 /* device / file handle status                                 */
 
@@ -595,6 +601,7 @@ struct saa7134_dev {
 	/* various v4l controls */
 	struct saa7134_tvnorm      *tvnorm;              /* video */
 	struct saa7134_tvaudio     *tvaudio;
+	struct v4l2_ctrl_handler   ctrl_handler;
 	unsigned int               ctl_input;
 	int                        ctl_bright;
 	int                        ctl_contrast;
@@ -622,6 +629,7 @@ struct saa7134_dev {
 	int                        last_carrier;
 	int                        nosignal;
 	unsigned int               insuspend;
+	struct v4l2_ctrl_handler   radio_ctrl_handler;
 
 	/* I2C keyboard data */
 	struct IR_i2c_init_data    init_data;
@@ -634,10 +642,12 @@ struct saa7134_dev {
 
 	/* SAA7134_MPEG_EMPRESS only */
 	struct video_device        *empress_dev;
+	struct v4l2_subdev	   *empress_sd;
 	struct videobuf_queue      empress_tsq;
 	atomic_t 		   empress_users;
 	struct work_struct         empress_workqueue;
 	int                        empress_started;
+	struct v4l2_ctrl_handler   empress_ctrl_handler;
 
 #if IS_ENABLED(CONFIG_VIDEO_SAA7134_DVB)
 	/* SAA7134_MPEG_DVB only */
@@ -757,9 +767,6 @@ extern unsigned int video_debug;
 extern struct video_device saa7134_video_template;
 extern struct video_device saa7134_radio_template;
 
-int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, struct v4l2_control *c);
-int saa7134_g_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, struct v4l2_control *c);
-int saa7134_queryctrl(struct file *file, void *priv, struct v4l2_queryctrl *c);
 int saa7134_s_std_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, v4l2_std_id id);
 
 int saa7134_videoport_init(struct saa7134_dev *dev);
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 1666aab..8e4d1d9 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -164,6 +164,10 @@ enum v4l2_colorfx {
  * this driver */
 #define V4L2_CID_USER_TI_VPE_BASE		(V4L2_CID_USER_BASE + 0x1050)
 
+/* The base for the saa7134 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_SAA7134_BASE		(V4L2_CID_USER_BASE + 0x1060)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
-- 
1.8.4.3

