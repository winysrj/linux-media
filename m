Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1128 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab2EKHzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 05/16] mxb: first round of cleanups.
Date: Fri, 11 May 2012 09:54:59 +0200
Message-Id: <526eb2db7e251331c5c8b6aa72712c33b8e8b446.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert to the control framework, fix the easy v4l2-compliance failures.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/mxb.c |  175 ++++++++++++++++++++++-----------------------
 drivers/media/video/mxb.h |   29 --------
 2 files changed, 87 insertions(+), 117 deletions(-)

diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index ca3f70f..e289e83 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -64,8 +64,8 @@ enum { TUNER, AUX1, AUX3, AUX3_YC };
 static struct v4l2_input mxb_inputs[MXB_INPUTS] = {
 	{ TUNER,	"Tuner",		V4L2_INPUT_TYPE_TUNER,	1, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
 	{ AUX1,		"AUX1",			V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ AUX3,		"AUX3 Composite",	V4L2_INPUT_TYPE_CAMERA,	4, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ AUX3_YC,	"AUX3 S-Video",		V4L2_INPUT_TYPE_CAMERA,	4, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ AUX3,		"AUX3 Composite",	V4L2_INPUT_TYPE_CAMERA,	8, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ AUX3_YC,	"AUX3 S-Video",		V4L2_INPUT_TYPE_CAMERA,	8, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
 };
 
 /* this array holds the information, which port of the saa7146 each
@@ -90,6 +90,36 @@ struct mxb_routing {
 	u32 output;
 };
 
+/* these are the available audio sources, which can switched
+   to the line- and cd-output individually */
+static struct v4l2_audio mxb_audios[MXB_AUDIOS] = {
+	    {
+		.index	= 0,
+		.name	= "Tuner",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 1,
+		.name	= "AUX1",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 2,
+		.name	= "AUX2",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 3,
+		.name	= "AUX3",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 4,
+		.name	= "Radio (X9)",
+		.capability = V4L2_AUDCAP_STEREO,
+	} , {
+		.index	= 5,
+		.name	= "CD-ROM (X10)",
+		.capability = V4L2_AUDCAP_STEREO,
+	}
+};
+
 /* These are the necessary input-output-pins for bringing one audio source
    (see above) to the CD-output. Note that gain is set to 0 in this table. */
 static struct mxb_routing TEA6420_cd[MXB_AUDIOS + 1][2] = {
@@ -114,11 +144,6 @@ static struct mxb_routing TEA6420_line[MXB_AUDIOS + 1][2] = {
 	{ { 6, 3 }, { 6, 2 } }	/* Mute */
 };
 
-#define MAXCONTROLS	1
-static struct v4l2_queryctrl mxb_controls[] = {
-	{ V4L2_CID_AUDIO_MUTE, V4L2_CTRL_TYPE_BOOLEAN, "Mute", 0, 1, 1, 0, 0 },
-};
-
 struct mxb
 {
 	struct video_device	*video_dev;
@@ -168,16 +193,45 @@ static inline void tea6420_route_line(struct mxb *mxb, int idx)
 
 static struct saa7146_extension extension;
 
+static int mxb_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct saa7146_dev *dev = container_of(ctrl->handler,
+				struct saa7146_dev, ctrl_handler);
+	struct mxb *mxb = dev->ext_priv;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		mxb->cur_mute = ctrl->val;
+		/* switch the audio-source */
+		tea6420_route_line(mxb, ctrl->val ? 6 :
+				video_audio_connect[mxb->cur_input]);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops mxb_ctrl_ops = {
+	.s_ctrl = mxb_s_ctrl,
+};
+
 static int mxb_probe(struct saa7146_dev *dev)
 {
+	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
 	struct mxb *mxb = NULL;
 
+	v4l2_ctrl_new_std(hdl, &mxb_ctrl_ops,
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+	if (hdl->error)
+		return hdl->error;
 	mxb = kzalloc(sizeof(struct mxb), GFP_KERNEL);
 	if (mxb == NULL) {
 		DEB_D("not enough kernel memory\n");
 		return -ENOMEM;
 	}
 
+
 	snprintf(mxb->i2c_adapter.name, sizeof(mxb->i2c_adapter.name), "mxb%d", mxb_num);
 
 	saa7146_i2c_adapter_prepare(dev, &mxb->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
@@ -214,6 +268,8 @@ static int mxb_probe(struct saa7146_dev *dev)
 	/* we store the pointer in our private data field */
 	dev->ext_priv = mxb;
 
+	v4l2_ctrl_handler_setup(hdl);
+
 	return 0;
 }
 
@@ -385,69 +441,6 @@ void mxb_irq_bh(struct saa7146_dev* dev, u32* irq_mask)
 }
 */
 
-static int vidioc_queryctrl(struct file *file, void *fh, struct v4l2_queryctrl *qc)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	int i;
-
-	for (i = MAXCONTROLS - 1; i >= 0; i--) {
-		if (mxb_controls[i].id == qc->id) {
-			*qc = mxb_controls[i];
-			DEB_D("VIDIOC_QUERYCTRL %d\n", qc->id);
-			return 0;
-		}
-	}
-	return dev->ext_vv_data->core_ops->vidioc_queryctrl(file, fh, qc);
-}
-
-static int vidioc_g_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-	int i;
-
-	for (i = MAXCONTROLS - 1; i >= 0; i--) {
-		if (mxb_controls[i].id == vc->id)
-			break;
-	}
-
-	if (i < 0)
-		return dev->ext_vv_data->core_ops->vidioc_g_ctrl(file, fh, vc);
-
-	if (vc->id == V4L2_CID_AUDIO_MUTE) {
-		vc->value = mxb->cur_mute;
-		DEB_D("VIDIOC_G_CTRL V4L2_CID_AUDIO_MUTE:%d\n", vc->value);
-		return 0;
-	}
-
-	DEB_EE("VIDIOC_G_CTRL V4L2_CID_AUDIO_MUTE:%d\n", vc->value);
-	return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *vc)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-	int i = 0;
-
-	for (i = MAXCONTROLS - 1; i >= 0; i--) {
-		if (mxb_controls[i].id == vc->id)
-			break;
-	}
-
-	if (i < 0)
-		return dev->ext_vv_data->core_ops->vidioc_s_ctrl(file, fh, vc);
-
-	if (vc->id == V4L2_CID_AUDIO_MUTE) {
-		mxb->cur_mute = vc->value;
-		/* switch the audio-source */
-		tea6420_route_line(mxb, vc->value ? 6 :
-				video_audio_connect[mxb->cur_input]);
-		DEB_EE("VIDIOC_S_CTRL, V4L2_CID_AUDIO_MUTE: %d\n", vc->value);
-	}
-	return 0;
-}
-
 static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
 	DEB_EE("VIDIOC_ENUMINPUT %d\n", i->index);
@@ -568,12 +561,8 @@ static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
-	if (mxb->cur_input) {
-		DEB_D("VIDIOC_G_FREQ: channel %d does not have a tuner!\n",
-		      mxb->cur_input);
+	if (f->tuner)
 		return -EINVAL;
-	}
-
 	*f = mxb->cur_freq;
 
 	DEB_EE("VIDIOC_G_FREQ: freq:0x%08x\n", mxb->cur_freq.frequency);
@@ -592,17 +581,16 @@ static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency
 	if (V4L2_TUNER_ANALOG_TV != f->type)
 		return -EINVAL;
 
-	if (mxb->cur_input) {
-		DEB_D("VIDIOC_S_FREQ: channel %d does not have a tuner!\n",
-		      mxb->cur_input);
-		return -EINVAL;
-	}
-
-	mxb->cur_freq = *f;
 	DEB_EE("VIDIOC_S_FREQUENCY: freq:0x%08x\n", mxb->cur_freq.frequency);
 
 	/* tune in desired frequency */
-	tuner_call(mxb, tuner, s_frequency, &mxb->cur_freq);
+	tuner_call(mxb, tuner, s_frequency, f);
+	/* let the tuner subdev clamp the frequency to the tuner range */
+	tuner_call(mxb, tuner, g_frequency, f);
+	mxb->cur_freq = *f;
+
+	if (mxb->cur_input)
+		return 0;
 
 	/* hack: changing the frequency should invalidate the vbi-counter (=> alevt) */
 	spin_lock(&dev->slock);
@@ -612,6 +600,14 @@ static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency
 	return 0;
 }
 
+static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *a)
+{
+	if (a->index >= MXB_AUDIOS)
+		return -EINVAL;
+	*a = mxb_audios[a->index];
+	return 0;
+}
+
 static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
@@ -629,8 +625,13 @@ static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 
 static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
 {
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+
 	DEB_D("VIDIOC_S_AUDIO %d\n", a->index);
-	return 0;
+	if (mxb_inputs[mxb->cur_input].audioset & (1 << a->index))
+		return 0;
+	return -EINVAL;
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -709,9 +710,6 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 	}
 	mxb = (struct mxb *)dev->ext_priv;
 
-	vv_data.ops.vidioc_queryctrl = vidioc_queryctrl;
-	vv_data.ops.vidioc_g_ctrl = vidioc_g_ctrl;
-	vv_data.ops.vidioc_s_ctrl = vidioc_s_ctrl;
 	vv_data.ops.vidioc_enum_input = vidioc_enum_input;
 	vv_data.ops.vidioc_g_input = vidioc_g_input;
 	vv_data.ops.vidioc_s_input = vidioc_s_input;
@@ -719,6 +717,7 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 	vv_data.ops.vidioc_s_tuner = vidioc_s_tuner;
 	vv_data.ops.vidioc_g_frequency = vidioc_g_frequency;
 	vv_data.ops.vidioc_s_frequency = vidioc_s_frequency;
+	vv_data.ops.vidioc_enumaudio = vidioc_enumaudio;
 	vv_data.ops.vidioc_g_audio = vidioc_g_audio;
 	vv_data.ops.vidioc_s_audio = vidioc_s_audio;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -836,7 +835,7 @@ MODULE_DEVICE_TABLE(pci, pci_tbl);
 
 static struct saa7146_ext_vv vv_data = {
 	.inputs		= MXB_INPUTS,
-	.capabilities	= V4L2_CAP_TUNER | V4L2_CAP_VBI_CAPTURE,
+	.capabilities	= V4L2_CAP_TUNER | V4L2_CAP_VBI_CAPTURE | V4L2_CAP_AUDIO,
 	.stds		= &standard[0],
 	.num_stds	= sizeof(standard)/sizeof(struct saa7146_standard),
 	.std_callback	= &std_callback,
diff --git a/drivers/media/video/mxb.h b/drivers/media/video/mxb.h
index 400a57b..dfa4b1c 100644
--- a/drivers/media/video/mxb.h
+++ b/drivers/media/video/mxb.h
@@ -10,33 +10,4 @@
 
 #define MXB_AUDIOS	6
 
-/* these are the available audio sources, which can switched
-   to the line- and cd-output individually */
-static struct v4l2_audio mxb_audios[MXB_AUDIOS] = {
-	    {
-		.index	= 0,
-		.name	= "Tuner",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 1,
-		.name	= "AUX1",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 2,
-		.name	= "AUX2",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 3,
-		.name	= "AUX3",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 4,
-		.name	= "Radio (X9)",
-		.capability = V4L2_AUDCAP_STEREO,
-	} , {
-		.index	= 5,
-		.name	= "CD-ROM (X10)",
-		.capability = V4L2_AUDCAP_STEREO,
-	}
-};
 #endif
-- 
1.7.10

