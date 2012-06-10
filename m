Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2299 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab2FJKzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 02/11] cx88: first phase to convert cx88 to the control framework.
Date: Sun, 10 Jun 2012 12:54:48 +0200
Message-Id: <f466fc55842a94918671919e8b7f41af0762bfea.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-alsa.c      |   31 +-
 drivers/media/video/cx88/cx88-blackbird.c |   71 -----
 drivers/media/video/cx88/cx88-cards.c     |   11 +
 drivers/media/video/cx88/cx88-core.c      |    3 +-
 drivers/media/video/cx88/cx88-video.c     |  493 ++++++++++-------------------
 drivers/media/video/cx88/cx88.h           |   48 ++-
 6 files changed, 211 insertions(+), 446 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 04bf662..dfac6e3 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -585,13 +585,10 @@ static void snd_cx88_wm8775_volume_put(struct snd_kcontrol *kcontrol,
 {
 	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
-	struct v4l2_control client_ctl;
 	int left = value->value.integer.value[0];
 	int right = value->value.integer.value[1];
 	int v, b;
 
-	memset(&client_ctl, 0, sizeof(client_ctl));
-
 	/* Pass volume & balance onto any WM8775 */
 	if (left >= right) {
 		v = left << 10;
@@ -600,13 +597,8 @@ static void snd_cx88_wm8775_volume_put(struct snd_kcontrol *kcontrol,
 		v = right << 10;
 		b = right ? 0xffff - (0x8000 * left) / right : 0x8000;
 	}
-	client_ctl.value = v;
-	client_ctl.id = V4L2_CID_AUDIO_VOLUME;
-	call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
-
-	client_ctl.value = b;
-	client_ctl.id = V4L2_CID_AUDIO_BALANCE;
-	call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
+	wm8775_s_ctrl(core, V4L2_CID_AUDIO_VOLUME, v);
+	wm8775_s_ctrl(core, V4L2_CID_AUDIO_BALANCE, b);
 }
 
 /* OK - TODO: test it */
@@ -687,14 +679,8 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 		cx_swrite(SHADOW_AUD_VOL_CTL, AUD_VOL_CTL, vol);
 		/* Pass mute onto any WM8775 */
 		if ((core->board.audio_chip == V4L2_IDENT_WM8775) &&
-		    ((1<<6) == bit)) {
-			struct v4l2_control client_ctl;
-
-			memset(&client_ctl, 0, sizeof(client_ctl));
-			client_ctl.value = 0 != (vol & bit);
-			client_ctl.id = V4L2_CID_AUDIO_MUTE;
-			call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
-		}
+		    ((1<<6) == bit))
+			wm8775_s_ctrl(core, V4L2_CID_AUDIO_MUTE, 0 != (vol & bit));
 		ret = 1;
 	}
 	spin_unlock_irq(&chip->reg_lock);
@@ -724,13 +710,10 @@ static int snd_cx88_alc_get(struct snd_kcontrol *kcontrol,
 {
 	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
-	struct v4l2_control client_ctl;
-
-	memset(&client_ctl, 0, sizeof(client_ctl));
-	client_ctl.id = V4L2_CID_AUDIO_LOUDNESS;
-	call_hw(core, WM8775_GID, core, g_ctrl, &client_ctl);
-	value->value.integer.value[0] = client_ctl.value ? 1 : 0;
+	s32 val;
 
+	val = wm8775_g_ctrl(core, V4L2_CID_AUDIO_LOUDNESS);
+	value->value.integer.value[0] = val ? 1 : 0;
 	return 0;
 }
 
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index cbacdf6..c9bbe9f 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -685,43 +685,6 @@ static struct videobuf_queue_ops blackbird_qops = {
 
 /* ------------------------------------------------------------------ */
 
-static const u32 *ctrl_classes[] = {
-	cx88_user_ctrls,
-	cx2341x_mpeg_ctrls,
-	NULL
-};
-
-static int blackbird_queryctrl(struct cx8802_dev *dev, struct v4l2_queryctrl *qctrl)
-{
-	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
-	if (qctrl->id == 0)
-		return -EINVAL;
-
-	/* Standard V4L2 controls */
-	if (cx8800_ctrl_query(dev->core, qctrl) == 0)
-		return 0;
-
-	/* MPEG V4L2 controls */
-	if (cx2341x_ctrl_query(&dev->params, qctrl))
-		qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;
-	return 0;
-}
-
-/* ------------------------------------------------------------------ */
-/* IOCTL Handlers                                                     */
-
-static int vidioc_querymenu (struct file *file, void *priv,
-				struct v4l2_querymenu *qmenu)
-{
-	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
-	struct v4l2_queryctrl qctrl;
-
-	qctrl.id = qmenu->id;
-	blackbird_queryctrl(dev, &qctrl);
-	return v4l2_ctrl_query_menu(qmenu, &qctrl,
-			cx2341x_ctrl_get_menu(&dev->params, qmenu->id));
-}
-
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
@@ -917,20 +880,6 @@ static int vidioc_log_status (struct file *file, void *priv)
 	return 0;
 }
 
-static int vidioc_queryctrl (struct file *file, void *priv,
-				struct v4l2_queryctrl *qctrl)
-{
-	struct cx8802_dev *dev  = ((struct cx8802_fh *)priv)->dev;
-
-	if (blackbird_queryctrl(dev, qctrl) == 0)
-		return 0;
-
-	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
-	if (unlikely(qctrl->id == 0))
-		return -EINVAL;
-	return cx8800_ctrl_query(dev->core, qctrl);
-}
-
 static int vidioc_enum_input (struct file *file, void *priv,
 				struct v4l2_input *i)
 {
@@ -938,22 +887,6 @@ static int vidioc_enum_input (struct file *file, void *priv,
 	return cx88_enum_input (core,i);
 }
 
-static int vidioc_g_ctrl (struct file *file, void *priv,
-				struct v4l2_control *ctl)
-{
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
-	return
-		cx88_get_control(core,ctl);
-}
-
-static int vidioc_s_ctrl (struct file *file, void *priv,
-				struct v4l2_control *ctl)
-{
-	struct cx88_core  *core = ((struct cx8802_fh *)priv)->dev->core;
-	return
-		cx88_set_control(core,ctl);
-}
-
 static int vidioc_g_frequency (struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
@@ -1178,7 +1111,6 @@ static const struct v4l2_file_operations mpeg_fops =
 };
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
-	.vidioc_querymenu     = vidioc_querymenu,
 	.vidioc_querycap      = vidioc_querycap,
 	.vidioc_enum_fmt_vid_cap  = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap     = vidioc_g_fmt_vid_cap,
@@ -1195,10 +1127,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_try_ext_ctrls = vidioc_try_ext_ctrls,
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_log_status    = vidioc_log_status,
-	.vidioc_queryctrl     = vidioc_queryctrl,
 	.vidioc_enum_input    = vidioc_enum_input,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index cbd5d11..cd8c3bf6 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3693,7 +3693,14 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 		return NULL;
 	}
 
+	if (v4l2_ctrl_handler_init(&core->hdl, 13)) {
+		v4l2_device_unregister(&core->v4l2_dev);
+		kfree(core);
+		return NULL;
+	}
+
 	if (0 != cx88_get_resources(core, pci)) {
+		v4l2_ctrl_handler_free(&core->hdl);
 		v4l2_device_unregister(&core->v4l2_dev);
 		kfree(core);
 		return NULL;
@@ -3706,6 +3713,10 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	core->bmmio = (u8 __iomem *)core->lmmio;
 
 	if (core->lmmio == NULL) {
+		release_mem_region(pci_resource_start(pci, 0),
+			   pci_resource_len(pci, 0));
+		v4l2_ctrl_handler_free(&core->hdl);
+		v4l2_device_unregister(&core->v4l2_dev);
 		kfree(core);
 		return NULL;
 	}
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index fbfdd80..a6480aa 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -1030,7 +1030,7 @@ struct video_device *cx88_vdev_init(struct cx88_core *core,
 		return NULL;
 	*vfd = *template_;
 	vfd->v4l2_dev = &core->v4l2_dev;
-	vfd->parent = &pci->dev;
+	vfd->ctrl_handler = &core->hdl;
 	vfd->release = video_device_release;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 core->name, type, core->board.name);
@@ -1086,6 +1086,7 @@ void cx88_core_put(struct cx88_core *core, struct pci_dev *pci)
 	iounmap(core->lmmio);
 	cx88_devcount--;
 	mutex_unlock(&devlist);
+	v4l2_ctrl_handler_free(&core->hdl);
 	v4l2_device_unregister(&core->v4l2_dev);
 	kfree(core);
 }
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 5d99736..2f3d4df 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -160,210 +160,144 @@ static const struct v4l2_queryctrl no_ctl = {
 	.flags = V4L2_CTRL_FLAG_DISABLED,
 };
 
+
+struct cx88_ctrl {
+	/* control information */
+	u32 id;
+	s32 minimum;
+	s32 maximum;
+	u32 step;
+	s32 default_value;
+
+	/* control register information */
+	u32 off;
+	u32 reg;
+	u32 sreg;
+	u32 mask;
+	u32 shift;
+};
+
 static const struct cx88_ctrl cx8800_ctls[] = {
 	/* --- video --- */
 	{
-		.v = {
-			.id            = V4L2_CID_BRIGHTNESS,
-			.name          = "Brightness",
-			.minimum       = 0x00,
-			.maximum       = 0xff,
-			.step          = 1,
-			.default_value = 0x7f,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 128,
-		.reg                   = MO_CONTR_BRIGHT,
-		.mask                  = 0x00ff,
-		.shift                 = 0,
+		.id            = V4L2_CID_BRIGHTNESS,
+		.minimum       = 0x00,
+		.maximum       = 0xff,
+		.step          = 1,
+		.default_value = 0x7f,
+		.off           = 128,
+		.reg           = MO_CONTR_BRIGHT,
+		.mask          = 0x00ff,
+		.shift         = 0,
 	},{
-		.v = {
-			.id            = V4L2_CID_CONTRAST,
-			.name          = "Contrast",
-			.minimum       = 0,
-			.maximum       = 0xff,
-			.step          = 1,
-			.default_value = 0x3f,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 0,
-		.reg                   = MO_CONTR_BRIGHT,
-		.mask                  = 0xff00,
-		.shift                 = 8,
+		.id            = V4L2_CID_CONTRAST,
+		.minimum       = 0,
+		.maximum       = 0xff,
+		.step          = 1,
+		.default_value = 0x3f,
+		.off           = 0,
+		.reg           = MO_CONTR_BRIGHT,
+		.mask          = 0xff00,
+		.shift         = 8,
 	},{
-		.v = {
-			.id            = V4L2_CID_HUE,
-			.name          = "Hue",
-			.minimum       = 0,
-			.maximum       = 0xff,
-			.step          = 1,
-			.default_value = 0x7f,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 128,
-		.reg                   = MO_HUE,
-		.mask                  = 0x00ff,
-		.shift                 = 0,
+		.id            = V4L2_CID_HUE,
+		.minimum       = 0,
+		.maximum       = 0xff,
+		.step          = 1,
+		.default_value = 0x7f,
+		.off           = 128,
+		.reg           = MO_HUE,
+		.mask          = 0x00ff,
+		.shift         = 0,
 	},{
 		/* strictly, this only describes only U saturation.
 		 * V saturation is handled specially through code.
 		 */
-		.v = {
-			.id            = V4L2_CID_SATURATION,
-			.name          = "Saturation",
-			.minimum       = 0,
-			.maximum       = 0xff,
-			.step          = 1,
-			.default_value = 0x7f,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 0,
-		.reg                   = MO_UV_SATURATION,
-		.mask                  = 0x00ff,
-		.shift                 = 0,
+		.id            = V4L2_CID_SATURATION,
+		.minimum       = 0,
+		.maximum       = 0xff,
+		.step          = 1,
+		.default_value = 0x7f,
+		.off           = 0,
+		.reg           = MO_UV_SATURATION,
+		.mask          = 0x00ff,
+		.shift         = 0,
 	}, {
-		.v = {
-			.id            = V4L2_CID_SHARPNESS,
-			.name          = "Sharpness",
-			.minimum       = 0,
-			.maximum       = 4,
-			.step          = 1,
-			.default_value = 0x0,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 0,
+		.id            = V4L2_CID_SHARPNESS,
+		.minimum       = 0,
+		.maximum       = 4,
+		.step          = 1,
+		.default_value = 0x0,
+		.off           = 0,
 		/* NOTE: the value is converted and written to both even
 		   and odd registers in the code */
-		.reg                   = MO_FILTER_ODD,
-		.mask                  = 7 << 7,
-		.shift                 = 7,
+		.reg           = MO_FILTER_ODD,
+		.mask          = 7 << 7,
+		.shift         = 7,
 	}, {
-		.v = {
-			.id            = V4L2_CID_CHROMA_AGC,
-			.name          = "Chroma AGC",
-			.minimum       = 0,
-			.maximum       = 1,
-			.default_value = 0x1,
-			.type          = V4L2_CTRL_TYPE_BOOLEAN,
-		},
-		.reg                   = MO_INPUT_FORMAT,
-		.mask                  = 1 << 10,
-		.shift                 = 10,
+		.id            = V4L2_CID_CHROMA_AGC,
+		.minimum       = 0,
+		.maximum       = 1,
+		.default_value = 0x1,
+		.reg           = MO_INPUT_FORMAT,
+		.mask          = 1 << 10,
+		.shift         = 10,
 	}, {
-		.v = {
-			.id            = V4L2_CID_COLOR_KILLER,
-			.name          = "Color killer",
-			.minimum       = 0,
-			.maximum       = 1,
-			.default_value = 0x1,
-			.type          = V4L2_CTRL_TYPE_BOOLEAN,
-		},
-		.reg                   = MO_INPUT_FORMAT,
-		.mask                  = 1 << 9,
-		.shift                 = 9,
+		.id            = V4L2_CID_COLOR_KILLER,
+		.minimum       = 0,
+		.maximum       = 1,
+		.default_value = 0x1,
+		.reg           = MO_INPUT_FORMAT,
+		.mask          = 1 << 9,
+		.shift         = 9,
 	}, {
-		.v = {
-			.id            = V4L2_CID_BAND_STOP_FILTER,
-			.name          = "Notch filter",
-			.minimum       = 0,
-			.maximum       = 1,
-			.step          = 1,
-			.default_value = 0x0,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.off                   = 0,
-		.reg                   = MO_HTOTAL,
-		.mask                  = 3 << 11,
-		.shift                 = 11,
+		.id            = V4L2_CID_BAND_STOP_FILTER,
+		.minimum       = 0,
+		.maximum       = 1,
+		.step          = 1,
+		.default_value = 0x0,
+		.off           = 0,
+		.reg           = MO_HTOTAL,
+		.mask          = 3 << 11,
+		.shift         = 11,
 	}, {
-	/* --- audio --- */
-		.v = {
-			.id            = V4L2_CID_AUDIO_MUTE,
-			.name          = "Mute",
-			.minimum       = 0,
-			.maximum       = 1,
-			.default_value = 1,
-			.type          = V4L2_CTRL_TYPE_BOOLEAN,
-		},
-		.reg                   = AUD_VOL_CTL,
-		.sreg                  = SHADOW_AUD_VOL_CTL,
-		.mask                  = (1 << 6),
-		.shift                 = 6,
+		/* --- audio --- */
+		.id            = V4L2_CID_AUDIO_MUTE,
+		.minimum       = 0,
+		.maximum       = 1,
+		.default_value = 1,
+		.reg           = AUD_VOL_CTL,
+		.sreg          = SHADOW_AUD_VOL_CTL,
+		.mask          = (1 << 6),
+		.shift         = 6,
 	},{
-		.v = {
-			.id            = V4L2_CID_AUDIO_VOLUME,
-			.name          = "Volume",
-			.minimum       = 0,
-			.maximum       = 0x3f,
-			.step          = 1,
-			.default_value = 0x3f,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.reg                   = AUD_VOL_CTL,
-		.sreg                  = SHADOW_AUD_VOL_CTL,
-		.mask                  = 0x3f,
-		.shift                 = 0,
+		.id            = V4L2_CID_AUDIO_VOLUME,
+		.minimum       = 0,
+		.maximum       = 0x3f,
+		.step          = 1,
+		.default_value = 0x3f,
+		.reg           = AUD_VOL_CTL,
+		.sreg          = SHADOW_AUD_VOL_CTL,
+		.mask          = 0x3f,
+		.shift         = 0,
 	},{
-		.v = {
-			.id            = V4L2_CID_AUDIO_BALANCE,
-			.name          = "Balance",
-			.minimum       = 0,
-			.maximum       = 0x7f,
-			.step          = 1,
-			.default_value = 0x40,
-			.type          = V4L2_CTRL_TYPE_INTEGER,
-		},
-		.reg                   = AUD_BAL_CTL,
-		.sreg                  = SHADOW_AUD_BAL_CTL,
-		.mask                  = 0x7f,
-		.shift                 = 0,
+		.id            = V4L2_CID_AUDIO_BALANCE,
+		.minimum       = 0,
+		.maximum       = 0x7f,
+		.step          = 1,
+		.default_value = 0x40,
+		.reg           = AUD_BAL_CTL,
+		.sreg          = SHADOW_AUD_BAL_CTL,
+		.mask          = 0x7f,
+		.shift         = 0,
 	}
 };
-enum { CX8800_CTLS = ARRAY_SIZE(cx8800_ctls) };
 
-/* Must be sorted from low to high control ID! */
-const u32 cx88_user_ctrls[] = {
-	V4L2_CID_USER_CLASS,
-	V4L2_CID_BRIGHTNESS,
-	V4L2_CID_CONTRAST,
-	V4L2_CID_SATURATION,
-	V4L2_CID_HUE,
-	V4L2_CID_AUDIO_VOLUME,
-	V4L2_CID_AUDIO_BALANCE,
-	V4L2_CID_AUDIO_MUTE,
-	V4L2_CID_SHARPNESS,
-	V4L2_CID_CHROMA_AGC,
-	V4L2_CID_COLOR_KILLER,
-	V4L2_CID_BAND_STOP_FILTER,
-	0
-};
-EXPORT_SYMBOL(cx88_user_ctrls);
+enum { CX8800_CTLS = ARRAY_SIZE(cx8800_ctls) };
 
-static const u32 * const ctrl_classes[] = {
-	cx88_user_ctrls,
-	NULL
-};
 
 int cx8800_ctrl_query(struct cx88_core *core, struct v4l2_queryctrl *qctrl)
 {
-	int i;
-
-	if (qctrl->id < V4L2_CID_BASE ||
-	    qctrl->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-	for (i = 0; i < CX8800_CTLS; i++)
-		if (cx8800_ctls[i].v.id == qctrl->id)
-			break;
-	if (i == CX8800_CTLS) {
-		*qctrl = no_ctl;
-		return 0;
-	}
-	*qctrl = cx8800_ctls[i].v;
-	/* Report chroma AGC as inactive when SECAM is selected */
-	if (cx8800_ctls[i].v.id == V4L2_CID_CHROMA_AGC &&
-	    core->tvnorm & V4L2_STD_SECAM)
-		qctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
-
 	return 0;
 }
 EXPORT_SYMBOL(cx8800_ctrl_query);
@@ -974,98 +908,43 @@ video_mmap(struct file *file, struct vm_area_struct * vma)
 /* ------------------------------------------------------------------ */
 /* VIDEO CTRL IOCTLS                                                  */
 
-int cx88_get_control (struct cx88_core  *core, struct v4l2_control *ctl)
-{
-	const struct cx88_ctrl  *c    = NULL;
-	u32 value;
-	int i;
-
-	for (i = 0; i < CX8800_CTLS; i++)
-		if (cx8800_ctls[i].v.id == ctl->id)
-			c = &cx8800_ctls[i];
-	if (unlikely(NULL == c))
-		return -EINVAL;
-
-	value = c->sreg ? cx_sread(c->sreg) : cx_read(c->reg);
-	switch (ctl->id) {
-	case V4L2_CID_AUDIO_BALANCE:
-		ctl->value = ((value & 0x7f) < 0x40) ? ((value & 0x7f) + 0x40)
-					: (0x7f - (value & 0x7f));
-		break;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctl->value = 0x3f - (value & 0x3f);
-		break;
-	case V4L2_CID_SHARPNESS:
-		ctl->value = ((value & 0x0200) ? (((value & 0x0180) >> 7) + 1)
-						 : 0);
-		break;
-	default:
-		ctl->value = ((value + (c->off << c->shift)) & c->mask) >> c->shift;
-		break;
-	}
-	dprintk(1,"get_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
-				ctl->id, c->v.name, ctl->value, c->reg,
-				value,c->mask, c->sreg ? " [shadowed]" : "");
-	return 0;
-}
-EXPORT_SYMBOL(cx88_get_control);
-
-int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
+static int cx8800_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	const struct cx88_ctrl *c = NULL;
+	struct cx88_core *core =
+		container_of(ctrl->handler, struct cx88_core, hdl);
+	const struct cx88_ctrl *cc = ctrl->priv;
 	u32 value,mask;
-	int i;
-
-	for (i = 0; i < CX8800_CTLS; i++) {
-		if (cx8800_ctls[i].v.id == ctl->id) {
-			c = &cx8800_ctls[i];
-		}
-	}
-	if (unlikely(NULL == c))
-		return -EINVAL;
-
-	if (ctl->value < c->v.minimum)
-		ctl->value = c->v.minimum;
-	if (ctl->value > c->v.maximum)
-		ctl->value = c->v.maximum;
 
 	/* Pass changes onto any WM8775 */
 	if (core->board.audio_chip == V4L2_IDENT_WM8775) {
-		struct v4l2_control client_ctl;
-		memset(&client_ctl, 0, sizeof(client_ctl));
-		client_ctl.id = ctl->id;
-
-		switch (ctl->id) {
+		switch (ctrl->id) {
 		case V4L2_CID_AUDIO_MUTE:
-			client_ctl.value = ctl->value;
+			wm8775_s_ctrl(core, ctrl->id, ctrl->val);
 			break;
 		case V4L2_CID_AUDIO_VOLUME:
-			client_ctl.value = (ctl->value) ?
-				(0x90 + ctl->value) << 8 : 0;
+			wm8775_s_ctrl(core, ctrl->id, (ctrl->val) ?
+						(0x90 + ctrl->val) << 8 : 0);
 			break;
 		case V4L2_CID_AUDIO_BALANCE:
-			client_ctl.value = ctl->value << 9;
+			wm8775_s_ctrl(core, ctrl->id, ctrl->val << 9);
 			break;
 		default:
-			client_ctl.id = 0;
 			break;
 		}
-		if (client_ctl.id)
-			call_hw(core, WM8775_GID, core, s_ctrl, &client_ctl);
 	}
 
-	mask=c->mask;
-	switch (ctl->id) {
+	mask = cc->mask;
+	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_BALANCE:
-		value = (ctl->value < 0x40) ? (0x7f - ctl->value) : (ctl->value - 0x40);
+		value = (ctrl->val < 0x40) ? (0x7f - ctrl->val) : (ctrl->val - 0x40);
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
-		value = 0x3f - (ctl->value & 0x3f);
+		value = 0x3f - (ctrl->val & 0x3f);
 		break;
 	case V4L2_CID_SATURATION:
 		/* special v_sat handling */
 
-		value = ((ctl->value - c->off) << c->shift) & c->mask;
+		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
 
 		if (core->tvnorm & V4L2_STD_SECAM) {
 			/* For SECAM, both U and V sat should be equal */
@@ -1078,44 +957,29 @@ int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
 		break;
 	case V4L2_CID_SHARPNESS:
 		/* 0b000, 0b100, 0b101, 0b110, or 0b111 */
-		value = (ctl->value < 1 ? 0 : ((ctl->value + 3) << 7));
+		value = (ctrl->val < 1 ? 0 : ((ctrl->val + 3) << 7));
 		/* needs to be set for both fields */
 		cx_andor(MO_FILTER_EVEN, mask, value);
 		break;
 	case V4L2_CID_CHROMA_AGC:
 		/* Do not allow chroma AGC to be enabled for SECAM */
-		value = ((ctl->value - c->off) << c->shift) & c->mask;
-		if (core->tvnorm & V4L2_STD_SECAM && value)
+		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
+		if ((core->tvnorm & V4L2_STD_SECAM) && value)
 			return -EINVAL;
 		break;
 	default:
-		value = ((ctl->value - c->off) << c->shift) & c->mask;
+		value = ((ctrl->val - cc->off) << cc->shift) & cc->mask;
 		break;
 	}
 	dprintk(1,"set_control id=0x%X(%s) ctrl=0x%02x, reg=0x%02x val=0x%02x (mask 0x%02x)%s\n",
-				ctl->id, c->v.name, ctl->value, c->reg, value,
-				mask, c->sreg ? " [shadowed]" : "");
-	if (c->sreg) {
-		cx_sandor(c->sreg, c->reg, mask, value);
-	} else {
-		cx_andor(c->reg, mask, value);
-	}
+				ctrl->id, ctrl->name, ctrl->val, cc->reg, value,
+				mask, cc->sreg ? " [shadowed]" : "");
+	if (cc->sreg)
+		cx_sandor(cc->sreg, cc->reg, mask, value);
+	else
+		cx_andor(cc->reg, mask, value);
 	return 0;
 }
-EXPORT_SYMBOL(cx88_set_control);
-
-static void init_controls(struct cx88_core *core)
-{
-	struct v4l2_control ctrl;
-	int i;
-
-	for (i = 0; i < CX8800_CTLS; i++) {
-		ctrl.id=cx8800_ctls[i].v.id;
-		ctrl.value=cx8800_ctls[i].v.default_value;
-
-		cx88_set_control(core, &ctrl);
-	}
-}
 
 /* ------------------------------------------------------------------ */
 /* VIDEO IOCTLS                                                       */
@@ -1382,35 +1246,6 @@ static int vidioc_s_input (struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-
-
-static int vidioc_queryctrl (struct file *file, void *priv,
-				struct v4l2_queryctrl *qctrl)
-{
-	struct cx88_core *core = ((struct cx8800_fh *)priv)->dev->core;
-
-	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
-	if (unlikely(qctrl->id == 0))
-		return -EINVAL;
-	return cx8800_ctrl_query(core, qctrl);
-}
-
-static int vidioc_g_ctrl (struct file *file, void *priv,
-				struct v4l2_control *ctl)
-{
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
-	return
-		cx88_get_control(core,ctl);
-}
-
-static int vidioc_s_ctrl (struct file *file, void *priv,
-				struct v4l2_control *ctl)
-{
-	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
-	return
-		cx88_set_control(core,ctl);
-}
-
 static int vidioc_g_tuner (struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
@@ -1563,29 +1398,6 @@ static int radio_s_tuner (struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_queryctrl (struct file *file, void *priv,
-			    struct v4l2_queryctrl *c)
-{
-	int i;
-
-	if (c->id <  V4L2_CID_BASE ||
-		c->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-	if (c->id == V4L2_CID_AUDIO_MUTE ||
-		c->id == V4L2_CID_AUDIO_VOLUME ||
-		c->id == V4L2_CID_AUDIO_BALANCE) {
-		for (i = 0; i < CX8800_CTLS; i++) {
-			if (cx8800_ctls[i].v.id == c->id)
-				break;
-		}
-		if (i == CX8800_CTLS)
-			return -EINVAL;
-		*c = cx8800_ctls[i].v;
-	} else
-		*c = no_ctl;
-	return 0;
-}
-
 /* ----------------------------------------------------------- */
 
 static void cx8800_vid_timeout(unsigned long data)
@@ -1739,9 +1551,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
-	.vidioc_queryctrl     = vidioc_queryctrl,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
 	.vidioc_g_tuner       = vidioc_g_tuner,
@@ -1776,9 +1585,6 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap      = vidioc_querycap,
 	.vidioc_g_tuner       = radio_g_tuner,
 	.vidioc_s_tuner       = radio_s_tuner,
-	.vidioc_queryctrl     = radio_queryctrl,
-	.vidioc_g_ctrl        = vidioc_g_ctrl,
-	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -1793,6 +1599,10 @@ static const struct video_device cx8800_radio_template = {
 	.ioctl_ops 	      = &radio_ioctl_ops,
 };
 
+static const struct v4l2_ctrl_ops cx8800_ctrl_ops = {
+	.s_ctrl = cx8800_s_ctrl,
+};
+
 /* ----------------------------------------------------------- */
 
 static void cx8800_unregister_video(struct cx8800_dev *dev)
@@ -1825,8 +1635,8 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 {
 	struct cx8800_dev *dev;
 	struct cx88_core *core;
-
 	int err;
+	int i;
 
 	dev = kzalloc(sizeof(*dev),GFP_KERNEL);
 	if (NULL == dev)
@@ -1897,6 +1707,19 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	}
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask);
 
+	for (i = 0; i < CX8800_CTLS; i++) {
+		const struct cx88_ctrl *cc = &cx8800_ctls[i];
+		struct v4l2_ctrl *vc;
+
+		vc = v4l2_ctrl_new_std(&core->hdl, &cx8800_ctrl_ops,
+			cc->id, cc->minimum, cc->maximum, cc->step, cc->default_value);
+		if (vc == NULL) {
+			err = core->hdl.error;
+			goto fail_core;
+		}
+		vc->priv = (void *)cc;
+	}
+
 	/* load and configure helper modules */
 
 	if (core->board.audio_chip == V4L2_IDENT_WM8775) {
@@ -1914,8 +1737,10 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 
 		sd = v4l2_i2c_new_subdev_board(&core->v4l2_dev, &core->i2c_adap,
 				&wm8775_info, NULL);
-		if (sd != NULL)
+		if (sd != NULL) {
+			core->sd_wm8775 = sd;
 			sd->grp_id = WM8775_GID;
+		}
 	}
 
 	if (core->board.audio_chip == V4L2_IDENT_TVAUDIO) {
@@ -1946,7 +1771,7 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	/* initial device configuration */
 	mutex_lock(&core->lock);
 	cx88_set_tvnorm(core, core->tvnorm);
-	init_controls(core);
+	v4l2_ctrl_handler_setup(&core->hdl);
 	cx88_video_mux(core, 0);
 
 	/* register v4l devices */
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 8e9820c..f12a77b 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -115,15 +115,6 @@ struct cx8800_fmt {
 	u32   cxformat;
 };
 
-struct cx88_ctrl {
-	struct v4l2_queryctrl  v;
-	u32                    off;
-	u32                    reg;
-	u32                    sreg;
-	u32                    mask;
-	u32                    shift;
-};
-
 /* ----------------------------------------------------------- */
 /* SRAM memory management data (see cx88-core.c)               */
 
@@ -359,6 +350,8 @@ struct cx88_core {
 
 	/* config info -- analog */
 	struct v4l2_device 	   v4l2_dev;
+	struct v4l2_ctrl_handler   hdl;
+	struct v4l2_subdev	   *sd_wm8775;
 	struct i2c_client 	   *i2c_rtc;
 	unsigned int               boardnr;
 	struct cx88_board	   board;
@@ -409,8 +402,6 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
 	return container_of(v4l2_dev, struct cx88_core, v4l2_dev);
 }
 
-#define WM8775_GID	(1 << 0)
-
 #define call_hw(core, grpid, o, f, args...) \
 	do {							\
 		if (!core->i2c_rc) {				\
@@ -424,6 +415,36 @@ static inline struct cx88_core *to_core(struct v4l2_device *v4l2_dev)
 
 #define call_all(core, o, f, args...) call_hw(core, 0, o, f, ##args)
 
+#define WM8775_GID      (1 << 0)
+
+#define wm8775_s_ctrl(core, id, val) \
+	do {									\
+		struct v4l2_ctrl *ctrl_ =					\
+			v4l2_ctrl_find(core->sd_wm8775->ctrl_handler, id);	\
+		if (ctrl_ && !core->i2c_rc) {					\
+			if (core->gate_ctrl)					\
+				core->gate_ctrl(core, 1);			\
+			v4l2_ctrl_s_ctrl(ctrl_, val);				\
+			if (core->gate_ctrl)					\
+				core->gate_ctrl(core, 0);			\
+		}								\
+	} while (0)
+
+#define wm8775_g_ctrl(core, id) \
+	({									\
+		struct v4l2_ctrl *ctrl_ =					\
+			v4l2_ctrl_find(core->sd_wm8775->ctrl_handler, id);	\
+		s32 val = 0;							\
+		if (ctrl_ && !core->i2c_rc) {					\
+			if (core->gate_ctrl)					\
+				core->gate_ctrl(core, 1);			\
+			val = v4l2_ctrl_g_ctrl(ctrl_);				\
+			if (core->gate_ctrl)					\
+				core->gate_ctrl(core, 0);			\
+		}								\
+		val;								\
+	})
+
 struct cx8800_dev;
 struct cx8802_dev;
 
@@ -722,13 +743,8 @@ void cx8802_cancel_buffers(struct cx8802_dev *dev);
 
 /* ----------------------------------------------------------- */
 /* cx88-video.c*/
-extern const u32 cx88_user_ctrls[];
-extern int cx8800_ctrl_query(struct cx88_core *core,
-			     struct v4l2_queryctrl *qctrl);
 int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i);
 int cx88_set_freq (struct cx88_core  *core,struct v4l2_frequency *f);
-int cx88_get_control(struct cx88_core *core, struct v4l2_control *ctl);
-int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl);
 int cx88_video_mux(struct cx88_core *core, unsigned int input);
 void cx88_querycap(struct file *file, struct cx88_core *core,
 		struct v4l2_capability *cap);
-- 
1.7.10

