Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3918 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab2EKHzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 06/16] mxb: Fix audio and secam/ntsc bugs.
Date: Fri, 11 May 2012 09:55:00 +0200
Message-Id: <e413e90bc52f38e13ca4848b848ccb0d10752166.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Instead of using custom ioctls use the VIDIOC_ENUM/G/S/_AUDIO ioctls.
  Also send the same audio to both CDROM-out and line-out.

  This is what you would expect and anyway, the CDROM-out connector is unlikely
  to be used these days as it is obsolete.

- Audio tuner detection was wrong: the tda9840 does not autodetect changes in
  the audio standard, so after every change such as changing frequencies that
  might affect the audio standard call the tda9840 to attempt to detect it
  again.

- Non-PAL standards for composite/S-video inputs were not setup correctly.

- Added querystd support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/mxb.c |  147 +++++++++++++++++++++------------------------
 drivers/media/video/mxb.h |   13 ----
 2 files changed, 70 insertions(+), 90 deletions(-)
 delete mode 100644 drivers/media/video/mxb.h

diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index e289e83..0ea221d 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -31,10 +31,11 @@
 #include <media/saa7115.h>
 #include <linux/module.h>
 
-#include "mxb.h"
 #include "tea6415c.h"
 #include "tea6420.h"
 
+#define MXB_AUDIOS	6
+
 #define I2C_SAA7111A  0x24
 #define	I2C_TDA9840   0x42
 #define	I2C_TEA6415C  0x43
@@ -62,10 +63,14 @@ MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
 enum { TUNER, AUX1, AUX3, AUX3_YC };
 
 static struct v4l2_input mxb_inputs[MXB_INPUTS] = {
-	{ TUNER,	"Tuner",		V4L2_INPUT_TYPE_TUNER,	1, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ AUX1,		"AUX1",			V4L2_INPUT_TYPE_CAMERA,	2, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ AUX3,		"AUX3 Composite",	V4L2_INPUT_TYPE_CAMERA,	8, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
-	{ AUX3_YC,	"AUX3 S-Video",		V4L2_INPUT_TYPE_CAMERA,	8, 0, V4L2_STD_PAL_BG|V4L2_STD_NTSC_M, 0, V4L2_IN_CAP_STD },
+	{ TUNER,   "Tuner",          V4L2_INPUT_TYPE_TUNER,  0x3f, 0,
+		V4L2_STD_PAL_BG | V4L2_STD_PAL_I, 0, V4L2_IN_CAP_STD },
+	{ AUX1,	   "AUX1",           V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
+		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ AUX3,	   "AUX3 Composite", V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
+		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
+	{ AUX3_YC, "AUX3 S-Video",   V4L2_INPUT_TYPE_CAMERA, 0x3f, 0,
+		V4L2_STD_ALL, 0, V4L2_IN_CAP_STD },
 };
 
 /* this array holds the information, which port of the saa7146 each
@@ -160,6 +165,7 @@ struct mxb
 
 	int	cur_mode;	/* current audio mode (mono, stereo, ...) */
 	int	cur_input;	/* current input */
+	int	cur_audinput;	/* current audio input */
 	int	cur_mute;	/* current mute status */
 	struct v4l2_frequency	cur_freq;	/* current frequency the tuner is tuned to */
 };
@@ -175,16 +181,21 @@ struct mxb
 #define call_all(dev, o, f, args...) \
 	v4l2_device_call_until_err(&dev->v4l2_dev, 0, o, f, ##args)
 
-static inline void tea6420_route_cd(struct mxb *mxb, int idx)
+static void mxb_update_audmode(struct mxb *mxb)
+{
+	struct v4l2_tuner t = {
+		.audmode = mxb->cur_mode,
+	};
+
+	tda9840_call(mxb, tuner, s_tuner, &t);
+}
+
+static inline void tea6420_route(struct mxb *mxb, int idx)
 {
 	v4l2_subdev_call(mxb->tea6420_1, audio, s_routing,
 		TEA6420_cd[idx][0].input, TEA6420_cd[idx][0].output, 0);
 	v4l2_subdev_call(mxb->tea6420_2, audio, s_routing,
 		TEA6420_cd[idx][1].input, TEA6420_cd[idx][1].output, 0);
-}
-
-static inline void tea6420_route_line(struct mxb *mxb, int idx)
-{
 	v4l2_subdev_call(mxb->tea6420_1, audio, s_routing,
 		TEA6420_line[idx][0].input, TEA6420_line[idx][0].output, 0);
 	v4l2_subdev_call(mxb->tea6420_2, audio, s_routing,
@@ -203,7 +214,7 @@ static int mxb_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_AUDIO_MUTE:
 		mxb->cur_mute = ctrl->val;
 		/* switch the audio-source */
-		tea6420_route_line(mxb, ctrl->val ? 6 :
+		tea6420_route(mxb, ctrl->val ? 6 :
 				video_audio_connect[mxb->cur_input]);
 		break;
 	default:
@@ -222,7 +233,7 @@ static int mxb_probe(struct saa7146_dev *dev)
 	struct mxb *mxb = NULL;
 
 	v4l2_ctrl_new_std(hdl, &mxb_ctrl_ops,
-			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 0);
+			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
 	if (hdl->error)
 		return hdl->error;
 	mxb = kzalloc(sizeof(struct mxb), GFP_KERNEL);
@@ -342,6 +353,9 @@ static int mxb_init_done(struct saa7146_dev* dev)
 
 	int i = 0, err = 0;
 
+	/* mute audio on tea6420s */
+	tea6420_route(mxb, 6);
+
 	/* select video mode in saa7111a */
 	saa7111a_call(mxb, core, s_std, std);
 
@@ -362,12 +376,12 @@ static int mxb_init_done(struct saa7146_dev* dev)
 	tuner_call(mxb, tuner, s_frequency, &mxb->cur_freq);
 
 	/* set a default video standard */
+	/* These two gpio calls set the GPIO pins that control the tda9820 */
+	saa7146_write(dev, GPIO_CTRL, 0x00404050);
+	saa7111a_call(mxb, core, s_gpio, 1);
+	saa7111a_call(mxb, core, s_std, std);
 	tuner_call(mxb, core, s_std, std);
 
-	/* mute audio on tea6420s */
-	tea6420_route_line(mxb, 6);
-	tea6420_route_cd(mxb, 6);
-
 	/* switch to tuner-channel on tea6415c */
 	tea6415c_call(mxb, video, s_routing, 3, 17, 0);
 
@@ -376,9 +390,11 @@ static int mxb_init_done(struct saa7146_dev* dev)
 
 	/* the rest for mxb */
 	mxb->cur_input = 0;
+	mxb->cur_audinput = video_audio_connect[mxb->cur_input];
 	mxb->cur_mute = 1;
 
 	mxb->cur_mode = V4L2_TUNER_MODE_STEREO;
+	mxb_update_audmode(mxb);
 
 	/* check if the saa7740 (aka 'sound arena module') is present
 	   on the mxb. if so, we must initialize it. due to lack of
@@ -512,9 +528,12 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 	if (saa7111a_call(mxb, video, s_routing, i, SAA7111_FMT_CCIR, 0))
 		pr_err("VIDIOC_S_INPUT: could not address saa7111a\n");
 
+	mxb->cur_audinput = video_audio_connect[input];
 	/* switch the audio-source only if necessary */
 	if (0 == mxb->cur_mute)
-		tea6420_route_line(mxb, video_audio_connect[input]);
+		tea6420_route(mxb, mxb->cur_audinput);
+	if (mxb->cur_audinput == 0)
+		mxb_update_audmode(mxb);
 
 	return 0;
 }
@@ -556,6 +575,13 @@ static int vidioc_s_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
 	return call_all(dev, tuner, s_tuner, t);
 }
 
+static int vidioc_querystd(struct file *file, void *fh, v4l2_std_id *norm)
+{
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+
+	return call_all(dev, video, querystd, norm);
+}
+
 static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency *f)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
@@ -588,6 +614,8 @@ static int vidioc_s_frequency(struct file *file, void *fh, struct v4l2_frequency
 	/* let the tuner subdev clamp the frequency to the tuner range */
 	tuner_call(mxb, tuner, g_frequency, f);
 	mxb->cur_freq = *f;
+	if (mxb->cur_audinput == 0)
+		mxb_update_audmode(mxb);
 
 	if (mxb->cur_input)
 		return 0;
@@ -613,13 +641,8 @@ static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
-	if (a->index > MXB_INPUTS) {
-		DEB_D("VIDIOC_G_AUDIO %d out of range\n", a->index);
-		return -EINVAL;
-	}
-
-	DEB_EE("VIDIOC_G_AUDIO %d\n", a->index);
-	memcpy(a, &mxb_audios[video_audio_connect[mxb->cur_input]], sizeof(struct v4l2_audio));
+	DEB_EE("VIDIOC_G_AUDIO\n");
+	*a = mxb_audios[mxb->cur_audinput];
 	return 0;
 }
 
@@ -629,8 +652,15 @@ static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
 
 	DEB_D("VIDIOC_S_AUDIO %d\n", a->index);
-	if (mxb_inputs[mxb->cur_input].audioset & (1 << a->index))
+	if (mxb_inputs[mxb->cur_input].audioset & (1 << a->index)) {
+		if (mxb->cur_audinput != a->index) {
+			mxb->cur_audinput = a->index;
+			tea6420_route(mxb, a->index);
+			if (mxb->cur_audinput == 0)
+				mxb_update_audmode(mxb);
+		}
 		return 0;
+	}
 	return -EINVAL;
 }
 
@@ -650,50 +680,6 @@ static int vidioc_s_register(struct file *file, void *fh, struct v4l2_dbg_regist
 }
 #endif
 
-static long vidioc_default(struct file *file, void *fh, bool valid_prio,
-							int cmd, void *arg)
-{
-	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
-
-	switch (cmd) {
-	case MXB_S_AUDIO_CD:
-	{
-		int i = *(int *)arg;
-
-		if (i < 0 || i >= MXB_AUDIOS) {
-			DEB_D("invalid argument to MXB_S_AUDIO_CD: i:%d\n", i);
-			return -EINVAL;
-		}
-
-		DEB_EE("MXB_S_AUDIO_CD: i:%d\n", i);
-
-		tea6420_route_cd(mxb, i);
-		return 0;
-	}
-	case MXB_S_AUDIO_LINE:
-	{
-		int i = *(int *)arg;
-
-		if (i < 0 || i >= MXB_AUDIOS) {
-			DEB_D("invalid argument to MXB_S_AUDIO_LINE: i:%d\n",
-			      i);
-			return -EINVAL;
-		}
-
-		DEB_EE("MXB_S_AUDIO_LINE: i:%d\n", i);
-		tea6420_route_line(mxb, i);
-		return 0;
-	}
-	default:
-/*
-		DEB2(pr_err("does not handle this ioctl\n"));
-*/
-		return -ENOTTY;
-	}
-	return 0;
-}
-
 static struct saa7146_ext_vv vv_data;
 
 /* this function only gets called when the probing was successful */
@@ -713,6 +699,7 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 	vv_data.ops.vidioc_enum_input = vidioc_enum_input;
 	vv_data.ops.vidioc_g_input = vidioc_g_input;
 	vv_data.ops.vidioc_s_input = vidioc_s_input;
+	vv_data.ops.vidioc_querystd = vidioc_querystd;
 	vv_data.ops.vidioc_g_tuner = vidioc_g_tuner;
 	vv_data.ops.vidioc_s_tuner = vidioc_s_tuner;
 	vv_data.ops.vidioc_g_frequency = vidioc_g_frequency;
@@ -724,7 +711,6 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 	vv_data.ops.vidioc_g_register = vidioc_g_register;
 	vv_data.ops.vidioc_s_register = vidioc_s_register;
 #endif
-	vv_data.ops.vidioc_default = vidioc_default;
 	if (saa7146_register_device(&mxb->video_dev, dev, "mxb", VFL_TYPE_GRABBER)) {
 		ERR("cannot register capture v4l2 device. skipping.\n");
 		saa7146_vv_release(dev);
@@ -751,6 +737,9 @@ static int mxb_detach(struct saa7146_dev *dev)
 
 	DEB_EE("dev:%p\n", dev);
 
+	/* mute audio on tea6420s */
+	tea6420_route(mxb, 6);
+
 	saa7146_unregister_device(&mxb->video_dev,dev);
 	if (MXB_BOARD_CAN_DO_VBI(dev))
 		saa7146_unregister_device(&mxb->vbi_dev, dev);
@@ -772,20 +761,24 @@ static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *standa
 		v4l2_std_id std = V4L2_STD_PAL_I;
 
 		DEB_D("VIDIOC_S_STD: setting mxb for PAL_I\n");
-		/* set the 7146 gpio register -- I don't know what this does exactly */
+		/* These two gpio calls set the GPIO pins that control the tda9820 */
 		saa7146_write(dev, GPIO_CTRL, 0x00404050);
-		/* unset the 7111 gpio register -- I don't know what this does exactly */
 		saa7111a_call(mxb, core, s_gpio, 0);
-		tuner_call(mxb, core, s_std, std);
+		saa7111a_call(mxb, core, s_std, std);
+		if (mxb->cur_input == 0)
+			tuner_call(mxb, core, s_std, std);
 	} else {
 		v4l2_std_id std = V4L2_STD_PAL_BG;
 
+		if (mxb->cur_input)
+			std = standard->id;
 		DEB_D("VIDIOC_S_STD: setting mxb for PAL/NTSC/SECAM\n");
-		/* set the 7146 gpio register -- I don't know what this does exactly */
+		/* These two gpio calls set the GPIO pins that control the tda9820 */
 		saa7146_write(dev, GPIO_CTRL, 0x00404050);
-		/* set the 7111 gpio register -- I don't know what this does exactly */
 		saa7111a_call(mxb, core, s_gpio, 1);
-		tuner_call(mxb, core, s_std, std);
+		saa7111a_call(mxb, core, s_std, std);
+		if (mxb->cur_input == 0)
+			tuner_call(mxb, core, s_std, std);
 	}
 	return 0;
 }
@@ -842,7 +835,7 @@ static struct saa7146_ext_vv vv_data = {
 };
 
 static struct saa7146_extension extension = {
-	.name		= MXB_IDENTIFIER,
+	.name		= "Multimedia eXtension Board",
 	.flags		= SAA7146_USE_I2C_IRQ,
 
 	.pci_tbl	= &pci_tbl[0],
diff --git a/drivers/media/video/mxb.h b/drivers/media/video/mxb.h
deleted file mode 100644
index dfa4b1c..0000000
--- a/drivers/media/video/mxb.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __MXB__
-#define __MXB__
-
-#define BASE_VIDIOC_MXB 10
-
-#define MXB_S_AUDIO_CD		_IOW  ('V', BASE_VIDIOC_PRIVATE+BASE_VIDIOC_MXB+0, int)
-#define MXB_S_AUDIO_LINE	_IOW  ('V', BASE_VIDIOC_PRIVATE+BASE_VIDIOC_MXB+1, int)
-
-#define MXB_IDENTIFIER "Multimedia eXtension Board"
-
-#define MXB_AUDIOS	6
-
-#endif
-- 
1.7.10

